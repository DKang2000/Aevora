# NC Chapter One Shop World Value Pack

## Purpose
Lock the launch-safe Chapter One narrative/content shell, NPC witness dialogue, quest copy, reward copy hooks, and world-state narration that make the city feel inhabited after the oven rekindles.

## Why it exists
Without a content layer beyond Day 7, the world promise and premium framing would outrun what the player can actually see. This pack keeps the next chapter readable, motivating, and utility-first.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/specs/source-of-truth/ST-06_content_config_schema.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`

## Sections
### NC-07 — Chapter One content pack
- Chapter One title remains `The Seven Markets Remember`.
- Launch shell uses five milestone beats: market memory, reopening stalls, supply reliability, lantern/ledger repair, and gathering-table closure.
- Every beat points toward the next useful action rather than burying utility under lore.

### NC-09 — NPC dialogue pack
- Maerin frames dependable civic rhythm.
- Sera frames pattern and evidence.
- Tovan frames warmth becoming reliable welcome.
- Brigant frames supply as quiet guard duty.
- Ilya frames civic follow-through.
- Pollen remains short, warm, and lightly mythic.

### NC-10 — Quest journal text pack
- Starter arc remains intact as a historical seven-day section.
- Chapter One milestones are shown as day ranges with one-line summaries and tomorrow prompts.
- Free-preview gating is acknowledged plainly rather than hidden behind lore.

### NC-11 — Reward / chapter-complete copy pack
- Reward copy continues to say the world responds.
- Chapter One preview note explains that premium expands depth rather than replacing the free path.
- Chapter completion copy points to a district ready to gather again.

### NC-12 — Shopkeeper and vendor dialogue pack
- Shop offers are tied to Maerin, Tovan, and Sera so the market feels inhabited instead of abstract.
- Vendor lines still clarify the practical role of the item.

### NC-15 — World-state narration variants
- Ember Quay narration now extends through `market_waking`, `market_mended`, `lantern_garden`, and `festival_ready`.
- Hearth copy reflects when props are merely owned versus visibly placed.

## Output / canonical artifact
- This narrative pack
- Updated `content/launch/copy/en/core.v1.json`
- Updated `content/launch/launch-content.min.v1.json`

## Edge cases
- Dialogue can vary by progress phase without creating separate quest trees.
- Premium copy cannot imply paid auto-progression.
- World-state narration must remain readable with reduced context.

## Explicit non-goals
- full bespoke scripts for every day of a 30-day run
- post-launch faction arcs
- final VO or cinematic writing
