# Content Publishing

## Purpose
Promote authored launch content and copy together while keeping authored content separate from runtime tuning.

## Inputs
- content candidate under `content/launch/`
- copy candidate under `content/launch/copy/`
- admin role header

## Steps
1. Validate with `corepack pnpm --filter @aevora/api validate:content-release`.
2. Confirm the content payload still matches ST-06 structure.
3. Promote through `POST /v1/admin/content/releases/promote` with:
   - `contentPath`
   - optional `copyPath`
   - `label`
   - optional `notes`
4. Confirm `GET /v1/admin/content/releases/current` shows the active content release.
5. Confirm `GET /v1/content/manifest` reports source `promoted_override`.

## Rollback
- Re-promote the previous validated content bundle.
- Do not use remote config to work around invalid authored content.
