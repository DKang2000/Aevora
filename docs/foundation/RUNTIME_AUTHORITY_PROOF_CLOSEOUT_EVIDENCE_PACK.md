# Runtime Authority Proof Closeout Evidence Pack

Date: 2026-03-16
Scope: Prisma/Postgres runtime authority proof patch for the durable starter-arc and monetization foundation

## `<RUNTIME_AUTHORITY_PROOF> complete`

Canonical artifact:
- `docs/specs/data/DATA-02_migration_plan_and_migration_scripts.md`
- `docs/specs/ops/OPS-01_dev_staging_prod_environments.md`
- `docs/specs/ops/OPS-03_backend_ci_cd_pipeline.md`
- `.github/workflows/backend-ci.yml`

Supporting files created/updated:
- `backend/apps/api/test/core-loop.postgres.e2e-spec.ts`
- `backend/apps/api/package.json`
- `backend/apps/api/src/common/database/`
- `ops/ci/backend/README.md`

Validation run:
- `PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH" createdb aevora_test` — pass
- `DATABASE_URL='postgresql://donghokang@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api prisma:validate` — pass
- `DATABASE_URL='postgresql://donghokang@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api migrate:deploy` — pass
- `DATABASE_URL='postgresql://donghokang@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api test:postgres` — pass

Key decisions:
- Keep the general backend test pass on the file-backed path for deterministic local/CI speed.
- Add a narrow dedicated Postgres-backed e2e step to prove migrations plus runtime persistence before merge.
- Reuse the existing runtime snapshot model rather than redesigning persistence mid-bundle.

Conflicts or assumptions:
- Local proof in this environment used Homebrew Postgres 16 because Docker was unavailable.
- This patch proves runtime authority for the current contract-driven snapshot architecture, not a fully normalized gameplay persistence redesign.

Downstream sections unblocked:
- BE-14 / BE-15 / BE-16
- QA-05 / QA-06
- OPS-03 backend merge gating for monetization continuity

Anything still missing:
- Hosted staging proof remains a later operational concern.
- Real receipt verification is still outside this pre-art-stage bundle.
