# Backend CI

This directory documents the backend validation and release pipeline foundations.

## Current gate
- install workspace dependencies
- generate Prisma client
- typecheck backend packages
- run backend and analytics tests
- validate Prisma schema
- apply Prisma migrations to a reachable Postgres service
- exercise the Prisma-backed runtime path with `test:postgres`
- validate analytics fixtures and demo datasets

## Local equivalent
- Start a reachable Postgres 16 instance. Repo-native options:
  - `docker-compose.dev.yml`
  - local Homebrew/Postgres with `DATABASE_URL=postgresql://<user>@localhost:5432/aevora_test?schema=public`
- Run:
  - `corepack pnpm install --frozen-lockfile`
  - `corepack pnpm --filter @aevora/api prisma:generate`
  - `corepack pnpm typecheck`
  - `corepack pnpm test`
  - `DATABASE_URL=... corepack pnpm --filter @aevora/api prisma:validate`
  - `DATABASE_URL=... corepack pnpm --filter @aevora/api migrate:deploy`
  - `DATABASE_URL=... corepack pnpm --filter @aevora/api test:postgres`
  - `corepack pnpm --filter @aevora/api validate:analytics`
  - `corepack pnpm --filter @aevora/api validate:datasets`

## CI service contract
- GitHub Actions provides a `postgres:16-alpine` service container for backend validation.
- The general workspace test pass stays on the file-backed path for speed and determinism.
- A dedicated Postgres-backed e2e step proves migrations plus runtime persistence before merge.

## Future extension
- staging deploy promotion
- migration apply step gated behind manual approval
- production rollout orchestration
