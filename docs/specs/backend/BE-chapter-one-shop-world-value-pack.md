# BE Chapter One Shop World Value Pack

## Purpose
Extend the snapshot-oriented core-loop backend so Chapter One, district restoration, inventory, shop purchase, and reward audit behavior are durable and server-authoritative where it matters.

## Why it exists
The prior bundles proved starter-arc continuity and monetization authority. This bundle turns that foundation into an ongoing loop with meaningful spend, auditable rewards, and a coherent post-Day-7 world state.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `shared/contracts/api/aevora-v1.openapi.yaml`

## Sections
### BE-11 — Inventory service hardening
- Inventory items now carry `status`, `slot`, and durable `earnedFrom`.
- Completion milestones and shop purchases both land in inventory through one canonical path.

### BE-12 — Shop service
- `GET /v1/shop/offers` returns computed affordability, ownership, lock state, and remaining stock.
- `POST /v1/shop/offers/{offerId}/purchase` deducts Gold, records purchase history, and grants inventory.

### BE-09 / BE-10 hardening
- Chapter state can move from starter arc into Chapter One with free preview versus premium full access.
- District state extends past `rekindled` into readable launch-safe phases.

### Durable persistence and auditability
- Runtime snapshot now stores Gold balance, reward ledger entries, and shop purchase history.
- No Prisma schema change is required because the existing runtime-authority snapshot already stores JSON payload state.

## Output / canonical artifact
- This backend pack
- Updated backend implementation under `backend/apps/api/src/`
- Updated OpenAPI contract and backend e2e coverage

## Edge cases
- Non-repeatable shop items cannot be bought twice.
- Free users can enter Chapter One preview but cannot progress beyond the preview cap without premium breadth.
- Purchased or earned items survive relaunch and restore-session flows.

## Explicit non-goals
- admin console work
- receipt-verification expansion
- notification orchestration
