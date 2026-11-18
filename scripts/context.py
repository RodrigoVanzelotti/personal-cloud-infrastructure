"""Emit validated GitHub job outputs; no credentials or secret values."""
import argparse
import json
import os

from validate import manifests, validate_tree


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("solution")
    parser.add_argument("environment", choices=["stage", "prod"])
    args = parser.parse_args()
    validate_tree()
    solution, environment = manifests(args.solution, args.environment, deployable=True)
    hosting = []
    for name, component in solution["components"].items():
        if component["type"] == "firebase_hosting":
            hosting.append({
                "component": name,
                "repository": solution["repositories"][component["repository"]]["slug"],
                **environment["deployments"][name],
            })
    outputs = {
        "project_id": environment["gcp"]["project_id"],
        "state_bucket": environment["state_bucket"],
        "hosting": json.dumps(hosting, separators=(",", ":")),
    }
    with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as stream:
        for key, value in outputs.items():
            stream.write(f"{key}={value}\n")
