terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
    }
  }
}

variable "project_id" { type = string }
variable "site_id" { type = string }

# Firebase must already be enabled on the project before adopting its sites.
resource "google_firebase_hosting_site" "this" {
  provider        = google-beta
  project         = var.project_id
  site_id         = var.site_id
  deletion_policy = "PREVENT"
  lifecycle { prevent_destroy = true }
}

