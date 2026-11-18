"""Fail before cloud authentication if production lacks required reviewers."""
import json
import os
import sys
from urllib.request import Request, urlopen


def check(environment):
    return any(
        rule.get("type") == "required_reviewers" and rule.get("reviewers")
        for rule in environment.get("protection_rules", [])
    )


if __name__ == "__main__":
    if os.environ["DEPLOY_ENVIRONMENT"] == "prod":
        name = os.environ["DEPLOY_SOLUTION"] + "-prod"
        request = Request(
            f"https://api.github.com/repos/{os.environ['GITHUB_REPOSITORY']}/environments/{name}",
            headers={"Authorization": f"Bearer {os.environ['GH_TOKEN']}",
                     "Accept": "application/vnd.github+json"},
        )
        with urlopen(request, timeout=30) as response:
            if not check(json.load(response)):
                sys.exit("Production requires configured environment reviewers")
