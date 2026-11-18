"""Refuse automated deletion/replacement, including removal of a whole module."""
import json
import sys


def check(plan):
    deletes = [
        change["address"] for change in plan.get("resource_changes", [])
        if "delete" in change.get("change", {}).get("actions", [])
    ]
    if deletes:
        raise ValueError("Deletion requires a separate retirement process: " + ", ".join(deletes))


if __name__ == "__main__":
    try:
        check(json.load(sys.stdin))
    except ValueError as error:
        sys.exit(str(error))
