# ART-01 Visual Target Sheets Pack

## Purpose
Lock the first production-ready visual thesis for Aevora so downstream art work can inherit one coherent direction instead of branching into competing fantasy styles.

## Why it exists
Aevora already has its core product surfaces implemented. The missing piece is a clear visual north star that makes Today, World, Hearth, NPCs, and Cyrane feel unmistakably Aevora while keeping utility clarity above ornament.

## Inputs / dependencies
- `AGENTS.md`
- `ARCHITECTURE_OVERVIEW.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/world/WORLD_BIBLE_PRINCIPLES_SUMMARY.md`
- `ios/Aevora/Features/Today/TodayRootView.swift`
- `ios/Aevora/Features/World/WorldRootView.swift`
- `ios/Aevora/Features/World/WorldScene.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`

Initial kickoff and workflow notes originally lived outside the repo. Their required direction has been absorbed into this pack, the prompt log, and the local renderer workflow so the canonical ART-01 record is now repo-local.

## Output / canonical artifact
- Canonical pack: `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- Prompt log: `docs/specs/art/ART-01-visual-target-sheets-prompt-log.md`
- Render script: `ops/assets/art/generate_art_01_target_sheets.py`
- Exported target sheets:
  - `assets/art/target-sheets/ART-01-00_pack-cover.png`
  - `assets/art/target-sheets/ART-01-01_today-ui-target.png`
  - `assets/art/target-sheets/ART-01-02_world-vertical-slice-target.png`
  - `assets/art/target-sheets/ART-01-03_hearth-target.png`
  - `assets/art/target-sheets/ART-01-04_npc-bust-language-target.png`
  - `assets/art/target-sheets/ART-01-05_cyrane-materials-props-target.png`
  - `assets/art/target-sheets/ART-01-06_identity-silhouettes-target.png`

## Execution note
This workspace does not have a configured external image-generation client or API key. To keep `ART-01` moving without inventing a second workflow, this pack uses the kickoff prompts as the design input and renders the selected directions locally into portrait target sheets. The exact prompt language is preserved in the prompt log so the same set can later be rerun through an external image-model bake-off if desired.

## Renderer QA gate
A target sheet cannot be marked final if any of the following is true:
- annotation text is truncated
- a callout is covered by an inset or figure
- a label sits underneath a silhouette or body block
- the primary phone or UI composition reads as crowded instead of intentional
- a support note becomes harder to scan than the focal visual

## Visual thesis recap
- Aevora should feel like heroic coziness in a living mythic city.
- World-facing surfaces should lean toward a top-down fantasy pixel world with larger-than-retro readability for modern phone screens.
- UI-facing surfaces should remain premium-native, manually composed, and utility-first with fantasy framing rather than pixel-pure controls.
- Restoration must read as warmth, order, motion, and witness returning to the city.
- Civilian, domestic, scholarly, and mercantile fantasies must feel as important as martial ones.

## Sheet set

### Sheet 1 — Today utility target
Purpose:
Establish the visual bar for the highest-frequency utility surface in the app.

Must-show elements:
- vow cards
- quick-complete affordance
- readable progress bars
- chapter presence without crowding
- light magical confirmation around successful completion

Composition rules:
- one visual priority: utility and completion clarity
- real controls, spacing, and hierarchy stay manually composed
- ornament lives in materials, chapter polish, and completion warmth only

Palette notes:
- `Parchment Stone` for primary surfaces
- `Dawn Gold` and `Ember Copper` for meaningful progress/action cues
- `Moss Green` for calm completion states
- `Signal Red` only for warnings

Anti-patterns:
- fake AI screenshot text
- fantasy borders around every card
- HUD density that slows scanning

Downstream sections unblocked:
- `ART-03`
- `ART-04`

Selected direction:
Premium-native white and parchment cards over indigo atmosphere, with chapter warmth and strong bordered action buttons. The sheet intentionally looks closer to a premium iPhone app than a game HUD.

### Sheet 2 — World vertical slice target
Purpose:
Lock the look of one focal Cyrane neighborhood in Ember Quay.

Must-show elements:
- canal edge
- lanterns
- stone/timber/tile architecture
- ward sigil motif
- one repair-state contrast cue
- one visible witness path and NPC presence

Composition rules:
- one focal neighborhood scene
- top-down with soft-isometric suggestion only
- no wide-map sprawl
- props sized for iPhone readability first

Palette notes:
- `Moon Indigo` depth
- `Dawn Gold` and `Ember Copper` for restored warmth
- `Moss Green` in life-returning areas

Anti-patterns:
- desktop farm-management layout
- cluttered tile soup
- tiny unreadable prop density

Downstream sections unblocked:
- `ART-11`
- `ART-14`
- `ART-16`

Selected direction:
Ember Quay centers on a glowing oven and nearby lanterns, with canal geometry, softened sigil language, and a clear warmth shift between unstable and repaired states.

### Sheet 3 — Hearth reward surface target
Purpose:
Define home as a reward surface and identity-expression space instead of a storage shell.

Must-show elements:
- avatar placement zone
- warmth gradient between states
- keepsake/trophy density
- at least two visible Hearth progression states

Composition rules:
- one visual priority: avatar plus room identity
- collectible density rises over time without turning into clutter
- the room must feel intimate, lived-in, and aspirational

Palette notes:
- parchment neutrals and warm wood
- ember-gold highlights for earned status
- moonlit silver only for special magical objects

Anti-patterns:
- empty generic tavern room
- inventory-grid-first composition
- static room art with no progression cue

Downstream sections unblocked:
- `ART-12`
- `ART-15`

Selected direction:
A split-state room composition shows warmth and density increasing from bare to personalized, with the oven/fireplace as the emotional anchor and applied keepsakes concentrated around the avatar zone.

### Sheet 4 — NPC bust language target
Purpose:
Lock how launch NPCs read at mobile dialogue scale.

Must-show elements:
- civic authority read
- scholar read
- craft/hearth read
- mercantile/civic order read
- martial read
- companion language for Pollen

Composition rules:
- silhouette first
- prop logic and costume mass do the role work
- culturally broad without flattening lineage into one look
- bust readability must survive later sprite translation

Palette notes:
- role accents vary by function
- city materials echo the wider Cyrane kit
- companion magic uses lantern warmth rather than loud novelty

Anti-patterns:
- same-face portrait cloning
- hyper-rendered realism detached from world art
- MMO quest-giver styling

Downstream sections unblocked:
- `ART-09`
- later `ART-10`

Selected direction:
The set emphasizes role silhouettes, not facial rendering tricks. Pollen remains small, luminous, and emotionally connective instead of mascot-like.

### Sheet 5 — Cyrane materials and props target
Purpose:
Define the reusable launch-city vocabulary for tiles, props, inventory objects, and shop hero art.

Must-show elements:
- oven
- lantern
- canal architecture
- archive details
- market stall
- charter seal
- bronze/brass trim
- timber/tile/stone combinations

Composition rules:
- prop silhouettes must survive gameplay scale
- each prop should feel civic, lived-in, and purposeful
- kit pieces should imply trade, law, study, nourishment, and repair

Palette notes:
- bronze/brass trim
- parchment neutrals
- moss/patina aging
- ember gold for returned warmth

Anti-patterns:
- generic medieval clutter kits
- one-off prop flourishes that cannot be reused
- details dependent on close zoom

Downstream sections unblocked:
- `ART-11`
- `ART-12`
- `ART-13`
- `ART-15`

Selected direction:
Chunkier prop silhouettes tuned for later reuse, with material roles clearly separated so downstream tiles, items, and shop art stay consistent.

### Sheet 6 — Identity silhouette strip
Purpose:
Prove the 10 launch identities can read distinctly while remaining flavor-first wrappers on shared systems.

Must-show elements:
- Knight
- Paladin
- Ranger
- Mage
- Scholar
- Farmer
- Baker
- Cafe Keeper
- Merchant
- Charterlord

Composition rules:
- silhouette first, micro-detail second
- distinction comes from outerwear, tools, stance, and drape
- no shapes that imply ten separate progression engines

Palette notes:
- family-coded accents are acceptable
- silhouette clarity matters more than palette variety

Anti-patterns:
- hard class-fantasy exaggeration
- high-detail concept costumes that will fail at sprite scale
- visual hierarchy that privileges martial roles only

Downstream sections unblocked:
- `ART-06`
- `ART-08`

Selected direction:
The strip keeps strong family groupings while letting civilian and scholarly silhouettes hold equal charisma beside Dawnbound reads.

## What stays utility-first
- Today keeps real hierarchy, tappable spacing, readable typography, and obvious action buttons ahead of fantasy chrome.
- Profile/settings are deliberately excluded from decorative experimentation in this pass.
- World remains neighborhood-scale, not a broad explorable map or dense management surface.
- Hearth stays a reward and identity surface rather than a friction-heavy decorate mode.

## Edge cases
- fantasy ornament starts out-competing scan speed on Today
- repair-state changes feel too subtle to read without explanation
- Hearth drifts into a static room mockup instead of visible reward progression
- NPCs flatten into one same-face style or over-index on martial fantasy
- Cyrane props read like generic fantasy filler instead of a specific city
- silhouette differences imply separate job trees rather than flavor wrappers

## Acceptance criteria
- every sheet reads clearly in portrait-iPhone framing
- the set feels unmistakably Aevora rather than generic cozy fantasy
- Today remains utility-first and fast to parse
- World shows visible restoration and district consequence
- Hearth feels rewarding and personal
- NPC language supports civilian, scholarly, mercantile, and martial fantasies
- Cyrane materials and props point cleanly into later tiles, props, items, and keepsakes
- downstream `ART-03`, `ART-04`, `ART-06`, `ART-09`, `ART-11`, `ART-12`, `ART-13`, `ART-14`, `ART-15`, and `ART-16` can proceed without redefining the thesis

## Explicit non-goals
- no full asset library
- no production spritesheets or animation strips
- no App Store screenshot suite
- no new v1 regions, systems, or identity mechanics
- no ST, API, entitlement, string, or UI-state changes
- no broad marketing branch beyond the launch footprint

## Approval checklist
- Does Today still read like a premium utility app first?
- Does World visibly show restoration and district consequence?
- Does Hearth feel like reward and personalization rather than a menu shell?
- Do civilian, scholarly, and mercantile fantasies read as strongly as martial ones?
- Does Cyrane feel like a specific city with civic memory instead of a fantasy kitbash?
- Can these sheets hand off directly into tokens, UI kit, avatar, NPC, tile, prop, repair-state, item, and FX production?

## Signoff status
The cleanup rerender requested by the ART-01 addendum is complete. With the Today, World, and NPC sheets corrected and the repo-local workflow tightened by the renderer QA gate, ART-01 should now be treated as fully approved and ready to hand off into `ART-03`, `ART-04`, one polished Today pass, and the later production-tool bake-off for sprite, tile, and animation work.
