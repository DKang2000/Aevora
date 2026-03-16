# Alert Runbook Starter

## API health degraded
1. Check `/v1/health` and `/v1/health/ready`.
2. Inspect recent structured logs and metrics.
3. Confirm recent deploy or migration activity.

## Analytics ingestion failures
1. Inspect `/v1/analytics/events` rejection counts and recent audit entries.
2. Re-run fixture validation with `corepack pnpm --filter @aevora/api validate:analytics`.
3. Confirm no schema drift in `shared/contracts/events/`.

## Remote config or content delivery failures
1. Confirm default JSON payloads still parse.
2. Inspect override path or environment-specific configuration.
3. Verify file-backed payload versions and cache metadata.

## CI failures
1. Check workflow logs for dependency, typecheck, test, or Prisma validation failures.
2. Reproduce locally using the commands from `ops/ci/backend/README.md`.
