import {
  to = google_cloud_run_v2_service.api
  id = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario"
}

import {
  to = google_secret_manager_secret.smtp_password
  id = "projects/358530732475/secrets/smtp-password"
}

import {
  to = google_secret_manager_secret.smtp_username
  id = "projects/358530732475/secrets/smtp-username"
}

import {
  to = google_secret_manager_secret.stripe_secret_key
  id = "projects/358530732475/secrets/stripe-secret-key"
}

import {
  to = google_secret_manager_secret.stripe_webhook_secret
  id = "projects/358530732475/secrets/stripe-webhook-secret"
}

import {
  to = google_artifact_registry_repository.images
  id = "projects/fundocentenario-website-prd/locations/southamerica-east1/repositories/fundo-images"
}

import {
  to       = google_firebase_hosting_site.frontend
  id       = "projects/fundocentenario-website-prd/sites/fundocentenario-website-prd"
  provider = google-beta
}

import {
  to = google_firestore_database.app
  id = "projects/fundocentenario-website-prd/databases/(default)"
}

import {
  to = google_firestore_index.outbox_0
  id = "projects/fundocentenario-website-prd/databases/(default)/collectionGroups/fundo_thank_you_outbox/indexes/CICAgOjXh4EK"
}

import {
  to = google_cloud_scheduler_job.email
  id = "projects/fundocentenario-website-prd/locations/southamerica-east1/jobs/fundo-thank-you"
}

import {
  to = google_service_account.fundo_scheduler
  id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-scheduler@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_service_account.fundo_deploy
  id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_service_account.fundo_runtime
  id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_service_account.firebase_adminsdk_fbsvc
  id = "projects/fundocentenario-website-prd/serviceAccounts/firebase-adminsdk-fbsvc@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_iam_workload_identity_pool.github
  id = "projects/358530732475/locations/global/workloadIdentityPools/github"
}

import {
  to = google_iam_workload_identity_pool_provider.github
  id = "projects/358530732475/locations/global/workloadIdentityPools/github/providers/github"
}

import {
  to = google_service_account_iam_member.fundo_deploy_iam_workloadIdentityUser_0
  id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com roles/iam.workloadIdentityUser principalSet://iam.googleapis.com/projects/358530732475/locations/global/workloadIdentityPools/github/attribute.repository_id/1400597312"
}

import {
  to = google_service_account_iam_member.fundo_runtime_iam_serviceAccountUser_0
  id = "projects/fundocentenario-website-prd/serviceAccounts/fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com roles/iam.serviceAccountUser serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.smtp_password_secretmanager_secretAccessor_0
  id = "projects/fundocentenario-website-prd/secrets/smtp-password roles/secretmanager.secretAccessor serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.smtp_username_secretmanager_secretAccessor_0
  id = "projects/fundocentenario-website-prd/secrets/smtp-username roles/secretmanager.secretAccessor serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.stripe_secret_key_secretmanager_secretAccessor_0
  id = "projects/fundocentenario-website-prd/secrets/stripe-secret-key roles/secretmanager.secretAccessor serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.stripe_secret_key_secretmanager_secretAccessor_1
  id = "projects/fundocentenario-website-prd/secrets/stripe-secret-key roles/secretmanager.secretAccessor serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.stripe_webhook_secret_secretmanager_secretAccessor_0
  id = "projects/fundocentenario-website-prd/secrets/stripe-webhook-secret roles/secretmanager.secretAccessor serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_cloud_run_v2_service_iam_member.run_developer_0
  id = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario roles/run.developer serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_cloud_run_v2_service_iam_member.run_invoker_0
  id = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario roles/run.invoker serviceAccount:fundo-scheduler@fundocentenario-website-prd.iam.gserviceaccount.com"
}

import {
  to = google_cloud_run_v2_service_iam_member.run_invoker_1
  id = "projects/fundocentenario-website-prd/locations/southamerica-east1/services/fundo-centenario roles/run.invoker user:rodrigo.vanzelotti@fundocentenario.com.br"
}

import {
  to = google_firebaserules_ruleset.firestore
  id = "projects/fundocentenario-website-prd/rulesets/e17c6547-c7fc-4524-aee2-0035965d7b3a"
}

import {
  to = google_firebaserules_release.firestore
  id = "projects/fundocentenario-website-prd/releases/cloud.firestore"
}
