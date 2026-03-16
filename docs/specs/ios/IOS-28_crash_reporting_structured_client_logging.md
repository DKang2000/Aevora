# IOS-28 — Crash Reporting + Structured Client Logging

## Purpose
Provide provider-agnostic crash reporting, structured client logging, and metadata redaction for the foundation iOS client.

## Why it exists
Foundation code needs diagnosable failures without turning logs or crash breadcrumbs into privacy leaks or vendor lock-in.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/specs/data/DATA-12_privacy_redaction_rules_for_analytics.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- crash reporting abstraction in `ios/Aevora/Core/Observability/CrashReporter.swift`
- log context model in `ios/Aevora/Core/Observability/LogContext.swift`
- metadata sanitizer in `ios/Aevora/Core/Observability/RedactionPolicy.swift`
- structured logger in `ios/Aevora/Core/Observability/StructuredLogger.swift`
- observability tests in `ios/AevoraTests/Observability/ObservabilityTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.

## Edge cases
- Sensitive identifiers and freeform note text must not survive log sanitization.
- Development crash reporting must remain swappable with a production adapter later.
- Correlation context should remain small and structured so it can line up with backend request IDs and sync IDs.

## Acceptance criteria
- A provider-agnostic crash reporter protocol exists.
- Structured logs pass through a redaction policy before storage.
- Development logging can capture sanitized entries for inspection.
- Tests prove redaction behavior.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- hard-wiring a specific vendor SDK
- logging raw payload bodies or sensitive freeform fields
- shipping verbose debug-only observability behavior to production by default
