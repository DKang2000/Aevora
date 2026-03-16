# BE-13 — Content / Config Delivery Service

## Purpose
Serve launch content payloads and manifest metadata through a backend bootstrap path.

## Why it exists
The repo already contains launch content, but the client needs a server-shaped path to retrieve that content without conflating it with runtime config. This section adds a file-backed content bootstrap module with manifest metadata and version checking.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-06_content_config_schema.md`
- `docs/specs/backend/BE-23_security_rate_limiting_audit_logging.md`
- `content/launch/launch-content.min.v1.json`
- `content/launch/copy/en/core.v1.json`

## Output / canonical artifact
- content module in `backend/apps/api/src/content/`
- e2e coverage in `backend/apps/api/test/content.e2e-spec.ts`

## Foundation posture
- Launch content is file-backed for the initial implementation.
- Manifest and bootstrap endpoints stay separate from remote config.
- Version mismatches fail clearly so the client can decide whether to refresh or fall back.

## Acceptance criteria
- The API can serve a manifest and bootstrap payload.
- Invalid content payloads fail fast.
- Version mismatch behavior is explicit and test-covered.
- The implementation does not drift into runtime feature-flag logic.

## Explicit non-goals
- admin UI for content authoring
- content moderation workflows
- runtime tuning through the content path
