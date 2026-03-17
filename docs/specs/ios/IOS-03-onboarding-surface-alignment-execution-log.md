# IOS-03 / UX-03 / UX-07 / UX-08 — Onboarding Surface Alignment Execution Log

## Purpose

Record the implementation pass that brought the real onboarding flow materially closer to the locked first-playable sequence and the approved `ART-05` onboarding board pack.

## Why this exists

The app already had tokenized onboarding styling, reward presentation, and quest-journal support, but the actual onboarding flow was still compressed into too few surfaces. This pass closes that gap so the user now experiences the intended promise -> diagnosis -> identity -> starter-plan -> witness -> soft-paywall rhythm before landing in Today.

## Inputs / dependencies

- `AGENTS.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-05-onboarding-board-execution-log.md`
- `docs/specs/art/ART-03-token-bridge-phase2-execution-log.md`
- `ios/Aevora/DesignSystem/AevoraTokens.swift`
- `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/AevoraTests/CoreLoop/FirstPlayableStoreTests.swift`

## Output / canonical artifact

- Updated onboarding state and flow implementation:
  - `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
  - `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- Added onboarding flow coverage:
  - `ios/AevoraTests/CoreLoop/FirstPlayableStoreTests.swift`
- Execution log:
  - `docs/specs/ios/IOS-03-onboarding-surface-alignment-execution-log.md`

## Implemented screen sequence

The in-app onboarding sequence now clearly separates these surfaces:

1. welcome promise
2. problem / solution
3. sign in / continue as guest
4. goals
5. life areas
6. blocker
7. daily load
8. tone
9. family selection
10. identity selection
11. avatar basics
12. starter vow recommendations
13. quest preview
14. first magical moment / witness beat
15. soft paywall preview
16. land in Today

## Implementation notes

- Replaced the old compressed step progression with a dedicated onboarding flow enum inside `FirstPlayableStore`.
- Preserved the valid guest path and the Apple-native `SignInWithAppleButton`.
- Kept starter-plan behavior aligned with the existing local recommendation model rather than inventing a new onboarding planner.
- Added explicit quest-preview and magical-moment preview surfaces before the soft paywall.
- Kept the soft paywall informational, dismissible, and free-path safe by routing all exit paths into `finishOnboarding()`.
- Reused the existing `AevoraTokens` bridge and avoided introducing a second theme layer.

## Test coverage added

- Verified the onboarding sequence cannot move past sign-in until the user chooses Apple sign-in or guest mode.
- Verified the guest path reaches the soft paywall with starter recommendations generated.
- Verified finishing onboarding suppresses an immediate repeat soft paywall after the first reward flow.

## Validation commands

Project regeneration:

```bash
xcodegen generate --spec ios/project.yml
```

App tests:

```bash
xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Validation results

- Locked onboarding surface order is now materially reflected in-app: **passed by implementation review**
- Guest onboarding remains valid and reaches Today cleanly after soft paywall dismissal: **passed**
- World consequence is visible before any premium invitation through the magical-moment preview surface: **passed**
- Existing token bridge remained sufficient with no second palette system introduced: **passed**
- `xcodegen generate --spec ios/project.yml`: **passed**
- `xcodebuild test` completed successfully with 31 passing tests: **passed**

## Intentionally deferred debt

- This pass does not add final animation choreography across the onboarding sequence.
- The magical-moment step is a same-session witness preview, not a full bespoke world-scene transition.
- Reward modal and quest journal were not reopened because onboarding alignment was achievable without further behavior changes there.

## Explicit non-goals

- pricing or entitlement redesign
- new onboarding questions
- reopening token naming or art-system contracts
- turning onboarding into a world-navigation requirement
