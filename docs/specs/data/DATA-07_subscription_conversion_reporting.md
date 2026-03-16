# DATA-07 — Subscription Conversion Reporting

## Purpose
Define the reporting starter for paywall exposure, trial starts, purchases, restores, and downgrade outcomes in the first monetizable beta slice.

## Why it exists
The monetization bundle adds a real soft paywall and subscription continuity flow. Product and QA need a repo-native way to measure that funnel without inventing event semantics outside ST-04.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_paywall_trial_events.sql`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_subscription_lifecycle.sql`

## Output / canonical artifact
- Warehouse mart scaffolding for paywall/trial/purchase and subscription lifecycle reporting

## Acceptance criteria
- Paywall exposure, trial start, purchase start/completion/failure, restore, cancel, renew, and expire events map to warehouse starter SQL.
- The reporting layer does not redefine subscription tiers or billing states outside ST-07.

## Explicit non-goals
- vendor-specific BI dashboards
- revenue recognition or finance tooling
