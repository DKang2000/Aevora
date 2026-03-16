# BE Durable Starter Arc Pack

## Purpose
Harden the first-playable backend into a durable starter-arc service that preserves guest progress, day-by-day arc state, rewards, Chains, Embers, Rekindling, and minimal inventory outputs across relaunches.

## Why it exists
The first-playable slice proved day-one loop feel, but not retention. The starter arc needs durable server-side state so day-two through day-seven return flows survive app relaunches and replay safely through sync.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/backend/BE-first-playable-core-loop-pack.md`
- `docs/specs/game-systems/GS-first-playable-core-loop-pack.md`

## Sections
### BE-02 / BE-03
- Guest and Apple session flows remain on the existing `/v1/auth/*` shapes.
- Session issuance and guest-to-account continuity now persist to durable storage rather than process memory.

### BE-04 / BE-05
- Profile, avatar, and vow state stay on the first-playable transport shapes.
- Vow cap enforcement remains entitlement-driven and archive keeps history intact.

### BE-06 / BE-07 / BE-08
- Completion writes stay idempotent on `clientRequestId`.
- Reward, level, chain, ember, and rekindling outcomes remain server-authoritative.
- Rekindling preserves continuity inside the 72-hour window by consuming one Ember.

### BE-09 / BE-10 / minimal BE-11
- Starter-arc progression advances on unique completion days.
- District stage still maps `dim -> stirring -> rebuilding -> rekindled`.
- Minimal inventory snapshots expose day-one token and day-seven closure reward destinations.

## Output / canonical artifact
- Durable starter-arc implementation in `backend/apps/api/`
- Prisma schema additions for level, ember, chain, and inventory durability
- Durable starter-arc integration coverage in `backend/apps/api/test/core-loop.e2e-spec.ts`

## Edge cases
- Duplicate completion replay must return the same logical result.
- Day gaps cool momentum without deleting history.
- Account linking must not fork guest progress.
- Local development may use a durable file-backed runtime fallback when Postgres is unavailable; contract shapes stay unchanged.

## Explicit non-goals
- StoreKit or subscription verification
- Full shop depth
- Admin console expansion
