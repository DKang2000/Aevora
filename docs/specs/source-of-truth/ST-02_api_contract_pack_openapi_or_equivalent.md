# ST-02 — API Contract Pack

## Purpose
Define the v1 network contract between the iPhone client and backend for auth, profile, vows, completions, progression, world state, commerce, remote config, and analytics ingestion.

## Why it exists
iOS and backend need one shared transport contract for payloads, errors, idempotency, and sync behavior. Without it, local-first logging and server-authoritative rewards drift immediately.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`

## Scope
This section defines:
- authenticated and guest session flows
- canonical request/response envelopes
- offline-safe write endpoints
- sync and world-state fetch endpoints
- entitlement- and config-aware reads

## Non-goals
- handler implementation
- database schema
- social or multiplayer endpoints

## API design rules
- Version prefix: `/v1`
- JSON request/response bodies
- Authenticated requests use bearer access tokens
- Offline-created writes include `clientRequestId`
- Completion and reward-sensitive writes support idempotency via `Idempotency-Key` or `clientRequestId`
- Server remains authoritative for rewards, entitlements, and finalized progression

## Canonical endpoints
### Auth and account
- `POST /v1/auth/guest`
- `POST /v1/auth/apple`
- `POST /v1/auth/link-account`
- `POST /v1/auth/restore-session`
- `GET /v1/account`
- `POST /v1/account/export`
- `DELETE /v1/account`

### Profile and avatar
- `GET /v1/profile`
- `PATCH /v1/profile`
- `PATCH /v1/avatar`

### Vows
- `GET /v1/vows`
- `POST /v1/vows`
- `PATCH /v1/vows/{vowId}`
- `POST /v1/vows/{vowId}/archive`

### Logging and sync
- `POST /v1/completions`
- `POST /v1/sync/operations`
- `GET /v1/progression/snapshot`

### World, chapter, inventory, shop
- `GET /v1/world-state`
- `GET /v1/chapters/current`
- `GET /v1/inventory`
- `GET /v1/shop/offers`
- `POST /v1/shop/offers/{offerId}/purchase`

### Entitlements and runtime config
- `GET /v1/subscription/state`
- `POST /v1/subscription/restore`
- `GET /v1/remote-config`

### Analytics
- `POST /v1/analytics/events`

### Internal launch ops
- `GET /v1/admin/runtime-config/releases/current`
- `POST /v1/admin/runtime-config/releases/promote`
- `GET /v1/admin/content/releases/current`
- `POST /v1/admin/content/releases/promote`
- `GET /v1/admin/assets/releases/current`
- `POST /v1/admin/assets/releases/promote`
- `GET /v1/admin/accounts/{userId}`
- `POST /v1/admin/accounts/{userId}/export`

## Canonical error envelope
```json
{
  "error": {
    "code": "vow_cap_reached",
    "messageKey": "errors.vow.cap_reached.title",
    "detailKey": "errors.vow.cap_reached.body",
    "retryable": false,
    "correlationId": "req_123"
  }
}
```

## Server authority boundaries
- Server-authoritative:
  - reward calculation
  - entitlement evaluation
  - canonical progression snapshots
  - billing and restore outcomes
- Client-preview only:
  - optimistic completion acknowledgement
  - provisional Today-screen updates before sync completes

## Sync and idempotency rules
- `POST /v1/completions` accepts one completion intent; duplicate `clientRequestId` must return the same logical result.
- `POST /v1/verified-inputs/completions` accepts one verified completion intent; duplicate `sourceEventId` must return the same logical result without granting duplicate rewards.
- `POST /v1/sync/operations` accepts a batch of queued offline operations and returns per-operation status.
- Reward grants are returned as derived results, never accepted as client-authored writes.
- Conflict results must identify whether the client should replace local state, retry later, or keep the local record but mark it reconciled.

## Status code policy
- `200`: read or mutation succeeded
- `201`: new server resource created
- `202`: async ingestion accepted
- `400`: malformed request
- `401`: missing or invalid auth
- `403`: valid auth but entitlement or policy denies action
- `404`: resource not found
- `409`: idempotency or state conflict
- `422`: semantically invalid request, such as out-of-range progress
- `429`: rate limited
- `500/503`: server failure or temporary unavailability

## Edge cases
- Guest account upgrade must preserve local progression and vows after link
- Expired premium during queued writes must not invalidate already-earned manual completions
- Stale remote config fetch falls back to cached or bundled defaults
- HealthKit-linked vows still accept manual completion when verification is unavailable
- Notification-plan reads may be stale, but local reminder preferences remain valid until the next refresh
- StoreKit server notifications can revise local entitlement assumptions after relaunch or restore
- Internal launch-ops routes remain admin-guarded and support-safe; they must not expose raw HealthKit payloads or freeform note content

## Versioning notes
- The public API is versioned under `/v1`
- Additive fields are preferred over breaking response-shape changes
- Schema-breaking changes require a new contract version and explicit migration notes

## Examples
Supporting files live in `shared/contracts/api/examples/`.

## Acceptance criteria
- High-value v1 flows are covered by a canonical endpoint set
- Error semantics and idempotency are explicit
- Guest mode, Sign in with Apple, linking, and entitlements all have defined transport behavior
- No out-of-scope endpoints are introduced
- Verified-input ingestion, notification-plan reads, and StoreKit reconciliation paths are explicit enough for iOS, backend, and QA to share one contract
