# Analytics Schema Package

This package provides executable validation and privacy helpers for Aevora analytics.

## Canonical references
- `docs/specs/data/DATA-03_analytics_event_schema_implementation.md`
- `docs/specs/data/DATA-12_privacy_redaction_rules_for_analytics.md`
- `shared/contracts/events/`
- `shared/contracts/fixtures/launch/analytics_events_sample.json`

## Repo adaptation
The foundation pack assumed `packages/analytics-schema`. This repo uses `backend/packages/analytics-schema` for executable code and keeps the canonical machine-readable contracts under `shared/contracts/events/`.
