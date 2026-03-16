# BE-01 — Backend Repo / Service Skeleton

## Purpose
Create the executable backend service spine, workspace conventions, and provider-agnostic runtime configuration layer for Aevora foundation work.

## Why it exists
The repo had canonical backend roots but no executable service bootstrap. This section turns `backend/apps/api/` into the shared backend home so later API, config, analytics, and observability sections build on one stable service.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-06_content_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`
- `docs/specs/source-of-truth/ST-11_seed_data_fixture_pack.md`
- `docs/specs/source-of-truth/ST-12_acceptance_criteria_matrix.md`

## Output / canonical artifact
- Workspace manager rooted at the repo root with `pnpm-workspace.yaml` and `tsconfig.base.json`
- NestJS API scaffold at `backend/apps/api/`
- provider-agnostic config parsing in `backend/apps/api/src/common/config/`
- request correlation middleware in `backend/apps/api/src/common/http/request-id.middleware.ts`
- health and readiness endpoints in `backend/apps/api/src/health/`

## Repo adaptation
- Pack path `services/api` is adapted to `backend/apps/api`.
- Pack path `packages/contracts` stays canonical at `shared/contracts`; backend-only executable packages live under `backend/packages/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/04_Game_Economy_Spec.md` -> `docs/product/04_Game_Economy_Spec.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.
- Required read substitution: `docs/product/foundation/07_Analytics_Event_Taxonomy.md` -> `docs/product/07_Analytics_Event_Taxonomy.md`.

## Edge cases
- Missing hosted runtime values should fail fast through env validation rather than booting with partial config.
- Request IDs should be generated when upstream infrastructure does not supply one.
- Health/readiness surfaces must remain provider-agnostic and avoid exposing secrets.

## Acceptance criteria
- A single repo-wide JS/TS workspace manager exists.
- `backend/apps/api/` can become the canonical backend service root without introducing a second structure.
- API config, health checks, and request correlation exist as executable scaffolding.
- The implementation does not define business-specific services beyond foundation needs.

## Explicit non-goals
- business-domain handlers beyond health/readiness
- analytics ingestion, content delivery, or feature-flag evaluation logic
- production deployment workflows
