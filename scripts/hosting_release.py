"""Check Firebase's latest live release before retrying a pinned deployment."""
import json
import os
from urllib.error import HTTPError
from urllib.request import Request, urlopen


def matches(releases, infra_commit, source_commit):
    if not releases:
        return False
    prefix = f"infra:{infra_commit} source:{source_commit} "
    return releases[0].get("message", "").startswith(prefix)


if __name__ == "__main__":
    request = Request(
        f"https://firebasehosting.googleapis.com/v1beta1/sites/{os.environ['SITE']}/releases?pageSize=1",
        headers={"Authorization": f"Bearer {os.environ['ACCESS_TOKEN']}",
                 "x-goog-user-project": os.environ["PROJECT"]},
    )
    try:
        with urlopen(request, timeout=30) as response:
            releases = json.load(response).get("releases", [])
    except HTTPError as error:
        if error.code != 404:
            raise
        releases = []
    deployed = matches(releases, os.environ["GITHUB_SHA"], os.environ["SOURCE_COMMIT"])
    with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as output:
        output.write(f"deployed={'true' if deployed else 'false'}\n")
    with open(os.environ["GITHUB_STEP_SUMMARY"], "a", encoding="utf-8") as summary:
        if releases:
            summary.write(f"Latest live Hosting release: `{releases[0].get('name', 'unknown')}`\n")
        else:
            summary.write("No prior Hosting release found.\n")
