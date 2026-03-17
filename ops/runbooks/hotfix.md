# Hotfix Runbook

## Purpose
Ship the smallest safe patch when a launch-blocking issue is discovered after beta candidate assembly.

## Sequence
1. Triage the issue and confirm it cannot be mitigated by publish rollback alone.
2. Create a focused patch on top of the current launch branch.
3. Re-run:
   - backend typecheck/tests
   - publishing validation scripts if config/content/assets are touched
   - iOS tests if app code changes
4. Regenerate the Xcode project if iOS sources change.
5. Follow the existing TestFlight workflow in `ops/release/testflight/README.md`.

## Guardrails
- Prefer config/content rollback before code hotfix when possible.
- Do not broaden product scope during a hotfix.
- Record every hotfix with the affected surface, rollback path, and remaining follow-up.
