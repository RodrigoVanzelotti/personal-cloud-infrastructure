resource "google_firebaserules_release" "firestore" {
  deletion_policy = "DELETE"
  name            = "cloud.firestore"
  project         = "fundocentenario-website-stg"
  ruleset_name    = "projects/fundocentenario-website-stg/rulesets/b2663f9d-b86d-4cbd-a362-50d96d21cbb4"
  lifecycle { prevent_destroy = true }
}
resource "google_firebaserules_ruleset" "firestore" {
  deletion_policy = "DELETE"
  project         = "fundocentenario-website-stg"
  source {
    files {
      content = "rules_version = '2';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    // Only the backend accesses donor data through IAM / Application Default Credentials.\n    match /{document=**} {\n      allow read, write: if false;\n    }\n  }\n}\n"
      name    = "firestore.rules"
    }
  }
  lifecycle { prevent_destroy = true }
}
