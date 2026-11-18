import {
  to = google_cloud_run_v2_service.main
  id = "projects/landing-optimizer-landing-page/locations/southamerica-east1/services/landing-optimizer-landing-page"
}

import {
  to = google_artifact_registry_repository.main
  id = "projects/landing-optimizer-landing-page/locations/southamerica-east1/repositories/cloud-run-source-deploy"
}

import {
  to = google_cloudbuild_trigger.main
  id = "projects/landing-optimizer-landing-page/locations/global/triggers/f81273bd-0790-45e2-9e44-20dcb5012b7e"
}

import {
  to = google_storage_bucket.build_logs
  id = "505424813528-global-cloudbuild-logs"
}

import {
  to = google_storage_bucket.build_sources
  id = "landing-optimizer-landing-page_cloudbuild"
}

import {
  to = google_storage_bucket.terraform_state
  id = "landing-optimizer-v1-tfstate-505424813528"
}

import {
  to = google_project_service.main["analyticshub.googleapis.com"]
  id = "landing-optimizer-landing-page/analyticshub.googleapis.com"
}

import {
  to = google_project_service.main["appoptimize.googleapis.com"]
  id = "landing-optimizer-landing-page/appoptimize.googleapis.com"
}

import {
  to = google_project_service.main["apptopology.googleapis.com"]
  id = "landing-optimizer-landing-page/apptopology.googleapis.com"
}

import {
  to = google_project_service.main["artifactregistry.googleapis.com"]
  id = "landing-optimizer-landing-page/artifactregistry.googleapis.com"
}

import {
  to = google_project_service.main["backupdr.googleapis.com"]
  id = "landing-optimizer-landing-page/backupdr.googleapis.com"
}

import {
  to = google_project_service.main["bigquery.googleapis.com"]
  id = "landing-optimizer-landing-page/bigquery.googleapis.com"
}

import {
  to = google_project_service.main["bigqueryconnection.googleapis.com"]
  id = "landing-optimizer-landing-page/bigqueryconnection.googleapis.com"
}

import {
  to = google_project_service.main["bigquerydatapolicy.googleapis.com"]
  id = "landing-optimizer-landing-page/bigquerydatapolicy.googleapis.com"
}

import {
  to = google_project_service.main["bigquerydatatransfer.googleapis.com"]
  id = "landing-optimizer-landing-page/bigquerydatatransfer.googleapis.com"
}

import {
  to = google_project_service.main["bigquerymigration.googleapis.com"]
  id = "landing-optimizer-landing-page/bigquerymigration.googleapis.com"
}

import {
  to = google_project_service.main["bigqueryreservation.googleapis.com"]
  id = "landing-optimizer-landing-page/bigqueryreservation.googleapis.com"
}

import {
  to = google_project_service.main["bigquerystorage.googleapis.com"]
  id = "landing-optimizer-landing-page/bigquerystorage.googleapis.com"
}

import {
  to = google_project_service.main["cloudapis.googleapis.com"]
  id = "landing-optimizer-landing-page/cloudapis.googleapis.com"
}

import {
  to = google_project_service.main["cloudbuild.googleapis.com"]
  id = "landing-optimizer-landing-page/cloudbuild.googleapis.com"
}

import {
  to = google_project_service.main["cloudresourcemanager.googleapis.com"]
  id = "landing-optimizer-landing-page/cloudresourcemanager.googleapis.com"
}

import {
  to = google_project_service.main["cloudtrace.googleapis.com"]
  id = "landing-optimizer-landing-page/cloudtrace.googleapis.com"
}

import {
  to = google_project_service.main["containerregistry.googleapis.com"]
  id = "landing-optimizer-landing-page/containerregistry.googleapis.com"
}

import {
  to = google_project_service.main["dataform.googleapis.com"]
  id = "landing-optimizer-landing-page/dataform.googleapis.com"
}

import {
  to = google_project_service.main["dataplex.googleapis.com"]
  id = "landing-optimizer-landing-page/dataplex.googleapis.com"
}

import {
  to = google_project_service.main["datastore.googleapis.com"]
  id = "landing-optimizer-landing-page/datastore.googleapis.com"
}

import {
  to = google_project_service.main["firebaserules.googleapis.com"]
  id = "landing-optimizer-landing-page/firebaserules.googleapis.com"
}

import {
  to = google_project_service.main["firestore.googleapis.com"]
  id = "landing-optimizer-landing-page/firestore.googleapis.com"
}

import {
  to = google_project_service.main["iam.googleapis.com"]
  id = "landing-optimizer-landing-page/iam.googleapis.com"
}

import {
  to = google_project_service.main["iamcredentials.googleapis.com"]
  id = "landing-optimizer-landing-page/iamcredentials.googleapis.com"
}

import {
  to = google_project_service.main["logging.googleapis.com"]
  id = "landing-optimizer-landing-page/logging.googleapis.com"
}

import {
  to = google_project_service.main["monitoring.googleapis.com"]
  id = "landing-optimizer-landing-page/monitoring.googleapis.com"
}

import {
  to = google_project_service.main["pubsub.googleapis.com"]
  id = "landing-optimizer-landing-page/pubsub.googleapis.com"
}

import {
  to = google_project_service.main["run.googleapis.com"]
  id = "landing-optimizer-landing-page/run.googleapis.com"
}

import {
  to = google_project_service.main["secretmanager.googleapis.com"]
  id = "landing-optimizer-landing-page/secretmanager.googleapis.com"
}

import {
  to = google_project_service.main["servicemanagement.googleapis.com"]
  id = "landing-optimizer-landing-page/servicemanagement.googleapis.com"
}

import {
  to = google_project_service.main["servicenetworking.googleapis.com"]
  id = "landing-optimizer-landing-page/servicenetworking.googleapis.com"
}

import {
  to = google_project_service.main["serviceusage.googleapis.com"]
  id = "landing-optimizer-landing-page/serviceusage.googleapis.com"
}

import {
  to = google_project_service.main["sql-component.googleapis.com"]
  id = "landing-optimizer-landing-page/sql-component.googleapis.com"
}

import {
  to = google_project_service.main["sqladmin.googleapis.com"]
  id = "landing-optimizer-landing-page/sqladmin.googleapis.com"
}

import {
  to = google_project_service.main["storage-api.googleapis.com"]
  id = "landing-optimizer-landing-page/storage-api.googleapis.com"
}

import {
  to = google_project_service.main["storage-component.googleapis.com"]
  id = "landing-optimizer-landing-page/storage-component.googleapis.com"
}

import {
  to = google_project_service.main["storage.googleapis.com"]
  id = "landing-optimizer-landing-page/storage.googleapis.com"
}

import {
  to = google_project_service.main["sts.googleapis.com"]
  id = "landing-optimizer-landing-page/sts.googleapis.com"
}

import {
  to = google_project_service.main["telemetry.googleapis.com"]
  id = "landing-optimizer-landing-page/telemetry.googleapis.com"
}

import {
  to = google_firestore_database.main
  id = "projects/landing-optimizer-landing-page/databases/(default)"
}

import {
  to = google_service_account.landing_page
  id = "projects/landing-optimizer-landing-page/serviceAccounts/landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
}

import {
  to       = google_cloud_run_v2_service.demo
  id       = "projects/landing-optimizer-demo/locations/southamerica-east1/services/landing-optimizer-demo"
  provider = google.demo
}

import {
  to       = google_artifact_registry_repository.demo
  id       = "projects/landing-optimizer-demo/locations/southamerica-east1/repositories/cloud-run-source-deploy"
  provider = google.demo
}

import {
  to       = google_cloudbuild_trigger.demo
  id       = "projects/landing-optimizer-demo/locations/global/triggers/9e89550d-65eb-4a58-8b9b-739a97f0bd4d"
  provider = google.demo
}

import {
  to       = google_project_service.demo["analyticshub.googleapis.com"]
  id       = "landing-optimizer-demo/analyticshub.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["apptopology.googleapis.com"]
  id       = "landing-optimizer-demo/apptopology.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["artifactregistry.googleapis.com"]
  id       = "landing-optimizer-demo/artifactregistry.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigquery.googleapis.com"]
  id       = "landing-optimizer-demo/bigquery.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigqueryconnection.googleapis.com"]
  id       = "landing-optimizer-demo/bigqueryconnection.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigquerydatapolicy.googleapis.com"]
  id       = "landing-optimizer-demo/bigquerydatapolicy.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigquerydatatransfer.googleapis.com"]
  id       = "landing-optimizer-demo/bigquerydatatransfer.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigquerymigration.googleapis.com"]
  id       = "landing-optimizer-demo/bigquerymigration.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigqueryreservation.googleapis.com"]
  id       = "landing-optimizer-demo/bigqueryreservation.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["bigquerystorage.googleapis.com"]
  id       = "landing-optimizer-demo/bigquerystorage.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["cloudapis.googleapis.com"]
  id       = "landing-optimizer-demo/cloudapis.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["cloudbuild.googleapis.com"]
  id       = "landing-optimizer-demo/cloudbuild.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["cloudtrace.googleapis.com"]
  id       = "landing-optimizer-demo/cloudtrace.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["containeranalysis.googleapis.com"]
  id       = "landing-optimizer-demo/containeranalysis.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["containerregistry.googleapis.com"]
  id       = "landing-optimizer-demo/containerregistry.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["dataform.googleapis.com"]
  id       = "landing-optimizer-demo/dataform.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["dataplex.googleapis.com"]
  id       = "landing-optimizer-demo/dataplex.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["datastore.googleapis.com"]
  id       = "landing-optimizer-demo/datastore.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["iam.googleapis.com"]
  id       = "landing-optimizer-demo/iam.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["iamcredentials.googleapis.com"]
  id       = "landing-optimizer-demo/iamcredentials.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["logging.googleapis.com"]
  id       = "landing-optimizer-demo/logging.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["monitoring.googleapis.com"]
  id       = "landing-optimizer-demo/monitoring.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["pubsub.googleapis.com"]
  id       = "landing-optimizer-demo/pubsub.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["run.googleapis.com"]
  id       = "landing-optimizer-demo/run.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["servicemanagement.googleapis.com"]
  id       = "landing-optimizer-demo/servicemanagement.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["serviceusage.googleapis.com"]
  id       = "landing-optimizer-demo/serviceusage.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["sql-component.googleapis.com"]
  id       = "landing-optimizer-demo/sql-component.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["storage-api.googleapis.com"]
  id       = "landing-optimizer-demo/storage-api.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["storage-component.googleapis.com"]
  id       = "landing-optimizer-demo/storage-component.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["storage.googleapis.com"]
  id       = "landing-optimizer-demo/storage.googleapis.com"
  provider = google.demo
}

import {
  to       = google_project_service.demo["telemetry.googleapis.com"]
  id       = "landing-optimizer-demo/telemetry.googleapis.com"
  provider = google.demo
}

import {
  to = google_project_iam_member.main["roles/artifactregistry.serviceAgent/serviceAccount:service-505424813528@gcp-sa-artifactregistry.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/artifactregistry.serviceAgent serviceAccount:service-505424813528@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/artifactregistry.writer/serviceAccount:505424813528-compute@developer.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/artifactregistry.writer serviceAccount:505424813528-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/cloudbuild.builds.builder/serviceAccount:505424813528@cloudbuild.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/cloudbuild.builds.builder serviceAccount:505424813528@cloudbuild.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/cloudbuild.builds.builder/serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/cloudbuild.builds.builder serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/cloudbuild.serviceAgent/serviceAccount:service-505424813528@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/cloudbuild.serviceAgent serviceAccount:service-505424813528@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/cloudsql.instanceUser/user:rodrigovanzelotti@gmail.com"]
  id = "landing-optimizer-landing-page roles/cloudsql.instanceUser user:rodrigovanzelotti@gmail.com"
}

import {
  to = google_project_iam_member.main["roles/cloudsql.studioUser/user:rodrigovanzelotti@gmail.com"]
  id = "landing-optimizer-landing-page roles/cloudsql.studioUser user:rodrigovanzelotti@gmail.com"
}

import {
  to = google_project_iam_member.main["roles/containerregistry.ServiceAgent/serviceAccount:service-505424813528@containerregistry.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/containerregistry.ServiceAgent serviceAccount:service-505424813528@containerregistry.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/datastore.user/serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/datastore.user serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/editor/serviceAccount:505424813528-compute@developer.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/editor serviceAccount:505424813528-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/firebaserules.system/serviceAccount:service-505424813528@firebase-rules.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/firebaserules.system serviceAccount:service-505424813528@firebase-rules.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/firestore.serviceAgent/serviceAccount:service-505424813528@gcp-sa-firestore.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/firestore.serviceAgent serviceAccount:service-505424813528@gcp-sa-firestore.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/iam.serviceAccountUser/serviceAccount:505424813528-compute@developer.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/iam.serviceAccountUser serviceAccount:505424813528-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/logging.logWriter/serviceAccount:505424813528-compute@developer.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/logging.logWriter serviceAccount:505424813528-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/owner/user:rodrigovanzelotti@gmail.com"]
  id = "landing-optimizer-landing-page roles/owner user:rodrigovanzelotti@gmail.com"
}

import {
  to = google_project_iam_member.main["roles/pubsub.serviceAgent/serviceAccount:service-505424813528@gcp-sa-pubsub.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/pubsub.serviceAgent serviceAccount:service-505424813528@gcp-sa-pubsub.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/run.admin/serviceAccount:505424813528-compute@developer.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/run.admin serviceAccount:505424813528-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/run.admin/serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/run.admin serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.main["roles/run.serviceAgent/serviceAccount:service-505424813528@serverless-robot-prod.iam.gserviceaccount.com"]
  id = "landing-optimizer-landing-page roles/run.serviceAgent serviceAccount:service-505424813528@serverless-robot-prod.iam.gserviceaccount.com"
}

import {
  to       = google_project_iam_member.demo["roles/artifactregistry.serviceAgent/serviceAccount:service-943261198056@gcp-sa-artifactregistry.iam.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/artifactregistry.serviceAgent serviceAccount:service-943261198056@gcp-sa-artifactregistry.iam.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/artifactregistry.writer/serviceAccount:943261198056-compute@developer.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/artifactregistry.writer serviceAccount:943261198056-compute@developer.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/cloudbuild.builds.builder/serviceAccount:943261198056@cloudbuild.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/cloudbuild.builds.builder serviceAccount:943261198056@cloudbuild.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/cloudbuild.serviceAgent/serviceAccount:service-943261198056@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/cloudbuild.serviceAgent serviceAccount:service-943261198056@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/containeranalysis.ServiceAgent/serviceAccount:service-943261198056@container-analysis.iam.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/containeranalysis.ServiceAgent serviceAccount:service-943261198056@container-analysis.iam.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/containerregistry.ServiceAgent/serviceAccount:service-943261198056@containerregistry.iam.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/containerregistry.ServiceAgent serviceAccount:service-943261198056@containerregistry.iam.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/editor/serviceAccount:943261198056-compute@developer.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/editor serviceAccount:943261198056-compute@developer.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/iam.serviceAccountUser/serviceAccount:943261198056-compute@developer.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/iam.serviceAccountUser serviceAccount:943261198056-compute@developer.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/logging.logWriter/serviceAccount:943261198056-compute@developer.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/logging.logWriter serviceAccount:943261198056-compute@developer.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/owner/user:rodrigovanzelotti@gmail.com"]
  id       = "landing-optimizer-demo roles/owner user:rodrigovanzelotti@gmail.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/pubsub.serviceAgent/serviceAccount:service-943261198056@gcp-sa-pubsub.iam.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/pubsub.serviceAgent serviceAccount:service-943261198056@gcp-sa-pubsub.iam.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/run.admin/serviceAccount:943261198056-compute@developer.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/run.admin serviceAccount:943261198056-compute@developer.gserviceaccount.com"
  provider = google.demo
}

import {
  to       = google_project_iam_member.demo["roles/run.serviceAgent/serviceAccount:service-943261198056@serverless-robot-prod.iam.gserviceaccount.com"]
  id       = "landing-optimizer-demo roles/run.serviceAgent serviceAccount:service-943261198056@serverless-robot-prod.iam.gserviceaccount.com"
  provider = google.demo
}

import {
  to = google_firebaserules_ruleset.firestore
  id = "projects/landing-optimizer-landing-page/rulesets/1643490c-cc5d-41ee-beab-24b09c6266ec"
}

import {
  to = google_firebaserules_release.firestore
  id = "projects/landing-optimizer-landing-page/releases/cloud.firestore"
}
