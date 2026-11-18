terraform {
  backend "gcs" {
    bucket = "fundocentenario-website-prd-tfstate"
    prefix = "fundocentenario/prod"
  }
}
