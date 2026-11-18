# Personal Cloud Infrastructure

> Landing Optimizer is self-contained under [solutions/landing-optimizer](solutions/landing-optimizer/README.md): native Terraform, five secrets and five service release paths. The source-workflow handover is prepared locally and not published. See [the current reconciliation record](docs/reconciliation.md).

This repository centralizes Cloud infrastructure and release execution for multiple solutions. Terraform owns the adopted Cloud Run services/jobs, databases, Firestore rules/indexes, Scheduler, IAM/federation, APIs, storage, image repositories, secret containers/access and Hosting sites. Landing Optimizer uses native Terraform in its solution directory; the generic YAML stack serves Fundocentenario. Exact roots and states are listed in [the ownership table](docs/reconciliation.md). Secret payloads and application data stay outside Git and Terraform.

The registrations are **fundocentenario** and **landing-optimizer**. The active inventory contains the four projects belonging to the registered solutions. Adopted infrastructure uses the existing remote states plus separate states for newly adopted scopes. **Automatic deployment handovers remain pending publication by the owner; Fundocentenario Hosting also needs a publisher preserving its existing rewrites and headers.** Application serving versions and access were preserved. See [the current inventory](docs/inventory.md) and [remaining handovers](docs/reconciliation.md).

Use Python 3.12, Terraform 1.16.6, and Google Cloud CLI. CI uses the same Terraform version as the verified imported state. The Google providers are constrained to major version 7 and locked to 7.46.2; Hosting uses `google-beta`, as required by [the provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firebase_hosting_site). Install the two validation dependencies and run the local checks:

```powershell
python -m pip install -r requirements.txt
python scripts/validate.py
python -m unittest discover -s tests -v
python -m unittest discover -s solutions/landing-optimizer/terraform/v1/tests -v
terraform fmt -check -recursive terraform
terraform fmt -check -recursive solutions
```

Validate one environment with `python scripts/validate.py --solution fundocentenario --environment stage`. Add `--deployable` to require a complete, enabled configuration. Disabled drafts may omit project IDs, state buckets, repositories, and deployments; supplied fields still must satisfy the schemas. Enabled environments must declare every component deployment. Duplicate YAML keys, unknown fields, invalid references, duplicate resources across states, mutable versions, and shared stage/prod projects are rejected.

The repository is organized around:

| Path | Responsibility |
| --- | --- |
| `solutions/landing-optimizer/` | Complete native Terraform, secrets and release configuration; start at its README |
| `solutions/<solution>/solution.yaml` | Repositories, component types and secret identifiers for YAML-managed solutions |
| `solutions/<solution>/environments/{stage,prod}.yaml` | Explicit environment configuration and pinned releases |
| `schemas/` | JSON Schema contract, plus semantic validation in `scripts/validate.py` |
| `terraform/stack/` | One generic YAML-consuming stack |
| `terraform/modules/` | Cloud Run, static Hosting sites, secrets, Artifact Registry |
| `terraform/bootstrap/` | Per-environment state bucket, APIs, CI identities, GitHub federation |
| `.github/workflows/` | Validation, trusted PR plans, deployment, Firebase release records |

After inventory, a solution can declare components using existing types without new Terraform code:

```yaml
schema_version: 1
name: example
description: Example solution
repositories:
  app:
    provider: github
    slug: YOUR_ORG/YOUR_REPOSITORY
components:
  api:
    type: cloud_run_service
    repository: app
  frontend:
    type: firebase_hosting
    repository: app
secrets:
  - database-url
```

The matching environment declares full configuration. Replace the illustrative identifiers, digest, and commit below with verified values. The accounts, sites, image and secret version must already exist or be provisioned through the adoption procedure.

```yaml
environment: stage
enabled: true
gcp:
  project_id: example-stage
  region: southamerica-east1
state_bucket: example-stage-tfstate
artifact_registry: [apps]  # Optional; import first if it already exists.
deployments:
  api:
    service_name: example-api
    image: southamerica-east1-docker.pkg.dev/example-stage/apps/api@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    service_account: runtime@example-stage.iam.gserviceaccount.com
    public: false
    ingress: INGRESS_TRAFFIC_ALL
    port: 8080
    cpu: "1"
    memory: 512Mi
    env:
      APP_ENV: stage
      ENABLE_ANALYTICS: "false"
    secret_env:
      DATABASE_URL:
        secret: database-url
        version: "1"
    scaling:
      min_instances: 0
      max_instances: 2
  frontend:
    site_id: example-stage
    commit: bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    public_dir: dist
```

`public: false` means this stack does not grant anonymous invocation. It does not remove pre-existing IAM grants; audit them during adoption. Runtime service accounts are existing, explicitly selected identities. The stack grants only the declared secret-access permissions and does not create runtime identities or silently change unrelated IAM members.

Cloud Run also supports explicit timeout, concurrency, CPU behavior, HTTP startup probes, service-level scaling, invoker IAM behavior, and traffic targets for adoption. The staging snapshot pins its existing revision, traffic, and deployment-client metadata to produce a clean plan. When releasing a different image, remove or change `revision` and update the traffic targets deliberately; reusing an existing immutable revision name with a different image will fail. Do not change these snapshot fields until the source deployment workflow has been handed over. `invoker_iam_disabled: true` makes invocation public without an `allUsers` IAM member; staging already used that setting before import.

Hosting commits must contain **prebuilt static assets**, including `index.html`, under `public_dir`. Source repositories own build/test and publication of those assets. The release job checks out the pinned commit, copies its assets, and runs a pinned Firebase CLI using a generated static Hosting configuration. It executes no source-repository hooks or build scripts with cloud credentials. Source content must be safe for public distribution. Current support excludes SSR, Firebase App Hosting, redirects, rewrites, custom headers, and custom domains. Inspect existing Hosting configuration before adoption; extend this engine before enabling a site that uses those features. Terraform preserves existing domain resources but does not manage them.

To onboard either solution, follow [the adoption procedure](docs/adoption.md). It covers bootstrap, imports, GitHub setup, and the first staging change. [Operations](docs/operations.md) covers releases, promotion, rollback, secret rotation, and recovery.

On pull requests, validation always runs. Cloud plans run only for same-repository PRs and only for affected enabled environments. Fork PRs get validation without cloud credentials; maintainers must review and move accepted changes to a trusted branch for a cloud plan. Plan identities can read infrastructure and state and write only the GCS lock object. Treat trusted PR authors as readers of state; plans and state can contain non-secret configuration.

Merges to `main` deploy changed enabled environments. Changes to shared Terraform, scripts, schemas, dependencies, or workflows select every enabled environment. Manual retries accept a solution and environment and run only from `main`. One concurrency group serializes the complete infrastructure and Hosting release for each environment. Terraform also uses GCS locking. Production jobs use GitHub Environments and check for configured required reviewers before cloud authentication. Configure branch protection to require validation and Terraform plans before merge.

The bootstrap scopes [Workload Identity Federation](https://docs.cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines) to this repository. Apply subjects require `main`; PR subjects can impersonate only plan identities. Each solution/environment gets its own state bucket and `${solution}/${environment}` prefix, so deployment identities cannot read another environment's state. GitHub deployment environments also separate stage and prod identities. Protect environment settings and repository `main`; users who can change those controls can change the approval boundary.

Infrastructure plans reject all deletions and replacements, including resources removed from a module. Persistent resources also have Terraform destruction protection. These protections do not detect every harmful in-place change; review the first imported plan carefully. A release failure can leave Cloud Run updated while Hosting remains on its previous release; deployments across engines are not atomic. Release records identify the infrastructure commit, Hosting commit, and outcome. No automatic rollback is attempted.

Verification on 2026-11-18: 17 repository tests and 10 central release tests pass, along with the legacy entry-point test suite, manifest validation, Terraform formatting and validation of all seven roots. The exact live-plan results, imported resource counts, read-only inventory limits and remaining release handovers are recorded in [reconciliation.md](docs/reconciliation.md). No commit or push was performed.
