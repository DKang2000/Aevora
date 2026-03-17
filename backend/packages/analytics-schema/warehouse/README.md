# Warehouse Model Scaffold

This folder contains tool-neutral SQL scaffolding for Aevora analytics transforms.

## Layers
- `sql/staging/`: lightly cleaned views over raw event storage
- `sql/marts/`: user-facing KPI models for funnels, economy, and daily activity
- `sql/support/`: support-safe lookup queries for account, monetization, reward, and return-surface debugging

## Current monetization and return-surface marts
- `mart_paywall_trial_events.sql`: paywall exposure and immediate conversion counts
- `mart_subscription_lifecycle.sql`: restore, downgrade, renewal, and expiration continuity
- `mart_return_surface_engagement.sql`: widget, Live Activity, and notification pullback signals

## Launch-readiness dashboard marts
- `mart_activation_kpis.sql`: north-star starter activation and monetization coverage
- `mart_onboarding_conversion_daily.sql`: onboarding funnel counts by local date
- `mart_subscription_conversion_daily.sql`: paywall, trial, purchase, restore, cancel, and expire counts by local date
- `mart_retention_cohorts.sql`: cohort-date versus activity-date retention scaffold
- `mart_economy_health_daily.sql`: reward, shop, and progression-event health counts

## Support lookup queries
- `support_account_lookup.sql`
- `support_subscription_lookup.sql`
- `support_reward_audit.sql`
- `support_return_surface_lookup.sql`

## Guardrail
The SQL here is an implementation starter, not a second source of truth. Event names and field semantics continue to come from ST-04 and the shared contracts.
