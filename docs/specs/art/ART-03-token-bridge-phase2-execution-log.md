# ART-03 — Token Bridge Phase 2 Execution Log

## Purpose

Record the second implementation pass that extended the canonical `ART-03` token bridge beyond Today, World, and Hearth into onboarding, reward, and quest-journal surfaces.

## Why this exists

After the first bridge pass, three launch-critical surfaces still relied on hard-coded colors, gradients, and typography. This log captures the follow-on normalization work so ART-04 component language can stay consistent across the first-playable path without introducing a parallel palette.

## Inputs / dependencies

- `AGENTS.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ios/Aevora/DesignSystem/AevoraTokens.swift`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/Aevora/Features/Rewards/RewardModalView.swift`
- `ios/Aevora/Features/Quest/QuestJournalSheet.swift`
- `ios/project.yml`

## Output / canonical artifact

- Refactored surfaces:
  - `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
  - `ios/Aevora/Features/Rewards/RewardModalView.swift`
  - `ios/Aevora/Features/Quest/QuestJournalSheet.swift`
- Execution log:
  - `docs/specs/art/ART-03-token-bridge-phase2-execution-log.md`

## Bridge strategy

- Reuse the existing bundled JSON bridge in `AevoraTokens.swift`.
- Replace hard-coded gradients, color literals, ad hoc radii, and obvious typography literals where canonical token roles already exist.
- Keep behavior, onboarding steps, copy, and flow timing intact.
- Do not introduce a second palette table or parallel token dictionary.

## Hard-coded literal removal by surface

### Onboarding

Removed or normalized:
- brown CTA tint literals
- welcome gradient literal
- ad hoc white/white-opacity card backgrounds
- fixed `18` corner-radius literals on main answer cards
- direct `.system` hero typography on the welcome step where `ART-03` already provides display roles

### Reward modal

Removed or normalized:
- raw parchment and warm panel color literals
- raw primary accent color literal
- rounded display metric typography literal
- ad hoc card radii on magical-moment and unlocked sections

### Quest journal

Removed or normalized:
- default list styling dependence for key hierarchy cues
- raw semantic colors for completed/current/upcoming states
- unthemed row and section treatments where token roles already exist

## Token additions required

- None.

The existing token catalog covered the needed gradients, surfaces, text roles, border roles, and radii.

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

- Runtime token bridge remained sufficient with no token-file changes: **passed**
- Xcode project regeneration: **passed**
- Onboarding, reward, and quest surfaces compile using `AevoraTokens`: **passed**
- Main hard-coded visual literals were removed from the three target surfaces: **passed by inspection**
- No second palette table or competing token bridge was introduced: **passed**
- `xcodebuild test` completed successfully with 29 passing tests: **passed**

## Residual visual debt intentionally left for a later pass

- `SignInWithAppleButton` keeps its native Apple styling.
- The quest journal remains a straightforward utility list rather than a fully custom illustrated sheet.
- This pass does not redesign flow structure, copy, or motion behavior.

## Explicit non-goals

- onboarding logic changes
- copy rewrites
- Quest Journal redesign into a bespoke world scene
- reopening Today, World, or Hearth without a shared-helper need
