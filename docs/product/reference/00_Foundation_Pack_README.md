# Aevora Foundation Pack
**Version:** 1.0  
**Status:** Locked for v1 backbone  
**Date:** 2026-03-14  

This pack is the operating backbone for Aevora. It converts the founder vision, the Aevora world bible, the art references, and the competitive research into eight working product documents.

## What is locked
- Aevora is a **native iPhone life-RPG**, not a broad “life OS.”
- The core promise is: **level up in Aevora as you level up in real life**.
- The launch wedge is **daily habits first**, with optional quantity and duration-based tracking.
- The product is **single-player first**, with private accountability later.
- Launch content is **Cyrane + the Dawnmarch**, not the full continent map.
- Launch identity set is **10 selectable identities built on 4 mechanical families**.
- The app is **utility-fast, game-rewarding**. Logging can never become slower than delight.
- The underlying data model is **flexible**, even if user-facing onboarding uses five starter life categories.
- iOS stack is **SwiftUI + SpriteKit + SwiftData (local) + custom backend**, with WidgetKit, ActivityKit, App Intents, HealthKit, StoreKit 2, and Sign in with Apple as first-class platform choices.

## The eight documents
1. `01_Product_Thesis.md`  
   Strategic product statement, market wedge, principles, positioning.

2. `02_v1_PRD.md`  
   What ships in v1, what does not, who it is for, user flows, IA, acceptance criteria.

3. `03_Onboarding_Paywall_Spec.md`  
   Personalized onboarding flow, first magical moment, offer timing, trial and subscription logic.

4. `04_Game_Economy_Spec.md`  
   Resonance, gold, levels, Chains, Embers, quest pacing, rewards, tuning rules.

5. `05_Narrative_Content_Launch_Spec.md`  
   Launch city, origin families, NPC cast, 7-day starter arc, chapter plan, content templates.

6. `06_Technical_Architecture_Spec.md`  
   Native iOS architecture, backend architecture, data model, sync, modules, delivery plan.

7. `07_Analytics_Event_Taxonomy.md`  
   North-star metric, events, funnels, dashboards, experiment framework, instrumentation rules.

8. `08_Art_UI_System_Spec.md`  
   Visual direction, portrait layout rules, tile/sprite system, typography, motion, accessibility.

## How to use this pack
- Use the **Product Thesis** to align investors, hiring, and growth messaging.
- Use the **PRD** to manage execution scope and sprint planning.
- Use the **Onboarding/Paywall Spec** for design, copy, and growth experiments.
- Use the **Economy Spec** for gameplay logic and balance work.
- Use the **Narrative Spec** for content production and live-ops planning.
- Use the **Technical Spec** to stand up architecture and implementation sequencing.
- Use the **Analytics Taxonomy** before any production code ships.
- Use the **Art/UI Spec** to prevent visual drift and over-PC-ification of a portrait product.

## Inputs incorporated
- Founder vision from this thread.
- Aevora world bible:
  - repeated action as metaphysical reality
  - legendary labor
  - humane “embers not erasure” philosophy
  - Cyrane/Dawnmarch as the ideal launch footprint
  - diegetic mapping from real-life actions to Aevoran rewards
- Competitive research on gamified habit/focus apps:
  - tight coupling between real-life behavior and game loop beats shallow gamification
  - finite challenge framing can strengthen retention
  - monetization should enhance progression, not break the core action
  - public visibility and cultural relevance do not automatically mean strong revenue

## Parked but not ignored
These are intentionally not locked into v1:
- public MMO-style social hub
- dozens of fully bespoke classes
- real-time multiplayer
- cross-platform support beyond iPhone
- deep third-party integrations beyond Apple-native surfaces
- broad productivity-suite positioning
- lifetime subscription pricing

## Build order summary
1. Lock product thesis and v1 scope
2. Prototype emotional loop
3. Ship vertical slice
4. Add retention infrastructure and analytics
5. Beta
6. Launch
7. Expand content and social only after retention proves out

## Definition of success for v1
Aevora succeeds if a user can:
1. set up 3–5 vows fast,
2. complete one in under two taps,
3. see a meaningful world/character consequence the same day,
4. feel motivated to return tomorrow.

