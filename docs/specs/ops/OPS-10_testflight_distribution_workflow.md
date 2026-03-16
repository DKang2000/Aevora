# OPS-10 — TestFlight Distribution Workflow

## Purpose
Define the manual-to-automated release path for producing signed internal beta builds and uploading them to TestFlight.

## Why it exists
Once the iOS shell is green in CI, the repo needs a repeatable release workflow that preserves the same generation/build path while keeping signing material external.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ops/OPS-02_ios_ci_cd_pipeline.md`
- `docs/specs/ops/OPS-04_secrets_management.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`

## Output / canonical artifact
- GitHub Actions workflow at `.github/workflows/testflight.yml`
- operator notes at `ops/release/testflight/README.md`

## Repo adaptation
- The workflow keeps XcodeGen as the release-time project source of truth.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.

## Edge cases
- Signing assets and App Store Connect credentials remain external and environment-scoped.
- Hosted runner simulator validation is not a substitute for archive signing validation.
- Release failures need clear retry points across certificate import, profile install, archive, export, and upload.

## Acceptance criteria
- A manually dispatched workflow exists for archive/export/upload preparation.
- The workflow documents required secrets and signing prerequisites.
- Release notes explain versioning, build numbering, and tester-group promotion expectations.

## Validation
- Workflow YAML parses successfully.
- The workflow reuses the same `xcodegen generate` step as `OPS-02`.

## Explicit non-goals
- committing signing material
- assuming Xcode Organizer uploads as the primary path
- broad release-train automation beyond TestFlight foundation
