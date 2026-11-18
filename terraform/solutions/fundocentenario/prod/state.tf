resource "google_storage_bucket" "state" {
  project                     = "fundocentenario-website-prd"
  name                        = "fundocentenario-website-prd-tfstate"
  location                    = "SOUTHAMERICA-EAST1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  versioning { enabled = true }
  lifecycle { prevent_destroy = true }
}
