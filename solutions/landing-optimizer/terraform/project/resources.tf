resource "google_cloud_run_v2_service" "demo" {
  provider             = google.demo
  client               = "gcloud"
  client_version       = "594.0.0"
  default_uri_disabled = false
  deletion_policy      = "DELETE"
  deletion_protection  = true
  iap_enabled          = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = true
  launch_stage         = "GA"
  location             = "southamerica-east1"
  name                 = "landing-optimizer-demo"
  project              = "landing-optimizer-demo"
  scaling {
    manual_instance_count = 0
    max_instance_count    = 1
    min_instance_count    = 0
  }
  template {
    gpu_zonal_redundancy_disabled    = false
    health_check_disabled            = false
    labels                           = var.demo_revision_labels
    max_instance_request_concurrency = 80
    service_account                  = "943261198056-compute@developer.gserviceaccount.com"
    session_affinity                 = false
    timeout                          = "300s"
    containers {
      image            = var.demo_image
      name             = "placeholder-1"
      sandbox_launcher = false
      ports {
        container_port = 8080
        name           = "http1"
      }
      resources {
        cpu_idle = true
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
        startup_cpu_boost = true
      }
      startup_probe {
        failure_threshold     = 1
        initial_delay_seconds = 0
        period_seconds        = 240
        timeout_seconds       = 240
        tcp_socket {
          port = 8080
        }
      }
    }
    scaling {
      max_instance_count = 3
      min_instance_count = 0
    }
  }
  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
  lifecycle { prevent_destroy = true }
}
resource "google_artifact_registry_repository" "demo" {
  provider               = google.demo
  cleanup_policy_dry_run = false
  deletion_policy        = "DELETE"
  description            = "Cloud Run Source Deployments"
  format                 = "DOCKER"
  location               = "southamerica-east1"
  mode                   = "STANDARD_REPOSITORY"
  project                = "landing-optimizer-demo"
  repository_id          = "cloud-run-source-deploy"
  vulnerability_scanning_config {
  }
  lifecycle { prevent_destroy = true }
}
resource "google_cloudbuild_trigger" "demo" {
  provider           = google.demo
  deletion_policy    = "DELETE"
  description        = "Legacy source build disabled; releases are owned by personal-cloud-infrastructure"
  disabled           = true
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  location           = "global"
  name               = "rmgpgab-landing-optimizer-demo-southamerica-east1-RodrigoVannit"
  project            = "landing-optimizer-demo"
  service_account    = "projects/landing-optimizer-demo/serviceAccounts/943261198056-compute@developer.gserviceaccount.com"
  substitutions = {
    _AR_HOSTNAME   = "southamerica-east1-docker.pkg.dev"
    _AR_PROJECT_ID = "landing-optimizer-demo"
    _AR_REPOSITORY = "cloud-run-source-deploy"
    _DEPLOY_REGION = "southamerica-east1"
    _PLATFORM      = "managed"
    _SERVICE_NAME  = "landing-optimizer-demo"
    _TRIGGER_ID    = "9e89550d-65eb-4a58-8b9b-739a97f0bd4d"
  }
  tags = ["gcp-cloud-build-deploy-cloud-run", "gcp-cloud-build-deploy-cloud-run-managed", "landing-optimizer-demo"]
  approval_config {
    approval_required = false
  }
  build {
    # Preserve the Cloud Build API default; the provider otherwise chooses 600s.
    timeout = "3600s"
    images  = ["$_AR_HOSTNAME/$_AR_PROJECT_ID/$_AR_REPOSITORY/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA"]
    substitutions = {
      _AR_HOSTNAME   = "southamerica-east1-docker.pkg.dev"
      _AR_PROJECT_ID = "landing-optimizer-demo"
      _AR_REPOSITORY = "cloud-run-source-deploy"
      _DEPLOY_REGION = "southamerica-east1"
      _PLATFORM      = "managed"
      _SERVICE_NAME  = "landing-optimizer-demo"
      _TRIGGER_ID    = "9e89550d-65eb-4a58-8b9b-739a97f0bd4d"
    }
    tags = ["gcp-cloud-build-deploy-cloud-run", "gcp-cloud-build-deploy-cloud-run-managed", "landing-optimizer-demo"]
    options {
      disk_size_gb          = 0
      dynamic_substitutions = false
      logging               = "CLOUD_LOGGING_ONLY"
      substitution_option   = "ALLOW_LOOSE"
    }
    step {
      allow_failure = false
      args          = ["build", "--no-cache", "-t", "$_AR_HOSTNAME/$_AR_PROJECT_ID/$_AR_REPOSITORY/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA", ".", "-f", "Dockerfile"]
      id            = "Build"
      name          = "gcr.io/cloud-builders/docker"
    }
    step {
      allow_failure = false
      args          = ["push", "$_AR_HOSTNAME/$_AR_PROJECT_ID/$_AR_REPOSITORY/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA"]
      id            = "Push"
      name          = "gcr.io/cloud-builders/docker"
    }
  }
  github {
    name  = "landing-optimizer-demo"
    owner = "RodrigoVanzelotti"
    push {
      branch       = "^main$"
      invert_regex = false
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_storage_bucket" "build_logs" {
  default_event_based_hold    = false
  deletion_policy             = "DELETE"
  enable_object_retention     = false
  force_destroy               = false
  location                    = "US"
  name                        = "505424813528-global-cloudbuild-logs"
  project                     = "landing-optimizer-landing-page"
  public_access_prevention    = "inherited"
  requester_pays              = false
  rpo                         = "DEFAULT"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  hierarchical_namespace {
    enabled = false
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                                     = 0
      days_since_custom_time                  = 0
      days_since_noncurrent_time              = 0
      num_newer_versions                      = 1
      send_age_if_zero                        = false
      send_days_since_custom_time_if_zero     = false
      send_days_since_noncurrent_time_if_zero = false
      send_num_newer_versions_if_zero         = false
      size_above_bytes                        = 0
      size_below_bytes                        = 0
      with_state                              = "ANY"
    }
  }
  soft_delete_policy {
    retention_duration_seconds = 604800
  }
  versioning {
    enabled = true
  }
  lifecycle { prevent_destroy = true }
}
resource "google_firestore_database" "main" {
  app_engine_integration_mode       = "DISABLED"
  concurrency_mode                  = "PESSIMISTIC"
  database_edition                  = "STANDARD"
  delete_protection_state           = "DELETE_PROTECTION_DISABLED"
  deletion_policy                   = "ABANDON"
  location_id                       = "southamerica-east1"
  name                              = "(default)"
  point_in_time_recovery_enablement = "POINT_IN_TIME_RECOVERY_DISABLED"
  project                           = "landing-optimizer-landing-page"
  realtime_updates_mode             = "REALTIME_UPDATES_MODE_ENABLED"
  type                              = "FIRESTORE_NATIVE"
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service" "main" {
  client               = "gcloud"
  client_version       = "594.0.1"
  default_uri_disabled = false
  deletion_policy      = "DELETE"
  deletion_protection  = true
  iap_enabled          = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = true
  launch_stage         = "GA"
  location             = "southamerica-east1"
  name                 = "landing-optimizer-landing-page"
  project              = "landing-optimizer-landing-page"
  scaling {
    manual_instance_count = 0
    max_instance_count    = 3
    min_instance_count    = 0
  }
  template {
    gpu_zonal_redundancy_disabled    = false
    health_check_disabled            = false
    labels                           = var.landing_page_revision_labels
    max_instance_request_concurrency = 80
    service_account                  = "landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
    session_affinity                 = false
    timeout                          = "300s"
    containers {
      image            = var.landing_page_image
      name             = "placeholder-1"
      sandbox_launcher = false
      ports {
        container_port = 8080
        name           = "http1"
      }
      resources {
        cpu_idle = true
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
        startup_cpu_boost = true
      }
      startup_probe {
        failure_threshold     = 1
        initial_delay_seconds = 0
        period_seconds        = 240
        timeout_seconds       = 240
        tcp_socket {
          port = 8080
        }
      }
    }
  }
  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
  lifecycle { prevent_destroy = true }
}
resource "google_storage_bucket" "build_sources" {
  default_event_based_hold    = false
  deletion_policy             = "DELETE"
  enable_object_retention     = false
  force_destroy               = false
  location                    = "US"
  name                        = "landing-optimizer-landing-page_cloudbuild"
  project                     = "landing-optimizer-landing-page"
  public_access_prevention    = "inherited"
  requester_pays              = false
  rpo                         = "DEFAULT"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false
  hierarchical_namespace {
    enabled = false
  }
  soft_delete_policy {
    retention_duration_seconds = 604800
  }
  lifecycle { prevent_destroy = true }
}
resource "google_cloudbuild_trigger" "main" {
  deletion_policy    = "DELETE"
  description        = "Legacy source build disabled; releases are owned by personal-cloud-infrastructure"
  disabled           = true
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  location           = "global"
  name               = "rmgpgab-landing-optimizer-landing-page-southamerica-east1-Rohqb"
  project            = "landing-optimizer-landing-page"
  service_account    = "projects/landing-optimizer-landing-page/serviceAccounts/landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
  substitutions = {
    _AR_HOSTNAME   = "southamerica-east1-docker.pkg.dev"
    _AR_PROJECT_ID = "landing-optimizer-landing-page"
    _AR_REPOSITORY = "cloud-run-source-deploy"
    _DEPLOY_REGION = "southamerica-east1"
    _PLATFORM      = "managed"
    _SERVICE_NAME  = "landing-optimizer-landing-page"
    _TRIGGER_ID    = "f81273bd-0790-45e2-9e44-20dcb5012b7e"
  }
  tags = ["gcp-cloud-build-deploy-cloud-run", "gcp-cloud-build-deploy-cloud-run-managed", "landing-optimizer-landing-page"]
  approval_config {
    approval_required = false
  }
  build {
    # Preserve the Cloud Build API default; the provider otherwise chooses 600s.
    timeout = "3600s"
    images  = ["$_AR_HOSTNAME/$_AR_PROJECT_ID/$_AR_REPOSITORY/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA"]
    substitutions = {
      _AR_HOSTNAME   = "southamerica-east1-docker.pkg.dev"
      _AR_PROJECT_ID = "landing-optimizer-landing-page"
      _AR_REPOSITORY = "cloud-run-source-deploy"
      _DEPLOY_REGION = "southamerica-east1"
      _PLATFORM      = "managed"
      _SERVICE_NAME  = "landing-optimizer-landing-page"
      _TRIGGER_ID    = "f81273bd-0790-45e2-9e44-20dcb5012b7e"
    }
    tags = ["gcp-cloud-build-deploy-cloud-run", "gcp-cloud-build-deploy-cloud-run-managed", "landing-optimizer-landing-page"]
    options {
      disk_size_gb          = 0
      dynamic_substitutions = false
      logging               = "CLOUD_LOGGING_ONLY"
      substitution_option   = "ALLOW_LOOSE"
    }
    step {
      allow_failure = false
      args          = ["build", "--no-cache", "-t", "$_AR_HOSTNAME/$_AR_PROJECT_ID/$_AR_REPOSITORY/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA", ".", "-f", "Dockerfile"]
      id            = "Build"
      name          = "gcr.io/cloud-builders/docker"
    }
    step {
      allow_failure = false
      args          = ["push", "$_AR_HOSTNAME/$_AR_PROJECT_ID/$_AR_REPOSITORY/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA"]
      id            = "Push"
      name          = "gcr.io/cloud-builders/docker"
    }
  }
  github {
    name  = "landing-optimizer-landing-page"
    owner = "RodrigoVanzelotti"
    push {
      branch       = "^main$"
      invert_regex = false
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "landing_page" {
  account_id      = "landing-page"
  deletion_policy = "DELETE"
  disabled        = false
  display_name    = "landing-page"
  project         = "landing-optimizer-landing-page"
  lifecycle { prevent_destroy = true }
}
resource "google_storage_bucket" "terraform_state" {
  default_event_based_hold    = false
  deletion_policy             = "DELETE"
  enable_object_retention     = false
  force_destroy               = false
  location                    = "SOUTHAMERICA-EAST1"
  name                        = "landing-optimizer-v1-tfstate-505424813528"
  project                     = "landing-optimizer-landing-page"
  public_access_prevention    = "enforced"
  requester_pays              = false
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  hierarchical_namespace {
    enabled = false
  }
  soft_delete_policy {
    retention_duration_seconds = 604800
  }
  versioning {
    enabled = true
  }
  lifecycle { prevent_destroy = true }
}
resource "google_artifact_registry_repository" "main" {
  cleanup_policy_dry_run = false
  deletion_policy        = "DELETE"
  description            = "Cloud Run Source Deployments"
  format                 = "DOCKER"
  location               = "southamerica-east1"
  mode                   = "STANDARD_REPOSITORY"
  project                = "landing-optimizer-landing-page"
  repository_id          = "cloud-run-source-deploy"
  vulnerability_scanning_config {
  }
  lifecycle { prevent_destroy = true }
}
