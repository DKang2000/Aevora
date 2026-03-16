# OPS-05 — Monitoring and Alerting Stack

## Purpose
Define the operating posture and example alert templates for the backend and foundation services.

## Why it exists
BE-25 created observability hooks, but ops still needed a small set of clear alert classes and response guidance. This section maps signals to owners, severity, and starter investigation steps.

## Inputs / dependencies
- `docs/specs/backend/BE-25_backend_observability_and_alerts.md`
- `ops/monitoring/alerts.example.yaml`
- `ops/runbooks/alerts.md`

## Output / canonical artifact
- monitoring docs under `ops/monitoring/`
- runbook starter at `ops/runbooks/alerts.md`

## Severity model
- `page`: immediate service degradation or unreadiness
- `ticket`: sustained failures that should be addressed in working hours
- informational noise should stay out of paging and remain in logs or dashboards later

## Acceptance criteria
- Alert templates exist and parse.
- Owner and severity are defined for core backend signal families.
- A starter runbook exists for the highest-value alert classes.
- The config avoids real destinations or noisy alert sprawl.

## Explicit non-goals
- real pager wiring
- exhaustive SRE policy
- hundreds of low-signal alerts
