# ST-03 — Client Local Storage Schema

## Purpose
Define the local-first storage model that powers instant logging, offline resilience, widgets, Live Activities, and queued sync on iPhone.

## Why it exists
Without a canonical device-store contract, SwiftData models, widget snapshots, and sync behavior would all diverge. This spec locks what lives on-device, what is derived, and what is only queued for reconciliation.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`

## Scope
This section defines:
- cached entities required for core v1 UX
- queue-only records for offline sync
- widget and Live Activity snapshot shape
- cache retention and pruning rules

## Non-goals
- SwiftData code generation
- server persistence design
- backend reconciliation implementation

## Local store partitions
### Cached current state
- `profile`
- `avatar`
- `subscriptionState`
- `activeVows`
- `progressionSnapshot`
- `districtState`
- `inventorySummary`
- `remoteConfigCache`
- `permissionState`

### Event and operation history
- local `completionDrafts`
- `syncQueue`
- minimal `rewardHistory` for recent UX rendering

### Shareable glanceable state
- `todaySnapshot` for widgets
- `liveActivitySnapshot` for active logging or chapter state

## Queue model
Each queued operation stores:
- `clientRequestId`
- `operationType`
- `createdAt`
- `attemptCount`
- `lastAttemptAt`
- `payload`
- `dependencyIds`
- `status`: `pending`, `in_flight`, `retryable_error`, `terminal_error`, `applied`

Supported operation types:
- `vow_create`
- `vow_update`
- `vow_archive`
- `completion_submit`
- `shop_purchase`
- `verified_completion`

## Local-first rules
- Logging and local vow edits write to the device store immediately.
- The queue records network intent separately from current UI state.
- Reward UI may show a provisional local preview, but the canonical reward result comes from server reconciliation.
- Widget and Live Activity snapshots must read from locally available state only.

## Conflict-handling notes
- Completion duplicate: mark queue item `applied` and merge server reward response
- Vow update conflict: prefer server canonical state and keep the local draft as a resolved history item
- Entitlement mismatch: keep historical local facts, but enforce new access boundaries for future edits
- Remote config stale or missing: use last known good cache, then bundled defaults

## Retention and pruning
- keep recent completion drafts until reconciled plus 30 days
- keep recent reward history sufficient for current UX and debug surfaces
- prune fully applied queue items after durable reconciliation and snapshot refresh
- keep widget snapshot lean and derived

## Widget and Live Activity snapshot rules
- no raw journaling or note text in widget-shared state
- include only what is needed for glanceable progress:
  - today vow summary
  - completion counts
  - chapter/district short status
  - current streak/chain count

## Edge cases
- app relaunch during sync: queue items resume from durable local state
- guest-to-account link: preserve queue and merge server identifiers during token refresh
- denied HealthKit permission: source connection remains local with denied state; manual logging remains available
- duplicate verified-input import: preserve the local source-connection record, mark the queued item reconciled, and do not grant duplicate rewards

## Versioning notes
- local store schema version is `v1`
- additive cached fields are preferred
- breaking changes require a migration note and fixture update

## Examples
Supporting examples live in `shared/contracts/client-local-storage/examples/`.

## Acceptance criteria
- the on-device store covers every core v1 surface needed for offline-capable daily use
- queued operations are explicit and durable
- widget and Live Activity state is derived from local store, not network-only dependencies
- conflict behavior is defined clearly enough for iOS implementation and QA
