resource "google_storage_bucket" "state" {
  project                     = "fundocentenario-website-stg"
  name                        = "fundocentenario-website-stg-tfstate"
  location                    = "SOUTHAMERICA-EAST1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  versioning { enabled = true }
  lifecycle { prevent_destroy = true }
}

output "state_bucket" {
  value = google_storage_bucket.state.name
}
