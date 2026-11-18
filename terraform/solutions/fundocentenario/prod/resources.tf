resource "google_firestore_index" "outbox_0" {
  api_scope       = "ANY_API"
  collection      = "fundo_thank_you_outbox"
  database        = "(default)"
  deletion_policy = "DELETE"
  density         = "SPARSE_ALL"
  multikey        = false
  project         = "fundocentenario-website-prd"
  query_scope     = "COLLECTION"
  skip_wait       = false
  unique          = false
  fields {
    field_path = "state"
    order      = "ASCENDING"
  }
  fields {
    field_path = "next_attempt_at"
    order      = "ASCENDING"
  }
  fields {
    field_path = "__name__"
    order      = "ASCENDING"
  }
  lifecycle { prevent_destroy = true }
}
resource "google_artifact_registry_repository" "images" {
  cleanup_policy_dry_run = false
  deletion_policy        = "DELETE"
  format                 = "DOCKER"
  location               = "southamerica-east1"
  mode                   = "STANDARD_REPOSITORY"
  project                = "fundocentenario-website-prd"
  repository_id          = "fundo-images"
  vulnerability_scanning_config {
  }
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret" "smtp_password" {
  deletion_policy     = "DELETE"
  deletion_protection = false
  project             = "358530732475"
  secret_id           = "smtp-password"
  replication {
    auto {
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service_iam_member" "run_developer_0" {
  location = "southamerica-east1"
  member   = "serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
  name     = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario"
  project  = "fundocentenario-website-prd"
  role     = "roles/run.developer"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "fundo_scheduler" {
  account_id      = "fundo-scheduler"
  deletion_policy = "DELETE"
  disabled        = false
  project         = "fundocentenario-website-prd"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "fundo_runtime" {
  account_id      = "fundo-runtime"
  deletion_policy = "DELETE"
  disabled        = false
  project         = "fundocentenario-website-prd"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "firebase_adminsdk_fbsvc" {
  account_id      = "firebase-adminsdk-fbsvc"
  deletion_policy = "DELETE"
  description     = "Firebase Admin SDK Service Agent"
  disabled        = false
  display_name    = "firebase-adminsdk"
  project         = "fundocentenario-website-prd"
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret_iam_member" "stripe_webhook_secret_secretmanager_secretAccessor_0" {
  member    = "serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
  project   = "fundocentenario-website-prd"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = "projects/fundocentenario-website-prd/secrets/stripe-webhook-secret"
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret" "smtp_username" {
  deletion_policy     = "DELETE"
  deletion_protection = false
  project             = "358530732475"
  secret_id           = "smtp-username"
  replication {
    auto {
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_scheduler_job" "email" {
  attempt_deadline = "180s"
  deletion_policy  = "DELETE"
  name             = "fundo-thank-you"
  paused           = false
  project          = "fundocentenario-website-prd"
  region           = "southamerica-east1"
  schedule         = "*/5 * * * *"
  time_zone        = "America/Sao_Paulo"
  http_target {
    http_method = "POST"
    uri         = "https://fundo-centenario-o2dq7ckysa-rj.a.run.app/api/internal/emails/process"
    oidc_token {
      audience              = "https://fundo-centenario-o2dq7ckysa-rj.a.run.app"
      service_account_email = "fundo-scheduler@fundocentenario-website-prd.iam.gserviceaccount.com"
    }
  }
  retry_config {
    max_backoff_duration = "3600s"
    max_doublings        = 5
    max_retry_duration   = "0s"
    min_backoff_duration = "5s"
    retry_count          = 3
  }
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret_iam_member" "smtp_password_secretmanager_secretAccessor_0" {
  member    = "serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
  project   = "fundocentenario-website-prd"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = "projects/fundocentenario-website-prd/secrets/smtp-password"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "fundo_deploy" {
  account_id      = "fundo-deploy"
  deletion_policy = "DELETE"
  disabled        = false
  project         = "fundocentenario-website-prd"
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret_iam_member" "smtp_username_secretmanager_secretAccessor_0" {
  member    = "serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
  project   = "fundocentenario-website-prd"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = "projects/fundocentenario-website-prd/secrets/smtp-username"
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service_iam_member" "run_invoker_1" {
  location = "southamerica-east1"
  member   = "user:rodrigo.vanzelotti@fundocentenario.com.br"
  name     = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario"
  project  = "fundocentenario-website-prd"
  role     = "roles/run.invoker"
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret" "stripe_webhook_secret" {
  deletion_policy     = "DELETE"
  deletion_protection = false
  project             = "358530732475"
  secret_id           = "stripe-webhook-secret"
  replication {
    auto {
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret" "stripe_secret_key" {
  deletion_policy     = "DELETE"
  deletion_protection = false
  project             = "358530732475"
  secret_id           = "stripe-secret-key"
  replication {
    auto {
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "google_firestore_database" "app" {
  app_engine_integration_mode       = "DISABLED"
  concurrency_mode                  = "PESSIMISTIC"
  database_edition                  = "STANDARD"
  delete_protection_state           = "DELETE_PROTECTION_DISABLED"
  deletion_policy                   = "ABANDON"
  location_id                       = "southamerica-east1"
  name                              = "(default)"
  point_in_time_recovery_enablement = "POINT_IN_TIME_RECOVERY_DISABLED"
  project                           = "fundocentenario-website-prd"
  realtime_updates_mode             = "REALTIME_UPDATES_MODE_ENABLED"
  type                              = "FIRESTORE_NATIVE"
  lifecycle { prevent_destroy = true }
}
resource "google_iam_workload_identity_pool_provider" "github" {
  attribute_condition = "assertion.repository_id=='1400597312' && assertion.repository_owner_id=='85701210' && assertion.ref=='refs/heads/main' && assertion.environment=='production'"
  attribute_mapping = {
    "attribute.repository_id"       = "assertion.repository_id"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
    "google.subject"                = "assertion.sub"
  }
  deletion_policy                    = "DELETE"
  disabled                           = false
  project                            = "358530732475"
  workload_identity_pool_id          = "github"
  workload_identity_pool_provider_id = "github"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  lifecycle { prevent_destroy = true }
}
resource "google_iam_workload_identity_pool" "github" {
  deletion_policy           = "DELETE"
  disabled                  = false
  display_name              = "GitHub deployments"
  project                   = "358530732475"
  workload_identity_pool_id = "github"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account_iam_member" "fundo_runtime_iam_serviceAccountUser_0" {
  member             = "serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account_iam_member" "fundo_deploy_iam_workloadIdentityUser_0" {
  member             = "principalSet://iam.googleapis.com/projects/358530732475/locations/global/workloadIdentityPools/github/attribute.repository_id/1400597312"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service" "api" {
  client               = "gcloud"
  client_version       = "591.0.0"
  default_uri_disabled = false
  deletion_policy      = "DELETE"
  deletion_protection  = true
  iap_enabled          = false
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = false
  launch_stage         = "GA"
  location             = "southamerica-east1"
  name                 = "fundo-centenario"
  project              = "fundocentenario-website-prd"
  scaling {
    manual_instance_count = 0
    max_instance_count    = 20
    min_instance_count    = 0
  }
  template {
    gpu_zonal_redundancy_disabled    = false
    health_check_disabled            = false
    max_instance_request_concurrency = 20
    service_account                  = "fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
    session_affinity                 = false
    timeout                          = "180s"
    containers {
      image            = "southamerica-east1-docker.pkg.dev/fundocentenario-website-prd/fundo-images/fundo@sha256:ba502c8b99f625c760dbd10fc5d39c13842fad5c377a5202f17d9458ec54aea6"
      sandbox_launcher = false
      env {
        name  = "APP_ENV"
        value = "production"
      }
      env {
        name  = "CORS_ORIGINS"
        value = "https://fundocentenario.com.br"
      }
      env {
        name  = "EMAIL_ENABLED"
        value = "true"
      }
      env {
        name  = "EMAIL_FROM_ADDRESS"
        value = "rodrigo.vanzelotti@fundocentenario.com.br"
      }
      env {
        name  = "FIRESTORE_DATABASE"
        value = "(default)"
      }
      env {
        name  = "FIRESTORE_PREFIX"
        value = "fundo_"
      }
      env {
        name  = "GOOGLE_CLOUD_PROJECT"
        value = "fundocentenario-website-prd"
      }
      env {
        name  = "PUBLIC_BASE_URL"
        value = "https://fundocentenario.com.br"
      }
      env {
        name  = "PYTHON_DOTENV_DISABLED"
        value = "1"
      }
      env {
        name  = "SCHEDULER_AUDIENCE"
        value = "https://fundo-centenario-o2dq7ckysa-rj.a.run.app"
      }
      env {
        name  = "SCHEDULER_SERVICE_ACCOUNT"
        value = "fundo-scheduler@fundocentenario-website-prd.iam.gserviceaccount.com"
      }
      env {
        name  = "SERVE_FRONTEND"
        value = "false"
      }
      env {
        name  = "SMTP_HOST"
        value = "smtp.gmail.com"
      }
      env {
        name = "SMTP_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = "smtp-password"
            version = "2"
          }
        }
      }
      env {
        name  = "SMTP_PORT"
        value = "587"
      }
      env {
        name  = "SMTP_SECURITY"
        value = "starttls"
      }
      env {
        name = "SMTP_USERNAME"
        value_source {
          secret_key_ref {
            secret  = "smtp-username"
            version = "2"
          }
        }
      }
      env {
        name  = "STORAGE_BACKEND"
        value = "firestore"
      }
      env {
        name  = "STRIPE_API_VERSION"
        value = "2026-10-28.endive"
      }
      env {
        name = "STRIPE_SECRET_KEY"
        value_source {
          secret_key_ref {
            secret  = "stripe-secret-key"
            version = "1"
          }
        }
      }
      env {
        name = "STRIPE_WEBHOOK_SECRET"
        value_source {
          secret_key_ref {
            secret  = "stripe-webhook-secret"
            version = "1"
          }
        }
      }
      ports {
        container_port = 8000
        name           = "http1"
      }
      resources {
        cpu_idle = true
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
        startup_cpu_boost = true
      }
      startup_probe {
        failure_threshold     = 12
        initial_delay_seconds = 0
        period_seconds        = 10
        timeout_seconds       = 2
        http_get {
          path = "/api/health"
          port = 8000
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
resource "google_secret_manager_secret_iam_member" "stripe_secret_key_secretmanager_secretAccessor_0" {
  member    = "serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
  project   = "fundocentenario-website-prd"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = "projects/fundocentenario-website-prd/secrets/stripe-secret-key"
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service_iam_member" "run_invoker_0" {
  location = "southamerica-east1"
  member   = "serviceAccount:fundo-scheduler@fundocentenario-website-prd.iam.gserviceaccount.com"
  name     = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario"
  project  = "fundocentenario-website-prd"
  role     = "roles/run.invoker"
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret_iam_member" "stripe_secret_key_secretmanager_secretAccessor_1" {
  member    = "serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
  project   = "fundocentenario-website-prd"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = "projects/fundocentenario-website-prd/secrets/stripe-secret-key"
  lifecycle { prevent_destroy = true }
}
resource "google_firebase_hosting_site" "frontend" {
  provider        = google-beta
  deletion_policy = "DELETE"
  project         = "fundocentenario-website-prd"
  site_id         = "fundocentenario-website-prd"
  lifecycle { prevent_destroy = true }
}
