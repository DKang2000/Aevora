# Product Docs

This folder contains the locked human-readable product foundation for Aevora v1.

## Canonical files
- `Aevora_V1_Master_Build_Register.md`: assignment index for section IDs. Every sub-agent task starts here.
- `01_Product_Thesis.md`: strategic product intent, market wedge, anti-theses, and launch positioning.
- `02_v1_PRD.md`: locked v1 scope, core flows, information architecture, acceptance criteria, and free versus premium boundaries.
- `03_Onboarding_Paywall_Spec.md`: onboarding funnel, first magical moment, paywall timing, entitlement framing, and onboarding instrumentation.
- `04_Game_Economy_Spec.md`: reward formulas, level curve, Chains, Embers, Rekindling, quest pacing, shop rules, and premium economy limits.
- `05_Narrative_Content_Launch_Spec.md`: Cyrane and Dawnmarch launch footprint, identity flavor, NPC cast, starter arc, Chapter One shell, and diegetic vocabulary.
- `06_Technical_Architecture_Spec.md`: client and backend architecture, data model, sync model, module boundaries, testing strategy, and delivery sequence.
- `07_Analytics_Event_Taxonomy.md`: event naming, KPI stack, event catalog, dashboards, experimentation, and privacy boundaries.
- `08_Art_UI_System_Spec.md`: visual direction, portrait composition, tile and sprite guidance, UI system rules, motion, and accessibility.

## Reference-only files
- `reference/00_Foundation_Pack_README.md`: import context for the eight locked docs.
- `reference/Aevora_Foundation_Master.md`: compiled convenience copy of the foundation docs. Use only for browsing; when conflicts exist, the split files above are canonical.

## Placement and downstream ownership
- `docs/product/`: locked source docs and assignment inputs only.
- `docs/design/`: derived UX flows, screen specs, copy decks, and motion guidance sourced primarily from `02_v1_PRD.md`, `03_Onboarding_Paywall_Spec.md`, `05_Narrative_Content_Launch_Spec.md`, and `08_Art_UI_System_Spec.md`.
- `docs/engineering/`: derived architecture notes, implementation plans, ADRs, and technical specs sourced primarily from `06_Technical_Architecture_Spec.md` and `07_Analytics_Event_Taxonomy.md`.
- `docs/operations/`: launch checklists, runbooks, deployment process, and support workflows sourced primarily from `06_Technical_Architecture_Spec.md`, `07_Analytics_Event_Taxonomy.md`, and the `OPS-*` items in `Aevora_V1_Master_Build_Register.md`.
- `shared/contracts/`: canonical machine-readable schemas derived from the product docs. Once accepted, these contracts outrank prose docs during implementation.
- `content/`: versioned narrative, quest, district, NPC, item, notification, and remote-config payloads derived primarily from `05_Narrative_Content_Launch_Spec.md`, with economy inputs from `04_Game_Economy_Spec.md`.
- `assets/`: source art, export packages, and marketing assets derived primarily from `08_Art_UI_System_Spec.md`.
- `ios/` and `backend/`: implementation only. These folders should consume source docs and contracts, not redefine them.

## Assignment guidance by build register section
- `UX-*`: start with `02_v1_PRD.md`, then pull `03_Onboarding_Paywall_Spec.md` and `08_Art_UI_System_Spec.md` as needed.
- `GS-*`: start with `04_Game_Economy_Spec.md`, then pull `02_v1_PRD.md` for user-facing behavior.
- `NC-*`: start with `05_Narrative_Content_Launch_Spec.md`.
- `ART-*`: start with `08_Art_UI_System_Spec.md`, then pull `05_Narrative_Content_Launch_Spec.md` for world and identity context.
- `IOS-*`, `BE-*`, `OPS-*`, `QA-*`: start with `06_Technical_Architecture_Spec.md`, then add the relevant product, economy, analytics, or art doc for the section.
- `DATA-*`: start with `07_Analytics_Event_Taxonomy.md`, then pull `06_Technical_Architecture_Spec.md` for storage and ingestion boundaries.
- `ST-*`: start with `06_Technical_Architecture_Spec.md`, then add `02_v1_PRD.md`, `03_Onboarding_Paywall_Spec.md`, `04_Game_Economy_Spec.md`, and `07_Analytics_Event_Taxonomy.md` as required by the contract being authored.
