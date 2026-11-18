resource "google_firebaserules_ruleset" "firestore" {
  deletion_policy = "DELETE"
  project         = "landing-optimizer-landing-page"
  source {
    files {
      content = "rules_version = '2';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    match /{document=**} {\n      allow read, write: if false;\n    }\n  }\n}"
      name    = "cloud.firestore"
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_firebaserules_release" "firestore" {
  deletion_policy = "DELETE"
  name            = "cloud.firestore"
  project         = "landing-optimizer-landing-page"
  ruleset_name    = "projects/landing-optimizer-landing-page/rulesets/1643490c-cc5d-41ee-beab-24b09c6266ec"
  lifecycle { prevent_destroy = true }
}
