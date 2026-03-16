# DATA-03 — Analytics Event Schema Implementation

## Purpose
Provide executable analytics validation helpers and a shared event package that downstream backend and iOS work can depend on.

## Why it exists
ST-04 locked the event taxonomy, but executable validation was still missing. This section adds a backend package that validates the common event envelope, exposes the canonical event list, and points back to the shared machine-readable contracts under `shared/contracts/events/`.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `shared/contracts/events/event-catalog.v1.yaml`
- `shared/contracts/events/schemas/`
- `shared/contracts/fixtures/launch/analytics_events_sample.json`

## Output / canonical artifact
- executable package at `backend/packages/analytics-schema/`
- validation helpers in `backend/packages/analytics-schema/src/`
- canonical contract manifest in `backend/packages/analytics-schema/schemas/manifest.json`
- example envelopes in `backend/packages/analytics-schema/examples/`

## Repo adaptation
- Pack path `packages/analytics-schema` is adapted to `backend/packages/analytics-schema`.
- Canonical machine-readable schemas remain in `shared/contracts/events/`; the executable package consumes and references them instead of redefining event truth in a second place.

## Edge cases
- Unknown event names fail validation instead of silently passing through.
- Events must carry either `user_id` or `anonymous_device_id` to preserve attribution continuity rules.
- Event examples remain fixture-safe and never include prohibited free text.

## Acceptance criteria
- There is one executable package for analytics validation.
- The package exposes typed event names, common envelope validation, and canonical contract paths.
- Valid examples pass validation and malformed envelopes fail tests.
- The implementation does not introduce event names outside ST-04.

## Explicit non-goals
- dashboards or warehouse models
- backend ingestion endpoints
- vendor SDK integration
