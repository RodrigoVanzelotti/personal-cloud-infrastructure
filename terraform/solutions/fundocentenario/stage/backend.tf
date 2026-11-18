terraform {
  backend "gcs" {
    bucket = "fundocentenario-website-stg-tfstate"
    prefix = "fundocentenario/stage-foundation"
  }
}
