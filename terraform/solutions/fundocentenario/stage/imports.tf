import {
  to = google_firestore_database.app
  id = "projects/fundocentenario-website-stg/databases/(default)"
}

import {
  to = google_firestore_index.outbox_0
  id = "projects/fundocentenario-website-stg/databases/(default)/collectionGroups/fundo_thank_you_outbox/indexes/CICAgOjXh4EK"
}

import {
  to = google_cloud_scheduler_job.email
  id = "projects/fundocentenario-website-stg/locations/southamerica-east1/jobs/fundo-thank-you"
}

import {
  to = google_service_account.firebase_app_hosting_compute
  id = "projects/fundocentenario-website-stg/serviceAccounts/firebase-app-hosting-compute@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_service_account.firebase_adminsdk_fbsvc
  id = "projects/fundocentenario-website-stg/serviceAccounts/firebase-adminsdk-fbsvc@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_service_account.fundo_scheduler
  id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-scheduler@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_service_account.fundo_deploy
  id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_service_account.fundo_runtime
  id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-runtime@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_iam_workload_identity_pool.github
  id = "projects/424614961062/locations/global/workloadIdentityPools/github"
}

import {
  to = google_iam_workload_identity_pool_provider.github
  id = "projects/424614961062/locations/global/workloadIdentityPools/github/providers/github"
}

import {
  to = google_service_account_iam_member.fundo_deploy_iam_workloadIdentityUser_0
  id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com roles/iam.workloadIdentityUser principalSet://iam.googleapis.com/projects/424614961062/locations/global/workloadIdentityPools/github/attribute.repository_id/1400597312"
}

import {
  to = google_service_account_iam_member.fundo_runtime_iam_serviceAccountUser_0
  id = "projects/fundocentenario-website-stg/serviceAccounts/fundo-runtime@fundocentenario-website-stg.iam.gserviceaccount.com roles/iam.serviceAccountUser serviceAccount:fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.stripe_secret_key_secretmanager_secretAccessor_0
  id = "projects/fundocentenario-website-stg/secrets/stripe-secret-key roles/secretmanager.secretAccessor serviceAccount:fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_cloud_run_v2_service_iam_member.run_developer_0
  id = "projects/fundocentenario-website-stg/locations/southamerica-east1/services/fundo-centenario roles/run.developer serviceAccount:fundo-deploy@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_cloud_run_v2_service_iam_member.run_invoker_0
  id = "projects/fundocentenario-website-stg/locations/southamerica-east1/services/fundo-centenario roles/run.invoker serviceAccount:fundo-scheduler@fundocentenario-website-stg.iam.gserviceaccount.com"
}

import {
  to = google_cloud_run_v2_service_iam_member.run_invoker_1
  id = "projects/fundocentenario-website-stg/locations/southamerica-east1/services/fundo-centenario roles/run.invoker user:rodrigo.vanzelotti@fundocentenario.com.br"
}

import {
  to = google_firebaserules_ruleset.firestore
  id = "projects/fundocentenario-website-stg/rulesets/b2663f9d-b86d-4cbd-a362-50d96d21cbb4"
}

import {
  to = google_firebaserules_release.firestore
  id = "projects/fundocentenario-website-stg/releases/cloud.firestore"
}
