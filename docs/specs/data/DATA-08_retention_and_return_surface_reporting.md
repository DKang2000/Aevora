# DATA-08 — Retention and Return-Surface Reporting

## Purpose
Define the starter reporting layer for widgets, Live Activities, reminder prompts, and notification re-entry during the starter arc.

## Why it exists
The glanceable return-surface bundle is only useful if Aevora can measure whether those surfaces pull users back into Today without degrading the free-path loop.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_return_surface_engagement.sql`

## Output / canonical artifact
- Return-surface warehouse mart scaffold under `backend/packages/analytics-schema/warehouse/sql/marts/`

## Acceptance criteria
- Widget, Live Activity, and notification engagement events are represented in a starter warehouse model.
- Premium-only surfaces remain segmentable by entitlement tier using the canonical event contract.

## Explicit non-goals
- long-horizon data science modeling
- notification vendor implementation details
