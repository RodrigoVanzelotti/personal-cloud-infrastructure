terraform {
  required_version = ">= 1.16, < 2.0"
  required_providers {
    google      = { source = "hashicorp/google", version = "7.46.2" }
    google-beta = { source = "hashicorp/google-beta", version = "7.46.2" }
  }
}
provider "google" {
  project                         = "fundocentenario-website-prd"
  region                          = "southamerica-east1"
  billing_project                 = "fundocentenario-website-prd"
  user_project_override           = true
  add_terraform_attribution_label = false
}
provider "google-beta" {
  project                         = "fundocentenario-website-prd"
  region                          = "southamerica-east1"
  billing_project                 = "fundocentenario-website-prd"
  user_project_override           = true
  add_terraform_attribution_label = false
}
