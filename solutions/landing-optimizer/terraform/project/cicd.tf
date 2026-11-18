locals {
  deployer = "serviceAccount:${google_service_account.sites_deployer.email}"
}
resource "google_project_iam_member" "demo_release_read" {
  provider = google.demo
  project  = "landing-optimizer-demo"
  for_each = toset(["roles/viewer", "roles/iam.securityReviewer"])
  role     = each.value
  member   = local.deployer
}
resource "google_cloud_run_v2_service_iam_member" "demo_deployer" {
  provider = google.demo
  project  = "landing-optimizer-demo"
  location = "southamerica-east1"
  name     = google_cloud_run_v2_service.demo.name
  role     = "roles/run.admin"
  member   = local.deployer
}
resource "google_artifact_registry_repository_iam_member" "demo_deployer" {
  provider   = google.demo
  project    = "landing-optimizer-demo"
  location   = "southamerica-east1"
  repository = google_artifact_registry_repository.demo.repository_id
  role       = "roles/artifactregistry.writer"
  member     = local.deployer
}
resource "google_artifact_registry_repository_iam_member" "landing_page_deployer" {
  project    = "landing-optimizer-landing-page"
  location   = "southamerica-east1"
  repository = google_artifact_registry_repository.main.repository_id
  role       = "roles/artifactregistry.writer"
  member     = local.deployer
}
resource "google_service_account_iam_member" "demo_runtime" {
  provider           = google.demo
  service_account_id = "projects/landing-optimizer-demo/serviceAccounts/943261198056-compute@developer.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  member             = local.deployer
}
resource "google_service_account_iam_member" "landing_page_runtime" {
  service_account_id = google_service_account.landing_page.name
  role               = "roles/iam.serviceAccountUser"
  member             = local.deployer
}

resource "google_service_account" "sites_deployer" {
  project      = "landing-optimizer-landing-page"
  account_id   = "landing-optimizer-sites"
  display_name = "Landing Optimizer marketing/demo releases"
}
resource "google_project_iam_member" "sites_read" {
  project  = "landing-optimizer-landing-page"
  for_each = toset(["roles/viewer", "roles/iam.securityReviewer", "roles/serviceusage.serviceUsageConsumer", "roles/firebaserules.viewer"])
  role     = each.value
  member   = local.deployer
}
resource "google_cloud_run_v2_service_iam_member" "landing_page_deployer" {
  project  = "landing-optimizer-landing-page"
  location = "southamerica-east1"
  name     = google_cloud_run_v2_service.main.name
  role     = "roles/run.admin"
  member   = local.deployer
}
resource "google_service_account_iam_member" "sites_github" {
  for_each           = toset(["1437893209", "1437556030"])
  service_account_id = google_service_account.sites_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/505424813528/locations/global/workloadIdentityPools/landing-optimizer-github/attribute.repository_id/${each.value}"
}
resource "google_storage_bucket_iam_member" "sites_state_read" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectViewer"
  member = local.deployer
}
resource "google_storage_bucket_iam_member" "sites_state_write" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = local.deployer
  condition {
    title      = "SitesStateAndReleaseLock"
    expression = "resource.name.startsWith('projects/_/buckets/${google_storage_bucket.terraform_state.name}/objects/landing-optimizer/project/') || resource.name == 'projects/_/buckets/${google_storage_bucket.terraform_state.name}/objects/landing-optimizer/v1/deployment.lock'"
  }
}
