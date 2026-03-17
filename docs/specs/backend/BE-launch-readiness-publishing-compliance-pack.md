# BE Launch Readiness, Publishing, and Compliance Pack

## Purpose
Complete the minimal backend/operator surface required to publish launch config and content safely, inspect support-relevant player state, manage account export/delete requests, and prepare for later asset ingestion without broadening Aevora into a full admin product.

## Why it exists
The core loop, starter arc, monetization, glance surfaces, and verified-input flows are already present. The remaining launch risk is operational: changing runtime config or launch content safely, inspecting support issues without reading raw storage, and handling delete/export requests with clear continuity and redaction boundaries.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-06_content_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/backend/BE-13_content_config_delivery_service.md`
- `docs/specs/backend/BE-20_feature_flag_remote_config_service.md`
- `docs/specs/backend/BE-23_security_rate_limiting_audit_logging.md`
- `docs/specs/backend/BE-monetization-account-glance-pack.md`

## Scope
### BE-21 admin/content ops surface
- Guarded admin endpoints live inside the existing API rather than a separate SaaS console.
- Admin publish/promote flows cover:
  - remote-config candidate promotion
  - launch-content candidate promotion
  - asset-manifest promotion
  - support-safe account inspection
  - support-triggered export preparation
- All admin routes remain protected by the existing `x-aevora-role=admin` boundary and audit logging.

### BE-22 asset storage and CDN pipeline foundation
- Asset ingestion remains placeholder-safe in this bundle.
- The canonical artifact is an asset version manifest plus validation path, not a real CDN uploader.
- Asset manifests define release IDs, logical paths, content hashes, version tokens, and cache behavior so the later art bundle can publish against a stable contract.

### BE-24 account deletion and data export hardening
- `POST /v1/account/export` now returns a richer prepared-export summary with:
  - retention window
  - redaction profile
  - included sections
  - summary counts for vows, rewards, inventory, and recent completion state
- `DELETE /v1/account` now returns deletion timestamp and revoked-session counts.
- Admin support flows can inspect a user summary and prepare an export without direct datastore access.

## Output / canonical artifact
- backend implementation in `backend/apps/api/src/admin/`
- hardened account/runtime-config/content services in `backend/apps/api/src/`
- validation scripts in `backend/apps/api/scripts/`
- asset manifest contract at `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- placeholder manifest at `ops/assets/manifests/launch-assets.v1.json`

## Edge cases
- Promoted config/content/asset candidates must stay within the repo and validate before activation.
- Environment override paths still outrank promoted state for controlled local/operator overrides.
- Invalid promoted config falls back safely to bundled defaults.
- Invalid promoted content or asset manifests fail promotion rather than partially activating.
- Delete-account revokes active bearer/refresh/device/Apple-link sessions but does not invent a separate retention database in this bundle.
- Export remains support-safe and summary-oriented; it does not include freeform note text or raw HealthKit payloads.

## Acceptance criteria
- A guarded admin path exists for remote config, launch content, asset manifests, and support-safe account inspection.
- Runtime config and content publishing remain separate channels.
- Asset manifests are canonical, versioned, and placeholder-safe.
- Delete/export responses are explicit enough for iOS, support, QA, and ops docs to reference one lifecycle.
- Audit entries are recorded for user export/delete actions and admin publish/support actions.

## Explicit non-goals
- broad internal CMS scope
- live CDN upload credentials or infrastructure provisioning
- full legal retention automation
- receipt-verification expansion beyond the already-landed StoreKit notification handshake
