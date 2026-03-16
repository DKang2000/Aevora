# Chapter One Shop World Value Closeout Evidence Pack

Date: 2026-03-16
Scope: Chapter One shell, district restoration extension, NPC witness dialogue, inventory apply loop, curated shop purchases, and shared contract/spec updates

## `<CHAPTER_ONE_SHOP_WORLD_VALUE>` complete

Canonical artifact:
- `docs/specs/game-systems/GS-chapter-one-shop-world-value-pack.md`
- `docs/specs/narrative/NC-chapter-one-shop-world-value-pack.md`
- `docs/specs/ux/UX-chapter-one-shop-world-value-pack.md`
- `docs/specs/backend/BE-chapter-one-shop-world-value-pack.md`
- `docs/specs/ios/IOS-chapter-one-shop-world-value-pack.md`
- `docs/specs/qa/QA-chapter-one-shop-world-value-pack.md`

Supporting files created/updated:
- `content/launch/launch-content.min.v1.json`
- `content/launch/copy/en/core.v1.json`
- `shared/contracts/`
- `backend/apps/api/src/core-loop/`
- `ios/Aevora/Features/CoreLoop/`
- `ios/Aevora/Features/World/`
- `ios/Aevora/Features/Hearth/`
- `ios/Aevora/Features/Quest/`

Validation run:
- `jq empty content/launch/launch-content.min.v1.json` — passed
- `jq empty content/launch/copy/en/core.v1.json` — passed
- `xcodegen generate --spec ios/project.yml` — passed
- `corepack pnpm --filter @aevora/api typecheck` — passed
- `corepack pnpm --filter @aevora/api validate:datasets` — passed
- `corepack pnpm --filter @aevora/api validate:analytics` — passed
- `corepack pnpm test` — passed
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'` — passed

Key decisions:
- Preserve the existing docs path pattern of `game-systems` and `narrative` rather than introducing new top-level spec folders.
- Use the smallest ST patch set necessary to give shop purchase, queueing, and new world states canonical homes.
- Keep Chapter One content phase-based and launch-safe instead of pretending to ship 30 bespoke daily scripts.
- Bundle canonical launch content and copy into the iOS app target through explicit resource-phase entries in `ios/project.yml` so simulator/test runs use the real Chapter One payload instead of the local fallback stub.

Conflicts or assumptions:
- Runtime durability continues to use the existing snapshot-oriented persistence path instead of a new normalized gameplay schema.
- Free users receive a coherent Chapter One preview cap; premium/trial receive the full 30-day shell.

Downstream sections unblocked:
- HealthKit / notifications / utility-completion bundle
- later art-generation bundle

Anything still missing:
- Signed TestFlight / App Store proof remains out of scope for this bundle.
- Full HealthKit / App Intents / release-hardening work remains the next likely bundle, not part of this closeout.
