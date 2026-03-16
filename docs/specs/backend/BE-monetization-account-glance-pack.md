# BE Monetization, Account, and Glance Pack

## Purpose
Harden the first-playable backend into an entitlement-aware starter-arc service with durable account continuity and glance-surface snapshots.

## Why it exists
The durable starter arc solved relaunch continuity, but beta-readiness still required a real subscription state machine, restore/downgrade handling, account continuity surfaces, and a proven Prisma-backed runtime path for those flows.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/backend/BE-durable-starter-arc-pack.md`

## Sections
### BE-02 / BE-03 hardening
- Guest, Apple auth, and link-account flows continue to preserve a single starter-arc identity across relaunch and account linking.
- Prisma-backed runtime snapshots now prove that continuity against reachable Postgres, not only file-backed fallback storage.

### BE-14 / BE-15 / BE-16
- Subscription state is server-authoritative through `/v1/subscription/state`, `/trial`, `/purchase`, `/restore`, and `/downgrade`.
- Free tier keeps the 7-day starter arc and free vow cap; premium expands breadth and glance surfaces rather than replacing the loop.
- Restore continuity and downgrade outcomes preserve canonical entitlement state for later relaunch.

### BE-17 / minimal BE-24
- `/v1/glance/state` provides widget and Live Activity snapshots without creating a parallel state model.
- `/v1/account` and `/v1/account/export` expose minimum viable account continuity surfaces.
- `DELETE /v1/account` remains intentionally narrow: it clears current runtime state without inventing broader compliance workflows.

## Output / canonical artifact
- Backend implementation under `backend/apps/api/src/`
- OpenAPI expansion in `shared/contracts/api/aevora-v1.openapi.yaml`
- Postgres-backed e2e coverage in `backend/apps/api/test/core-loop.postgres.e2e-spec.ts`

## Edge cases
- Trial may only start once per user.
- Restore may no-op safely when no prior paid or trial tier exists.
- Downgrade preserves restore continuity while returning current entitlement breadth to free.

## Explicit non-goals
- full receipt verification backend
- commerce catalog expansion beyond locked v1 subscription tiers
- admin tooling
