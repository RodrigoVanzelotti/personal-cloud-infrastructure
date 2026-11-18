"""Return the enabled solution/environment matrix affected by a Git diff."""
import argparse
import json
import subprocess

from validate import ROOT, manifests, validate_tree


def changed(paths, root=ROOT):
    paths = set(paths)
    global_change = any(
        p.startswith(("terraform/", "scripts/", "schemas/", ".github/workflows/"))
        or p == "requirements.txt" for p in paths
    )
    result = []
    for solution_file in sorted((root / "solutions").glob("*/solution.yaml")):
        solution_name = solution_file.parent.name
        for name in ("stage", "prod"):
            _, environment = manifests(solution_name, name, root=root)
            prefix = f"solutions/{solution_name}"
            if environment["enabled"] and (
                global_change or f"{prefix}/solution.yaml" in paths
                or f"{prefix}/environments/{name}.yaml" in paths
            ):
                result.append({"solution": solution_name, "environment": name})
    # Removing a manifest must never silently orphan an enabled state.
    for path in paths:
        if path.startswith("solutions/") and path.endswith(".yaml") and not (root / path).exists():
            native = root / "solutions" / path.split("/")[1] / "terraform"
            if not any(native.glob("*/providers.tf")):
                raise ValueError(f"Deleted manifest: {path}; retire resources explicitly before removal")
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", required=True)
    parser.add_argument("--head", default="HEAD")
    args = parser.parse_args()
    validate_tree()
    paths = subprocess.check_output(
        ["git", "diff", "--name-only", "--no-renames", args.base, args.head],
        cwd=ROOT, text=True,
    ).splitlines()
    print(json.dumps(changed(paths), separators=(",", ":")))
