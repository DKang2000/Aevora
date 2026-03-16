# DATA-01 — Canonical Relational Database Schema

## Purpose
Map the locked v1 domain model into an executable Postgres schema for backend foundation work.

## Why it exists
The source-of-truth layer defined the nouns and authority boundaries, but the repo had no executable relational schema. This section creates the durable backbone for users, vows, progression-adjacent snapshots, analytics raw events, and runtime config history.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/backend/BE-01_backend_repo_service_skeleton.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- Prisma schema at `backend/apps/api/prisma/schema.prisma`
- relational design notes in `backend/apps/api/prisma/README.md`

## Key design choices
- Stable string identifiers are preserved from ST-01 instead of database-generated integer IDs.
- Auth and session tables are separated from the `User` record to support guest-to-account continuity.
- Authored content remains outside the relational schema and continues to live in `content/` and `shared/contracts/`.
- Historical retention is explicit for completions, reward grants, sync operations, analytics raw events, and audit logs.
- Soft-delete is limited to user-edited breadth where history matters, starting with `Vow.deletedAt`.

## Edge cases
- Guest-to-account linking preserves the same canonical `User` row while adding provider links and sessions.
- Entitlement downgrade preserves historical state because `SubscriptionState` is append-only by refresh time instead of destructive overwrite.
- Offline completion replay is supported through unique `clientRequestId` values on completion and sync operation tables.

## Acceptance criteria
- The schema covers the locked backend foundation entities called for by the bundle.
- Primary keys, foreign keys, and uniqueness constraints match the ST authority boundaries.
- Shared content/config contracts are referenced rather than duplicated into relational tables.
- The schema validates with Prisma tooling.

## Explicit non-goals
- warehouse marts and dashboard models
- out-of-scope social or multiplayer tables
- production migration history beyond the initial schema baseline
