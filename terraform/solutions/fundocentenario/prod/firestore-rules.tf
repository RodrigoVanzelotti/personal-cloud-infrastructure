resource "google_firebaserules_ruleset" "firestore" {
  deletion_policy = "DELETE"
  project         = "fundocentenario-website-prd"
  source {
    files {
      content = "rules_version = '2';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    // Only the backend accesses donor data through IAM / Application Default Credentials.\n    match /{document=**} {\n      allow read, write: if false;\n    }\n  }\n}\n"
      name    = "firestore.rules"
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_firebaserules_release" "firestore" {
  deletion_policy = "DELETE"
  name            = "cloud.firestore"
  project         = "fundocentenario-website-prd"
  ruleset_name    = "projects/fundocentenario-website-prd/rulesets/e17c6547-c7fc-4524-aee2-0035965d7b3a"
  lifecycle { prevent_destroy = true }
}
