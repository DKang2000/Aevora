# Asset Manifest Publishing

## Purpose
Version future launch art and placeholder-safe asset references through one manifest contract before real CDN uploads exist.

## Inputs
- manifest candidate under `ops/assets/manifests/`
- schema at `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- admin role header

## Steps
1. Validate with `corepack pnpm --filter @aevora/api validate:asset-manifest`.
2. Confirm each entry has:
   - stable `assetId`
   - `channel`
   - `logicalPath`
   - `versionToken`
   - `contentHash`
   - `cacheControl`
3. Promote through `POST /v1/admin/assets/releases/promote`.
4. Record the promoted release ID and version tokens in the release notes.

## Guardrail
Placeholder manifests are allowed here. This workflow should not imply that final art files have been generated or uploaded.
