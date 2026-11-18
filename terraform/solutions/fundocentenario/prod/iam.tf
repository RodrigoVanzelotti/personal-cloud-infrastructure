locals {
  project_iam = {
    "roles/artifactregistry.serviceAgent/serviceAccount:service-358530732475@gcp-sa-artifactregistry.iam.gserviceaccount.com" : {
      "role" : "roles/artifactregistry.serviceAgent",
      "member" : "serviceAccount:service-358530732475@gcp-sa-artifactregistry.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/cloudscheduler.serviceAgent/serviceAccount:service-358530732475@gcp-sa-cloudscheduler.iam.gserviceaccount.com" : {
      "role" : "roles/cloudscheduler.serviceAgent",
      "member" : "serviceAccount:service-358530732475@gcp-sa-cloudscheduler.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/containerregistry.ServiceAgent/serviceAccount:service-358530732475@containerregistry.iam.gserviceaccount.com" : {
      "role" : "roles/containerregistry.ServiceAgent",
      "member" : "serviceAccount:service-358530732475@containerregistry.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/datastore.user/serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com" : {
      "role" : "roles/datastore.user",
      "member" : "serviceAccount:fundo-runtime@fundocentenario-website-prd.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/firebase.managementServiceAgent/serviceAccount:service-358530732475@gcp-sa-firebase.iam.gserviceaccount.com" : {
      "role" : "roles/firebase.managementServiceAgent",
      "member" : "serviceAccount:service-358530732475@gcp-sa-firebase.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/firebase.sdkAdminServiceAgent/serviceAccount:firebase-adminsdk-fbsvc@fundocentenario-website-prd.iam.gserviceaccount.com" : {
      "role" : "roles/firebase.sdkAdminServiceAgent",
      "member" : "serviceAccount:firebase-adminsdk-fbsvc@fundocentenario-website-prd.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/firebasehosting.admin/serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com" : {
      "role" : "roles/firebasehosting.admin",
      "member" : "serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/firebaserules.system/serviceAccount:service-358530732475@firebase-rules.iam.gserviceaccount.com" : {
      "role" : "roles/firebaserules.system",
      "member" : "serviceAccount:service-358530732475@firebase-rules.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/firestore.serviceAgent/serviceAccount:service-358530732475@gcp-sa-firestore.iam.gserviceaccount.com" : {
      "role" : "roles/firestore.serviceAgent",
      "member" : "serviceAccount:service-358530732475@gcp-sa-firestore.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/iam.serviceAccountTokenCreator/serviceAccount:firebase-adminsdk-fbsvc@fundocentenario-website-prd.iam.gserviceaccount.com" : {
      "role" : "roles/iam.serviceAccountTokenCreator",
      "member" : "serviceAccount:firebase-adminsdk-fbsvc@fundocentenario-website-prd.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/owner/user:rodrigo.vanzelotti@fundocentenario.com.br" : {
      "role" : "roles/owner",
      "member" : "user:rodrigo.vanzelotti@fundocentenario.com.br",
      "condition" : null
    },
    "roles/pubsub.serviceAgent/serviceAccount:service-358530732475@gcp-sa-pubsub.iam.gserviceaccount.com" : {
      "role" : "roles/pubsub.serviceAgent",
      "member" : "serviceAccount:service-358530732475@gcp-sa-pubsub.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/run.serviceAgent/serviceAccount:service-358530732475@serverless-robot-prod.iam.gserviceaccount.com" : {
      "role" : "roles/run.serviceAgent",
      "member" : "serviceAccount:service-358530732475@serverless-robot-prod.iam.gserviceaccount.com",
      "condition" : null
    },
    "roles/serviceusage.serviceUsageConsumer/serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com" : {
      "role" : "roles/serviceusage.serviceUsageConsumer",
      "member" : "serviceAccount:fundo-deploy@fundocentenario-website-prd.iam.gserviceaccount.com",
      "condition" : null
    }
  }
}
resource "google_project_iam_member" "existing" {
  project  = "fundocentenario-website-prd"
  for_each = local.project_iam
  role     = each.value.role
  member   = each.value.member
  dynamic "condition" {
    for_each = each.value.condition == null ? [] : [each.value.condition]
    content {
      title       = condition.value.title
      expression  = condition.value.expression
      description = try(condition.value.description, null)
    }
  }
  lifecycle { prevent_destroy = true }
}
import {
  for_each = local.project_iam
  to       = google_project_iam_member.existing[each.key]
  id       = "fundocentenario-website-prd ${each.value.role} ${each.value.member}${each.value.condition == null ? "" : " ${each.value.condition.title}"}"
}
