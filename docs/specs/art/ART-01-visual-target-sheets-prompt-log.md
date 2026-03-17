# ART-01 Visual Target Sheets Prompt Log

## Purpose
Preserve the exact prompt language and exploration variables used to arrive at the `ART-01` target-sheet directions so the same set can later be rerun through an external image-model bake-off without re-deriving intent.

## Execution note
No external image-generation client is configured in this workspace. The final exported sheets in `assets/art/target-sheets/` were rendered locally from the selected directions below, using the prompt pack as the canonical design input.

## Global world-facing suffix
`top-down fantasy pixel world direction, larger-than-retro readability for modern phone screens, silhouette and contrast over dense texture, no micro-detail that disappears on iPhone, no tiny pixel fonts, no MMO HUD density, no desktop farm-management layout`

## Global Today suffix
`premium-native iPhone UI direction with fantasy framing, real utility hierarchy, no fake app text, no raw generated UI labels, no tiny pixel-font body copy, visual language only for cards, materials, ornament, and progress accents`

## Global NPC suffix
`clear role silhouettes that can later survive translation into readable sprite language, avoid hyper-rendered portrait painting, avoid same-face syndrome, costume masses and props should read instantly`

## Sheet 1 — Today utility target
Base prompt:
`Create a portrait iPhone fantasy productivity UI target sheet for Aevora, a life-RPG where real habits visibly restore a mythic city. Show a premium-native mobile interface, not a retro game HUD. The mood is heroic coziness in a living mythic city: warm parchment surfaces, ember-gold progress accents, moss growth calm, moon-indigo depth. Include vow cards, a quick-complete button, a readable progress ring or bar, a chapter card, and a subtle magical completion response. The screen must feel instantly tappable, utility-first, and readable in one glance. Keep fantasy motifs tasteful and secondary to legibility. ` + Global Today suffix

Negative prompt:
`tiny pixel fonts, MMO density, over-ornamented fantasy borders, desktop UI layout, gaudy monetization gold overload, generic mobile fantasy RPG HUD`

Exploration batches:
- Batch 1: vary chapter-card warmth from restrained parchment to stronger ember highlight.
- Batch 2: vary card density from three strong vow cards to four tighter cards, rejecting the tighter version if scanning slows.
- Batch 3: vary ornament ceiling between plain premium-native and subtle sigil/lantern micro-motif.

Shortlist:
- A. Warm parchment cards over indigo depth, strong prominent buttons, restrained ornament.
- B. Darker premium shell with brighter chapter glow, rejected because the page read more like a game dashboard.

Selected direction:
- A. Manual premium-native card stack with bolder action buttons and magical warmth reserved for success states only.

## Sheet 2 — World vertical slice
Base prompt:
`Create a portrait-first visual target sheet for Aevora's World screen in Cyrane, the City of Seven Markets. Show one focal neighborhood scene with a canal, lanterns, ward sigils, stone and timber architecture, market cloth, and a visible repair/restoration contrast. The world should feel inhabited, warm, and ancient, with neighborhood-scale wonder and visible civic recovery. Top-down with a soft isometric suggestion only. Characters and props must be large enough to read on iPhone. Emphasize restoration as warmth returning to a place. ` + Global world-facing suffix

Negative prompt:
`wide open-world map, over-cluttered farm sim imitation, unreadable tiny props, grimdark mud palette, generic medieval village`

Exploration batches:
- Batch 1: vary prop density between chunkier readable blocks and busier market layering.
- Batch 2: vary repair-state contrast from lighting-first to geometry-first to mixed lighting-plus-object repair.
- Batch 3: vary focal anchor between oven-centered warmth, lantern-bridge warmth, and canal-gate repair.

Shortlist:
- A. Oven-centered Ember Quay with canal lane and sigil inset.
- B. Canal-gate-centered composition with stronger architecture but weaker warmth anchor.

Selected direction:
- A. The oven glow anchors the neighborhood while the canal and lantern network make the city legible.

## Sheet 3 — Hearth reward surface
Base prompt:
`Create a portrait iPhone target sheet for Aevora's Hearth screen, a warm home base that functions as a reward surface and customization space. Show avatar presence, home upgrades, trophy density, collectible warmth, and two progression states from bare to personalized or prestigious. The feeling should be intimate, aspirational, and clearly more like a lived-in magical home than a menu. Prioritize warmth, restoration, and identity expression. ` + Global world-facing suffix

Negative prompt:
`empty static room, tavern cliché, storage-grid-first composition, cold lifeless staging`

Exploration batches:
- Batch 1: vary split-state composition between left-to-right progression and stacked inset progression.
- Batch 2: vary collectible density from sparse/premium to denser keepsake layering.
- Batch 3: vary the emotional anchor between oven, window, and bedside keepsake glow.

Shortlist:
- A. Split-state room anchored on oven/fireplace warmth.
- B. Window-lit room with elegant composition but weaker reward read.

Selected direction:
- A. The hearth heat source carries progression emotionally and ties back to the starter arc.

## Sheet 4 — NPC bust language
Base prompt:
`Create a target sheet defining NPC bust language for Aevora. Include a civic warden, a young archivist scholar, a baker/craft master, a martial captain-in-training, a charter clerk, and a magical lantern fox guide. Emphasize clear mobile-readable silhouettes, warm fantasy realism, and cultural breadth without monoculture flattening. The city is lived-in, scholarly, mercantile, and restorative as much as martial. ` + Global NPC suffix

Negative prompt:
`same-face anime clones, hyper-real cinematic rendering, generic MMO quest-giver styling, monocultural costume logic`

Exploration batches:
- Batch 1: vary silhouette exaggeration from subtle realism to stronger mobile-readable shape language.
- Batch 2: vary palette role accents from neutral civic tones to slightly richer city-material echoes.
- Batch 3: vary Pollen from delicate guide-creature to brighter lantern-companion emphasis.

Shortlist:
- A. Role-first silhouettes with restrained face detail and prop cues.
- B. More painterly busts with richer facial detail, rejected because sprite translation got weaker.

Selected direction:
- A. Mobile readability and later sprite survivability win over painterly finish.

## Sheet 5 — Cyrane materials and props
Base prompt:
`Create a visual target sheet for Cyrane materials and key props in Aevora: canal stonework, brass lanterns, ward sigils, archive tools, market stalls, bread ovens, charter seals, timber-and-tile buildings, moss and patina, ember-gold accents, moonlit silver highlights. The city should feel like trade, study, hospitality, law, and repair have equal dignity. Props must be readable at gameplay scale. ` + Global world-facing suffix + ` designed to later convert into reusable tile and prop language, no one-off visual noise, no prop detail that only works at desktop zoom`

Negative prompt:
`random prop dump, generic medieval clutter, props dependent on close zoom to read, modern industrial styling`

Exploration batches:
- Batch 1: vary material emphasis between warmer brass-and-wood and cooler stone-and-silver.
- Batch 2: vary prop chunkiness for later tile reuse.
- Batch 3: vary the ratio of legal/archive props to hospitality/market props.

Shortlist:
- A. Balanced civic kit with ovens, lanterns, archive tools, charter seals, and stall language.
- B. Heavier market kit, rejected because it weakened the city-law and archive identity.

Selected direction:
- A. The launch city needs law, study, nourishment, and trade to read together.

## Sheet 6 — Identity silhouettes
Base prompt:
`Create an identity silhouette strip for Aevora showing Knight, Paladin, Ranger, Mage, Scholar, Farmer, Baker, Cafe Keeper, Merchant, and Charterlord. Emphasize silhouette-first readability, phone-scale clarity, and flavor-first distinction through outerwear, props, and stance rather than bespoke class fantasy. The strip should prove that civilian, mercantile, scholarly, and martial identities all carry equal charisma.`

Negative prompt:
`overbuilt class fantasy, ten separate combat archetypes, costume micro-detail that disappears at sprite scale, same-shape silhouettes`

Exploration batches:
- Batch 1: vary silhouette width and cape/apron drape across the four origin families.
- Batch 2: vary prop logic to make civilian and mercantile reads stronger without overloading them.
- Batch 3: vary posture exaggeration to find the strongest readable strip that still feels grounded.

Shortlist:
- A. Family-coded silhouettes with balanced civilian and martial energy.
- B. More dramatic heroic poses, rejected because they implied separate class systems.

Selected direction:
- A. Flavor-first wrappers with clear role massing and restrained heroic gesture.
