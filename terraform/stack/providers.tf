terraform {
  required_version = ">= 1.16, < 2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
    }
  }
  backend "gcs" {}
}

provider "google" {
  project                         = local.environment.gcp.project_id
  region                          = local.environment.gcp.region
  billing_project                 = local.environment.gcp.project_id
  user_project_override           = true
  add_terraform_attribution_label = false
}

provider "google-beta" {
  project                         = local.environment.gcp.project_id
  region                          = local.environment.gcp.region
  billing_project                 = local.environment.gcp.project_id
  user_project_override           = true
  add_terraform_attribution_label = false
}
