# DATA-02 — Migration Plan and Migration Scripts

## Purpose
Turn the Prisma schema baseline into a forward-only migration workflow that CI and operators can run consistently.

## Why it exists
The schema now exists, but later environments and CI need a repeatable way to apply it. This section adds initial migration artifacts, package scripts, and a documented forward-only posture.

## Inputs / dependencies
- `docs/specs/data/DATA-01_canonical_relational_database_schema.md`
- `backend/apps/api/prisma/schema.prisma`
- `backend/apps/api/package.json`

## Output / canonical artifact
- migration commands in `backend/apps/api/package.json`
- initial migration SQL under `backend/apps/api/prisma/migrations/`

## Migration posture
- Migrations are forward-only.
- Rollback is operational and backup-driven, not destructive automation.
- CI validates schema and migration shape; hosted apply steps should remain environment-gated.

## Acceptance criteria
- The backend package exposes migration scripts.
- An initial migration artifact exists for the current schema.
- Prisma validation succeeds with a supplied `DATABASE_URL`.
- A clean database migrate path is documented even if it is not auto-applied in this repo yet.

## Explicit non-goals
- destructive rollback automation
- production auto-migration without approval
- hand-maintained migration divergence from the Prisma schema
