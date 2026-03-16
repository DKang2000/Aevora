# BE-23 — Security, Rate Limiting, Audit Logging

## Purpose
Add the reusable security, audit, and request-protection foundations that later backend modules can share.

## Why it exists
The API skeleton needs guardrails before broader endpoint work lands. This section adds rate limiting for public-ish endpoints, secure headers, a minimal admin-role boundary, and an audit log service that later account and admin flows can reuse.

## Inputs / dependencies
- `docs/specs/backend/BE-01_backend_repo_service_skeleton.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- security helpers in `backend/apps/api/src/common/security/`
- audit module in `backend/apps/api/src/common/audit/`
- e2e coverage in `backend/apps/api/test/security.e2e-spec.ts`

## Foundation posture
- Request IDs remain the primary correlation key.
- Security headers are applied globally.
- Rate limiting is route-specific and intentionally conservative for analytics, content, and runtime config.
- Admin-only access is kept intentionally narrow and header-based until OPS-12 introduces the fuller access model.
- Audit persistence is currently in-memory foundation scaffolding with a clear upgrade path to database-backed storage.

## Acceptance criteria
- Public or semi-public endpoints can be rate limited.
- Audit entries can be recorded and inspected through a guarded admin path.
- Access failures and request protections are test-covered.
- The implementation stays small and does not invent a broad permission system.

## Explicit non-goals
- full RBAC implementation
- production WAF or CDN configuration
- durable audit persistence before later backend/data sections need it
