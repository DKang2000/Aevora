# QA Launch Readiness and Compliance Pack

## Purpose
Capture the launch-specific QA matrix, performance/cold-start checks, submission copy, privacy/compliance answers, and support content required to move Aevora into a credible beta-candidate state.

## Why it exists
The feature bundles validated the core loop. Launch readiness adds the checks and content that App Store review, support, and operations need: device coverage, crash/recovery expectations, submission metadata, privacy/legal copy, age-rating notes, and support macros for common launch issues.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/ios/IOS-launch-readiness-account-hardening-pack.md`
- `docs/specs/backend/BE-launch-readiness-publishing-compliance-pack.md`
- `docs/specs/ops/OPS-launch-readiness-runbooks-pack.md`

## QA sections covered
### QA-12 performance benchmark suite
- benchmark focus:
  - cold launch to Today
  - cold launch into onboarding
  - Today quick-log interaction latency
  - World tab open latency
  - widget/live-activity snapshot refresh latency

### QA-14 device and screen-size matrix
- required launch matrix:
  - iPhone SE-size class
  - current standard iPhone
  - large Pro Max / Plus-size class
- portrait-only ergonomics remain the priority.

### QA-15 crash / recovery / cold-start suite
- validate relaunch after:
  - queued sync operations
  - notification open deep links
  - verified-input refresh attempt
  - local delete/reset action

### QA-17, QA-19, QA-20, QA-21, QA-22 documentation pack
- App Store metadata text pack
- privacy policy
- terms of service
- support-site structure
- App Privacy / nutrition-label answers
- age rating and content disclosure notes
- launch FAQ and support macros

## Output / canonical artifact
- docs under `docs/operations/`
- runbooks under `ops/runbooks/`

## Acceptance criteria
- Launch-critical QA scenarios are documented with explicit coverage goals.
- Submission/legal/support docs match the real shipped product behavior.
- External-proof gaps like signed TestFlight or App Store sandbox validation remain clearly called out when secrets are unavailable.

## Explicit non-goals
- final screenshot or preview asset generation
- post-launch CS tooling
- automated performance lab infrastructure
