import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest

import jsonschema
import yaml

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from changed_environments import changed
from check_approval import check as check_approval
from check_plan import check as check_plan
from hosting_release import matches
from validate import ROOT, load, manifests, validate, validate_tree


def fixture():
    solution = {
        "schema_version": 1, "name": "pilot", "description": "Test pilot",
        "repositories": {"app": {"provider": "github", "slug": "owner/repository"}},
        "components": {"api": {"type": "cloud_run_service", "repository": "app"}},
        "secrets": ["database-url"],
    }
    environment = {
        "environment": "stage", "enabled": True,
        "gcp": {"project_id": "pilot-stage", "region": "southamerica-east1"},
        "state_bucket": "pilot-stage-tfstate",
        "deployments": {"api": {
            "service_name": "pilot-api",
            "image": "southamerica-east1-docker.pkg.dev/pilot-stage/apps/api@sha256:" + "a" * 64,
            "service_account": "runtime@pilot-stage.iam.gserviceaccount.com",
            "port": 8080, "public": False, "ingress": "INGRESS_TRAFFIC_ALL",
            "env": {"APP_ENV": "stage"},
            "secret_env": {"DATABASE_URL": {"secret": "database-url", "version": "1"}},
            "scaling": {"min_instances": 0, "max_instances": 2},
        }},
    }
    return solution, environment


class ManifestTests(unittest.TestCase):
    def test_registered_manifests(self):
        self.assertGreater(validate_tree(), 0)
        for path in (ROOT / "solutions").glob("*/solution.yaml"):
            for environment in ("stage", "prod"):
                manifests(path.parent.name, environment)

    def test_disabled_drafts_are_not_deployable(self):
        solution, environment = fixture()
        environment.update(enabled=False, deployments={}, state_bucket=None)
        validate(solution, environment)
        with self.assertRaisesRegex(ValueError, "awaits inventory"):
            validate(solution, environment, deployable=True)

    def test_cloud_run_and_hosting(self):
        solution, environment = fixture()
        validate(solution, environment, deployable=True)
        solution["components"]["frontend"] = {"type": "firebase_hosting", "repository": "app"}
        environment["deployments"]["frontend"] = {
            "site_id": "pilot-stage", "commit": "b" * 40, "public_dir": "dist",
        }
        validate(solution, environment, deployable=True)

    def test_adopt_existing_cloud_run_settings(self):
        solution, environment = fixture()
        service = environment["deployments"]["api"]
        service.update(timeout_seconds=180, max_concurrency=20, invoker_iam_disabled=True,
                       service_scaling={"max_instances": 20},
                       startup_probe={"failure_threshold": 12, "period_seconds": 10,
                                      "timeout_seconds": 2, "http_get": {"path": "/api/health", "port": 8000}},
                       traffic=[{"type": "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION", "revision": "pilot-api-00001-abc", "percent": 100},
                                {"type": "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION", "revision": "pilot-api-00001-abc", "tag": "candidate"}])
        validate(solution, environment)
        service["traffic"][0]["percent"] = 99
        with self.assertRaisesRegex(ValueError, "total 100"):
            validate(solution, environment)
        service["traffic"][0]["percent"] = 100
        service["traffic"][0]["type"] = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
        with self.assertRaisesRegex(ValueError, "must omit"):
            validate(solution, environment)
        service.pop("traffic")
        service["startup_probe"]["timeout_seconds"] = 11
        with self.assertRaisesRegex(ValueError, "timeout cannot exceed"):
            validate(solution, environment)

    def test_reject_invalid_config(self):
        mutations = [
            lambda s, e: s["components"]["api"].update(repository="missing"),
            lambda s, e: s["components"]["api"].update(type="cloud_run_job"),
            lambda s, e: e["deployments"].update(unknown=e["deployments"]["api"]),
            lambda s, e: e["deployments"]["api"].update(image="image:latest"),
            lambda s, e: e["deployments"]["api"]["env"].update(ANALYTICS=False),
            lambda s, e: e["deployments"]["api"]["secret_env"]["DATABASE_URL"].update(secret="missing"),
            lambda s, e: e["deployments"]["api"]["secret_env"]["DATABASE_URL"].update(version="latest"),
            lambda s, e: e["deployments"]["api"]["env"].update(DATABASE_URL="plaintext"),
            lambda s, e: e["deployments"]["api"]["scaling"].update(min_instances=3),
            lambda s, e: e["deployments"].clear(),
            lambda s, e: e.update(state_bucket=None),
            lambda s, e: e["deployments"]["api"].update(service_account="runtime@another-project.iam.gserviceaccount.com"),
            lambda s, e: e["deployments"]["api"].update(site_id="wrong-component-type"),
        ]
        for mutate in mutations:
            with self.subTest(mutation=mutate):
                solution, environment = fixture()
                mutate(solution, environment)
                with self.assertRaises((ValueError, jsonschema.ValidationError)):
                    validate(solution, environment)

    def test_reject_duplicate_yaml_keys(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "duplicate.yaml"
            path.write_text("environment: stage\nenvironment: prod\n")
            with self.assertRaisesRegex(ValueError, "Duplicate"):
                load(path)

    def test_hosting_requires_pinned_commit_and_safe_directory(self):
        solution, environment = fixture()
        solution["components"] = {"frontend": {"type": "firebase_hosting", "repository": "app"}}
        for commit, directory in [("main", "dist"), ("b" * 40, "../private"), ("b" * 40, "/tmp")]:
            environment["deployments"] = {"frontend": {"site_id": "pilot-stage", "commit": commit, "public_dir": directory}}
            with self.assertRaises(jsonschema.ValidationError):
                validate(solution, environment)

    def test_changed_environments_and_isolation(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            directory = root / "solutions" / "pilot"
            (directory / "environments").mkdir(parents=True)
            solution, stage = fixture()
            (directory / "solution.yaml").write_text(yaml.safe_dump(solution))
            prod = copy.deepcopy(stage)
            prod.update(environment="prod", state_bucket="pilot-prod-tfstate")
            prod["gcp"]["project_id"] = "pilot-prod"
            prod["deployments"]["api"]["service_account"] = "runtime@pilot-prod.iam.gserviceaccount.com"
            for name, environment in [("stage", stage), ("prod", prod)]:
                (directory / "environments" / f"{name}.yaml").write_text(yaml.safe_dump(environment))
            self.assertEqual(validate_tree(root), 2)
            stage_change = [{"solution": "pilot", "environment": "stage"}]
            self.assertEqual(changed(["solutions/pilot/environments/stage.yaml"], root), stage_change)
            self.assertEqual(len(changed(["terraform/modules/cloud-run-service/main.tf"], root)), 2)
            self.assertEqual(len(changed(["solutions/pilot/solution.yaml"], root)), 2)
            self.assertEqual(changed(["README.md"], root), [])
            with self.assertRaisesRegex(ValueError, "Deleted manifest"):
                changed(["solutions/deleted/solution.yaml"], root)
            prod["gcp"] = stage["gcp"]
            prod["deployments"]["api"]["service_account"] = stage["deployments"]["api"]["service_account"]
            (directory / "environments" / "prod.yaml").write_text(yaml.safe_dump(prod))
            with self.assertRaisesRegex(ValueError, "separate GCP projects"):
                validate_tree(root)

    def test_prevent_two_states_owning_one_resource(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            for name in ("pilot", "second"):
                directory = root / "solutions" / name
                (directory / "environments").mkdir(parents=True)
                solution, stage = fixture()
                solution["name"] = name
                (directory / "solution.yaml").write_text(yaml.safe_dump(solution))
                (directory / "environments" / "stage.yaml").write_text(yaml.safe_dump(stage))
                prod = copy.deepcopy(stage)
                prod.update(environment="prod", enabled=False, deployments={})
                (directory / "environments" / "prod.yaml").write_text(yaml.safe_dump(prod))
            with self.assertRaisesRegex(ValueError, "multiple states"):
                validate_tree(root)

    def test_block_deletion_including_removed_modules(self):
        check_plan({"resource_changes": [{"address": "service", "change": {"actions": ["update"]}}]})
        for actions in (["delete"], ["delete", "create"], ["create", "delete"]):
            with self.assertRaisesRegex(ValueError, "Deletion"):
                check_plan({"resource_changes": [{"address": "module.removed.service", "change": {"actions": actions}}]})

    def test_production_gate_fails_closed(self):
        self.assertFalse(check_approval({}))
        self.assertFalse(check_approval({"protection_rules": [{"type": "required_reviewers", "reviewers": []}]}))
        rule = {"type": "required_reviewers", "reviewers": [{"id": 1}], "prevent_self_review": False}
        self.assertTrue(check_approval({"protection_rules": [rule]}))
        rule["prevent_self_review"] = True
        self.assertTrue(check_approval({"protection_rules": [rule]}))

    def test_hosting_retry_checks_latest_live_release(self):
        self.assertFalse(matches([], "infra", "source"))
        self.assertFalse(matches([{}], "infra", "source"))
        releases = [{"message": "infra:infra source:source run:1"}]
        self.assertTrue(matches(releases, "infra", "source"))
        self.assertFalse(matches(releases, "other", "source"))
        self.assertFalse(matches(releases, "infra", "source-other"))
        self.assertFalse(matches([{"message": "manual release"}, *releases], "infra", "source"))

    def test_schemas_and_workflow_syntax(self):
        for path in (ROOT / "schemas").glob("*.json"):
            jsonschema.Draft202012Validator.check_schema(json.loads(path.read_text()))
        for path in (ROOT / ".github").rglob("*.yml"):
            with self.subTest(path=path):
                self.assertIsInstance(yaml.load(path.read_text(), Loader=yaml.BaseLoader), dict)


if __name__ == "__main__":
    unittest.main()
