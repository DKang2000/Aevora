# OPS-01 — Dev / Staging / Prod Environments

## Purpose
Define the environment boundaries, non-secret templates, and local bootstrap expectations for Aevora foundation work.

## Why it exists
The repo had canonical infra roots but no shared environment matrix. This section prevents backend, iOS, and ops work from baking production assumptions into local development or inventing incompatible environment shapes.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- environment matrix and templates under `ops/environments/`
- backend example env at `backend/apps/api/.env.example`
- local service bootstrap at `docker-compose.dev.yml`
- iOS config placeholder guidance at `ios/Config/README.md`

## Repo adaptation
- Pack implementation home `ops/` is adapted to the repo root `ops/` directory created for foundation ops artifacts.
- Pack path `services/api/.env.example` is adapted to `backend/apps/api/.env.example`.
- Pack path `apps/ios/Config/README.md` is adapted to `ios/Config/README.md`.

## Edge cases
- `dev` can use local Postgres and file-backed content/config so long as contract shapes stay aligned with ST-02 and ST-05.
- `staging` must remain synthetic or scrubbed; production-only secrets and customer data never belong in local templates.
- Environment switching must not become a source of behavioral drift for manual logging or entitlement rules.

## Acceptance criteria
- Dev, staging, and prod each have a documented purpose and parity rule.
- Non-secret templates exist for local and hosted configuration.
- Local bootstrap for foundation services is parseable.
- The implementation does not commit secrets or introduce ST-05 contradictions.

## Explicit non-goals
- hosted infrastructure provisioning
- deployment automation
- platform signing assets or credentials
