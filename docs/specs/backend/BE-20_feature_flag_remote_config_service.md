# BE-20 — Feature Flag / Remote Config Service

## Purpose
Serve typed runtime config and feature-flag payloads from one backend control plane.

## Why it exists
ST-05 locked the remote config structure, but the backend still needed a runtime-serving path. This section adds a file-backed foundation service that validates required sections, supports safe overrides, and returns versioned payload metadata for the client.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/backend/BE-23_security_rate_limiting_audit_logging.md`
- `shared/contracts/remote-config/defaults/launch-defaults.v1.json`

## Output / canonical artifact
- runtime config module in `backend/apps/api/src/runtime-config/`
- e2e coverage in `backend/apps/api/test/runtime-config.e2e-spec.ts`

## Foundation posture
- Bundled launch defaults remain the canonical fallback.
- Optional override files are allowed for non-production foundation use and must validate required top-level keys.
- Content payloads remain separate and do not flow through this channel.

## Acceptance criteria
- The service returns typed payloads and etags.
- Invalid overrides fall back to defaults instead of partially corrupting the response.
- The implementation stays provider-agnostic.
- Tests cover default and fallback behavior.

## Explicit non-goals
- admin UI
- narrative content delivery
- experiment assignment authoring UI
