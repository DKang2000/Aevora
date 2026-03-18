# QA Asset Readiness Beta Pack

## Purpose
Define how QA should evaluate placeholder-safe builds before final art import, and how to verify imported art after the manual generation pass.

## Why this exists
Beta readiness depends on being able to distinguish acceptable placeholders from true blockers. QA needs one checklist that covers runtime safety, visual continuity, and thesis-critical visibility.

## Inputs / dependencies
- `shared/contracts/assets/aevora-v1-asset-slot-families.seed.json`
- `ops/assets/manifests/aevora-v1-local-placeholder-manifest.seed.json`
- `docs/specs/ios/IOS-asset-runtime-injection-pack.md`
- launch surfaces in onboarding, Today, World, Hearth, inventory, shop, and rewards

## Output / canonical artifact
This QA pack and future test execution notes tied to beta runs.

## Beta blockers
- any screen crashes because a mapped asset is missing
- onboarding, Today, World, Hearth, inventory, shop, or reward flows stop rendering because a slot is unresolved
- missing beta-critical slots are not visible in the debug menu
- world restoration or reward proof becomes unreadable due to missing placeholder/fallback coverage

## Acceptable placeholder states before final import
- placeholder-safe accent chrome appears instead of final art
- static proof appears where motion/FX art is still pending
- lower-priority packs such as marketing or animation remain unresolved as long as runtime behavior is safe

## Smoke order after placeholder-only build
1. onboarding through soft paywall
2. Today quick logging and reward modal
3. World scene, NPC dialogue, and shop
4. Hearth hero plus stored/applied inventory
5. debug menu asset inspector

## Smoke order after final manual import
1. confirm the imported manifest validates
2. run onboarding, Today, reward, World, Hearth, inventory, and shop smoke flows
3. verify reduced-motion-safe behavior for reward/world proof
4. spot-check NPC, identity, and district art consistency against the locked visual thesis
5. verify screenshot/marketing slots separately

## Snapshot and consistency checks
- chapter card still reads clearly under text
- reward modal remains legible with unlocked-item lists
- NPC dialogue panel keeps portrait utility over painterly density
- Hearth remains avatar-first, not clutter-first
- district repair-state proof stays obvious in 1–2 seconds

## Edge cases
- a slot is mapped in the manifest but still intentionally uses a placeholder artifact
- one related family is imported and another remains missing on the same surface
- long user text overlaps a decorative asset accent

## Acceptance criteria
- QA can tell which missing slots are blockers
- the app remains placeholder-safe before final import
- post-import verification can be run as a focused replacement pass

## Explicit non-goals
- narrative/content signoff outside asset consistency
- App Store Connect metadata entry
- external legal review
