# Landing Optimizer organization and pipeline handover

## Ready locally

- Complete native Terraform source lives under `solutions/landing-optimizer/terraform/{v1,project}`.
- The solution README indexes all services, source repositories, five secrets, runtime consumers, state backends and release procedures.
- Empty YAML registrations were removed. The generic YAML pipeline rejects native Terraform solutions before cloud authentication.
- API, AI, dashboard, marketing and demo source workflows call the central reusable release workflow.
- The release script preserves other services' current images and labels, verifies source/main ownership, uses the existing global lock, and rejects unrelated infrastructure changes, deletion and replacement.
- Marketing/demo use a proposed separate release identity with scoped service/repository permissions and state/lock writes. Existing serving runtime identities and the API/AI/dashboard deployer are preserved.
- API CI uses the user-approved dashboard policy: production vulnerability audit blocks deployment; the complete audit remains visible and advisory for development findings.
- Legacy local commands delegate to the new central path. Product changes in the API/dashboard workspaces are excluded from the prepared publication scope.

## Tested

| Check | Result |
| --- | --- |
| Repository validation/unit tests | 17 passed |
| Central release unit tests | 10 passed |
| Legacy compatibility tests | 5 passed (overlap with the central suite) |
| All seven Terraform roots | Validated; both source trees formatted |
| Legacy local Docker Compose configuration | Validated without starting containers |
| API on Node.js 22.22.3, clean main checkout | Typecheck/build passed; 232 tests passed, 4 integration tests skipped |
| Dashboard on Node.js 22.22.3, clean main checkout | Typecheck/build passed; 62 tests passed |
| AI | Ruff passed; 3 tests passed |
| Marketing | 36 tests passed |
| SDK, clean main checkout | Typecheck passed; 41 tests passed with the original test config loaded natively in Node |
| API/dashboard production audit | No reported vulnerabilities |
| Workflow YAML/callers and source-path checks | Passed for all five components |
| GitHub Actions expressions and workflow references (actionlint 1.7.7) | Passed in all seven affected repositories |
| Cloud handover plans | No deletion, replacement, application image/traffic or database changes |

The 401 passing tests above are distinct; the legacy compatibility suite is not
counted again. Four API integrations require isolated databases and were skipped.
No production database was used for tests. Source test checkouts are in
`.publication/`; logs are ignored under `.local/validation/`.

## Not validated or applied

The SDK's standard CLI/build config loader tries to scan an inaccessible ancestor
directory in this Windows sandbox. The test suite passes when its exact config is
loaded through Node's native TypeScript support; bundle generation remains blocked
by the same esbuild filesystem restriction. No SDK source change was made.

The local Docker daemon is inaccessible to this session. The demo/container builds
and the actual GitHub-to-GCP federation/deploy flow have not been run here. They
must be verified in the authorized publication environment before retiring the old
Cloud Build triggers.

The complete API audit still reports 10 high-severity development findings in the
picomatch dependency chain. Production audit reports zero. The user explicitly
selected the existing dashboard policy; its strict production gate was tested and
the full report remains in CI and is not
silently discarded. See the [upstream advisory](https://github.com/advisories/GHSA-fc5q-39xc-vjpf),
which was withdrawn on 2026-11-18 while the npm audit report still included it.

## Publication and cutover

The latest user instructions prohibit commits and pushes. None was performed.
Cloud handover plans were inspected but not applied. The production services,
legacy triggers and existing release permissions remain unchanged by this step.

The reviewed desired difference is 17 creates (one service account and 16 IAM
grants), one federation-provider update, and two legacy-trigger updates. The
updates disable the old triggers and remove their raw Cloud Run deploy steps.

When publication is explicitly allowed again:

1. Revalidate against current remote main heads, preserving unrelated product work.
2. Publish the central repository first and confirm its validation workflow.
3. Regenerate/review the handover plans with fresh state; do not apply an old saved plan.
4. Hold source pushes during the cutover and wait for any existing legacy builds.
   After central validation, coordinate the reviewed permission grants, legacy-trigger
   disabling and source caller publication so the two deploy paths do not run together.
   Existing serving revisions remain available throughout this configuration change.
5. Verify all five central releases and health checks, then clean post-release plans
   with current image/label inputs and update this record. Leave the legacy triggers
   disabled; do not re-enable a competing deploy while central releases are running.

The seven affected repositories are personal-cloud-infrastructure,
landing-optimizer-infra, landing-optimizer-api, landing-optimizer-ai,
landing-optimizer-dashboard, landing-optimizer-landing-page and landing-optimizer-demo.
The snippet repository is consumed by API builds but has no changes to publish.
The selected source-file list is retained in ignored `.local/handover/prepared-files.json`.
