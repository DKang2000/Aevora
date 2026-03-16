# Aevora Art Direction + UI System Spec
**Version:** 1.0  
**Status:** Locked for v1 visual production  
**Date:** 2026-03-14  

## 1. Visual thesis
Aevora should feel like **heroic coziness in a living mythic city**.  
The art must communicate:
- warmth,
- care,
- ancient depth,
- neighborhood-scale wonder,
- visible restoration.

## 2. Reference synthesis
The attached visual references point in the right emotional direction:
- top-down fantasy pixel world
- cozy farm/life-sim warmth
- readable environmental storytelling
- charming character silhouettes

However, one reference is structurally too close to a wide PC farm-management layout. Aevora is **portrait-first on iPhone**, so we must design for:
- a single focal scene,
- readable touch targets,
- clean HUD hierarchy,
- bottom-sheet utility surfaces.

## 3. Core art pillars
### 3.1 Lived-in myth
The world should feel inhabited, not ornamental.

### 3.2 Warm consequence
Repairs and progress should read as warmth returning to a place.

### 3.3 Distinct identity silhouettes
The 10 launch identities need clear silhouettes without requiring giant content branches.

### 3.4 Clarity over maximal density
The player should never squint to understand the scene.

### 3.5 Lore in the world, clarity in the UI
Fantasy flavor belongs in environments, icons, and microcopy—not at the expense of legibility.

## 4. Visual mood
Target blend:
- 40% cozy domestic fantasy
- 30% heroic civic restoration
- 20% magical mystery
- 10% danger / uncanny stakes

## 5. World look
### Environment keywords
- canals
- lanterns
- ward sigils
- stonework
- timber and tile
- market cloth
- garden terraces
- scaffolds
- ovens
- archives
- charter seals

### Material language
- bronze/brass trims
- indigo-night shadows
- warm parchment neutrals
- moss and patina
- ember gold accents
- moonlit silver highlights

## 6. Composition rules for portrait iPhone
### Core rule
Every primary screen gets **one visual priority**.

### Today screen
Visual priority = utility and completion clarity

### World screen
Visual priority = one focal neighborhood scene

### Hearth screen
Visual priority = avatar + home/customization

### Profile/settings
Visual priority = information clarity, minimal decoration

### Safe composition rule
Do not place critical interactive content:
- under the notch/dynamic island
- too low behind the home indicator
- in tiny upper corners

## 7. Camera and scene framing
### World camera
- top-down with slight soft-isometric feeling only through environment suggestion, not actual perspective complexity
- camera fixed or minimally drifting in v1
- no large scrolling map needed on most visits
- world scene should be navigable in short, readable chunks

### Scene scale
Characters and props should be large enough that:
- outfit changes are visible
- district repair states are obvious
- NPCs can be recognized quickly

## 8. Tile and sprite system
### Recommendation
Use a pixel-art system with:
- compact, reusable tiles
- layered environmental props
- limited animation frames for efficiency
- larger-than-retro readability for modern phone screens

### Practical lock
- use a consistent base tile system
- avoid micro-detail that only reads on tablet or desktop
- prioritize silhouette and contrast over dense texture

## 9. Character design rules
### Launch identities must read instantly
#### Dawnbound
- capes
- tabards
- shields / martial gear accents

#### Archivist
- robes
- satchels
- scrolls/lenses/staves/books

#### Hearthkeeper
- aprons
- work gloves
- baskets/tools/steam/warm colors

#### Chartermaker
- ledgers
- seals
- fitted coats
- architectural or mercantile accents

### Avatar customization scope for v1
- body frame presets (limited)
- skin tones
- hair styles/colors
- eye color limited if visible
- outfit palette accents
- simple accessory slot

## 10. UI visual system
### Design principle
The UI is not pixel-pure for its own sake. It should feel **premium-native**, with fantasy framing.

### UI layers
1. base system surfaces  
2. fantasy chrome and motifs  
3. reward/polish effects

### Rule
If fantasy chrome competes with legibility, remove chrome.

## 11. Typography
### Lock
- use a highly readable modern UI typeface for most app text
- reserve stylized fantasy display typography for:
  - section headers
  - chapter cards
  - splash screens
  - hero titles

### Avoid
- full pixel font for body copy
- tiny serif body text
- lore-style lettering in controls and forms

## 12. Color system
### Core palette roles
- **Dawn Gold** — progress, highlights, hope
- **Ember Copper** — warmth, rewards, active states
- **Moon Indigo** — night, mystery, depth
- **Moss Green** — calm, growth, restoration
- **Parchment Stone** — neutral surfaces
- **Ash Plum** — uncanny/dissonant states
- **Signal Red** — sparing use for warnings only

### Usage rules
- gold/ember accents should mean something
- premium does not equal gaudy
- Dissonance states should look wrong, not just darker

## 13. UI components
### Primary components
- vow card
- quick-complete button
- progress ring/bar
- chapter card
- reward modal
- district card
- shop card
- inventory tile
- NPC dialogue panel
- bottom sheet
- tab bar icon set

### Interaction rule
Primary actions must look tappable in a fraction of a second.

## 14. Iconography
### Style
- simple, readable silhouettes
- low-noise fantasy icon language
- consistent stroke/weight logic if vector
- if pixel-based, upscale carefully for retina clarity

### Important icon meanings
- vow complete
- chain/streak
- ember/rekindle
- resonance
- gold
- chapter
- reward chest
- notification/reminder

## 15. Motion system
### Motion tone
- warm
- responsive
- slightly magical
- never sluggish

### Timing rules
- immediate completion feedback: 120–220ms
- reward flourish: 300–600ms
- scene transition: < 500ms perceived
- celebratory sequence: rare, skippable, <= 2.5s

### Reduced motion
Provide a reduced-motion presentation for:
- flashes
- camera drifts
- particle bursts
- large scaling transitions

## 16. Animation priorities
### Must animate
- completion confirmation
- district repair increments
- reward chest open
- avatar idle
- lantern/oven/glow states
- companion micro-behavior

### Can be simple in v1
- combat-like boss feedback
- crowd loops
- weather cycles
- long ambient scene animation sets

## 17. World-state readability
When a district improves, the user should notice through:
- brighter lighting
- repaired objects
- increased animation warmth
- more people/creatures present
- clutter resolving into order

When a district worsens or remains unstable:
- colder lighting
- broken geometry
- soot/ash/violet tones
- fewer warm effects
- more uncanny props

## 18. Home / Hearth design
The Hearth is a reward surface, not just a menu.
It should show:
- identity expression
- trophy density
- warmth and restoration
- collectible depth

v1 hearth states:
- bare
- settled
- personalized
- prestigious

## 19. Shop and inventory presentation
### Shop
- boutique feel, not spreadsheet
- featured item hero slot
- small curated inventory
- rarity clearly readable

### Inventory
- category tabs
- clean tile presentation
- strong empty states
- easy equip/apply behavior

## 20. Accessibility
- body text never rely on pixel font
- respect Dynamic Type where reasonable on utility screens
- maintain contrast in both warm and dark palettes
- do not rely only on color for status
- include labels for VoiceOver on critical actions
- allow reduced motion
- maintain touch target comfort

## 21. Art production pipeline
### Recommended order
1. visual target sheets
2. palette and typography tokens
3. UI component library
4. one Today screen polish pass
5. one World scene vertical slice
6. avatar base + 10 identity variants
7. district repair state sheets
8. reward and inventory asset set

## 22. Asset priority list
### Highest priority
- app icon direction
- splash/loading art
- Today UI kit
- avatar base
- Cyrane district tiles
- key props: oven, lantern, canal, archive, stall, charter seal
- NPC portraits or bust language
- reward FX kit

### Lower priority
- wide scenic panoramas
- continent maps in detail
- highly bespoke one-off props
- large combat effect libraries

## 23. Visual anti-patterns
Do not drift into:
- over-cluttered Stardew imitation
- unreadably tiny pixel fonts
- MMO UI density
- over-dark grim fantasy
- generic medieval tavern art with no civic personality
- “mobile game fantasy” gold overload

## 24. Definition of done
The visual system is done when:
- it reads clearly on an iPhone in portrait,
- it feels unmistakably Aevora,
- utility actions are easy,
- world changes are visible,
- cozy and epic coexist without visual confusion.

