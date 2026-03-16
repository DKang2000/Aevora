# Aevora v1 Product Requirements Document
**Version:** 1.0  
**Status:** Locked  
**Date:** 2026-03-14  

## 1. Objective
Ship a native iPhone app that lets users create and complete daily vows, receive immediate and end-of-day in-world rewards, and progress through a 7-day starter arc in Cyrane.

## 2. Product goal
Validate that Aevora’s combined utility + fantasy progression loop creates better motivation and retention than a generic habit tracker.

## 3. Launch target
iPhone only, portrait-first.

## 4. Release thesis
v1 must prove three things:
1. users can set up and use Aevora as a primary daily habit tracker,
2. the world layer materially improves emotional attachment,
3. the first chapter is compelling enough to drive repeat return.

## 5. Target users
### Primary
Self-improvement oriented iPhone users who want help staying consistent and find ordinary trackers uninspiring.

### Secondary
- gamers who want a light but meaningful “life RPG”
- cozy-game fans
- users with mild executive function struggles who respond better to visible externalized motivation than abstract self-discipline

## 6. Jobs to be done
### Core JTBD
“When I am trying to improve my daily consistency, help me keep a small set of promises to myself and feel rewarded enough to keep going.”

### Supporting JTBD
- help me decide what to focus on
- help me remember my habits
- help me recover from a miss
- help me see that I am improving
- help me personalize the experience so it feels like *my* path

## 7. v1 scope
### In scope
- onboarding and avatar/origin setup
- 3–5 starter vows
- manual logging
- binary, count, and duration vow types
- daily reminder system
- streaks (“Chains”) and recovery system (“Embers/Rekindling”)
- avatar progression
- Resonance + Gold economy
- one launch region: Cyrane / Dawnmarch
- 4 mechanical origin families
- 10 selectable identities
- one 7-day starter arc
- one 30-day Chapter One structure
- district restoration / boss progress structure
- home scene + explorable district scene
- inventory and cosmetics (simple)
- widget
- Live Activity
- Sign in with Apple
- subscription + trial
- HealthKit integration for limited verification
- analytics instrumentation
- remote config / tuning

### Out of scope
- public social hub
- real-time multiplayer
- shared public economy
- open world beyond launch region
- deep calendar/task/project management
- Notion/MyFitnessPal/API import layer
- Apple Watch companion at launch
- Android
- fully bespoke content for every identity
- heavy combat mechanics

## 8. Product requirements
### 8.1 Account and identity
The user must be able to:
- sign in with Apple or continue in lightweight guest mode until upgrade/account creation point
- choose an identity family and one of 10 identities
- customize avatar basics (skin/hair/outfit accent, name, pronouns optional)

### 8.2 Habit model
A vow must support:
- title
- category (user-facing, one of five life categories)
- secondary tags
- type: yes/no, count, duration
- target amount
- schedule
- reminder
- optional note
- evidence source = manual by default; integration source optional

### 8.3 User-facing categories
These are the default categories shown in onboarding and creation:
- Physical
- Intellectual
- Career
- Hobbies
- Emotional

### 8.4 Underlying data model
The backend/client model must support flexible subdomains so future additions can include:
- sleep
- home/admin
- finance
- social/friendship
- recovery
- creativity

### 8.5 Logging
Logging must support:
- completion from Today screen in <= 2 taps
- note attachment
- partial progress for quantity/duration vows
- same-day immediate reward feedback
- offline local save with later sync

### 8.6 Game response
Every completion must trigger at least one of:
- Resonance gain
- Gold gain
- quest meter advance
- district repair increment
- boss damage
- item drop chance
- NPC dialogue change
- avatar animation or home scene change

### 8.7 Today screen
The Today screen is the default home surface and must include:
- date / chapter context
- today’s vows
- progress chips
- quick-complete controls
- quest summary
- chain/ember state
- CTA into world consequence

### 8.8 World scene
The World scene must allow:
- avatar movement in a compact district view
- tappable NPCs
- dialogue interactions
- quest markers
- home building / district state display
- light exploration only

The World scene must **not** be required to log a vow.

### 8.9 Quest system
v1 requires:
- one 7-day starter arc
- weekly progress arc tied to daily vow completion
- one “boss/problem” template
- flavor differences by family/identity

### 8.10 Economy
The game must include:
- Resonance (XP)
- Gold
- level progression
- simple inventory
- cosmetic rewards
- unlockable home/world upgrades

### 8.11 Recovery and anti-shame design
The system must:
- preserve longest chain
- allow limited rekindling
- visually frame misses as cooling embers rather than failure
- encourage return without moralizing language

### 8.12 Widgets / Live Activities
The app must support:
- a Today widget
- a progress/status widget
- a Live Activity for chapter or vow streak progress

### 8.13 Notifications
v1 notifications must support:
- reminder notifications for scheduled vows
- evening witness prompt
- streak risk warning
- chapter completion / reward prompts

### 8.14 Subscription
The app must support:
- free tier
- premium subscription
- 7-day free trial path tied to soft paywall
- server-backed entitlement state

### 8.15 Integrations
v1 verified logging is limited to:
- HealthKit workout/steps/sleep-related data where appropriate
- App Intents / Shortcuts actions for fast logging

## 9. Non-functional requirements
### Performance
- cold launch under 3s on supported iPhones
- warm launch under 1.5s
- local logging acknowledgment under 200ms
- scene transition under 500ms
- animation feedback under 700ms
- app remains fully usable offline for 72h+

### Reliability
- local persistence first
- sync retry queue
- no completion loss during intermittent connection
- crash-free session target > 99.5%

### Accessibility
- readable typography
- color not sole status indicator
- reduced-motion support
- VoiceOver labels for primary actions
- touch targets >= Apple standard comfort sizes

## 10. Information architecture
### Primary navigation
1. **Today**  
   vows, reminders, quick logging, chapter summary

2. **World**  
   Cyrane district, NPCs, quest spaces, visible consequence layer

3. **Hearth**  
   avatar, inventory, cosmetics, housing, origin progression

4. **Profile**  
   stats, settings, notifications, integrations, subscription, account

### Secondary surfaces
- quick add vow
- chapter detail sheet
- reward modal
- quest journal
- shop/inventory sheet

## 11. Core flows
### Flow A: first-time user
Install → onboarding → identity selection → starter vows → first magical moment → paywall/trial offer → Today

### Flow B: daily open
Open app → Today → complete one or more vows → see immediate response → optional World witness → close

### Flow C: evening return
Open app → Today/World → witness district change or boss damage → collect reward → prep tomorrow

### Flow D: miss and return
Miss scheduled vow → ember/cooling state shown → user returns → use rekindle or resume → identity preserved

## 12. Acceptance criteria
### Product acceptance
- user can create first vow in < 30 seconds
- user can complete first vow in <= 2 taps
- at least one visible world change occurs in first session
- user can finish 7-day arc without premium
- premium offer appears after delight, not before
- user understands where to go next at all times

### Design acceptance
- portrait layout feels native and uncluttered
- Today remains clearer than World
- game layer feels premium, not gimmicky
- lore terms never obscure basic function

### Engineering acceptance
- offline logging works
- remote config can tune economy values without app release
- analytics events fire reliably
- subscription state is consistent across relaunches

## 13. Launch content lock
### Origin families
- Dawnbound
- Archivist
- Hearthkeeper
- Chartermaker

### Selectable identities
- Knight
- Paladin
- Ranger
- Mage
- Scholar
- Farmer
- Baker
- Café Keeper
- Merchant
- Charterlord

## 14. Free vs premium
### Free
- 3 active vows
- 1 selected identity
- 7-day starter arc
- limited Chapter One access
- basic widget
- manual logging
- basic rewards and cosmetics

### Premium
- more active vows
- all identity options and deeper customization
- full Chapter One and seasonal content
- advanced widgets / Live Activities
- HealthKit verification
- deeper insights and progression history
- expanded inventory / housing / cosmetics
- future private accountability systems

## 15. Risks
- too much lore in critical utility flows
- overbuilt world navigation that slows logging
- over-scoping content before retention proves out
- paywall appearing too early
- clutter from trying to support every productivity use case

## 16. Launch sequence
### Phase 1
Prototype emotional loop

### Phase 2
Vertical slice with one family and one district arc

### Phase 3
Beta infrastructure and polish

### Phase 4
Launch with full v1 scope

## 17. Definition of done
Aevora v1 is done when a new user can:
1. choose an identity,
2. create vows,
3. complete them daily,
4. see the world respond,
5. feel invited to return tomorrow.

