# QA First Playable Core Loop Pack

## Purpose
Define the QA closure needed to prove the first-playable loop works end to end and traces back to the canonical specs, source-of-truth contracts, and shared fixtures.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-12_acceptance_criteria_matrix.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/game-systems/GS-first-playable-core-loop-pack.md`
- `docs/specs/narrative/NC-first-playable-core-loop-pack.md`
- `shared/contracts/fixtures/launch/`
- `backend/packages/analytics-schema/datasets/`

## Sections
### QA-01 — Master acceptance test plan
- Happy path: entry -> onboarding -> starter vows -> Today -> quick log -> reward -> World witness -> tomorrow CTA.
- Regression path: same journey in offline mode with queued reconciliation.
- Coverage anchors: ST contracts, launch content, seed fixtures, and canonical copy keys.

### QA-03 — iOS UI/snapshot tests for onboarding and quick log
- Validate onboarding step progression, recommended-vow acceptance, Today rendering, and quick-log modal behavior.
- Reduced-motion and VoiceOver label presence are included in the primary-flow coverage.

### QA-05 — Backend integration tests
- Cover guest session, Apple exchange/linking, profile bootstrap, vow CRUD, completion ingestion, progression snapshot, current chapter, and world state.

### QA-06 — API contract tests
- Ensure first-playable responses match the shared OpenAPI shapes for auth, profile, vows, completions, sync, progression, chapter, and world state.

### QA-07 — Offline / sync / retry test suite
- Cover local-first completion, queued sync replay, duplicate completion idempotency, and conflict-safe recovery copy.

### QA-13 — Accessibility QA suite
- Cover VoiceOver labels, reduced-motion behavior, non-color status cues, and large-text resilience for the primary first-playable journey.

### QA-16 — Content QA and narrative consistency pass
- Verify that starter-arc day copy, NPC dialogue, reward lines, and tomorrow prompts stay consistent with the canonical lexicon and the anti-shame tone rules.

## Output / canonical artifact
- This pack
- New unit/e2e tests plus expanded datasets and fixtures

## Edge cases
- Missing content keys must fail to utility-safe fallbacks rather than blank copy.
- Offline completion must still show a reward acknowledgement even before reconciliation.
- Cooling and rekindled day states must not produce shaming copy.

## Explicit non-goals
- App Store submission QA
- subscription restore or widget-specific QA
