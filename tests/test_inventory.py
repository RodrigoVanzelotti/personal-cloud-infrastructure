import json
from pathlib import Path
import sys
import unittest
from unittest.mock import MagicMock, patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from inventory import collect, gcloud


class InventoryTests(unittest.TestCase):
    @patch("inventory.subprocess.run")
    def test_cli_errors_are_not_empty_inventory(self, run):
        run.return_value.returncode = 1
        run.return_value.stderr = "Permission denied"
        with self.assertRaisesRegex(RuntimeError, "Permission denied"):
            gcloud("pilot-stage", "account@example.com", ["projects", "describe"])
        command = run.call_args.args[0]
        self.assertIn("--account=account@example.com", command)
        self.assertIn("--project=pilot-stage", command)
        self.assertIn("--quiet", command)

    @patch("inventory.gcloud", side_effect=RuntimeError("Network unavailable"))
    def test_failed_queries_remain_explicit(self, cloud):
        result = collect("pilot-stage", "account@example.com")
        self.assertEqual(result["resources"], {})
        self.assertEqual(len(result["errors"]), 14)

    @patch("inventory.urlopen")
    @patch("inventory.gcloud")
    def test_metadata_collection_paginates_without_recording_token(self, cloud, urlopen):
        cloud.side_effect = lambda project, account, args: "private-test-token" if args[0] == "auth" else "[]"
        pages = [
            {"sites": [{"name": "sites/one"}], "nextPageToken": "page 2"},
            {"sites": [{"name": "sites/two"}]},
        ]
        responses = []
        for page in pages:
            response = MagicMock()
            response.__enter__.return_value.read.return_value = json.dumps(page)
            responses.append(response)
        urlopen.side_effect = responses
        result = collect("pilot-stage", "account@example.com")
        self.assertEqual(result["errors"], {})
        self.assertEqual(len(result["resources"]["hosting_sites"]), 2)
        self.assertNotIn("private-test-token", json.dumps(result))
        queries = [call.args[2] for call in cloud.call_args_list]
        for service in ("run", "sql", "firestore", "scheduler", "builds", "asset"):
            self.assertTrue(any(query[0] == service for query in queries), service)
        self.assertFalse(any("access" in query or "--enable" in query for query in queries))
        self.assertIn("pageToken=page+2", urlopen.call_args.args[0].full_url)
        for call in urlopen.call_args_list:
            self.assertEqual(call.args[0].get_header("X-goog-user-project"), "pilot-stage")


if __name__ == "__main__":
    unittest.main()
