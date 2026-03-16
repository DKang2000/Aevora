# OPS-04 — Secrets Management

## Purpose
Define how Aevora handles secrets across local development, CI, and hosted environments without leaking credentials into the repo.

## Why it exists
The foundation bundle adds environment templates and CI foundations next. This section creates the guardrails and inventory template that keep those workflows safe before more services and integrations appear.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ops/OPS-01_dev_staging_prod_environments.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- secret inventory template at `ops/secrets/SECRET_INVENTORY_TEMPLATE.md`
- process guidance at `ops/secrets/README.md`
- `.gitignore` protections for local secret and config files

## Management model
- Local development uses untracked `.env` files and placeholder-only checked-in templates.
- CI uses GitHub Actions environments and repository or environment-scoped secrets.
- Hosted runtimes use a managed secret store; the repo is never the source of actual credentials.
- Rotation and access removal must be documented per secret family in the inventory template.

## Edge cases
- Local sandbox credentials still count as secrets and should not be committed.
- Emergency rotation should include revocation of CI access and hosted runtime injection paths, not just secret value replacement.
- Debug-only tooling must inherit the same secret boundaries as production code paths.

## Acceptance criteria
- The repo contains only templates and process guidance, not live credentials.
- The secret inventory captures owner, scope, rotation, and injection path.
- `.gitignore` covers likely local secret files introduced by foundation work.
- The guidance does not depend on a single person’s laptop or memory.

## Explicit non-goals
- committing real credentials
- choosing a specific hosted secret vendor
- legal/compliance policy authoring
