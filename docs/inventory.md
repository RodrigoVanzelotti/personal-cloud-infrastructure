# Verified inventory - 2026-11-18

The active inventory contains four registered projects across the two authenticated
accounts. This inventory replaces the 2026-11-09 staging-only status. See
[reconciliation.md](reconciliation.md) for exact roots and state ownership.

| Project | Number | Display name | Enabled APIs | Listed Cloud Run services | Listed buckets |
| --- | --- | --- | --- | --- | --- |
| fundocentenario-website-stg | 424614961062 | Fundo Centenario Staging | 50 | 1 | 1 |
| fundocentenario-website-prd | 358530732475 | Fundo Centenario Producao | 47 | 1 | 0 |
| landing-optimizer-landing-page | 505424813528 | landing-optimizer-landing-page | 39 | 4 | 3 |
| landing-optimizer-demo | 943261198056 | landing-optimizer-demo | 31 | 1 | 0 |

The production state bucket `fundocentenario-website-prd-tfstate` was created after
the discovery snapshot; its current bucket count is one. Other infrastructure
adoptions import existing objects without recreating them.

| Scope | Verified resources and adoption |
| --- | --- |
| Landing Optimizer V1 | Existing state, 40 managed instances: API, dashboard, AI, migration job, PostgreSQL instance/database, runtime identities, secret containers/access, Artifact Registry and GitHub federation/IAM. Canonical code moved to the central repository with unchanged addresses and backend. |
| Landing Optimizer project + demo | 115 existing instances imported, including the Firestore ruleset/release. Marketing and demo Cloud Run, both source-build repositories/triggers, three buckets, existing Firestore, landing-page runtime identity, 70 enabled APIs and 32 additional project IAM members. |
| Fundocentenario stage app | Existing eleven imported Cloud resources plus Terraform's manifest guard; clean live plan against canonical YAML with manual adoption mode. |
| Fundocentenario stage foundation | 89 existing instances imported, including the Firestore ruleset/release: 50 APIs, 21 project IAM members (including the unchanged expired setup condition), Firestore database/index, email Scheduler, five explicit service accounts, GitHub federation/provider and resource-specific IAM. |
| Fundocentenario production | 89 existing instances imported, including Firestore ruleset/release, plus the newly created protected state bucket (90 managed instances). Includes Cloud Run, four secrets and runtime access, image repository, Hosting site, Firestore/index, Scheduler, identities/federation and 47 APIs. |

The existing staging state bucket is managed from the canonical `stage-state` root,
using its original bootstrap state and without recreating it. All six active roots
have clean full live plans, with no duplicate Google resource ownership.

Current Landing Optimizer ready revisions:

- API: `landing-optimizer-api-00009-lvf`.
- Dashboard: `landing-optimizer-dashboard-00014-n67`.
- AI: `landing-optimizer-ai-00001-c5j`.
- Marketing: `landing-optimizer-landing-page-00018-xfd`.
- Demo: `landing-optimizer-demo-00003-kxq`.

Landing Optimizer configuration is organized under `solutions/landing-optimizer/terraform/`;
its native configuration replaces the old empty YAML registration.

The V1 image snapshot was refreshed from remote state. Marketing and demo still
have existing source-push Cloud Build release steps; central adoption preserves
their serving configurations. See the handover warning before new releases.

Fundocentenario staging serves revision `fundo-centenario-00006-pih` with its
`candidate` tag. Its Hosting release is
`sites/fundocentenario-website-stg/releases/1793842129864000`; the live configuration
preserves the API rewrite, security/cache headers and staging noindex behavior.
Production serves `fundo-centenario-00003-zp2`; its Hosting site exists but the
Hosting releases list is empty. Neither site has a registered custom domain in
the Hosting custom-domain API. No source commit was invented for production.

No BigQuery datasets were listed in the three deployed application projects.
Firestore security rules are inventoried and adopted separately from database
contents. Secret payloads, database contents, events and credentials were not read.
The retained expired stage IAM condition is
`developer-connect-connection-setup`, expiring on 2026-11-05; it was preserved as
found rather than converted into an unconditional permission.

Detailed metadata, denied/disabled queries, live service configuration, Hosting
release snapshots, import logs and Terraform state backups are retained under
ignored `.local/reconciliation/`. Do not publish that directory. API failures are
not evidence of an empty project; the Cloud Asset API was not enabled solely for
discovery. Region and discovery limits are recorded in the reconciliation report.
