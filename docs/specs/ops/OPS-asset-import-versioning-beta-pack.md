# OPS Asset Import Versioning Beta Pack

## Purpose
Define the import and versioning workflow for converting final manual art outputs into manifest-backed Aevora assets for beta and launch builds.

## Why this exists
The beta asset pass needs reproducible imports and stable identifiers so design, iOS, backend, and QA can talk about one manifest instead of ad hoc filenames.

## Inputs / dependencies
- `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- `shared/contracts/assets/aevora-v1-asset-slot-families.seed.json`
- `ops/assets/manifests/aevora-v1-local-placeholder-manifest.seed.json`
- `ops/publishing/assets.md`
- backend asset promotion flow under `backend/apps/api/src/admin/`

## Output / canonical artifact
This runbook, plus future manifest revisions under `ops/assets/manifests/`.

## Naming rules
- `assetId` stays equal to the logical slot family ID unless a later accepted contract explicitly introduces variants.
- `logicalPath` stays human-readable and stable across placeholder and final imports.
- `artifactPath` may change per release, but the slot family and logical path should not.
- `versionToken` must change on every imported revision, even when only visual polish changes.

## Import steps
1. Generate or export final manual art to the agreed beta slot family.
2. Place the importable artifact in the repo-managed asset location or release staging path.
3. Update the manifest entry:
   - `artifactPath`
   - `contentHash`
   - `versionToken`
   - `sizeBytes`
   - `generatedAt`
   - `releaseId`
4. Validate the manifest locally.
5. Promote the manifest through the existing admin asset-release flow.
6. Record the promoted release ID and version tokens in release notes or handoff logs.

## Version-token discipline
- Use monotonic, human-readable release tokens.
- Do not reuse placeholder version tokens for final imports.
- If multiple slots are imported from the same art batch, each slot still gets its own explicit entry.

## Reproducibility guardrails
- Keep slot-family IDs stable.
- Keep the manifest diff reviewable.
- Do not mix final imported assets with speculative future scope.
- Placeholder manifests remain valid for beta as long as the UI path remains safe and QA has explicit blocker rules.

## Edge cases
- a beta-critical slot is still placeholder-only at cut time
- imported art exists but manifest metadata is stale
- backend promotion points at the wrong manifest revision
- marketing/App Store assets are versioned separately from in-app launch art

## Acceptance criteria
- every imported asset can be traced back to one manifest entry
- backend promotion can use the manifest without schema changes
- placeholder and final art share the same slot-family model

## Explicit non-goals
- CDN implementation details beyond current manifest compatibility
- Apple signing, ASC secrets, or legal submission work
- reopening `ART-01`, `ART-03`, or `ART-04`
