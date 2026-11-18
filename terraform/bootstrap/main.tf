terraform {
  required_version = ">= 1.16, < 2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" { project = var.project_id }

variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "southamerica-east1"
}
variable "state_bucket" { type = string }
variable "solution" { type = string }
variable "environment" {
  type = string
  validation {
    condition     = contains(["stage", "prod"], var.environment)
    error_message = "Choose stage or prod."
  }
}
variable "github_repository" {
  type    = string
  default = "RodrigoVanzelotti/personal-cloud-infrastructure"
}
variable "runtime_service_accounts" {
  description = "Existing runtime identities that the deployer may act as."
  type        = set(string)
  default     = []
}

locals {
  identity_prefix = "infra-${substr(sha256("${var.solution}-${var.environment}"), 0, 12)}"
}

resource "google_project_service" "apis" {
  for_each = toset([
    "iam.googleapis.com", "iamcredentials.googleapis.com", "sts.googleapis.com",
    "cloudresourcemanager.googleapis.com", "run.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com", "artifactregistry.googleapis.com",
    "firebase.googleapis.com", "firebasehosting.googleapis.com",
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "state" {
  project                     = var.project_id
  name                        = var.state_bucket
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  versioning { enabled = true }
  lifecycle { prevent_destroy = true }
}

resource "google_service_account" "ci" {
  for_each     = toset(["plan", "apply"])
  project      = var.project_id
  account_id   = "${local.identity_prefix}-${each.key}"
  display_name = "${var.solution} ${var.environment} ${each.key}"
  depends_on   = [google_project_service.apis]
}

resource "google_storage_bucket_iam_member" "state" {
  bucket = google_storage_bucket.state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.ci["apply"].email}"
}

resource "google_storage_bucket_iam_member" "plan_read" {
  bucket = google_storage_bucket.state.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.ci["plan"].email}"
}

resource "google_storage_bucket_iam_member" "plan_lock" {
  bucket = google_storage_bucket.state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.ci["plan"].email}"
  condition {
    title      = "TerraformLockOnly"
    expression = "resource.name == 'projects/_/buckets/${var.state_bucket}/objects/${var.solution}/${var.environment}/default.tflock'"
  }
}

resource "google_project_iam_member" "plan" {
  for_each = toset(["roles/viewer", "roles/iam.securityReviewer", "roles/secretmanager.viewer", "roles/serviceusage.serviceUsageConsumer"])
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.ci["plan"].email}"
}

resource "google_project_iam_member" "apply" {
  for_each = toset([
    "roles/run.admin", "roles/secretmanager.admin",
    "roles/artifactregistry.admin", "roles/firebasehosting.admin",
    "roles/serviceusage.serviceUsageConsumer",
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.ci["apply"].email}"
}

resource "google_service_account_iam_member" "runtime" {
  for_each           = var.runtime_service_accounts
  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.value}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.ci["apply"].email}"
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = local.identity_prefix
  depends_on                = [google_project_service.apis]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  attribute_condition = "assertion.repository == '${var.github_repository}' && (assertion.ref == 'refs/heads/main' || (assertion.event_name == 'pull_request' && assertion.sub.endsWith('-plan')))"
  oidc { issuer_uri = "https://token.actions.githubusercontent.com" }
}

resource "google_service_account_iam_member" "federation" {
  for_each           = google_service_account.ci
  service_account_id = each.value.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/subject/repo:${var.github_repository}:environment:${var.solution}-${var.environment}${each.key == "plan" ? "-plan" : ""}"
}

output "workload_identity_provider" { value = google_iam_workload_identity_pool_provider.github.name }
output "service_accounts" { value = { for name, account in google_service_account.ci : name => account.email } }
output "state_bucket" { value = google_storage_bucket.state.name }
