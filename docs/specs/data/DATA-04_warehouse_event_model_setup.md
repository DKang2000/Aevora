# DATA-04 — Warehouse / Event Model Setup

## Purpose
Create the first transform-layer scaffold that downstream dashboards and analytics work can build on.

## Why it exists
Raw events alone are not enough for reporting. This section adds tool-neutral SQL staging and mart scaffolds so later data work starts from shared model boundaries instead of ad hoc queries.

## Inputs / dependencies
- `docs/specs/data/DATA-03_analytics_event_schema_implementation.md`
- `docs/specs/backend/BE-19_analytics_ingestion_service.md`
- `backend/packages/analytics-schema/warehouse/sql/`

## Output / canonical artifact
- warehouse scaffold under `backend/packages/analytics-schema/warehouse/`

## Model boundaries
- staging: raw event normalization and actor/date shaping
- marts: user-day activity, onboarding funnel, paywall/trial activity, and economy/reward views

## Acceptance criteria
- Tool-neutral SQL staging and mart layers exist.
- Naming and scope align with ST-04 and the foundation bundle.
- The scaffold is small but immediately usable by downstream data work.

## Explicit non-goals
- BI dashboards
- vendor lock-in to a warehouse product
- production orchestration of transforms
