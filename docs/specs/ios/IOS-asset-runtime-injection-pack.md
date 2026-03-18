# IOS Asset Runtime Injection Pack

## Purpose
Define the placeholder-safe asset runtime layer that lets Aevora request art by logical slot family instead of hard-coded file paths.

## Why this exists
The final manual art pass should behave like an import/replacement pass, not a late product-design pass. iOS needs one runtime path that can resolve either placeholder manifest entries or deterministic fallback chrome without breaking onboarding, Today, World, Hearth, inventory, shop, or reward flows.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- `shared/contracts/assets/aevora-v1-asset-slot-families.seed.json`
- `ops/assets/manifests/aevora-v1-local-placeholder-manifest.seed.json`
- `ios/Aevora/DesignSystem/AevoraTokens.swift`
- launch surfaces under `ios/Aevora/Features/`

## Output / canonical artifact
- `ios/Aevora/DesignSystem/AevoraAssetManifest.swift`
- `ios/Aevora/DesignSystem/AevoraAssetRegistry.swift`
- `ios/Aevora/DesignSystem/AevoraAssetResolver.swift`
- `ios/Aevora/Features/Debug/AssetDebugMenuView.swift`

## Runtime model
- App code resolves assets by logical slot family, using `AevoraAssetSlot`.
- `AevoraAssetRegistry` owns the slot-family metadata, section IDs, beta-critical flags, and surface groupings.
- `AevoraAssetManifest` loads the placeholder manifest seed that follows the canonical `v1` asset manifest schema.
- `AevoraAssetResolver` returns either:
  - a mapped manifest entry when the slot exists in the placeholder manifest
  - a deterministic placeholder resolution when the slot is still missing

## Fallback precedence
1. bundled placeholder manifest entry for the requested slot
2. deterministic placeholder-safe chrome generated from slot metadata
3. debug reporting for missing beta-critical slots

The UI path must never throw because art is missing.

## Surface mapping
- Onboarding:
  - `welcomePromise` -> `onboarding.promise.card.family`
  - `problemSolution` -> `onboarding.problemSolution.card.family`
  - `family` -> `onboarding.familySelection.card.family`
  - `identity` -> `onboarding.identitySelection.card.family`
  - `avatar` -> `avatar.base.bodyFrame.family`, `avatar.base.bustAnchor.family`
  - `magicalMoment` -> `onboarding.magicMoment.hero`, `fx.worldRepair.family`
  - `softPaywall` -> `onboarding.paywall.supporting.family`
- Today / rewards:
  - chapter surfaces -> `card.chapter.family`, `card.promo.family`
  - reward modal -> `card.reward.family`, `fx.reward.family`
- World:
  - scene -> `world.tileset.cyrane.family`, `district.repairState.family`
  - district chrome -> `world.district.accent.family`, `world.signage.family`, `fx.worldRepair.family`
  - NPC dialogue -> `npc.bust.family`
  - shop -> `shop.cardArt.family`, `item.icon.family`
- Hearth / inventory:
  - hero -> `hearth.environment.base.family`, `hearth.decor.family`, `avatar.base.bustAnchor.family`
  - items -> `item.icon.family` or `cosmetic.icon.family`

## Debug behavior
- The debug menu shows:
  - slot family ID
  - section ID
  - beta-critical status
  - logical path
  - artifact path or placeholder fallback state
- Missing beta-critical slots stay visible in debug builds until a manifest entry exists.

## Edge cases
- bundle resource missing in test host
- slot family exists in registry but not in manifest
- a surface resolves multiple related slots but only one is mapped
- world and reward surfaces need static proof even when motion/FX art is absent

## Acceptance criteria
- every integrated launch surface resolves through `AevoraAssetResolver`
- placeholder-only builds remain navigable end to end
- missing beta-critical slots are visible in the debug menu
- asset lookups do not affect the Today logging interaction path

## Explicit non-goals
- final manual art generation
- remote CDN delivery changes
- onboarding flow redesign
- monetization or entitlement changes
