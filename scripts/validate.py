"""Validate manifests without contacting Google Cloud or reading secret values."""
import argparse
import json
from pathlib import Path
import re
import sys

import jsonschema
import yaml

ROOT = Path(__file__).resolve().parents[1]
NAME = r"[a-z][a-z0-9-]{0,62}"


class UniqueLoader(yaml.SafeLoader):
    pass


def unique_mapping(loader, node):
    result = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node)
        if not isinstance(key, str) or key in result:
            raise ValueError(f"Duplicate or non-string YAML key: {key!r}")
        result[key] = loader.construct_object(value_node)
    return result


UniqueLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, unique_mapping)


def load(path):
    return yaml.load(Path(path).read_text(encoding="utf-8"), Loader=UniqueLoader)


def validate(solution, environment, *, deployable=False):
    for name, value in [("solution", solution), ("environment", environment)]:
        schema = json.loads((ROOT / "schemas" / f"{name}.schema.json").read_text())
        jsonschema.Draft202012Validator(schema).validate(value)
    components = solution["components"]
    deployments = environment["deployments"]
    for name, component in components.items():
        if component["repository"] not in solution["repositories"]:
            raise ValueError(f"{name}: unknown repository")
    if set(deployments) - set(components):
        raise ValueError("Deployment references unknown component")
    for name, deployment in deployments.items():
        kind = components[name]["type"]
        schema = json.loads((ROOT / "schemas" / "environment.schema.json").read_text())
        jsonschema.Draft202012Validator(schema["$defs"][kind]).validate(deployment)
        if kind == "cloud_run_service":
            if "traffic" in deployment:
                if sum(target.get("percent", 0) for target in deployment["traffic"]) != 100:
                    raise ValueError(f"{name}: traffic percentages must total 100")
                for target in deployment["traffic"]:
                    if (target["type"] == "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION") != bool(target.get("revision")):
                        raise ValueError(f"{name}: revision traffic requires a revision; latest traffic must omit it")
            if deployment.get("startup_probe", {}).get("timeout_seconds", 1) > deployment.get("startup_probe", {}).get("period_seconds", 1):
                raise ValueError(f"{name}: probe timeout cannot exceed period")
            scaling = deployment["scaling"]
            if scaling["min_instances"] > scaling["max_instances"]:
                raise ValueError(f"{name}: minimum instances exceed maximum")
            secrets = deployment.get("secret_env", {})
            if set(secrets) & set(deployment.get("env", {})):
                raise ValueError(f"{name}: env and secret_env overlap")
            for reference in secrets.values():
                if reference["secret"] not in solution["secrets"]:
                    raise ValueError(f"{name}: undeclared secret {reference['secret']}")
            if not deployment["service_account"].endswith(
                f"@{environment['gcp']['project_id']}.iam.gserviceaccount.com"
            ):
                raise ValueError(f"{name}: runtime identity must belong to target project")
    for field in ("service_name", "site_id"):
        values = [d[field] for d in deployments.values() if field in d]
        if len(values) != len(set(values)):
            raise ValueError(f"Duplicate {field}")
    if environment["enabled"] or deployable:
        if not environment["enabled"]:
            raise ValueError("Environment awaits inventory; enabled is false")
        if not solution["repositories"] or not components or set(deployments) != set(components):
            raise ValueError("Enabled environments require repositories and every component deployment")
        if not environment["gcp"]["project_id"] or not environment["state_bucket"]:
            raise ValueError("Enabled environments require a verified project and state bucket")


def manifests(solution_name, environment_name, *, root=ROOT, deployable=False):
    if not re.fullmatch(NAME, solution_name) or environment_name not in ("stage", "prod"):
        raise ValueError("Invalid solution or environment name")
    directory = root / "solutions" / solution_name
    solution = load(directory / "solution.yaml")
    environment = load(directory / "environments" / f"{environment_name}.yaml")
    validate(solution, environment, deployable=deployable)
    if solution["name"] != solution_name or environment["environment"] != environment_name:
        raise ValueError("Manifest name does not match its path")
    return solution, environment


def validate_tree(root=ROOT):
    paths = sorted((root / "solutions").glob("*/solution.yaml"))
    if not paths:
        raise ValueError("No solutions found")
    projects = {}
    owners = {}
    for path in paths:
        for name in ("stage", "prod"):
            solution, environment = manifests(path.parent.name, name, root=root)
            if environment["enabled"]:
                project = environment["gcp"]["project_id"]
                previous = projects.setdefault(project, name)
                if previous != name:
                    raise ValueError("Stage and prod must use separate GCP projects")
                resources = [(project, "secret", secret) for secret in solution["secrets"]]
                resources += [
                    (project, environment["gcp"]["region"], "artifact", repository)
                    for repository in environment.get("artifact_registry", [])
                ]
                for component, deployment in environment["deployments"].items():
                    if solution["components"][component]["type"] == "cloud_run_service":
                        resources.append((project, environment["gcp"]["region"], "run", deployment["service_name"]))
                    else:
                        resources.append(("hosting", deployment["site_id"]))
                for resource in resources:
                    if resource in owners:
                        raise ValueError(f"Resource managed by multiple states: {resource}")
                    owners[resource] = (solution["name"], name)
    return len(paths) * 2


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--solution")
    parser.add_argument("--environment", choices=["stage", "prod"])
    parser.add_argument("--deployable", action="store_true")
    args = parser.parse_args()
    if bool(args.solution) != bool(args.environment) or (args.deployable and not args.solution):
        parser.error("Use --solution and --environment together; --deployable requires both")
    try:
        if args.solution:
            manifests(args.solution, args.environment, deployable=args.deployable)
            print(f"Valid: {args.solution}/{args.environment}")
        else:
            print(f"Valid: {validate_tree()} environments (disabled drafts are not deployable)")
    except (ValueError, OSError, yaml.YAMLError, jsonschema.ValidationError) as error:
        print(str(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
