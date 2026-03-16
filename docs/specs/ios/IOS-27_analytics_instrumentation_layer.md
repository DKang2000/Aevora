# IOS-27 — Analytics Instrumentation Layer

## Purpose
Create the typed client analytics boundary that validates events before they enter the sync queue.

## Why it exists
Product, content, and economy decisions depend on trustworthy analytics. The client must reject unknown events locally instead of letting ad hoc strings leak downstream.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-08_networking_client_sync_queue.md`
- `docs/specs/data/DATA-03_analytics_event_schema_implementation.md`
- `docs/specs/data/DATA-12_privacy_redaction_rules_for_analytics.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-12_acceptance_criteria_matrix.md`

## Output / canonical artifact
- typed event names in `ios/Aevora/Core/Analytics/AnalyticsEvent.swift`
- shared envelope model in `ios/Aevora/Core/Analytics/AnalyticsEnvelope.swift`
- metadata construction in `ios/Aevora/Core/Analytics/AnalyticsMetadataProvider.swift`
- validator in `ios/Aevora/Core/Analytics/AnalyticsValidator.swift`
- queue-backed client in `ios/Aevora/Core/Analytics/AnalyticsClient.swift`
- validation tests in `ios/AevoraTests/Analytics/AnalyticsTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.

## Edge cases
- Unknown event names must be rejected before queueing.
- Event properties must remain lightweight and string-serializable for the current foundation contract.
- Analytics queueing must share the same replay substrate as other sync operations instead of building a second upload path.

## Acceptance criteria
- Analytics events are modeled through typed names.
- Envelope validation enforces the locked catalog before upload.
- The analytics client queues validated events through the sync queue.
- Tests prove unknown events fail locally.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- full instrumentation of every user journey
- raw string event emission outside the typed boundary
- bypassing `DATA-12` redaction rules
