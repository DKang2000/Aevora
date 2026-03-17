# IOS-03A — Onboarding Root View Alignment Hotfix Log

## Purpose

Record the follow-up hotfix pass that verified the public onboarding root view against the canonical store contract and added regression coverage for the completion path.

## Why this exists

The original `IOS-03` alignment work moved the live onboarding flow onto the locked multi-step sequence, but the repo still lacked a view-level contract test that would fail if the root view ever regressed back to an early finish path before the soft paywall.

## Inputs / dependencies

- `AGENTS.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-05-selection-board-refinement-addendum.md`
- `docs/specs/ios/IOS-03-onboarding-surface-alignment-execution-log.md`
- `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`

## Output / canonical artifact

- Updated root-view footer contract:
  - `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- Added root-view regression coverage:
  - `ios/AevoraTests/Onboarding/OnboardingRootViewTests.swift`
- Execution log:
  - `docs/specs/ios/IOS-03A-onboarding-root-view-alignment-hotfix-log.md`

## Hotfix scope

- Confirmed `OnboardingRootView` already drives presentation from `store.currentOnboardingFlowStep`.
- Confirmed progress header already uses `store.onboardingProgressValue` and `store.onboardingProgressTotal`.
- Added a small testable footer-configuration helper so the completion path is derived from canonical step semantics instead of being left implicit in the SwiftUI body.
- Added unit coverage proving:
  - only `softPaywall` owns inline completion actions
  - `signIn` remains a back-only footer state
  - late onboarding surfaces keep their dedicated advance labels

## Validation commands

```bash
xcodegen generate --spec ios/project.yml
xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Validation results

- `OnboardingRootView` remains aligned to `OnboardingFlowStep` and no longer relies on implicit footer semantics alone: **passed by implementation review**
- New root-view unit coverage fails if inline completion actions move earlier than `softPaywall`: **passed**
- `xcodegen generate --spec ios/project.yml`: **passed**
- `xcodebuild test` completed successfully with 33 passing tests: **passed**

## Intentionally deferred debt

- This hotfix does not add a full UI test framework or snapshot suite.
- Family and identity visual language remains implemented through the current tokenized SwiftUI cards rather than a bespoke production-art onboarding renderer.
- The magical-moment step remains a still-preview witness surface, not a cinematic transition.

## Explicit non-goals

- pricing or entitlement changes
- token renaming
- onboarding flow redesign
- ART-05 board regeneration
