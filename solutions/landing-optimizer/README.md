# Landing Optimizer Cloud

This directory is the complete Cloud infrastructure and release source for Landing
Optimizer. It uses native Terraform. There is no second YAML deployment model and
no disabled production registration. Current deployments are production only;
a separate staging project/stack has not been provisioned.

The five-service pipeline and its Cloud permission changes are prepared locally.
Publication is currently prohibited by the latest user instructions. Existing
marketing/demo Cloud Build triggers remain active until the replacement is
published and verified; do not apply their disabling plan prematurely.

## Components and ownership

| Component | Application repository | Terraform configuration | Project |
| --- | --- | --- | --- |
| API and SDK assets | `landing-optimizer-api`, `landing-optimizer-snippet` | `terraform/v1/main.tf` | `landing-optimizer-landing-page` |
| AI | `landing-optimizer-ai` | `terraform/v1/ai.tf` | `landing-optimizer-landing-page` |
| Dashboard | `landing-optimizer-dashboard` | `terraform/v1/dashboard.tf` | `landing-optimizer-landing-page` |
| Marketing website | `landing-optimizer-landing-page` | `terraform/project/resources.tf`, service `main` | `landing-optimizer-landing-page` |
| Demo | `landing-optimizer-demo` | `terraform/project/resources.tf`, service `demo` | `landing-optimizer-demo` |
| PostgreSQL and migration job | API | `terraform/v1/main.tf` | `landing-optimizer-landing-page` |
| Firestore/rules, buckets, enabled APIs and remaining IAM | Central infrastructure | `terraform/project/` | Both projects |
| GitHub federation and release permissions | Central infrastructure | Both stacks' `cicd.tf` | Both projects |

The SDK is included in API images; it does not have a separate Cloud Run service.
Actual CPU, memory, scaling, runtime environment, probes and service identities are
in the Terraform files above. Only this repository deploys Cloud infrastructure.

## Secrets

All five containers are declared in `terraform/v1/main.tf` through the shared
Secret Manager module. Secret payloads are never stored in this repository, tfvars,
container builds or Terraform state. Existing service references pin version `1`.

| Secret | Consumer |
| --- | --- |
| `lo-v1-database-url` | API and migration job |
| `lo-v1-jwt-secret` | API authentication |
| `lo-v1-config-key` | API configuration/signing-key encryption |
| `lo-v1-ai-token` | API and AI internal requests |
| `lo-v1-operator-password` | Authorized operator/onboarding scripts; not injected into runtime services |

The dashboard runtime has no Secret Manager access. Container/access IAM and
runtime version references are Terraform-managed. Administrator bootstrap/rotation
writes payloads through the central procedure; changing a version also requires
updating the corresponding Terraform reference. Never run bootstrap for a release.

## Releases

Every service repository's `CI` workflow calls the central reusable workflow
`.github/workflows/deploy-landing-optimizer.yml@main`. GitHub authentication uses
Workload Identity Federation restricted to the five source repository IDs, `main`,
and `push`/`workflow_dispatch`. No service-account JSON key is required.
API/AI/dashboard keep their existing deployer. Marketing/demo use a separate
`landing-optimizer-sites` identity with service-scoped deploy permissions, source
image repositories, runtime act-as and scoped state/lock writes. It receives no
direct administration grants for API/AI/dashboard services, SQL instances or project
IAM. Existing serving runtime identities are preserved by this handover.

The central script builds/tests the source, pushes an immutable digest, obtains
the existing shared GCS deployment lock, reloads the current images from the owning
remote state, and updates only the selected service. API releases run the migration
job successfully before updating the API. Plans reject replacements, deletions,
IAM changes and changes to other services during an application release. Health
checks follow each deployment. There is no automatic database rollback.

The handover configuration retains marketing/demo legacy Cloud Build triggers with
`disabled = true` and removes their Cloud Run deploy step. Apply that configuration
only after the replacement is published and validated. It has not been applied yet.

The two backends are unchanged:

| Stack | Bucket | Prefix |
| --- | --- | --- |
| `terraform/v1` | `landing-optimizer-v1-tfstate-505424813528` | `landing-optimizer/v1` |
| `terraform/project` | `landing-optimizer-v1-tfstate-505424813528` | `landing-optimizer/project` |

For reviewed administrator infrastructure changes, first refresh the local image
inputs from state; an old checked-in snapshot must never roll back a live release:

```powershell
python solutions/landing-optimizer/terraform/v1/ci_release.py --snapshot v1
python solutions/landing-optimizer/terraform/v1/ci_release.py --snapshot project
terraform -chdir=solutions/landing-optimizer/terraform/v1 plan -out=change.tfplan
terraform -chdir=solutions/landing-optimizer/terraform/project plan -out=change.tfplan
```

Review the complete plan before applying its saved file. Coordinate administrator
changes with application deployments and re-plan if remote state changes. Both
roots preserve their existing resource addresses. Never import one resource into
both states. Release identities do not administer databases or project IAM;
foundation changes require the authorized administrator.

## Relationship with landing-optimizer-infra

`landing-optimizer-infra` retains local Docker development, documentation and
historical examples. Its Python release commands delegate here; its old GCP
Terraform root is blocked. It is not a Cloud deployment owner. Application source
repositories and this central repository are sufficient for the release pipeline.

See [the overall Cloud ownership record](../../docs/reconciliation.md).
