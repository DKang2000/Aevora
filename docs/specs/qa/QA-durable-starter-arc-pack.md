# QA Durable Starter Arc Pack

## Purpose
Define the validation slice for starter-arc durability, relaunch continuity, day-seven closure, and humane recovery behavior.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/qa/QA-first-playable-core-loop-pack.md`
- `docs/specs/backend/BE-durable-starter-arc-pack.md`
- `docs/specs/ios/IOS-durable-starter-arc-pack.md`

## Sections
### QA-01 / QA-05 / QA-07
- Validate guest progression across relaunch.
- Validate day-one through day-seven completion.
- Validate duplicate completion replay and rekindling-safe reward reconciliation.

### QA-03 / QA-13
- Validate core starter-arc store behavior, persistence round-trip, and reduced-friction completion path.
- Keep accessibility expectations attached to Today, Journal, World, and Hearth.

### QA-11 / QA-16
- Validate return prompts happen after value.
- Validate copy stays anti-shame through cooling and rekindling.

## Output / canonical artifact
- This pack
- Backend e2e coverage and iOS starter-arc store coverage

## Edge cases
- Resource fallback during tests
- Day-gap recovery
- Reward destination visibility after day-seven completion

## Explicit non-goals
- Full App Store submission QA
- Widget-specific validation
