# BE Verified Inputs, Notifications, and Automation Pack

## Purpose
Extend the contract-driven backend slice so verified-input ingestion, notification planning, and entitlement reconciliation have canonical routes and deterministic outcomes.

## Why it exists
The prior bundles proved local-first progression and starter monetization flows. This pack hardens the backend authority layer so reminder plans, verified completions, and StoreKit-driven entitlement changes can all resolve without ambiguous launch behavior.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `shared/contracts/api/aevora-v1.openapi.yaml`

## Sections
### BE-17 — Notification orchestration service
- `GET /v1/notifications/plan` returns the launch-safe reminder/witness plan for the current user.
- The backend plan is intentionally sparse: vow reminders, witness prompt, streak-risk prompt, and chapter-ready prompt.
- Notification planning respects stored reminder preferences and current chapter/chain state without creating a second reminder model.

### BE-18 — Verified-source ingestion contract
- `POST /v1/verified-inputs/completions` ingests narrow HealthKit-backed completions for `workout`, `steps`, and `sleep`.
- Verified ingestion requires premium breadth and a vow/domain match allowed by the launch-safe mapping.
- Source events are deduplicated by `sourceEventId`; duplicate requests return the original completion result instead of issuing new rewards.

### BE-16 — StoreKit notification and entitlement hardening
- `POST /v1/subscription/refresh` lets the client reconcile server-authoritative entitlement state from a verified transaction summary.
- `POST /v1/subscription/storekit/notifications` applies deterministic StoreKit server notification outcomes for renew, recovery, billing retry, and expiry.
- Entitlement refresh updates chapter and district access immediately so free-preview versus premium-full state stays coherent across relaunches.

### Minimal runtime model hardening
- Runtime snapshots now persist notification preferences, source-connection state, and verified-completion ledgers alongside the existing snapshot-oriented player state.
- `sync/operations` accepts `verified_completion` so the local-first client queue can replay verified completions through the same contract surface.

## Output / canonical artifact
- This backend pack
- Updated backend implementation under `backend/apps/api/src/`
- Updated OpenAPI contract plus e2e coverage in `backend/apps/api/test/`

## Edge cases
- Free users cannot ingest verified completions even if a local client tries to queue them.
- Duplicate verified source events must not duplicate Gold, Resonance, or ledger writes.
- Expiry notifications must cool premium breadth without deleting previously earned progression.

## Explicit non-goals
- full App Store receipt-verification depth
- cross-platform push infrastructure
- generalized external data import connectors
