# Remote Config Publishing

## Purpose
Promote a validated runtime-config payload into the guarded API control plane without editing bundled defaults in place.

## Inputs
- candidate file under `shared/contracts/remote-config/` or another repo-tracked launch-ops path
- admin role header
- optional operator note

## Steps
1. Validate the candidate payload with `corepack pnpm --filter @aevora/api validate:remote-config-release`.
2. Confirm the payload preserves all ST-05 top-level sections.
3. Promote through `POST /v1/admin/runtime-config/releases/promote` with:
   - `candidatePath`
   - `label`
   - optional `notes`
4. Confirm `GET /v1/admin/runtime-config/releases/current` shows the new active release.
5. Confirm `GET /v1/remote-config` serves source `promoted_override` when no environment override is present.

## Rollback
- Re-promote the previous validated candidate.
- If the API itself is impaired, use the environment override path as break-glass and record the reason in the incident log.
