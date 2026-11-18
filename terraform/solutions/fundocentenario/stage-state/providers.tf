terraform {
  required_version = ">= 1.16, < 2.0"
  required_providers {
    google = { source = "hashicorp/google", version = "7.46.2" }
  }
  backend "gcs" {
    bucket = "fundocentenario-website-stg-tfstate"
    prefix = "bootstrap/fundocentenario/stage"
  }
}
provider "google" {
  project = "fundocentenario-website-stg"
  region  = "southamerica-east1"
}
