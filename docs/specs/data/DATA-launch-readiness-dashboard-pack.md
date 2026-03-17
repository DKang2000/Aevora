# DATA Launch Readiness Dashboard Pack

## Purpose
Provide the minimum reporting layer needed to operate Aevora’s beta and launch candidate: north-star activation, onboarding conversion, monetization conversion, retention cohorts, economy health, and support-safe lookup queries.

## Why it exists
The event taxonomy, privacy rules, and starter warehouse scaffold already exist. Launch readiness needs the next layer up: stable marts and lookup queries that answer whether users activate, convert, retain, and progress through the economy without requiring ad hoc SQL every time a question or support incident appears.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/data/DATA-03_analytics_event_schema_implementation.md`
- `docs/specs/data/DATA-04_warehouse_event_model_setup.md`
- `docs/specs/data/DATA-07_subscription_conversion_reporting.md`
- `docs/specs/data/DATA-08_retention_and_return_surface_reporting.md`
- `docs/specs/data/DATA-10_data_quality_checks_and_event_validation.md`
- `backend/packages/analytics-schema/warehouse/sql/`

## Output / canonical artifact
- marts under `backend/packages/analytics-schema/warehouse/sql/marts/`
- support lookup queries under `backend/packages/analytics-schema/warehouse/sql/support/`

## Dashboard groups
### DATA-05 north-star and KPI suite
- canonical north-star proxy for launch is activated users: distinct actors with a first-vow completion day.
- supporting daily KPI mart:
  - `mart_activation_kpis.sql`
- launch operators should read this alongside active users, onboarding completion, first magical moment, paywall exposure, and monetized-user counts.

### DATA-06 onboarding funnel dashboard
- daily funnel counts come from:
  - `mart_onboarding_conversion_daily.sql`
- required launch stages:
  - onboarding started
  - origin family selected
  - identity selected
  - starter vows accepted
  - onboarding completed
  - first magical moment viewed

### DATA-07 paywall / trial / subscription dashboard
- daily conversion and continuity metrics come from:
  - `mart_subscription_conversion_daily.sql`
  - `mart_subscription_lifecycle.sql`
- required launch questions:
  - how many users saw the paywall
  - how many started trial
  - how many completed purchase
  - how many restored successfully
  - how many canceled or expired

### DATA-08 retention / cohort dashboard
- cohort scaffolding comes from:
  - `mart_retention_cohorts.sql`
  - `mart_return_surface_engagement.sql`
- required launch cuts:
  - cohort date
  - activity date
  - D1, D3, and D7 retained users
  - return-surface engagement correlations

### DATA-09 economy health dashboard
- economy safety checks come from:
  - `mart_economy_health_daily.sql`
  - `mart_economy_reward_events.sql`
- launch watch metrics:
  - resonance award volume
  - gold award volume
  - item award volume
  - reward chest opens
  - shop purchases
  - district progression counts

### DATA-13 support/admin reporting queries
- support-safe query pack:
  - `support_account_lookup.sql`
  - `support_subscription_lookup.sql`
  - `support_reward_audit.sql`
  - `support_return_surface_lookup.sql`
- these queries are for account, entitlement, reward, and return-surface debugging only; they are not a second admin product.

## Metric and privacy rules
- actor grain stays pseudonymous and follows the existing analytics redaction rules.
- none of the launch marts introduce freeform note text or raw HealthKit payloads.
- SQL names are derived from ST-04 event names; no speculative event families are introduced here.

## Acceptance criteria
- launch operators can answer activation, onboarding, monetization, retention, and economy questions from repo-tracked SQL.
- support can run lookup queries without reaching for raw storage first.
- the dashboard layer remains tool-neutral and warehouse-vendor-neutral.
- no speculative growth dashboards or post-launch experimentation surfaces are introduced.

## Explicit non-goals
- BI product-specific YAML or dashboard exports
- production scheduler/orchestrator setup
- experiment assignment framework expansion beyond existing event metadata
