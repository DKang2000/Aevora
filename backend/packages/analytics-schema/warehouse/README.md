# Warehouse Model Scaffold

This folder contains tool-neutral SQL scaffolding for Aevora analytics transforms.

## Layers
- `sql/staging/`: lightly cleaned views over raw event storage
- `sql/marts/`: user-facing KPI models for funnels, economy, and daily activity

## Current monetization and return-surface marts
- `mart_paywall_trial_events.sql`: paywall exposure and immediate conversion counts
- `mart_subscription_lifecycle.sql`: restore, downgrade, renewal, and expiration continuity
- `mart_return_surface_engagement.sql`: widget, Live Activity, and notification pullback signals

## Guardrail
The SQL here is an implementation starter, not a second source of truth. Event names and field semantics continue to come from ST-04 and the shared contracts.
