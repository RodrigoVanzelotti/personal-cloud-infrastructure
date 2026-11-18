locals {
  directory   = "${path.module}/../../solutions/${var.solution}"
  solution    = yamldecode(file("${local.directory}/solution.yaml"))
  environment = yamldecode(file("${local.directory}/environments/${var.environment}.yaml"))
  run = {
    for name, component in local.solution.components : name => local.environment.deployments[name]
    if component.type == "cloud_run_service"
  }
  hosting = {
    for name, component in local.solution.components : name => local.environment.deployments[name]
    if component.type == "firebase_hosting"
  }
  secret_access = {
    for binding in flatten([
      for deployment in local.run : [
        for reference in try(deployment.secret_env, {}) : {
          account = deployment.service_account
          secret  = reference.secret
        }
      ]
    ]) : "${binding.account}/${binding.secret}" => binding...
  }
}

resource "terraform_data" "manifest" {
  lifecycle {
    precondition {
      condition     = (local.environment.enabled || var.adoption_mode) && local.environment.gcp.project_id != null && local.environment.state_bucket != null
      error_message = "Complete inventory and validation before enabling this environment."
    }
    precondition {
      condition     = local.solution.name == var.solution && local.environment.environment == var.environment
      error_message = "Manifest names must match the selected stack."
    }
  }
}

module "secrets" {
  source     = "../modules/secret-manager"
  project_id = local.environment.gcp.project_id
  secrets    = toset(local.solution.secrets)
  depends_on = [terraform_data.manifest]
}

module "cloud_run" {
  source     = "../modules/cloud-run-service"
  for_each   = local.run
  project_id = local.environment.gcp.project_id
  region     = local.environment.gcp.region
  deployment = each.value
  depends_on = [module.secrets, google_secret_manager_secret_iam_member.access]
}

resource "google_secret_manager_secret_iam_member" "access" {
  for_each   = local.secret_access
  project    = local.environment.gcp.project_id
  secret_id  = each.value[0].secret
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${each.value[0].account}"
  depends_on = [module.secrets]
}

module "hosting" {
  source     = "../modules/firebase-hosting"
  for_each   = local.hosting
  project_id = local.environment.gcp.project_id
  site_id    = each.value.site_id
  depends_on = [terraform_data.manifest]
}

module "artifacts" {
  source        = "../modules/artifact-registry"
  for_each      = toset(try(local.environment.artifact_registry, []))
  project_id    = local.environment.gcp.project_id
  region        = local.environment.gcp.region
  repository_id = each.value
  depends_on    = [terraform_data.manifest]
}

output "cloud_run_urls" {
  value = { for name, service in module.cloud_run : name => service.uri }
}
