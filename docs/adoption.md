# Adopt existing resources

Fundocentenario staging was imported on 2026-11-09 and has a clean live plan. Its 11 existing resources are recorded under `gs://fundocentenario-website-stg-tfstate/fundocentenario/stage/default.tfstate`. The isolated workspace at `.local/adoption/fundocentenario-stage` has the same Terraform stack and manifests, with only its staging manifest enabled. The repository manifests remain disabled because the source repository still owns releases and the central Hosting engine must preserve its rewrites, headers, and revision pinning before handover. See [the verified inventory](inventory.md) for exact scope and remaining work.

To recheck the imported staging state from a normal PowerShell terminal without creating a service account key, supply a short-lived token only in the process environment:

```powershell
$env:GOOGLE_OAUTH_ACCESS_TOKEN = (gcloud.cmd auth print-access-token --account=rodrigo.vanzelotti@fundocentenario.com.br)
$env:TF_VAR_solution = 'fundocentenario'
$env:TF_VAR_environment = 'stage'
terraform -chdir=.local/adoption/fundocentenario-stage/terraform/stack plan -detailed-exitcode
```

Exit code 0 means a clean plan. Tokens expire; obtain a fresh one before later operations. Do not persist the token in backend arguments, plans, or configuration files. Bootstrap state is remote at `bootstrap/fundocentenario/stage/default.tfstate` in the same bucket, and its isolated configuration is at `.local/bootstrap/fundocentenario-stage`. Only its bucket resource has been applied. A full bootstrap plan will still propose CI identities, federation, IAM, and API management; review those before applying them. Do not discard the isolated workspaces before their configuration and state locations are backed up.

For subsequent environments, complete inventory first. Do not infer a Hosting site ID, service name, runtime identity, image digest, or region from the project name. No repository environment currently authorizes an automatic apply because every environment is disabled.

1. Inventory existing APIs, resource names, regions, identities, networking, secret identifiers, and release references. Preserve existing domains and external integrations. Identify any infrastructure not supported by this stack, such as databases, Cloud Run VPC configuration, multiple containers, probes, custom traffic splits, or Hosting rewrites. Extend support before importing a resource that depends on those settings; the minimal module otherwise applies its simpler configuration.
2. Back up the existing deployment configuration and determine whether another Terraform state already owns these resources. Move ownership deliberately; never let two states manage one resource. Source repository deployment workflows must stop independently deploying a service before this repository becomes its owner.
3. Bootstrap using an administrator identity, inspect the plan, and apply the necessary foundational resources. Bootstrap is per solution/environment, with separate local directories and eventual remote states. Import existing foundation resources instead of attempting to recreate them.
4. Populate the solution and environment YAML with verified values and set `enabled: true` locally. Validate with `--deployable`. Do not merge enabled manifests until imports and GitHub approval controls are ready.
5. Initialize the stack's exact bucket/prefix and import existing resources. Reconcile the plan to preserve existing behavior. A first adoption plan must have no unexpected creation, replacement, deletion, IAM changes, or configuration changes. Never use `ignore_changes` to hide an unexplained difference.
6. Configure GitHub and run the first reviewed staging deployment. Use a harmless application-supported environment variable change; verify application behavior and a subsequent clean Terraform plan. Only then adopt production through its required approval gate.

Bootstrap example, from the repository root in PowerShell:

```powershell
$bootstrapDirectory = '.local/bootstrap/fundocentenario-stage'
New-Item -ItemType Directory -Force -Path $bootstrapDirectory
Copy-Item terraform/bootstrap/*.tf -Destination $bootstrapDirectory
Copy-Item terraform/bootstrap/bootstrap.example.tfvars "$bootstrapDirectory/terraform.tfvars"
# Edit terraform.tfvars: actual project, dedicated bucket, solution, environment,
# and existing runtime_service_accounts. Use the correct account's ADC credentials.
gcloud.cmd auth application-default login
terraform "-chdir=$bootstrapDirectory" init
terraform "-chdir=$bootstrapDirectory" plan -out=bootstrap.tfplan
terraform "-chdir=$bootstrapDirectory" apply bootstrap.tfplan
```

The bucket must be dedicated to this solution/environment because apply has object administration on that bucket. Its name must be globally unique. Bootstrap does not create GCP projects or link billing. It enables supported service APIs, creates CI identities and WIF, and grants project-level resource administration roles required by the modules. The apply identity has Secret Manager administration privileges; this can include access to secret values. Keep it limited to its environment project. The plan identity receives metadata/read roles and cannot read Secret Manager versions or write Terraform state.

Use bootstrap outputs for GitHub variables. Existing runtime service accounts must appear in `runtime_service_accounts` so apply can deploy services as those identities. Grant application-specific runtime roles separately; this stack never grants broad project permissions to an application. Firebase must already be enabled on a project before managing Hosting sites; merely enabling its APIs does not add a Firebase project.

After the bucket exists, migrate bootstrap state into it. In the isolated bootstrap directory, add a `backend.tf` containing:

```hcl
terraform {
  backend "gcs" {}
}
```

Then run:

```powershell
terraform "-chdir=$bootstrapDirectory" init -migrate-state `
  -backend-config="bucket=ACTUAL_STATE_BUCKET" `
  -backend-config="prefix=bootstrap/fundocentenario/stage"
```

Keep the isolated bootstrap files and variables securely backed up; do not commit local state. Subsequent bootstrap changes must use the same directory and remote backend. Copy updated bootstrap source into that directory deliberately and review its plan. Bootstrap is an administrative operation outside automatic app deployments.

Configure `solutions/fundocentenario/environments/stage.yaml` with the same state bucket. From a shell with ADC credentials and cloud access:

```powershell
$env:TF_VAR_solution = 'fundocentenario'
$env:TF_VAR_environment = 'stage'
python scripts/validate.py --solution fundocentenario --environment stage --deployable
terraform -chdir=terraform/stack init -reconfigure `
  -backend-config="bucket=ACTUAL_STATE_BUCKET" `
  -backend-config="prefix=fundocentenario/stage"
```

Terraform backend configuration is supplied at init, not read dynamically from YAML. Always reinitialize when selecting another environment; do not use Terraform workspaces here. Never use a bucket/prefix from a different environment. CI computes the same pair from validated manifests.

Use addresses matching the actual component keys. Illustrative imports (skip resources that do not exist or are not declared):

```powershell
terraform -chdir=terraform/stack import 'module.cloud_run["api"].google_cloud_run_v2_service.this' 'projects/PROJECT/locations/REGION/services/SERVICE'
terraform -chdir=terraform/stack import 'module.hosting["frontend"].google_firebase_hosting_site.this' 'projects/PROJECT/sites/SITE'
terraform -chdir=terraform/stack import 'module.secrets.google_secret_manager_secret.this["database-url"]' 'projects/PROJECT/secrets/database-url'
terraform -chdir=terraform/stack import 'module.artifacts["apps"].google_artifact_registry_repository.this' 'projects/PROJECT/locations/REGION/repositories/apps'
terraform -chdir=terraform/stack plan -out=adoption.tfplan
terraform -chdir=terraform/stack show -json adoption.tfplan | python scripts/check_plan.py
```

If existing IAM members will be owned by this stack, import those as well using the provider's documented IAM member import IDs. Importing a Cloud Run service does not import its public invocation or secret-access bindings. The service module defaults to 100% latest traffic; explicit `traffic` entries preserve other routing. Staging's snapshot preserves its existing revision and candidate tag. Terraform waits for service readiness, but application correctness still requires the application's smoke checks.

For each enabled pair, create two GitHub Environments:

| Environment name | `GCP_SERVICE_ACCOUNT` value | Protection |
| --- | --- | --- |
| `fundocentenario-stage-plan` | Bootstrap plan account | Trusted PRs only |
| `fundocentenario-stage` | Bootstrap apply account | Deployment branch restricted to `main` |
| `fundocentenario-prod-plan` | Production plan account | Trusted PRs only |
| `fundocentenario-prod` | Production apply account | Required reviewers; deployment branch `main` |

Each also needs an environment variable `GCP_WORKLOAD_IDENTITY_PROVIDER` from its bootstrap output. Repeat the names for Landing Optimizer once its actual environment layout is verified. Plan and apply identities must never be swapped. The workflow queries GitHub's environment API and fails before cloud authentication if production reviewer protection cannot be confirmed. If your GitHub plan does not support required reviewers for this repository's visibility, leave production disabled until an equivalent enforceable control is implemented.

Set branch protection on `main` to require the validation and plan checks and reviewed pull requests. Use CODEOWNERS or repository rules to restrict changes to workflows, bootstrap, and environment manifests. The current workspace has no authenticated GitHub management tool, so these settings are not configured by this implementation.

Public source repositories need no extra checkout credential. Private cross-repository Hosting content needs a fine-grained, read-only `SOURCE_READ_TOKEN` for the relevant repositories (prefer short-lived GitHub App tokens in an established source-release pipeline). This is a GitHub source-read credential, never a GCP service account key. Do not commit it. Source builds should publish tested static assets to an immutable Git commit; both stage and prod then reference that same commit.

Keep the remaining environments disabled until each passes the same adoption procedure. Landing Optimizer currently has no confirmed independent stage project; do not reuse its existing project for both stage and prod.
