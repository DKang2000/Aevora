# ART-03 — Token Bridge Execution Log

## Purpose

Record the first implementation pass that made the canonical `ART-03` token system consumable inside the iOS app.

## Why this exists

The app previously hard-coded the main visual values in Today, World, and Hearth. This log captures the bridge strategy, the Swift naming mapping, and the exact surface normalization work so future ART-04 implementation can build on one reusable design-system location instead of reintroducing literals.

## Inputs / dependencies

- `AGENTS.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `ios/Aevora/Features/Today/TodayRootView.swift`
- `ios/Aevora/Features/World/WorldRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`
- `ios/project.yml`

## Output / canonical artifact

- Token bridge:
  - `ios/Aevora/DesignSystem/AevoraTokens.swift`
- Refactored surfaces:
  - `ios/Aevora/Features/Today/TodayRootView.swift`
  - `ios/Aevora/Features/World/WorldRootView.swift`
  - `ios/Aevora/Features/Hearth/HearthRootView.swift`
- Bundled token source:
  - `shared/tokens/aevora-v1-design-tokens.json`
  - bundled into the app through `ios/project.yml`

## Bridge strategy

- The bridge reads from the canonical JSON at runtime from the app bundle.
- `ios/project.yml` now includes `../shared/tokens/aevora-v1-design-tokens.json` as an app resource.
- `AevoraTokens.swift` decodes the bundled JSON once and exposes a lean SwiftUI-friendly wrapper.
- No second competing palette dictionary was introduced.

## Swift naming mapping

The canonical token paths remain dot-path based in JSON and prose. The Swift bridge uses a small naming adaptation where needed:

- `color.surface.cardPrimary` -> `AevoraTokens.Color.surface.cardPrimary`
- `gradient.chapter.primary` -> `AevoraTokens.Gradient.chapter.primary`
- `radius.xl` -> `AevoraTokens.Radius.xl`
- `type.display.large` -> `AevoraTokens.Typography.displayLarge`
- `type.title.card` -> `AevoraTokens.Typography.titleCard`

`Typography` is used instead of `Type` because `AevoraTokens.Type` collides with Swift metatype resolution.

## Hard-coded literal removal by surface

### Today

Removed or normalized:
- chapter gradient literals
- primary CTA tint literals
- progress tint literals
- card background literals
- stat-chip background literals
- reminder-strip background literals
- corner-radius literals on core Today cards
- main display and supporting typography literals where ART-03 tokens already define them

### World

Removed or normalized:
- headline typography literal
- district-card background literals
- district progress tint literal
- status-note tint literal
- promenade-card background literals
- selected anchor background literal
- NPC card background literals
- shop card background literals
- primary CTA tint literals

### Hearth

Removed or normalized:
- headline typography literal
- summary-panel background literal
- item-card background literals
- item-card corner-radius literal
- button tint literal
- secondary text styling hooks on the main Hearth surfaces

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

- Xcode project regenerated successfully: **passed**
- Token JSON copied into the app bundle during build: **passed**
- Today, World, and Hearth compile using the bridge: **passed**
- Main hard-coded visual literals were removed from the three target surfaces: **passed**
- Swift token names remain traceable to the canonical JSON paths: **passed**
- `xcodebuild test` completed successfully: **passed**

## Compile or runtime caveats

- The bridge relies on the bundled token JSON being present in the app target resources.
- The implementation uses `AevoraTokens.Typography.*` instead of `AevoraTokens.Type.*` because the latter is not practical Swift syntax.
- No runtime caveat surfaced in the validated test pass.

## Explicit non-goals

- full design-system package architecture
- dark mode
- motion or haptic implementation
- Figma sync
- asset generation
- token expansion beyond the current Today, World, and Hearth needs
