# OPS Launch Readiness Runbooks Pack

## Purpose
Provide the minimal runbooks and recovery playbooks required to operate Aevora safely during beta and launch-candidate periods.

## Why it exists
Monitoring, CI, and TestFlight scaffolding already exist. Launch readiness needs the operator-facing response layer: backup/restore steps, incident handling, hotfix routing, and the explicit handoff between publishing workflows and support/compliance actions.

## Inputs / dependencies
- `docs/specs/ops/OPS-launch-readiness-publishing-compliance-pack.md`
- `docs/specs/ops/OPS-05_monitoring_and_alerting_stack.md`
- `docs/specs/ops/OPS-10_testflight_distribution_workflow.md`
- `ops/publishing/README.md`

## Output / canonical artifact
- `ops/runbooks/backup-restore.md`
- `ops/runbooks/incident-response.md`
- `ops/runbooks/hotfix.md`

## Runbook coverage
- backup and restore for file-backed and Prisma-backed runtime authority
- publishing rollback pointers for config/content/assets
- incident triage steps for:
  - restore purchase failures
  - config/content promotion mistakes
  - notification or shortcut regressions
  - account export/delete issues
- hotfix release sequencing through the existing CI/TestFlight path

## Acceptance criteria
- Operators have a starter playbook for restore, rollback, incident triage, and hotfix release.
- Runbooks point to real repo commands and docs rather than hand-waving external process.
- Environment-limited gaps are identified instead of hidden.

## Explicit non-goals
- full on-call staffing process
- enterprise incident tooling integration
- signed TestFlight proof when Apple credentials are absent
