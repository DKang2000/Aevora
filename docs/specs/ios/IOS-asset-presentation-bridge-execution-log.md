# IOS Asset Presentation Bridge — Execution Log

## Section ID
`IOS-asset-presentation-bridge`

## Purpose
Land the final presentation bridge so manifest-backed asset imports visibly replace placeholder-only treatment across launch surfaces without reopening product flow or art-direction decisions.

## Why it exists
The placeholder-safe runtime already resolved logical slot families and exposed debug state, but imported art was not yet replacing screen visuals in a meaningful way. This pass closes that gap so the remaining pre-beta work can stay focused on art generation/import, QA smoke, and external beta proofs.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/specs/ios/IOS-asset-runtime-injection-pack.md`
- `docs/specs/ops/OPS-asset-import-versioning-beta-pack.md`
- `docs/specs/qa/QA-asset-readiness-beta-pack.md`
- `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- `shared/contracts/assets/aevora-v1-asset-slot-families.seed.json`
- `ops/assets/manifests/aevora-v1-local-placeholder-manifest.seed.json`

## Output / canonical artifacts
- `ios/Aevora/DesignSystem/AevoraAssetRenderableView.swift`
- updated `ios/Aevora/DesignSystem/AevoraAssetResolver.swift`
- updated asset-backed launch surfaces under onboarding, Today, rewards, World, and Hearth
- strengthened asset runtime / surface / rendering tests

## What changed
- Added `AevoraAssetRenderableView` with reusable presentation styles for hero cards, portrait/busts, wide banners, and compact tiles.
- Expanded `AevoraAssetResolution` to classify `imported`, `mappedPlaceholder`, and `fallbackMissing` without changing the manifest schema.
- Updated debug summaries and pills so QA can distinguish imported assets from placeholder-backed manifest entries and truly missing mappings.
- Replaced accent-only slot status treatment with renderable art areas on:
  - onboarding art-backed steps
  - avatar / Hearth presentation
  - Today chapter card
  - reward modal
  - World district / NPC / shop surfaces
  - World scene backdrop path
- Preserved vector avatar fallback, placeholder-safe layout stability, and existing onboarding / entitlement behavior.

## Edge cases covered
- placeholder-only manifests remain readable and non-crashing
- imported remote URLs fall back to deterministic chrome when loading fails
- imported local/bundle paths fall back safely if the image cannot be read
- beta-critical missing slots still remain visible in debug reporting

## Validation
- `xcodegen generate --spec ios/project.yml`
  - passed
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`
  - passed
  - `48` tests, `0` failures

## Acceptance criteria check
- Changing a manifest entry from placeholder-tagged art to imported art now changes the render path on integrated surfaces.
- Placeholder-only builds remain stable and readable.
- Debug distinguishes imported vs placeholder-mapped vs missing.
- No onboarding-sequence, monetization, or entitlement behavior was changed.

## Explicit non-goals preserved
- no manual art generation/import work
- no manifest schema redesign
- no onboarding redesign
- no monetization or entitlement changes
- no sprite-engine expansion beyond the minimal backdrop replacement path
