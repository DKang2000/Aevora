# GS Durable Starter Arc Retention Pack

## Purpose
Complete the narrow systems pass needed for a humane, durable 7-day starter arc.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/game-systems/GS-first-playable-core-loop-pack.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`

## Sections
### GS-09 / GS-10 / GS-11
- Chains remain per-vow continuity markers.
- Cooling happens after a meaningful gap, not as identity deletion.
- Rekindling spends one Ember inside the return window and preserves continuity.

### GS-12 / GS-13 / GS-16
- Starter-arc progress advances on unique completion days.
- Day-seven closes the bakery arc and moves Ember Quay to `rekindled`.
- District presentation reads the canonical stage instead of ad hoc booleans.

### GS-20 / narrow GS-22
- Reward grants remain authoritative.
- Replay-safe completion handling must not double-grant rewards.
- Local-first acknowledgements are preserved even when server reconciliation happens later.

## Output / canonical artifact
- This pack
- Durable starter-arc backend and client implementations

## Edge cases
- Duplicate completion requests
- Multi-day gap followed by return
- Day-seven completion without premium

## Explicit non-goals
- Deep item economy balancing
- Post-starter-arc story branches
