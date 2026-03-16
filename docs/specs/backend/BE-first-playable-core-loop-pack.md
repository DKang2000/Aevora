# BE First Playable Core Loop Pack

## Purpose
Define the backend service surfaces needed for the first-playable free-path loop on top of the landed NestJS foundation and canonical contracts.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/backend/BE-01_backend_repo_service_skeleton.md`
- `docs/specs/backend/BE-13_content_config_delivery_service.md`
- `docs/specs/backend/BE-19_analytics_ingestion_service.md`
- `docs/specs/backend/BE-20_feature_flag_remote_config_service.md`
- `docs/specs/backend/BE-23_security_rate_limiting_audit_logging.md`
- `docs/specs/backend/BE-25_backend_observability_and_alerts.md`
- `docs/specs/data/DATA-01_canonical_relational_database_schema.md`
- `docs/specs/data/DATA-02_migration_plan_and_migration_scripts.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/game-systems/GS-first-playable-core-loop-pack.md`

## Sections
### BE-02 — Account/auth service
- Endpoints: guest session creation, Apple token exchange, restore session.
- Output: bearer access token, refresh token, and canonical user identity payload.

### BE-03 — Guest identity + account linking service
- Linking preserves guest-created vows, progression, and chapter state under the registered account identity.
- Duplicate-link prevention returns a clear conflict rather than silently splitting progress.

### BE-04 — Profile/avatar service
- Stores onboarding state, tone mode, selected identity shell, timezone, and avatar cosmetics.
- Returns profile, avatar, and subscription snapshot in one payload for local bootstrap.

### BE-05 — Vow service
- Supports vow list, create, update, and archive.
- Enforces entitlement-based active-vow cap.
- Keeps schedule and reminder metadata together with the vow.

### BE-06 — Completion ingestion service
- Accepts idempotent completion writes.
- Validates count/duration progress ranges and resolves duplicate `clientRequestId` safely.
- Returns completion event, reward grants, and reconciliation status in one response.

### BE-07 — Progression/reward calculation service
- Computes Resonance, Gold, level progression, first-vow-of-day bonus, and day-one magical-moment eligibility.
- Keeps reward authority server-side even if the client previews likely outcomes.

### BE-08 — Chain / ember / rekindling service
- Maintains chain continuity, cooling state, and the first-playable auto-rekindle rule within the 72-hour window when an Ember is available.

### BE-09 — Chapter / quest state service
- Uses starter-arc day progress derived from unique completion days.
- Exposes the current chapter snapshot and quest beat for Today and the journal.

### BE-10 — District state service
- Computes Ember Quay restoration stage from starter-arc state and first-session magical-moment milestones.
- Returns a world snapshot that World can render directly without inferring hidden booleans.

## Output / canonical artifact
- This pack
- New service modules under `backend/apps/api/src/`

## Edge cases
- Duplicate completion requests must return the same logical outcome.
- Offline replay through `/v1/sync/operations` must not double-grant rewards.
- Account linking cannot strand the guest state under a second user identity.

## Explicit non-goals
- subscription verification or StoreKit notifications
- notification orchestration
- admin console expansion
