import sys
import json
import os
import tempfile
import unittest
import urllib.error
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import ci_release
import deploy


def service(module, image, resource_type="google_cloud_run_v2_service"):
    return {"module": module, "type": resource_type, "instances": [{"attributes": {
        "template": [{"containers": [{"image": image}]}],
    }}]}


class ReleaseTests(unittest.TestCase):
    def test_preserves_current_service_images_and_ignores_migration_image(self):
        state = {"resources": [service("module.api[0]", "api@sha256:current"),
                              service("module.dashboard[0]", "dashboard@sha256:current"),
                              service("module.ai[0]", "ai@sha256:current"),
                              service("module.api[0]", "job@sha256:old", "google_cloud_run_v2_job")]}
        release = ci_release.deployed_images(state)
        self.assertEqual(release, {"deploy_api": True, "image": "api@sha256:current",
                                  "dashboard_image": "dashboard@sha256:current", "ai_image": "ai@sha256:current"})

    def test_missing_live_images_cannot_remove_existing_services(self):
        with self.assertRaisesRegex(RuntimeError, "missing"):
            ci_release.deployed_images({"resources": []})

    def test_project_releases_preserve_both_images_and_existing_labels(self):
        resources = []
        for name, image, labels in [("main", "marketing@sha256:current", {"commit-sha": "main-current"}),
                                    ("demo", "demo@sha256:current", {"commit-sha": "demo-current"})]:
            resources.append({"name": name, "type": "google_cloud_run_v2_service", "instances": [{"attributes": {
                "template": [{"containers": [{"image": image}], "labels": labels}],
            }}]})
        release = ci_release.deployed_images({"resources": resources}, "project")
        self.assertEqual(release, {"landing_page_image": "marketing@sha256:current", "demo_image": "demo@sha256:current",
                                  "landing_page_revision_labels": {"commit-sha": "main-current"},
                                  "demo_revision_labels": {"commit-sha": "demo-current"}})
        with self.assertRaisesRegex(RuntimeError, "missing"):
            ci_release.deployed_images({"resources": resources[:1]}, "project")

    @patch("deploy.cloud", return_value="test-token")
    @patch("deploy.run")
    def test_release_cannot_change_iam_or_another_service(self, run, cloud):
        for address in ("google_project_iam_member.owner", "module.dashboard[0].google_cloud_run_v2_service.this"):
            with self.subTest(address=address):
                run.side_effect = [None, json.dumps({"resource_changes": [{"address": address, "change": {"actions": ["update"]}}]})]
                with self.assertRaisesRegex(RuntimeError, "unrelated"):
                    deploy.apply(allowed_resources={"module.api[0].google_cloud_run_v2_service.this"})

    @patch("deploy.cloud", return_value="test-token")
    @patch("deploy.run")
    def test_release_applies_only_selected_service_and_refuses_replacement(self, run, cloud):
        address = "google_cloud_run_v2_service.demo"
        run.side_effect = [None, json.dumps({"resource_changes": [{"address": address, "change": {"actions": ["update"]}}]}), None]
        deploy.apply(root=deploy.ROOT.parent / "project", allowed_resources={address})
        self.assertIn("apply", run.call_args.args[0])
        run.side_effect = [None, json.dumps({"resource_changes": [{"address": address, "change": {"actions": ["delete", "create"]}}]})]
        with self.assertRaisesRegex(RuntimeError, "deletion/replacement"):
            deploy.apply(allowed_resources={address})

    @patch.dict(os.environ, {"COMPONENT": "demo", "GITHUB_SHA": "a" * 40,
                            "GITHUB_REPOSITORY": "RodrigoVanzelotti/landing-optimizer-api"})
    @patch("ci_release.github_request")
    def test_source_repository_cannot_release_another_component(self, github):
        previous = os.getcwd()
        try:
            with self.assertRaisesRegex(RuntimeError, "Invalid deployment source"):
                ci_release.main()
            github.assert_not_called()
        finally:
            os.chdir(previous)

    @patch.dict(os.environ, {"GITHUB_RUN_ID": "123"})
    @patch("ci_release.cloud", return_value="sha256:" + "a" * 64)
    @patch("ci_release.run")
    def test_demo_build_uses_its_project_and_checks_nginx(self, run, cloud):
        with tempfile.TemporaryDirectory() as temporary:
            workspace = Path(temporary)
            source = workspace / "landing-optimizer-demo"
            source.mkdir()
            (source / "Dockerfile").write_text("FROM nginx:stable-alpine\n")
            (source / "nginx.conf").write_text("server { listen 8080; }\n")
            (source / "index.html").write_text("<!doctype html><title>Demo</title>")
            with patch("ci_release.ROOT", workspace / "central"), patch("ci_release.WORKSPACE", workspace):
                image = ci_release.build("demo", "b" * 40)
            self.assertTrue(image.startswith("southamerica-east1-docker.pkg.dev/landing-optimizer-demo/"))
            self.assertEqual(cloud.call_args.kwargs["project"], "landing-optimizer-demo")
            calls = [call.args[0] for call in run.call_args_list]
            self.assertEqual(calls[1][-2:], ["nginx", "-t"])
            self.assertEqual(calls[2][0:2], ["docker", "push"])

    @patch("ci_release.owner_finished", return_value=True)
    @patch("ci_release.google_request")
    def test_recovers_only_finished_owner_and_deletes_exact_lock_generations(self, request, finished):
        busy = urllib.error.HTTPError("https://storage.googleapis.com", 412, "busy", None, None)
        owner = {"repository": "RodrigoVanzelotti/landing-optimizer-api", "run_id": "1", "attempt": "1"}
        request.side_effect = [busy, {"generation": "old"}, owner, {}, {"generation": "new"}, {}]
        with ci_release.deployment_lock(owner):
            pass
        finished.assert_called_once_with(owner)
        deletes = [call.args for call in request.call_args_list if len(call.args) > 1 and call.args[1] == "DELETE"]
        self.assertEqual(deletes, [(ci_release.LOCK_URL + "?ifGenerationMatch=old", "DELETE"),
                                  (ci_release.LOCK_URL + "?ifGenerationMatch=new", "DELETE")])

    @patch("ci_release.github_request")
    def test_refuses_unknown_lock_owner(self, request):
        with self.assertRaisesRegex(RuntimeError, "unknown owner"):
            ci_release.owner_finished({"repository": "someone/other", "run_id": "1", "attempt": "1"})
        request.assert_not_called()

    @patch("ci_release.github_request")
    def test_active_workflow_keeps_lock_but_finished_attempt_does_not(self, request):
        owner = {"repository": "RodrigoVanzelotti/landing-optimizer-ai", "run_id": "1", "attempt": "1"}
        request.return_value = {"status": "in_progress", "run_attempt": 1}
        self.assertFalse(ci_release.owner_finished(owner))
        request.return_value = {"status": "in_progress", "run_attempt": 2}
        self.assertTrue(ci_release.owner_finished(owner))


if __name__ == "__main__":
    unittest.main()
