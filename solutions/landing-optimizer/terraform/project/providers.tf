terraform {
  required_version = ">= 1.16, < 2.0"
  required_providers {
    google = { source = "hashicorp/google", version = "7.46.2" }
  }
  backend "gcs" {
    bucket = "landing-optimizer-v1-tfstate-505424813528"
    prefix = "landing-optimizer/project"
  }
}
provider "google" {
  project                         = "landing-optimizer-landing-page"
  region                          = "southamerica-east1"
  billing_project                 = "landing-optimizer-landing-page"
  user_project_override           = true
  add_terraform_attribution_label = false
}
provider "google" {
  alias                           = "demo"
  project                         = "landing-optimizer-demo"
  region                          = "southamerica-east1"
  add_terraform_attribution_label = false
}
