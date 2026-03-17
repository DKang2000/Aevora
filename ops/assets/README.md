# Asset Ops

This folder holds placeholder-safe asset manifests and later ingestion metadata for the launch pipeline.

## Why it exists
- `BE-22` needs a canonical path for asset-version metadata before final art generation exists.
- `OPS-09` needs a repeatable manifest and versioning workflow that can be promoted without inventing a separate system later.

## Current scope
- placeholder-safe manifest definitions only
- no generated art
- no signed CDN upload credentials

## Contracts
- schema: `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- launch manifest: `ops/assets/manifests/launch-assets.v1.json`

## Guardrail
Asset manifests may reference placeholder artifact targets, but they must not imply that final art assets already exist.
