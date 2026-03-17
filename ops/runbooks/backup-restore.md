# Backup and Restore Runbook

## Scope
Starter launch runbook for file-backed runtime snapshots, Prisma-backed runtime persistence, publishing rollback artifacts, and support-safe account recovery context.

## Backup Targets
- Prisma/Postgres database when `CORE_LOOP_PERSISTENCE=prisma`
- file-backed runtime snapshot store when `CORE_LOOP_PERSISTENCE=file`
- promoted remote-config/content/asset release state files
- release manifests and publish notes under `ops/`

## Restore Sequence
1. Identify whether the affected environment is file-backed or Prisma-backed.
2. Freeze new publish/promote actions until state health is confirmed.
3. Restore the latest verified database or runtime snapshot backup.
4. Re-apply the intended promoted config/content/asset release if needed.
5. Validate:
   - health endpoint
   - remote-config source
   - content manifest source
   - support-safe account lookup for one known fixture account

## Notes
- File-backed runtime proof is acceptable for local and non-prod launch readiness.
- Production backup automation remains environment-owned, not repo-owned, in this bundle.
