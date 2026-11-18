Inventory and adoption status as of 2026-11-09

| Solution | Environment | GCP project | Account | Evidence |
| --- | --- | --- | --- | --- |
| fundocentenario | stage | fundocentenario-website-stg | rodrigo.vanzelotti@fundocentenario.com.br | Direct CLI inventory; 11 existing resources imported; clean plan |
| fundocentenario | prod | fundocentenario-website-prd | rodrigo.vanzelotti@fundocentenario.com.br | Direct CLI inventory; no imports or changes |
| landing-optimizer | prod (provisional mapping) | landing-optimizer-landing-page | rodrigovanzelotti@gmail.com | Direct CLI inventory; no imports or changes; environment mapping unverified |
| landing-optimizer | stage | Not established | rodrigovanzelotti@gmail.com | Separate stage project needed if staging is required |

The refreshed `.local/inventory.json` confirms Landing Optimizer has the Cloud Run service `landing-optimizer-landing-page` in `southamerica-east1` and the Docker Artifact Registry repository `cloud-run-source-deploy` in the same region. Its latest ready revision in that snapshot is `landing-optimizer-landing-page-00014-hp4`. The service labels identify Cloud Build management and trigger `f81273bd-0790-45e2-9e44-20dcb5012b7e`; reconcile this existing deployment owner before adoption. No storage buckets were listed. Secret Manager, Firebase Hosting, and Firebase management APIs are absent from its enabled API inventory; failed queries for those services do not establish a need to enable them. Its container currently references an image tag; resolve the serving revision's digest before onboarding.

Both fundocentenario projects contain the Cloud Run service `fundo-centenario` and Docker repository `fundo-images` in `southamerica-east1`, plus the secret containers `smtp-password`, `smtp-username`, `stripe-secret-key`, and `stripe-webhook-secret`. Hosting sites are confirmed as `fundocentenario-website-stg` and `fundocentenario-website-prd`. No storage buckets existed before this adoption. The stage snapshot's latest ready revision is `fundo-centenario-00006-pih`; production's is `fundo-centenario-00003-zp2`. Secret values were not retrieved. Stripe references pin version 1; SMTP references pin version 2.

Direct access now works under the user's Windows identity, with outbound networking enabled. The corporate account was reauthenticated through Google's browser flow. Earlier session-permission failures are resolved. Hosting inventory also required the `x-goog-user-project` header; that is now supplied in inventory and release checks. Terraform providers likewise use explicit project quota attribution. No APIs were enabled to suppress inventory errors.

Staging adoption created only the private, versioned, uniform-access bucket `fundocentenario-website-stg-tfstate`, with public access prevention enforced. Bootstrap state is stored at `bootstrap/fundocentenario/stage/default.tfstate`; application state is at `fundocentenario/stage/default.tfstate`. Only the bootstrap bucket target was applied: new deployment identities, federation, project IAM grants, and API management have not been applied.

The application state contains 11 imported existing resources: Cloud Run service, Artifact Registry repository, Hosting site, four secret containers, and four runtime secret-access IAM members. The only subsequent state changes were creation of Terraform's manifest guard and setting the Hosting site's client-side deletion policy to PREVENT. The provider makes no API mutation for that deletion-policy-only update. The final plan has no changes. Backend `/api/health`, the Hosting homepage, and Hosting `/api/health` all returned HTTP 200. The old temporary credential-copy directory is confirmed absent.

All four repository environment manifests remain disabled. The verified staging configuration is copied to `.local/adoption/fundocentenario-stage`, with only that isolated copy enabled for importing and planning. Logs, snapshots, and the clean-plan/HTTP verification record are retained there. The root manifest points at the same remote state bucket but stays disabled until deployment handover is complete.

The source repository's `deploy.yml` still deploys staging on pushes to main, and its environment workflow deploys a candidate revision before pinning traffic and publishing Firebase content. It must be retired or changed to propose YAML releases before central deployment is enabled. Its Firebase configuration includes `/api/**` Cloud Run rewrites with `pinTag`, security headers, cache policies, and staging noindex headers. The current central static-content engine does not preserve those settings; enabling it prematurely would change site behavior. Finish that support and reconcile Firebase-generated Cloud Run traffic tags before a central release. Firestore, scheduler jobs, custom domains, and their existing IAM remain outside this initial import scope.

fundocentenario's repository is `RodrigoVanzelotti/fundo-centenario-website`, supplied by the user. Landing Optimizer's repository URLs were confirmed from local Git configurations: landing-page, api, dashboard, ai, and snippet, all under `RodrigoVanzelotti`. Its local infrastructure repository contains an AWS Terraform skeleton, which does not establish any GCP deployment. The landing-page repository runs a Node server, so Firebase Hosting must not be assumed.

From a normal terminal with network access, authenticate both accounts, then run the read-only metadata inventory:

```powershell
gcloud.cmd auth login rodrigo.vanzelotti@fundocentenario.com.br
gcloud.cmd auth login rodrigovanzelotti@gmail.com
python scripts/inventory.py
```

The output is ignored at `.local/inventory.json`. Every query uses an explicit account and project; it does not switch the active configuration, enable APIs, retrieve Secret Manager values, or export Cloud Run environment values. Missing permissions and disabled APIs are recorded as failures, never interpreted as an empty project. Review results before adding components. If an API is intentionally unused, document that fact rather than enabling it just to clear an inventory error.

The staging Hosting release is `sites/fundocentenario-website-stg/releases/1793842129864000`, with source commit `52964bd4f6c6f74192dfa80016dbc6e685a5c05b` and backend revision `fundo-centenario-00006-pih`. Its existing traffic routes 100% to that explicit revision and retains a `candidate` tag. Both are captured in YAML. No existing application revision, traffic target, IAM binding, secret version, or Hosting release was changed by this adoption.
