# OPS Launch Readiness and Publishing Compliance Pack

## Purpose
Define the operator workflows that safely move Aevora from a feature-complete beta build to a launch-ready candidate: publishing runtime config and launch content, versioning placeholder-safe assets, handling restore/export/delete incidents, and documenting environment-limited release proofs honestly.

## Why it exists
The repo already had CI, monitoring, secrets, and TestFlight scaffolding. Launch readiness needs the missing day-two workflows: how config and content are promoted, how placeholder asset manifests are versioned before art exists, how backups and hotfixes are handled, and how external gaps like Apple signing remain explicit rather than implied.

## Inputs / dependencies
- `docs/specs/backend/BE-launch-readiness-publishing-compliance-pack.md`
- `docs/specs/ops/OPS-01_dev_staging_prod_environments.md`
- `docs/specs/ops/OPS-04_secrets_management.md`
- `docs/specs/ops/OPS-10_testflight_distribution_workflow.md`
- `docs/specs/ops/OPS-12_access_control_admin_roles.md`
- `ops/assets/manifests/launch-assets.v1.json`

## Output / canonical artifact
- operator workflow docs under `ops/publishing/`
- asset ops notes under `ops/assets/`
- later runbook bundle under `docs/specs/ops/OPS-launch-readiness-runbooks-pack.md`

## Workflow boundaries
### OPS-07 remote config publishing
- Candidate runtime-config payloads are validated before promotion.
- Promotion is done through the guarded admin endpoint, not by editing live app defaults in place.
- Environment override paths remain reserved for controlled break-glass use.

### OPS-08 content publishing
- Launch content and copy promotion use the guarded admin content routes.
- Content and runtime config remain separate channels with separate validation.
- Version mismatches remain explicit so the client can decide whether to refresh or fall back.

### OPS-09 asset ingestion and versioning
- Asset releases are represented by a manifest and version token rather than ad hoc filenames.
- Placeholder manifests are valid launch-ops artifacts even when final art does not yet exist.
- Cache-control and logical-path fields are required so later art publishing can reuse the same manifest shape.

## Acceptance criteria
- Operators have one documented path for config, content, and asset-manifest promotion.
- Every publishing path has a validation command and a guarded activation step.
- Placeholder-safe asset ops are documented without pretending art delivery is complete.
- Environment-limited proofs remain clearly separated from landed repo automation.

## Explicit non-goals
- automated content authoring UI
- production CDN setup
- Apple credential generation inside the repo
- final App Store marketing asset production
