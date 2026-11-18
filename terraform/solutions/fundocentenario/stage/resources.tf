resource "google_firestore_index" "outbox_0" {
  api_scope       = "ANY_API"
  collection      = "fundo_thank_you_outbox"
  database        = "(default)"
  deletion_policy = "DELETE"
  density         = "SPARSE_ALL"
  multikey        = false
  project         = "fundocentenario-website-stg"
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
resource "google_service_account" "firebase_adminsdk_fbsvc" {
  account_id      = "firebase-adminsdk-fbsvc"
  deletion_policy = "DELETE"
  description     = "Firebase Admin SDK Service Agent"
  disabled        = false
  display_name    = "firebase-adminsdk"
  project         = "fundocentenario-website-stg"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "fundo_deploy" {
  account_id      = "fundo-deploy"
  deletion_policy = "DELETE"
  disabled        = false
  project         = "fundocentenario-website-stg"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "fundo_scheduler" {
  account_id      = "fundo-scheduler"
  deletion_policy = "DELETE"
  disabled        = false
  project         = "fundocentenario-website-stg"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "firebase_app_hosting_compute" {
  account_id      = "firebase-app-hosting-compute"
  deletion_policy = "DELETE"
  disabled        = false
  display_name    = "Firebase App Hosting compute service account"
  project         = "fundocentenario-website-stg"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account" "fundo_runtime" {
  account_id      = "fundo-runtime"
  deletion_policy = "DELETE"
  disabled        = false
  project         = "fundocentenario-website-stg"
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
  project                           = "fundocentenario-website-stg"
  realtime_updates_mode             = "REALTIME_UPDATES_MODE_ENABLED"
  type                              = "FIRESTORE_NATIVE"
  lifecycle { prevent_destroy = true }
}
resource "google_iam_workload_identity_pool" "github" {
  deletion_policy           = "DELETE"
  disabled                  = false
  display_name              = "GitHub deployments"
  project                   = "424614961062"
  workload_identity_pool_id = "github"
  lifecycle { prevent_destroy = true }
}
resource "google_iam_workload_identity_pool_provider" "github" {
  attribute_condition = "assertion.repository_id=='1400597312' && assertion.repository_owner_id=='85701210' && assertion.ref=='refs/heads/main' && assertion.environment=='staging'"
  attribute_mapping = {
    "attribute.repository_id"       = "assertion.repository_id"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
    "google.subject"                = "assertion.sub"
  }
  deletion_policy                    = "DELETE"
  disabled                           = false
  project                            = "424614961062"
  workload_identity_pool_id          = "github"
  workload_identity_pool_provider_id = "github"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service_iam_member" "run_developer_0" {
  location = "southamerica-east1"
  member   = "serviceAccount:fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
  name     = "projects/fundocentenario-website-stg/locations/southamerica-east1/services/fundo-centenario"
  project  = "fundocentenario-website-stg"
  role     = "roles/run.developer"
  lifecycle { prevent_destroy = true }
}
resource "google_secret_manager_secret_iam_member" "stripe_secret_key_secretmanager_secretAccessor_0" {
  member    = "serviceAccount:fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
  project   = "fundocentenario-website-stg"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = "projects/fundocentenario-website-stg/secrets/stripe-secret-key"
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_scheduler_job" "email" {
  attempt_deadline = "180s"
  deletion_policy  = "DELETE"
  name             = "fundo-thank-you"
  paused           = false
  project          = "fundocentenario-website-stg"
  region           = "southamerica-east1"
  schedule         = "*/5 * * * *"
  time_zone        = "America/Sao_Paulo"
  http_target {
    http_method = "POST"
    uri         = "https://fundo-centenario-wouc4s5bsa-rj.a.run.app/api/internal/emails/process"
    oidc_token {
      audience              = "https://fundo-centenario-wouc4s5bsa-rj.a.run.app"
      service_account_email = "fundo-scheduler@fundocentenario-website-stg.iam.gserviceaccount.com"
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
resource "google_cloud_run_v2_service_iam_member" "run_invoker_1" {
  location = "southamerica-east1"
  member   = "user:rodrigo.vanzelotti@fundocentenario.com.br"
  name     = "projects/fundocentenario-website-stg/locations/southamerica-east1/services/fundo-centenario"
  project  = "fundocentenario-website-stg"
  role     = "roles/run.invoker"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account_iam_member" "fundo_deploy_iam_workloadIdentityUser_0" {
  member             = "principalSet://iam.googleapis.com/projects/424614961062/locations/global/workloadIdentityPools/github/attribute.repository_id/1400597312"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
  lifecycle { prevent_destroy = true }
}
resource "google_service_account_iam_member" "fundo_runtime_iam_serviceAccountUser_0" {
  member             = "serviceAccount:fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-runtime@fundocentenario-website-stg.iam.gserviceaccount.com"
  lifecycle { prevent_destroy = true }
}
resource "google_cloud_run_v2_service_iam_member" "run_invoker_0" {
  location = "southamerica-east1"
  member   = "serviceAccount:fundo-scheduler@fundocentenario-website-stg.iam.gserviceaccount.com"
  name     = "projects/fundocentenario-website-stg/locations/southamerica-east1/services/fundo-centenario"
  project  = "fundocentenario-website-stg"
  role     = "roles/run.invoker"
  lifecycle { prevent_destroy = true }
}
