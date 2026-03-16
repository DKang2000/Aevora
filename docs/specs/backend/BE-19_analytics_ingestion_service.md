# BE-19 — Analytics Ingestion Service

## Purpose
Expose the backend analytics ingestion boundary that validates, deduplicates, redacts, and records client analytics events.

## Why it exists
The repo now has executable analytics validation and privacy rules, but no ingestion surface. This section adds the first backend endpoint for analytics batches while keeping the persistence boundary intentionally lightweight and contract-driven.

## Inputs / dependencies
- `docs/specs/data/DATA-03_analytics_event_schema_implementation.md`
- `docs/specs/data/DATA-12_privacy_redaction_rules_for_analytics.md`
- `docs/specs/backend/BE-23_security_rate_limiting_audit_logging.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`

## Output / canonical artifact
- analytics module in `backend/apps/api/src/analytics/`
- e2e coverage in `backend/apps/api/test/analytics.e2e-spec.ts`

## Foundation posture
- Accept only ST-04-compatible event envelopes.
- Normalize older root-level event-specific fields into `properties` for safe ingestion.
- Deduplicate by a stable content hash over the canonical event identity fields.
- Persist redacted event payloads in-memory for foundation-level inspection until database-backed ingestion lands.

## Acceptance criteria
- Batch ingestion exists at the backend service layer.
- Duplicate events do not produce duplicate stored results.
- Malformed events are rejected and audited.
- Privacy and correlation assumptions remain aligned with DATA-12.

## Explicit non-goals
- dashboards or warehouse jobs
- provider SDK forwarding
- broad event transformation beyond safe normalization into `properties`
