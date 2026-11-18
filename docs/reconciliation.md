# Cloud reconciliation - 2026-11-18

The identified infrastructure has been reconciled with Google Cloud. All six
active remote states have full clean plans (exit code 0). This reconciliation
imported **293 existing resource instances**, preserved the original V1/application
states, and created one protected production state bucket. No application serving
version, database contents, secret payload, traffic target or access rule was changed.
The two legacy build triggers received only the explicit existing API timeout default.

**Current organization and handover status:** Landing Optimizer now keeps both
native Terraform roots inside `solutions/landing-optimizer/terraform/{v1,project}`.
The empty YAML solution/environment drafts were removed. Its README indexes all
five services, the SDK, databases, five secret containers, IAM, states and releases.

Local CI callers for API, AI, dashboard, marketing and demo use the central reusable
workflow. Release plans may change only the selected service and the API migration
job; other services, IAM changes, replacements and deletions are rejected. The
existing remote image and label values are reloaded under the shared release lock.

Publication and Cloud handover remain pending: the latest user instructions
prohibit commits and pushes. No handover plan has been applied. Reviewed plans create one dedicated frontend release identity and 16 scoped IAM
grants, extend the existing federation condition to marketing/demo,
and disable/retire deploy steps in the two legacy Cloud Build triggers. They propose
no application image, traffic or database changes. Keep the old triggers active
until the replacement is published and verified. Application product changes in
the API/dashboard working trees are outside this infrastructure change.

The initial reconciliation verification below remains historical evidence. New
local test results and operational limits are recorded in `docs/handover-status.md`.

`personal-cloud-infrastructure` is the source of truth for infrastructure and cloud
release execution across solutions. Application repositories build/test artifacts
and call central release workflows. Do not provision or deploy independently from
the Console, application repositories, or another Terraform state.

## Ownership and state

| Solution / scope | Canonical Terraform root | GCS bucket | State prefix |
| --- | --- | --- | --- |
| Landing Optimizer API, dashboard, AI, SQL, migration job, CI identities and secret access | `solutions/landing-optimizer/terraform/v1` | `landing-optimizer-v1-tfstate-505424813528` | `landing-optimizer/v1` |
| Landing Optimizer marketing + demo, project APIs/IAM, Firestore, source repositories and buckets | `solutions/landing-optimizer/terraform/project` | `landing-optimizer-v1-tfstate-505424813528` | `landing-optimizer/project` |
| Fundocentenario stage application, Hosting site, secrets and image repository | `terraform/stack`, solution `fundocentenario`, environment `stage` | `fundocentenario-website-stg-tfstate` | `fundocentenario/stage` |
| Fundocentenario stage Firestore/index, Scheduler, identities/federation, APIs and remaining IAM | `terraform/solutions/fundocentenario/stage` | `fundocentenario-website-stg-tfstate` | `fundocentenario/stage-foundation` |
| Fundocentenario production application and foundation | `terraform/solutions/fundocentenario/prod` | `fundocentenario-website-prd-tfstate` | `fundocentenario/prod` |
| Existing Fundocentenario stage state bucket only | `terraform/solutions/fundocentenario/stage-state` | `fundocentenario-website-stg-tfstate` | `bootstrap/fundocentenario/stage` |

The V1 root was moved without changing resource addresses or migrating its state.
Landing Optimizer uses native Terraform without duplicate YAML manifests. The
Fundocentenario production YAML manifest remains disabled because its specialized
root already owns those resources.
Do not enable a second owner. The stage foundation root does not own the eleven
application resources or the bootstrap bucket.

The stage application can now be planned directly from the canonical repository,
without an enabled manifest copy under `.local/adoption`. Initialize its exact
backend and pass `-var=solution=fundocentenario -var=environment=stage
-var=adoption_mode=true` on manual plans. `adoption_mode` permits infrastructure
reconciliation while leaving automatic releases disabled. It does not publish
Hosting content or bypass production release approvals.

## What changed

- Copied the existing working V1 Terraform, release implementation, Dockerfile and
  tests into this repository and reused the central modules, including the existing
  Cloud SQL volume support. Refreshed all three image digests from remote state;
  stale local API/dashboard values would have rolled back running releases.
- Imported the additional Landing Optimizer project resources into a separate
  remote state: 115 existing resource instances, including its Firestore ruleset/release. Project IAM uses additive members,
  with existing V1 grants excluded to prevent duplicate ownership.
- Declared both legacy Cloud Build triggers in Terraform. Their only runtime
  configuration adjustment during import was an explicit `3600s` build timeout,
  preserving the Cloud Build API default instead of adopting the provider's `600s`
  default. No trigger was run and no application image or traffic was changed.
- Completed Fundocentenario imports for 89 existing instances per environment,
  preserving its conditional IAM grant, federation restrictions, email scheduler,
  Firestore index/rules and all application settings. Production state uses a new private,
  versioned bucket with uniform access and public access prevention; this was the
  only new persistent infrastructure resource required for adoption.
- Added a canonical `stage-state` root for the original staging bucket, preserving
  its resource address, backend, output and state. No isolated `.local` configuration
  is needed for that bucket now. The generic bootstrap remains an onboarding template;
  do not apply its complete CI/API scaffold over the existing foundation states.
- Imported all six Firestore ruleset/release resources without changing the existing
  deny-all client rules. Explicit quota attribution is configured on the main Landing
  Optimizer provider; demo keeps its existing API setup unchanged.
- Added destruction guards to adopted resources. Secret payloads and application
  data were not read or copied into configuration. Terraform owns secret containers
  and access only.
- A TLS error interrupted saving the Landing Optimizer project state after import.
  Recovered it with `terraform state push errored.tfstate` without `-force`, checked
  lineage and all 113 initial instance IDs in remote state, then verified a clean live plan.
  Subsequent rules imports brought this state to 115 instances.

## Releases and remaining handover

The central reusable workflow `.github/workflows/deploy-landing-optimizer.yml`
contains the API/AI/dashboard release implementation. Local application CI callers
now reference it; the old infra reusable workflow delegates to it. Legacy local
Python entry points delegate to the central code, and direct Terraform plans in the
old V1 directory fail with a migration instruction. Existing remote workflows are
unchanged because commits and pushes are prohibited in this session.

When publication is authorized again, publish the central repository first and
then the prepared callers, applying only the reviewed handover permissions in
coordination with that transition.
Verify that application workflow tokens may read the central repository before
switching callers. Keep the existing GCS deployment lock and WIF restrictions.
The proposed federation change explicitly adds only the two marketing/demo source
repository IDs. The existing main-branch/event/owner restrictions stay in place.
The new frontend identity receives image publication, metadata reads, runtime
act-as and Cloud Run administration scoped to the two existing frontend services.
Its state writes are restricted to the project state prefix and shared release lock;
the existing API/AI/dashboard service-account federation bindings remain unchanged.

Marketing and demo Cloud Build triggers still perform their historical `gcloud run
services update` step on source pushes. Their definitions are now managed centrally,
but automatic release ownership is **not yet handed over**. Do not run a central
apply concurrently with them or apply an old service/image snapshot. Their next
release must move to a central Terraform release procedure; retire the legacy deploy
steps only after its replacement is published and verified. Source releases can
otherwise reintroduce drift.

Fundocentenario's source deployment workflow remains active. Its staging Hosting
release has `/api/**` rewrites to the `candidate` tag, security/cache/noindex headers,
and revision pinning. The current central static release engine does not support
all of those settings. Its production Hosting site has no releases in the live API.
Do not enable automatic Hosting publication or invent a production source commit.
The live release/config snapshot is retained in ignored reconciliation evidence.
A source-workflow handover and compatible central Hosting publisher remain required.

Before every manual release, refresh the live images under the existing deployment
lock, update the canonical Terraform/release configuration, inspect a full plan,
and apply exactly that saved plan. Reject deletions, replacements, unexpected IAM,
traffic, database or unrelated image changes. Never use `ignore_changes` to hide drift.
Use explicit credentials per account/project and never save access tokens in files.

## Evidence and limits

Ignored `.local/reconciliation/` contains metadata inventories, import/plan/apply
logs, state backups and recovery verification. These include operational metadata
and state and must stay out of Git. The versioned inventory summary is in
`docs/inventory.md`.

Cloud Asset APIs are disabled, so discovery used direct service APIs without
turning anything on to make inventory queries succeed. Disabled APIs and denied
queries are recorded as errors, not empty resource lists. Scheduler discovery was
in `southamerica-east1`; global Cloud Build triggers and all-region repositories
and Cloud Run service listings were checked. This is not a proof that no other
resource types or regional resources exist.

General agent rules are installed in the workspace `AGENTS.md` and this repository's
`AGENTS.md`. A prepared user-global append is in `docs/global-AGENTS.md`. The session
cannot write `C:/Users/Vanzelotti/.codex/AGENTS.md` or other user-global agent files;
those paths are outside its permitted write roots. No commit or push was performed.

References: [Terraform import and configuration generation](https://developer.hashicorp.com/terraform/language/import/generating-configuration),
[additive project IAM members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam),
[Cloud Build API timeout](https://docs.cloud.google.com/build/docs/api/reference/rest/v1/projects.builds).
