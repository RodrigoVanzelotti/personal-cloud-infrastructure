resource "google_project_iam_member" "main" {
  project = "landing-optimizer-landing-page"
  for_each = {
    "roles/artifactregistry.serviceAgent/serviceAccount:service-505424813528@gcp-sa-artifactregistry.iam.gserviceaccount.com" : {
      "role" : "roles/artifactregistry.serviceAgent",
      "member" : "serviceAccount:service-505424813528@gcp-sa-artifactregistry.iam.gserviceaccount.com"
    },
    "roles/artifactregistry.writer/serviceAccount:505424813528-compute@developer.gserviceaccount.com" : {
      "role" : "roles/artifactregistry.writer",
      "member" : "serviceAccount:505424813528-compute@developer.gserviceaccount.com"
    },
    "roles/cloudbuild.builds.builder/serviceAccount:505424813528@cloudbuild.gserviceaccount.com" : {
      "role" : "roles/cloudbuild.builds.builder",
      "member" : "serviceAccount:505424813528@cloudbuild.gserviceaccount.com"
    },
    "roles/cloudbuild.builds.builder/serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com" : {
      "role" : "roles/cloudbuild.builds.builder",
      "member" : "serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
    },
    "roles/cloudbuild.serviceAgent/serviceAccount:service-505424813528@gcp-sa-cloudbuild.iam.gserviceaccount.com" : {
      "role" : "roles/cloudbuild.serviceAgent",
      "member" : "serviceAccount:service-505424813528@gcp-sa-cloudbuild.iam.gserviceaccount.com"
    },
    "roles/cloudsql.instanceUser/user:rodrigovanzelotti@gmail.com" : {
      "role" : "roles/cloudsql.instanceUser",
      "member" : "user:rodrigovanzelotti@gmail.com"
    },
    "roles/cloudsql.studioUser/user:rodrigovanzelotti@gmail.com" : {
      "role" : "roles/cloudsql.studioUser",
      "member" : "user:rodrigovanzelotti@gmail.com"
    },
    "roles/containerregistry.ServiceAgent/serviceAccount:service-505424813528@containerregistry.iam.gserviceaccount.com" : {
      "role" : "roles/containerregistry.ServiceAgent",
      "member" : "serviceAccount:service-505424813528@containerregistry.iam.gserviceaccount.com"
    },
    "roles/datastore.user/serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com" : {
      "role" : "roles/datastore.user",
      "member" : "serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
    },
    "roles/editor/serviceAccount:505424813528-compute@developer.gserviceaccount.com" : {
      "role" : "roles/editor",
      "member" : "serviceAccount:505424813528-compute@developer.gserviceaccount.com"
    },
    "roles/firebaserules.system/serviceAccount:service-505424813528@firebase-rules.iam.gserviceaccount.com" : {
      "role" : "roles/firebaserules.system",
      "member" : "serviceAccount:service-505424813528@firebase-rules.iam.gserviceaccount.com"
    },
    "roles/firestore.serviceAgent/serviceAccount:service-505424813528@gcp-sa-firestore.iam.gserviceaccount.com" : {
      "role" : "roles/firestore.serviceAgent",
      "member" : "serviceAccount:service-505424813528@gcp-sa-firestore.iam.gserviceaccount.com"
    },
    "roles/iam.serviceAccountUser/serviceAccount:505424813528-compute@developer.gserviceaccount.com" : {
      "role" : "roles/iam.serviceAccountUser",
      "member" : "serviceAccount:505424813528-compute@developer.gserviceaccount.com"
    },
    "roles/logging.logWriter/serviceAccount:505424813528-compute@developer.gserviceaccount.com" : {
      "role" : "roles/logging.logWriter",
      "member" : "serviceAccount:505424813528-compute@developer.gserviceaccount.com"
    },
    "roles/owner/user:rodrigovanzelotti@gmail.com" : {
      "role" : "roles/owner",
      "member" : "user:rodrigovanzelotti@gmail.com"
    },
    "roles/pubsub.serviceAgent/serviceAccount:service-505424813528@gcp-sa-pubsub.iam.gserviceaccount.com" : {
      "role" : "roles/pubsub.serviceAgent",
      "member" : "serviceAccount:service-505424813528@gcp-sa-pubsub.iam.gserviceaccount.com"
    },
    "roles/run.admin/serviceAccount:505424813528-compute@developer.gserviceaccount.com" : {
      "role" : "roles/run.admin",
      "member" : "serviceAccount:505424813528-compute@developer.gserviceaccount.com"
    },
    "roles/run.admin/serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com" : {
      "role" : "roles/run.admin",
      "member" : "serviceAccount:landing-page@landing-optimizer-landing-page.iam.gserviceaccount.com"
    },
    "roles/run.serviceAgent/serviceAccount:service-505424813528@serverless-robot-prod.iam.gserviceaccount.com" : {
      "role" : "roles/run.serviceAgent",
      "member" : "serviceAccount:service-505424813528@serverless-robot-prod.iam.gserviceaccount.com"
    }
  }
  role   = each.value.role
  member = each.value.member
  lifecycle { prevent_destroy = true }
}

resource "google_project_iam_member" "demo" {
  provider = google.demo
  project  = "landing-optimizer-demo"
  for_each = {
    "roles/artifactregistry.serviceAgent/serviceAccount:service-943261198056@gcp-sa-artifactregistry.iam.gserviceaccount.com" : {
      "role" : "roles/artifactregistry.serviceAgent",
      "member" : "serviceAccount:service-943261198056@gcp-sa-artifactregistry.iam.gserviceaccount.com"
    },
    "roles/artifactregistry.writer/serviceAccount:943261198056-compute@developer.gserviceaccount.com" : {
      "role" : "roles/artifactregistry.writer",
      "member" : "serviceAccount:943261198056-compute@developer.gserviceaccount.com"
    },
    "roles/cloudbuild.builds.builder/serviceAccount:943261198056@cloudbuild.gserviceaccount.com" : {
      "role" : "roles/cloudbuild.builds.builder",
      "member" : "serviceAccount:943261198056@cloudbuild.gserviceaccount.com"
    },
    "roles/cloudbuild.serviceAgent/serviceAccount:service-943261198056@gcp-sa-cloudbuild.iam.gserviceaccount.com" : {
      "role" : "roles/cloudbuild.serviceAgent",
      "member" : "serviceAccount:service-943261198056@gcp-sa-cloudbuild.iam.gserviceaccount.com"
    },
    "roles/containeranalysis.ServiceAgent/serviceAccount:service-943261198056@container-analysis.iam.gserviceaccount.com" : {
      "role" : "roles/containeranalysis.ServiceAgent",
      "member" : "serviceAccount:service-943261198056@container-analysis.iam.gserviceaccount.com"
    },
    "roles/containerregistry.ServiceAgent/serviceAccount:service-943261198056@containerregistry.iam.gserviceaccount.com" : {
      "role" : "roles/containerregistry.ServiceAgent",
      "member" : "serviceAccount:service-943261198056@containerregistry.iam.gserviceaccount.com"
    },
    "roles/editor/serviceAccount:943261198056-compute@developer.gserviceaccount.com" : {
      "role" : "roles/editor",
      "member" : "serviceAccount:943261198056-compute@developer.gserviceaccount.com"
    },
    "roles/iam.serviceAccountUser/serviceAccount:943261198056-compute@developer.gserviceaccount.com" : {
      "role" : "roles/iam.serviceAccountUser",
      "member" : "serviceAccount:943261198056-compute@developer.gserviceaccount.com"
    },
    "roles/logging.logWriter/serviceAccount:943261198056-compute@developer.gserviceaccount.com" : {
      "role" : "roles/logging.logWriter",
      "member" : "serviceAccount:943261198056-compute@developer.gserviceaccount.com"
    },
    "roles/owner/user:rodrigovanzelotti@gmail.com" : {
      "role" : "roles/owner",
      "member" : "user:rodrigovanzelotti@gmail.com"
    },
    "roles/pubsub.serviceAgent/serviceAccount:service-943261198056@gcp-sa-pubsub.iam.gserviceaccount.com" : {
      "role" : "roles/pubsub.serviceAgent",
      "member" : "serviceAccount:service-943261198056@gcp-sa-pubsub.iam.gserviceaccount.com"
    },
    "roles/run.admin/serviceAccount:943261198056-compute@developer.gserviceaccount.com" : {
      "role" : "roles/run.admin",
      "member" : "serviceAccount:943261198056-compute@developer.gserviceaccount.com"
    },
    "roles/run.serviceAgent/serviceAccount:service-943261198056@serverless-robot-prod.iam.gserviceaccount.com" : {
      "role" : "roles/run.serviceAgent",
      "member" : "serviceAccount:service-943261198056@serverless-robot-prod.iam.gserviceaccount.com"
    }
  }
  role   = each.value.role
  member = each.value.member
  lifecycle { prevent_destroy = true }
}

