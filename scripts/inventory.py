"""Read cloud resource metadata for the known projects. Never reads secret values."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
from urllib.request import Request, urlopen
from urllib.parse import urlencode

PROJECTS = {
    "fundocentenario-website-stg": "rodrigo.vanzelotti@fundocentenario.com.br",
    "fundocentenario-website-prd": "rodrigo.vanzelotti@fundocentenario.com.br",
    "landing-optimizer-landing-page": "rodrigovanzelotti@gmail.com",
}


def gcloud(project, account, arguments):
    command = "gcloud.cmd" if os.name == "nt" else "gcloud"
    result = subprocess.run(
        [command, "--quiet", f"--account={account}", f"--project={project}", *arguments],
        capture_output=True, text=True, timeout=120,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip())
    return result.stdout


def collect(project, account):
    queries = {
        "project": ["projects", "describe", project, "--format=json(projectId,projectNumber,name,lifecycleState)"],
        "enabled_apis": ["services", "list", "--enabled", "--format=json(config.name)"],
        "cloud_run": ["run", "services", "list", "--platform=managed",
                      "--format=json(metadata.name,metadata.labels,status.url,status.latestReadyRevisionName)"],
        "artifact_registry": ["artifacts", "repositories", "list", "--location=all", "--format=json(name,format)"],
        "secrets": ["secrets", "list", "--format=json(name,replication)"],
        "buckets": ["storage", "buckets", "list", "--format=json(name,location,versioning)"],
        "service_accounts": ["iam", "service-accounts", "list", "--format=json(email,disabled)"],
    }
    inventory = {"account": account, "resources": {}, "errors": {}}
    for name, arguments in queries.items():
        try:
            inventory["resources"][name] = json.loads(gcloud(project, account, arguments))
        except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as error:
            inventory["errors"][name] = str(error)
    try:
        token = gcloud(project, account, ["auth", "print-access-token"]).strip()
        request = Request(
            f"https://firebasehosting.googleapis.com/v1beta1/projects/{project}/sites?pageSize=100",
            headers={"Authorization": f"Bearer {token}", "x-goog-user-project": project},
        )
        sites = []
        while True:
            with urlopen(request, timeout=30) as response:
                page = json.load(response)
            sites.extend(page.get("sites", []))
            if not page.get("nextPageToken"):
                break
            request = Request(
                f"https://firebasehosting.googleapis.com/v1beta1/projects/{project}/sites?"
                + urlencode({"pageSize": 100, "pageToken": page["nextPageToken"]}),
                headers={"Authorization": f"Bearer {token}", "x-goog-user-project": project},
            )
        inventory["resources"]["hosting_sites"] = sites
    except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as error:
        inventory["errors"]["hosting_sites"] = str(error)
    return inventory


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", choices=list(PROJECTS))
    parser.add_argument("--output", type=Path, default=Path(".local/inventory.json"))
    args = parser.parse_args()
    projects = {args.project: PROJECTS[args.project]} if args.project else PROJECTS
    result = {project: collect(project, account) for project, account in projects.items()}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(f"Inventory written to {args.output}; failed queries are recorded explicitly")
    sys.exit(1 if any(value["errors"] for value in result.values()) else 0)
