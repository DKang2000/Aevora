# BE-25 — Backend Observability and Alerts

## Purpose
Create the reusable logging, metrics, and alert-shape foundations for the backend service.

## Why it exists
The API can already boot, but it needs structured signals before more modules and operators depend on it. This section adds an observability boundary, admin-facing metrics snapshot, and alert templates that later ops work can extend.

## Inputs / dependencies
- `docs/specs/backend/BE-01_backend_repo_service_skeleton.md`
- `docs/specs/data/DATA-12_privacy_redaction_rules_for_analytics.md`
- `docs/specs/ops/OPS-05_monitoring_and_alerting_stack.md`

## Output / canonical artifact
- observability services in `backend/apps/api/src/observability/`
- admin metrics snapshot endpoint
- alert templates in `ops/monitoring/api-alerts.example.yaml`

## Foundation posture
- Logging is provider-agnostic and currently backed by Nest logger plus an in-memory snapshot store.
- Metrics are simple counters that can later map onto OpenTelemetry or another exporter.
- Alert-worthy signals focus on health, analytics rejection rate, config delivery, and CI failure rather than a long noisy list.

## Acceptance criteria
- Observability services bootstrap with the backend app.
- Admins can inspect a metrics/log snapshot path.
- Alert templates exist and parse.
- No vendor secrets or provider lock-in are introduced.

## Explicit non-goals
- production pager wiring
- trace storage vendor choice
- exhaustive SLO/SLA policy authoring
