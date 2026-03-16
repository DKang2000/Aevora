# Backend

This folder is for server implementation only.

## Intended structure
- `apps/`: deployable services such as `api/`, `worker/`, and `admin/`
- `packages/`: shared backend domain, analytics, auth, and content-engine modules
- `migrations/`: database migration history
- `tests/`: backend integration and service-level tests

## Primary upstream sources
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
- `shared/contracts/`
- `docs/product/Aevora_V1_Master_Build_Register.md`

## Guardrail
Do not define product truth here when it belongs in `docs/product/` or `shared/contracts/`.
