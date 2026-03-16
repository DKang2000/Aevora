# DATA-10 — Data Quality Checks and Event Validation

## Purpose
Add executable checks that catch analytics contract drift before it pollutes downstream reporting.

## Why it exists
The analytics package can validate individual events, but the repo also needs a repeatable quality gate for fixture datasets and CI. This section adds machine-readable quality rules and runnable validation scripts.

## Inputs / dependencies
- `docs/specs/data/DATA-03_analytics_event_schema_implementation.md`
- `shared/contracts/fixtures/launch/analytics_events_sample.json`
- `backend/packages/analytics-schema/quality/quality-rules.json`

## Output / canonical artifact
- quality rules in `backend/packages/analytics-schema/quality/`
- runnable validation scripts in `backend/apps/api/scripts/`

## Blocking vs warning posture
- Blocking: unknown events, missing actor identifiers, invalid timestamps, and missing required routing fields.
- Warning posture is captured in the quality rules file for backward-compatible normalization cases such as empty experiment assignments.

## Acceptance criteria
- Analytics fixture validation is executable locally and in CI.
- Blocking failures are explicit and machine-readable.
- The implementation does not create new event semantics beyond ST-04.
- Monetization and return-surface events used by the soft paywall, restore, downgrade, widget, Live Activity, and notification flows are covered by the same executable contract validation path.

## Explicit non-goals
- dashboards
- warehouse transforms
- vendor-specific data quality platforms
