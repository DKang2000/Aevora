# OPS-03 — Backend CI/CD Pipeline

## Purpose
Define and implement the first backend validation pipeline for schema, contracts, tests, and migration readiness.

## Why it exists
The repo had only a placeholder workflow. This section adds a backend-specific CI path that validates the new workspace, Prisma schema, analytics package, and demo dataset checks before later deployment work lands.

## Inputs / dependencies
- `docs/specs/backend/BE-01_backend_repo_service_skeleton.md`
- `docs/specs/data/DATA-02_migration_plan_and_migration_scripts.md`
- `docs/specs/data/DATA-10_data_quality_checks_and_event_validation.md`
- `docs/specs/data/DATA-14_test_and_demo_datasets.md`

## Output / canonical artifact
- GitHub Actions workflow at `.github/workflows/backend-ci.yml`
- pipeline notes in `ops/ci/backend/README.md`

## Release gates
- install dependencies
- typecheck workspaces
- run tests
- validate Prisma schema
- validate analytics fixtures
- validate demo datasets

## Acceptance criteria
- Backend CI has a concrete workflow file.
- The workflow keeps environment-specific secrets external.
- Migration validation is included without destructive auto-apply behavior.
- Local equivalents of CI checks are documented.

## Explicit non-goals
- production deployment automation
- destructive auto-migration in prod
- pager or release approval policy authoring
