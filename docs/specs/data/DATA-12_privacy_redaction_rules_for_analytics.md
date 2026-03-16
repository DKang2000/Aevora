# DATA-12 — Privacy / Redaction Rules for Analytics

## Purpose
Define the machine-readable privacy classification and executable redaction rules used by analytics and observability foundations.

## Why it exists
The bundle needs analytics and logs to be useful without capturing free-text notes, raw HealthKit payloads, or casually exposed identifiers. This section creates a reusable ruleset that later iOS and backend observability sections can consume.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`

## Output / canonical artifact
- classification file at `backend/packages/analytics-schema/privacy/analytics-data-classification.v1.yaml`
- executable redaction helper at `backend/packages/analytics-schema/privacy/redaction-rules.ts`
- raw and redacted examples at `backend/packages/analytics-schema/privacy/examples/`

## Interaction rules
- Identifiers used for correlation are pseudonymous and hashed before export.
- Prohibited free-text or sensitive-source payloads are dropped, not masked in place.
- The policy applies to analytics events first and is designed to be reused by iOS and backend observability layers later.

## Edge cases
- Manual logging remains valid while note text stays out of analytics payloads.
- HealthKit-related analytics can record permission/result states without retaining raw HealthKit payload bodies.
- Missing optional identifiers should not cause redaction failure for otherwise valid envelopes.

## Acceptance criteria
- The classification file is machine-readable.
- A shared redaction helper exists and is test-covered.
- Example payloads demonstrate both raw and redacted forms.
- The implementation stays within ST-04, ST-08, and ST-10 privacy boundaries.

## Explicit non-goals
- full legal/privacy-policy copy
- data retention automation
- vendor-specific observability integrations
