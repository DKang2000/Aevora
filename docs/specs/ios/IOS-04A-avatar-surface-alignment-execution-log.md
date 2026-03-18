# IOS-04A — Avatar Surface Alignment Execution Log

## Purpose

Record the focused implementation pass that turns the `ART-06` avatar base system into a live shared UI contract for onboarding and Hearth.

## Why this exists

The onboarding flow already follows the locked step order, but the avatar step still relied on text labels and Hearth still lacked visible player presence. This pass closes that product gap without broadening v1 into a deeper avatar or housing system.

## Inputs / dependencies

- `AGENTS.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-06-avatar-base-system.md`
- `docs/specs/ios/IOS-04A-avatar-surface-alignment-handoff.md`
- `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`
- `ios/Aevora/Shared/AvatarPreviewCard.swift`

## Output / canonical artifact

- Shared avatar presentation layer:
  - `ios/Aevora/Shared/AvatarPreviewCard.swift`
- Updated onboarding avatar step:
  - `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- Updated Hearth hero region:
  - `ios/Aevora/Features/Hearth/HearthRootView.swift`
- Store-backed helper contract:
  - `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- Targeted regression coverage:
  - `ios/AevoraTests/Onboarding/AvatarSurfaceContractTests.swift`
- Handoff and execution docs:
  - `docs/specs/ios/IOS-04A-avatar-surface-alignment-handoff.md`
  - `docs/specs/ios/IOS-04A-avatar-surface-alignment-execution-log.md`

## What changed

### Shared avatar contract

- Added `AvatarPreviewCard(configuration:style:)` with:
  - `AvatarPreviewConfiguration`
  - `AvatarPreviewStyle`
  - presentation-only silhouette, palette, and accessory catalog mapping existing launch IDs
- Kept `OnboardingAvatarDraft` unchanged.
- Did not introduce schema, entitlement, or onboarding-sequence changes.

### Onboarding

- Replaced the old text-only arrival preview with a real avatar preview card.
- Preserved `Name` and optional `Pronouns`.
- Added fast family-scoped silhouette controls using existing launch silhouette IDs.
- Added compact palette swatch controls using existing launch palette IDs.
- Kept accessory treatment minimal as a non-editing label chip.
- Kept the step on one screen and avoided nested editors or detours.

### Hearth

- Added a shared avatar hero card above inventory sections.
- Surfaced the chosen display name, identity context, and current Hearth summary.
- Preserved stored and applied inventory sections below the hero region.
- Kept the surface as avatar + home witness, not a housing editor.

### Tests

- Added targeted contract coverage for:
  - default seed ID resolution
  - family-scoped onboarding silhouette and palette options
  - Hearth hero configuration carrying avatar + identity context

## Validation

```bash
xcodegen generate --spec ios/project.yml
xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Validation results

- Project regenerated successfully after the new shared component was added: **passed**
- Full iOS unit suite completed successfully: **passed**
- Total passing tests after the avatar surface pass: **36**
- New avatar surface contract tests passed:
  - default seed IDs remain resolvable
  - onboarding avatar options remain family-scoped
  - Hearth hero configuration remains populated
- No onboarding step-order regression was introduced: **passed through existing onboarding tests**

## Token gaps or naming conflicts found

- No new token family was required.
- Existing `ART-03` colors, borders, surfaces, typography, and radii were sufficient.
- The shared avatar catalog is presentation-only and preserves existing launch IDs.

## Intentionally deferred debt

- The avatar preview remains a lightweight SwiftUI presentation layer rather than sprite production.
- Accessory editing is still intentionally minimal in v1.
- Hearth now includes avatar presence, but not housing-layout editing or cosmetic equipment logic.

## Explicit non-goals

- onboarding flow redesign
- paywall or entitlement changes
- backend contract changes
- sprite animation or world movement work
- ART-07 / ART-08 breadth expansion
