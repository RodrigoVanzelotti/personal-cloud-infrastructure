# Append to user-global agent instructions

Preserve the existing instructions when appending these rules to the user's global
`AGENTS.md`, `CLAUDE.md`, or equivalent agent instruction file.

- `personal-cloud-infrastructure` is the central source of truth and execution point for Cloud infrastructure across all solutions. Locate its checkout before making a Cloud change.
- Every resource creation, update, removal, new deployment, release configuration, IAM, API, database or storage change must be defined and executed through that repository's Terraform and central release procedures. Application repositories may build/test artifacts and invoke the central workflows.
- Do not deploy independently through the Cloud Console, raw `gcloud`/Firebase commands, an application repository or a parallel Terraform stack. Read-only inventory and diagnostics are allowed. Use the central documented procedures for secret payload rotation and application content publication.
- Read that repository's `AGENTS.md` and `docs/reconciliation.md`; identify the solution, environment and owning state. Import existing resources or transfer ownership explicitly, never duplicate ownership, recreate resources to hide drift, or add unexplained `ignore_changes`.
- Preserve data, secrets, IAM, traffic and domains. Review a full plan and apply exactly that plan. Refresh release digests from live state before manual deployment.
- Existing legacy workflows awaiting handover are not authorization to create new independent deployment paths. Document blocked handovers; do not silently broaden cloud permissions.
- Do not commit or push code, or attribute changes to the agent. Ask the user about architectural decisions whose purpose is uncertain.
