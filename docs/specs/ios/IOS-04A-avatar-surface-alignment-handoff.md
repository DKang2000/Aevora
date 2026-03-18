# Codex Execution Handoff — IOS-04A Avatar Surface Alignment

**Section ID:** `IOS-04`

## Source documents
- `AGENTS.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-06-avatar-base-system.md` (once added)
- `shared/tokens/aevora-v1-design-tokens.json`
- `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`

## Task brief
Close the next implementation gap after onboarding alignment by making avatars visibly present in the app without waiting on deep sprite production.

## Required outputs
- Updated `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- Updated `ios/Aevora/Features/Hearth/HearthRootView.swift`
- One shared avatar preview/presentation component in the iOS app layer
- `docs/specs/ios/IOS-04A-avatar-surface-alignment-execution-log.md`
- Targeted tests for the new avatar surface contract

## Implementation targets
### 1. Onboarding avatar step
Replace the current text-only silhouette/palette preview treatment with a lightweight visual avatar preview.

Minimum bar:
- keep name + optional pronouns
- keep the step to one screen
- add a real visual preview card
- add fast silhouette and palette selection controls
- accessory presentation can stay minimal
- do not create a long-form creator or nested editor

### 2. Hearth header
Bring the chosen avatar into Hearth so the surface reads as avatar + home/customization, not summary + inventory only.

Minimum bar:
- avatar preview in the upper Hearth region
- selected name and identity context visible
- keep inventory sections intact
- do not turn Hearth into a housing editor

### 3. Shared contract
Use the existing `OnboardingAvatarDraft` fields as the source of truth unless a migration note is unavoidable.

## Acceptance criteria
- Onboarding avatar setup remains fast and readable.
- Hearth now visibly includes the player avatar.
- No new token family is invented unless a real gap is documented.
- Tests fail if the avatar preview disappears from either onboarding or Hearth.
- `xcodegen generate` and `xcodebuild test` are rerun and logged.

## Explicit non-goals
- sprite animation
- world movement or NPC interaction systems
- equipment/inventory cosmetic logic
- backend schema changes
- paywall or onboarding sequence changes
- ART-07 / ART-08 asset expansion

## Required output format
Return a concise implementation summary with:
- commit SHA
- files changed
- whether any new tokens were required
- tests run
- any intentionally deferred debt
