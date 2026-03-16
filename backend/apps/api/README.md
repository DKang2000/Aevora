# Aevora API

This folder is the executable backend service root for Aevora foundation work.

## Why this exists
It provides the shared service skeleton, health surface, environment validation, request correlation, and data-layer anchor that later backend sections build on.

## Canonical references
- `docs/specs/backend/BE-01_backend_repo_service_skeleton.md`
- `docs/specs/data/DATA-01_canonical_relational_database_schema.md`
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`

## Local usage
1. Install workspace dependencies from the repo root with `pnpm install`.
2. Copy `backend/apps/api/.env.example` to a local `.env` file outside version control.
3. Run `pnpm --filter @aevora/api start:dev`.
4. Validate the schema with `pnpm --filter @aevora/api prisma:validate`.
5. Run tests with `pnpm --filter @aevora/api test:e2e`.

## Repo adaptation
The foundation pack assumed `services/api`; this repo uses `backend/apps/api` as the canonical backend service root.
