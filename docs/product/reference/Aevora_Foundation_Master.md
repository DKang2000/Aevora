# Aevora Foundation Master Document
This file consolidates the eight locked backbone documents for Aevora v1.


---

# Aevora Product Thesis
**Version:** 1.0  
**Owner:** Founder + Product + CTO  
**Status:** Locked  
**Date:** 2026-03-14  

## One-line thesis
Aevora is a native iPhone life-RPG where consistent real-life habits produce visible in-world progress, so users feel their self-improvement mirrored by a fantasy avatar and a living world.

## Product promise
**Level up in Aevora as you level up in real life.**

## Why this product can exist
Most habit trackers are functionally adequate but emotionally thin. Most gamified apps add points and badges without building a believable world. Aevora can win because the world fiction and the behavior-change loop are aligned at the metaphysical level: in Aevora, repeated action literally reshapes reality. That means the habit loop is not a skin pasted onto a spreadsheet; it is the natural law of the world.

## Strategic market wedge
### Eventual market
Anyone trying to build better habits or keep better promises to themselves.

### Initial ICP
iPhone users who:
- want to improve daily consistency,
- have tried habit trackers and found them sterile or easy to abandon,
- respond to fantasy/cozy-game progression,
- are willing to check in daily if the reward feels emotionally meaningful.

### What Aevora is not
- not a team productivity suite
- not a Notion replacement
- not a calendar-first life admin dashboard
- not a full MMORPG
- not a therapy product
- not a pure idle game

## Core problem
Users do not usually fail habit tracking because they lack the ability to tap a checkbox. They fail because:
- the experience is emotionally flat,
- the reward is delayed or invisible,
- one bad day feels identity-destroying,
- the app becomes work rather than witness,
- the product asks them to manage too much at once.

## Core insight
The daily action itself is mundane. The *meaning* attached to the action determines whether it is repeated.  
Aevora turns “I checked a box” into “I kept cadence,” “I strengthened my oath,” and “the world changed because I showed up.”

## Product principles
### 1. Utility before spectacle
A user must be able to create or complete a vow faster than they could in a good mainstream habit tracker.

### 2. Visible consequence is mandatory
Every meaningful real-world action should produce some visible in-game consequence: progress meter movement, district repair, NPC response, boss damage, item drop, or avatar animation.

### 3. The world must feel real without the habits
Aevora has to stand as a fantasy setting, not just an optimization wrapper.

### 4. Missing a day should cool the ember, not erase identity
The product should encourage return, not perfectionism.

### 5. Civilian fantasies matter as much as martial fantasies
A baker, café owner, farmer, scholar, or charterlord should feel as valid as a knight or mage.

### 6. Launch depth beats launch breadth
We are shipping one excellent region with repeatable systems, not a giant shallow world.

### 7. Social should be intimate before it is public
Private accountability and small group challenges come before any public tavern/plaza concept.

### 8. Monetization must sit on top of delight, not in front of it
No paywall before the user has felt the first magical moment.

## Core loop
### Morning
- Open Today
- Review or recommit to today’s vows
- See quest priority and chapter status

### During the day
- Quick log with 1–2 taps
- Optional note/evidence
- Immediate Resonance and visual progress

### Evening
- Return to witness the day’s consequence
- Advance quest state
- Earn rewards
- See chain/ember state

### Weekly
- Resolve a civic problem, defeat a boss, or restore a district node

### Monthly
- Complete a chapter of world and personal progression

## Core product shape
Aevora v1 is best understood as four connected systems:
1. **Habit utility layer**  
2. **Progression engine**  
3. **Game presentation layer**  
4. **Ops/backend layer**

## Product differentiation
### Against basic habit trackers
Aevora offers identity, consequence, and world progression instead of sterile tracking.

### Against light gamification
Aevora offers an internally coherent world and chapter structure, not just XP and badges.

### Against deep RPG productivity apps
Aevora avoids onboarding clutter and keeps logging utility fast.

### Against coaching/self-help apps
Aevora focuses on agency and action, not lecture-heavy content.

## Launch positioning
**Aevora helps you build real habits by turning your daily progress into a fantasy world you can see and care about.**

Possible subtitle directions:
- “A fantasy habit tracker for real life progress”
- “Build better habits. Restore a living world.”
- “Your real-life growth, mirrored in an RPG world”

## What must be true for the product to work
- The first session produces emotional attachment.
- Logging is reliably easy.
- The first 7-day arc feels finishable.
- The reward economy feels generous enough to motivate but not so noisy that it becomes meaningless.
- The app remains readable and satisfying in portrait on iPhone.
- The lore enhances clarity rather than replacing it.

## The first customer story
“I want to get my life together, but the tools I try all feel dead. Aevora is the first one that makes my progress feel real.”

## Primary JTBD
### Functional
Help me define, remember, and complete my daily habits.

### Emotional
Help me feel like I am becoming someone stronger, steadier, and more alive.

### Identity
Help me see myself as a person who keeps vows and changes the world through consistency.

## Why now
- The habit and self-improvement category is crowded but still emotionally under-served.
- Cozy, progression-heavy, identity-rich experiences continue to outperform sterile tools in user affection.
- iPhone platform surfaces like widgets, Live Activities, Shortcuts, and HealthKit make a glanceable, native experience more powerful than a generic cross-platform wrapper.
- The Aevora world bible already solves the hardest thematic problem: it gives the product an original internal law.

## Anti-theses
If any of the following become true, Aevora is drifting:
- “It feels like a checklist with fancy art.”
- “It feels like a game that is annoying to use.”
- “I don’t understand what to do next.”
- “I missed a day and now I feel punished.”
- “The world seems cool, but my habits don’t really affect it.”
- “It’s trying to be every kind of productivity app.”

## North-star metric
**Meaningful Progress Days per Weekly Active User (MPD/WAU)**

A Meaningful Progress Day is a day where the user:
1. completes at least one planned vow, and  
2. sees at least one in-game consequence tied to that completion.

## Success criteria for the first release
- Strong D1/D7 retention for the starter arc
- A clear % of users reaching the first 7-day completion
- Positive qualitative feedback that the world change feels motivating
- Subscription conversion after delight, not before
- Users describe Aevora as both “easy to use” and “actually feels like a world”

## Non-goals for v1
- fully public social world
- broad team productivity
- dozens of unique mechanical class lines
- heavy task/project management depth
- Android parity
- deep API ecosystem

## Final product statement
Aevora is not trying to be the most feature-complete habit tracker in the market.  
It is trying to become the most emotionally resonant and world-rich daily consistency product on iPhone.


---

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


---

# Aevora Onboarding + Paywall Spec
**Version:** 1.0  
**Status:** Locked  
**Date:** 2026-03-14  

## 1. Goal
Turn install intent into emotional attachment and a first meaningful habit plan without exhausting the user.

## 2. Onboarding thesis
Onboarding should not feel like a survey. It should feel like:
1. being seen,
2. choosing an identity,
3. receiving a believable path,
4. witnessing the first flicker of change.

## 3. Rules
- Ask only questions that change setup or personalization.
- Show payoff as soon as possible.
- Do not gate before the first magical moment.
- Keep the user’s first active vow set small.
- Preserve clarity: plain language first, diegetic flavor second.
- Default to 3 vows unless the user explicitly wants more.

## 4. Funnel architecture
### Stage 0: pre-auth promise
Purpose: establish value fast

Screens:
1. Hero card  
   “Level up in Aevora as you level up in real life.”

2. Problem/solution carousel  
   - boring trackers don’t stick  
   - one bad day shouldn’t erase you  
   - your progress should feel visible

3. Optional Sign in with Apple / Continue  
   allow skip for flow continuity

### Stage 1: goal diagnosis
Purpose: understand intent and calibrate starter vows

Questions:
1. **What do you want more of right now?**  
   multi-select up to 3  
   - consistency
   - energy
   - focus
   - calm
   - discipline
   - momentum
   - balance
   - confidence

2. **Which life areas matter most this month?**  
   choose up to 3 from:
   - Physical
   - Intellectual
   - Career
   - Hobbies
   - Emotional

3. **What usually gets in your way?**  
   choose one:
   - I forget
   - I try to do too much
   - I lose motivation
   - I feel all-or-nothing
   - My days are unpredictable
   - My current tools feel dead

4. **How many daily vows can you realistically keep?**  
   - 3
   - 5
   - 7

Default recommendation: 3

5. **What tone do you want from Aevora?**  
   - Gentle
   - Balanced
   - Driven

This changes:
- copy tone
- reminder tone
- difficulty defaults
- quest narration intensity

### Stage 2: identity creation
Purpose: bind utility to fantasy

#### Step 2A: choose family
- Dawnbound
- Archivist
- Hearthkeeper
- Chartermaker

#### Step 2B: choose identity shell
- Dawnbound: Knight, Paladin, Ranger
- Archivist: Mage, Scholar
- Hearthkeeper: Farmer, Baker, Café Keeper
- Chartermaker: Merchant, Charterlord

#### Step 2C: avatar setup
- name
- pronouns optional
- appearance basics
- banner color accent

Rule: keep this fast. No long RPG character creator at launch.

### Stage 3: personalized starter plan
Purpose: convert aspiration into vows

The app generates 3 recommended vows based on:
- selected life areas
- blockers
- tone
- chosen daily load

#### Recommendation rules
- at least 1 low-friction vow
- no more than 1 duration-heavy vow by default
- avoid overly aspirational suggestions
- prefer “minimum viable consistency” over “ideal self fantasy”

Examples:
- Physical + low energy → “Walk 10 minutes”
- Intellectual + overwhelm → “Read 10 pages”
- Career + forgetfulness → “Plan top 3 priorities”
- Emotional + all-or-nothing → “Write one journal line”

The user can:
- accept all
- edit any
- replace with suggestions
- create manually

### Stage 4: first magical moment
Purpose: prove the loop before monetization

Sequence:
1. Show their identity arriving in Cyrane
2. Present their first quest frame
3. Simulate or guide one micro-completion
4. Trigger a visible in-world change

Possible moment:
- A shuttered oven glows faintly
- A canal lantern re-lights
- A barricade weakens
- A district map node brightens
- NPC says: “The city remembers those who keep cadence.”

This must happen before paywall.

## 5. The offer timing
### Paywall trigger
After:
- identity chosen
- starter vows set
- first magical moment shown

Never before.

### Recommended timing
Immediately after the first magical moment, with the option to dismiss.

### Offer framing
Do not frame premium as “pay to track habits.”
Frame it as:
- unlock your full chapter
- keep more vows at once
- expand your identity and world
- deepen your witness, not your obligation

## 6. Paywall structure
### Headline options
- Unlock your full journey in Aevora
- Keep building your world
- Turn daily progress into a living adventure

### Body copy themes
- More vows, more world change
- Full chapter and seasonal content
- Expanded customization and housing
- Advanced insights and verified progress
- Still keep your free starter path if you’re not ready

### CTA hierarchy
Primary: Start free trial  
Secondary: Keep the free path

## 7. Monetization model lock
### Launch model
- free core tier
- premium subscription
- 7-day free trial
- annual + monthly pricing
- **no lifetime option at launch**

### Why no lifetime at launch
- muddies pricing signal
- reduces ability to learn retention/LTV
- too early to know fair price
- over-optimizes for short-term conversion

## 8. Free tier entitlements
- 3 active vows
- 1 identity
- first 7-day arc
- basic world state
- basic widget
- manual logging
- basic progress stats

## 9. Premium entitlements
- higher active vow cap
- all launch identities
- full Chapter One
- expanded housing and cosmetics
- advanced widgets / Live Activities
- HealthKit verification
- deeper stats and insights
- future social/private accountability features

## 10. Suggested onboarding screen flow
1. Welcome promise
2. “Why Aevora works”
3. Sign in / continue
4. Goals
5. Life areas
6. Main blocker
7. Daily load
8. Desired tone
9. Family selection
10. Identity selection
11. Avatar basics
12. Starter vow recommendations
13. Quest setup preview
14. First magical moment
15. Paywall/trial
16. Land in Today

## 11. Onboarding pacing budget
Target total time:
- ideal: 2.5 to 4 minutes
- max acceptable: 5 minutes

If the flow exceeds this, cut fields before adding more polish.

## 12. Personalization logic
### Tone mapping
#### Gentle
- softer copy
- fewer reminders
- reduced failure language
- calmer animation style

#### Balanced
- default settings

#### Driven
- firmer copy
- stronger progress framing
- more assertive reminder language
- higher default daily quest intensity

### Blocker mapping
#### Forgetfulness
- earlier reminders
- widget setup prompt

#### Too much / overwhelm
- reduce starter load
- shorter vow suggestions

#### Lose motivation
- more visible early rewards
- stronger witness prompts

#### All-or-nothing
- emphasize embers / rekindling
- show humane progression copy

#### Unpredictable days
- flexible schedule defaults
- more quantity-lite vows

#### Current tools feel dead
- emphasize world consequence quickly

## 13. Copy rules
- never shame
- never diagnose
- never imply moral worth from completion
- avoid therapy language
- use plain English for core task flow
- introduce lore as flavor, not essential jargon

## 14. Important UX rules
- never ask for HealthKit during the first minute
- never ask for notifications before value is clear
- never make character creation longer than vow creation
- never force the user to walk around the world before the first log
- always provide a free path forward

## 15. Permission prompts
### Notifications
Ask after:
- first vow set
- reminder need is obvious

### HealthKit
Ask only in context when the user enables a compatible verified vow.

### App Intents / Shortcuts
Offer after day 2 or after repeated usage, not during first-run.

## 16. Key onboarding events to instrument
- onboarding_started
- onboarding_step_viewed
- onboarding_step_completed
- onboarding_abandoned
- family_selected
- identity_selected
- starter_vow_recommended
- starter_vow_accepted
- starter_vow_edited
- first_magical_moment_viewed
- paywall_viewed
- trial_started
- paywall_dismissed
- reached_today_home

## 17. Core experiments to run
### Experiment 1
Paywall immediately after first magical moment vs after arrival on Today

### Experiment 2
3-vow recommendation default vs 5-vow recommendation default

### Experiment 3
Identity selection before goals vs after goals

### Experiment 4
Free path messaging strength:
- “Keep the free path”
- “Continue with starter chapter”

## 18. Success metrics
- onboarding completion rate
- time to first magical moment
- % accepting at least one recommended vow
- % reaching Today
- % viewing paywall
- trial start rate
- D1 retention by onboarding tone
- 7-day arc completion by onboarding load

## 19. Definition of done
The onboarding is done when it reliably creates:
1. a clear identity,
2. a believable starter plan,
3. a felt world response,
4. a premium offer that does not break trust.


---

# Aevora Game Economy Spec
**Version:** 1.0  
**Status:** Locked for v1  
**Date:** 2026-03-14  

## 1. Economy philosophy
The economy must reward consistency, visible progress, and return.  
It must not:
- encourage fake habit inflation,
- force optimization math on the user,
- punish imperfect humans,
- become so generous that rewards feel meaningless.

## 2. Core economy pillars
1. **Resonance** = progression / mastery  
2. **Gold** = spendable reward / delight  
3. **Chains** = consistency signal  
4. **Embers** = humane recovery system  
5. **Witness Marks** = milestone achievements  
6. **World State** = the most important reward of all

## 3. Player-facing currencies
### Resonance
Primary progression currency. Used to gain levels (“Rank of the Way”).

### Gold
Soft currency. Used for:
- cosmetics
- home upgrades
- select utility unlocks
- shop items
- chapter decorations

### Embers
Limited recovery resource used to preserve momentum after a miss.

### Witness Marks
Non-spendable achievements. Used for profile prestige and future unlock hooks.

## 4. Vow types in v1
### Binary vow
Examples:
- Meditate
- Read
- Journal
- Stretch

### Count vow
Examples:
- Drink 8 glasses of water
- Do 30 pushups
- Save $10
- Write 500 words

### Duration vow
Examples:
- Focus for 25 minutes
- Walk for 20 minutes
- Practice guitar for 15 minutes

## 5. Daily vow recommendations
### Default active vow counts
- Free: up to 3 active vows
- Premium: up to 7 active vows visible in Today, with future expansion potential

Reason:
More than 7 visible daily vows in a portrait-first habit app risks overload and fake ambition.

## 6. Reward formula
### Base Resonance by vow type
- Binary: 10 RP
- Count: 10 RP
- Duration: 12 RP

### Difficulty multiplier
Each vow has a default multiplier:
- Easy: 0.8
- Standard: 1.0
- Challenging: 1.25
- Stretch: 1.5

Stretch vows must be opt-in and never default in onboarding.

### Completion quality
- Full completion: 100%
- Partial completion (count/duration only): proportional, min 30% once started
- Over-completion: capped at 120% reward unless explicitly configured

### Chain bonus
- 3-day chain: +5% RP
- 7-day chain: +10% RP
- 14-day chain: +15% RP
- 30-day chain: +20% RP cap

### Same-day witness bonus
If the user returns to witness the consequence the same day:
- +3 Gold
- +small world animation bonus
No extra Resonance. We want emotional reinforcement, not math farming.

## 7. Gold rewards
### Base Gold
- Binary: 5 Gold
- Count: 5 Gold
- Duration: 6 Gold

### Bonus Gold sources
- first vow completed today: +2
- all planned vows completed today: +5
- chapter milestone: +15 to +50
- weekly problem solved: +75+
- rare drop/chest: variable

## 8. Level curve
### Design goal
Fast early momentum, visible growth in the first week, steadier climb afterward.

### Cumulative Resonance required
| Rank | Total RP |
|---|---:|
| 1 | 0 |
| 2 | 40 |
| 3 | 100 |
| 4 | 180 |
| 5 | 280 |
| 6 | 400 |
| 7 | 540 |
| 8 | 700 |
| 9 | 880 |
| 10 | 1080 |
| 11 | 1300 |
| 12 | 1540 |
| 13 | 1800 |
| 14 | 2080 |
| 15 | 2380 |

Interpretation:
- first level-up should happen day 1 for most users
- multiple level-ups possible in first week
- later ranks require sustained cadence

## 9. World progress model
The world reward should be legible at three time horizons.

### Micro (same session)
- glow
- sparkle
- small object repaired
- NPC line change
- quest meter movement

### Weekly
- problem health reduced
- district node restored
- boss stage defeated
- shop inventory improves
- home prop unlocked

### Monthly / chapter
- district visibly transformed
- new NPC unlocked
- new lane or chapter scene opens
- new cosmetic set or housing room unlocked

## 10. Chain system
### Definition
A Chain is a count of consecutive scheduled completions for a vow.

### Rules
- only scheduled occurrences count
- skipped non-scheduled days do not break chain
- visible current chain and longest chain both stored

### Why Chains matter
Chains should signal continuity, not define worth.

## 11. Ember / Rekindling system
### Design principle
Broken chains should leave embers, not erase identity.

### Rules
- every user can earn Embers through consistency
- free users can hold up to 2 Embers
- premium users can hold up to 4 Embers
- missing one scheduled occurrence creates a **Cooling** state
- user can spend 1 Ember within 72 hours to preserve chain continuity
- if they do not spend an Ember, the chain breaks but Heat remains partially intact

### Heat system
Each vow has a hidden Heat tier:
- Cold
- Warm
- Kindled
- Bright
- Blazing

Heat rises through repetition and mildly affects:
- reward presentation flair
- drop chance
- quest affinity
Heat decays gradually, not instantly.

## 12. Daily completion states
- Not started
- In progress
- Completed
- Perfect day (all planned vows done)
- Cooling (missed, recoverable)
- Rekindled

## 13. Achievement structure
### Witness Marks categories
- Consistency
- Return / Rekindling
- Identity mastery
- District restoration
- Chapter completion
- Lifestyle breadth
- Signature feats

Examples:
- First Light: completed first vow
- Sevenfold Cadence: 7-day chapter finished
- Emberkeeper: successfully rekindled 3 times
- Bread of the Quarter: completed 20 nourishment-themed vows
- Ledger-True: completed 20 finance-focused vows

## 14. Item economy
### Item buckets
- Avatar cosmetics
- Home décor
- Utility boosts (non-power, non-pay-to-win)
- Chapter trophies
- Companion/pet cosmetics
- Portrait frames / banners

### Rarities
- Common
- Uncommon
- Rare
- Epic
- Mythic (very limited in v1)

### v1 rule
Items should be mostly expressive, not numerically dominant.

## 15. Shops
v1 includes:
- Ember Quay outfitter
- Lantern Quarter curios
- Hearth upgrades vendor
- chapter reward chest

Shops refresh on:
- daily soft refresh (cosmetics)
- weekly featured item
- chapter completion unlocks

## 16. Quest economy
### Daily quest structure
Complete planned vows to advance one local problem meter.

### Weekly structure
A weekly problem has 100 progress.
Daily vow completions contribute progress by formula:
- first completion of day: 20
- second: 15
- third: 15
- additional completions: 10 each up to cap

This rewards showing up without requiring impossible productivity volume.

### Weekly completion examples
- reopen bakery
- drive back Coin Wights
- mend aqueduct
- resolve Emberhouse feud
- recover forged charter fragments

## 17. Identity affinity bonuses
Each family gets cosmetic flavor emphasis, not exclusive power.

### Dawnbound
More martial-looking rewards

### Archivist
More scholarly/arcane rewards

### Hearthkeeper
More domestic/community rewards

### Chartermaker
More civic/commerce/estate rewards

Rule:
All families can progress through all life domains. No real-life category is “wasted” because of identity choice.

## 18. Anti-inflation rules
- no infinite rewards for repeated same-day toggling
- partial completion can only award once per scheduled vow window
- server validates reward grants for premium/social-sensitive systems
- cap over-completion bonus
- reward tables remotely tunable

## 19. Premium economy boundaries
Premium should enhance breadth and expression, not buy virtue.

### Premium can unlock
- more simultaneous vows
- more cosmetics
- more housing options
- more chapter content
- richer stat history
- enhanced witness surfaces

### Premium cannot do
- auto-complete vows
- buy Chains
- buy permanent stat superiority over manual progression
- bypass core behavior loop

## 20. Tuning knobs for live balance
- base RP per vow type
- Gold values
- chain bonus %
- weekly problem thresholds
- shop pricing
- drop rates
- Ember cap
- rank curve
- chapter reward frequency

## 21. Economy health metrics
- average vows completed per active day
- average RP earned per active day
- Gold sink/source ratio
- % of users reaching Rank 5 by day 7
- % of users using Rekindle
- % of users hoarding Embers
- perfect day rate
- drop excitement rate (reward opens per user)
- shop conversion rate
- chapter completion rate

## 22. Economy failure modes
### Too stingy
User feels nothing happens.

### Too generous
Everything feels fake and weightless.

### Too complex
User doesn’t understand why they got what they got.

### Too punitive
A missed day destroys attachment.

### Too identity-locked
User regrets origin choice because it invalidates real-life goals.

## 23. Economy lock summary
For v1, Aevora is a **consistency economy**, not a grind economy.  
The user should feel:
- “my actions matter,”
not
- “I need to min-max a spreadsheet.”


---

# Aevora Narrative + Content Launch Spec
**Version:** 1.0  
**Status:** Locked for launch content production  
**Date:** 2026-03-14  

## 1. Narrative thesis
Aevora’s launch narrative must prove that ordinary consistency can feel epic. The story cannot require the user to be a chosen one; it must make them feel like a person whose steady cadence helps re-knit a living city.

## 2. Launch footprint
### Region
**Cyrane and the Dawnmarch**

### Why this is the right launch region
Cyrane can hold every key fantasy lane at human scale:
- scholars and mages
- martial orders
- cafés and kitchens
- builders and property charters
- gardens and beast handling
- finance and bureaucracy
- nearby farms, ruins, canals, and haunted infrastructure

This lets us showcase Aevora’s thesis without pretending to ship a full continent.

## 3. Launch city structure
### Cyrane: City of Seven Markets
Districts:
- Lantern Quarter
- Ember Quay
- Stonehook Ward
- Mooncanal
- Banner Rise
- Greenstep
- Ledger Hill

### Launch explorable footprint
v1 explorable world scene should compress Cyrane into:
- a central hub district
- a home/hearth area
- 2–3 unlockable district pockets
- one edge road leading to Dawnmarch flavor scenes

Rule:
Imply scale beyond what is directly traversable.

## 4. Identity system for launch
### Mechanical families
1. Dawnbound
2. Archivist
3. Hearthkeeper
4. Chartermaker

### Selectable identities
#### Dawnbound
- Knight
- Paladin
- Ranger

#### Archivist
- Mage
- Scholar

#### Hearthkeeper
- Farmer
- Baker
- Café Keeper

#### Chartermaker
- Merchant
- Charterlord

## 5. Identity philosophy
Identities are **flavor-first wrappers on shared systemic content**.

They change:
- opening dialogue
- avatar silhouette
- home props
- reward flavor
- quest text variants
- social fantasy framing

They do **not** create 10 separate progression engines.

## 6. Launch NPC cast
### 6.1 Maerin Vale, Quarter Warden of Ember Quay
Role:
- first practical guide
- civic problem explainer
- represents hopeful reconstruction

Tone:
warm, competent, tired but unbroken

### 6.2 Sera Quill, junior archivist of the Lantern Quarter
Role:
- lore explainer
- journal/chronicle anchor
- study/intellectual lane guide

Tone:
sharp, curious, slightly overcaffeinated

### 6.3 Tovan Hearth, master baker of the shuttered oven
Role:
- chapter one emotional anchor
- proves civilian labor matters
- introduces wardbread / morale / neighborhood stakes

Tone:
steady, humble, quietly sacred

### 6.4 Brigant Hal, captain-in-training at Banner Rise
Role:
- fitness / discipline lane framing
- challenge language
- action-forward family guide

Tone:
direct, honorable, not macho-caricature

### 6.5 Ilya Fen, charter clerk of Stonehook Ward
Role:
- career, finance, organization lane
- city repair logic
- introduces charters and district memory

Tone:
dry humor, exacting, trustworthy

### 6.6 Pollen, a Lantern Fox
Role:
- wonder/attachment creature
- soft guide into hidden content
- charm and companionship

Tone:
silent but expressive

## 7. Chapter structure
### v1 time horizons
- first session
- first 7 days
- first 30 days

## 8. First session narrative
### Premise
The user arrives in Cyrane during a fragile period of Rekindling. A neighborhood problem is worsening because everyday rhythms have broken down. Their first kept vow strengthens the city’s cadence.

### First magical moment options
Primary:
A shuttered oven in Ember Quay glows back to life for one moment.

Secondary variants:
- a ward lantern re-lights
- a damaged canal gate shudders toward repair
- a hidden sigil appears beneath cobblestones
- Pollen the Lantern Fox emerges from cover

## 9. 7-day starter arc
### Title
**The Ember That Returned**

### High-level pitch
A beloved district bakery has been closed. Fear and disorder are spreading. The user’s first week of kept vows rekindles the neighborhood’s rhythm and helps reopen the oven before festival week.

### Why this arc works
- it centers civilian heroism
- it fits every origin family
- it can show visible progress
- it is warm but still high stakes
- it proves that “small” work matters

### Day-by-day outline
#### Day 1 — Arrival in a dim quarter
- intro to Cyrane
- first vow completion
- first oven glow / first witness

#### Day 2 — Ash in the stones
- user learns the bakery’s closure weakened nearby routines
- minor obstruction clears
- NPC trust increases

#### Day 3 — The missing ledger / missing yeast / broken ward
- identity-specific flavor scene
- user sees first repair task advance
- optional visit with Pollen

#### Day 4 — Rumors in the canal lanes
- link to broader city instability
- reveal that neglect breeds uncanny effects
- show first “problem meter” visibly reduced

#### Day 5 — A night of cooling embers
- designed tension point
- one warning that cadence matters
- recovery language introduced

#### Day 6 — The quarter gathers
- visual build-up
- shop or home prop unlock
- NPCs acknowledge user role

#### Day 7 — Oven Rekindled
- bakery reopens
- chapter reward chest
- district scene visibly improves
- lead-in to Chapter One

## 10. Family-specific flavor overlays for starter arc
### Dawnbound
Frames progress as warding and civic defense.

### Archivist
Frames progress as restoring correct memory and pattern.

### Hearthkeeper
Frames progress as nourishment, warmth, and neighborhood morale.

### Chartermaker
Frames progress as repair of civic order, supply, and stewardship.

The underlying mechanics remain the same.

## 11. 30-day Chapter One
### Title
**The Seven Markets Remember**

### Premise
The bakery crisis was only the first symptom. Across Cyrane, several districts are fraying because routines, contracts, and neighborhood care have broken down. The player becomes a recognized force in the city’s Rekindling.

### Chapter beats
1. Ember Quay rekindled
2. Stonehook charter dispute exposed
3. Greenstep companion bond / hidden shrine
4. Banner Rise civic defense drill
5. Lantern Quarter archive breach
6. Mooncanal smuggling rumor
7. Chapter capstone: district-wide festival restoration

### Chapter end state
- one district visibly stabilized
- player’s hearth improved
- rank/title granted
- one new questline hook unlocked

## 12. Content templates
To keep production scalable, launch content should be templated.

### Problem templates
- neglected infrastructure
- broken supply rhythm
- haunted property memory
- guild feud
- smuggling / corruption
- lost shrine / forgotten rite
- displaced creature companion

### Reward templates
- district visual repair
- NPC trust rank
- cosmetic
- home prop
- banner/title
- rare ingredient/relic
- pet/companion flair

### Dialogue templates
- greeting
- completion acknowledgment
- chain praise
- miss/return empathy
- milestone celebration
- chapter transition

## 13. Writing tone guide
### Tone blend
- ancient but approachable
- tender without being saccharine
- mythic without being purple
- motivational without sounding like self-help spam

### Avoid
- parody-fantasy language
- faux-epic bloat
- moralizing
- overly modern productivity jargon in NPC dialogue
- therapy speak

### Prefer
- cadence
- witness
- rekindling
- keeping faith with small work
- civic warmth
- earned hope

## 14. Diegetic vocabulary lock
### Use in flavor layers
- Vow
- Deed
- Great Work
- Chain
- Resonance
- Witness Mark
- Company
- Hearthhold

### Use in core utility surfaces
Pair lore with clarity when needed:
- Vow (Habit)
- Chain (Streak)
- Resonance (XP)

## 15. Companion and environmental hooks
### Launch companion
**Pollen, Lantern Fox**

Function:
- emotional attachment
- hint delivery
- rare discovery animation
- future collectible system seed

### Environmental language
Show:
- public ovens
- canal wards
- notice boards
- scaffolds
- garden terraces
- archive lamps
- charter seals
- neighborhood bustle

## 16. World-state change rules
The player must see three kinds of change:
1. **Object change**  
   oven, lantern, barricade, stall, shrine

2. **Social change**  
   NPC lines, crowd density, market warmth

3. **Atmospheric change**  
   lighting, color, ambient motion, music layering

## 17. Seasonal/live-ops expansion spine
After launch, expand outward through problem systems and chapter packs, not giant unstructured map drops.

### Recommended order
1. More Cyrane district arcs
2. Dawnmarch outskirts
3. Pelukai social/coastal expansion
4. Qoruun scholar expansion
5. Sahirra law/charter expansion
6. Vesperreach high-stakes late-game arc

## 18. Content production priorities
### Must ship
- chapter one intro scenes
- 7-day starter arc
- identity intro variants
- 6 key NPC dialogue sets
- district repair states
- reward text and chapter celebration scenes

### Can be light in v1
- deep branching conversation trees
- extensive side quests
- full district free-roam breadth
- multiple companion species

## 19. Narrative risks
- over-writing utility moments
- too many nouns too early
- too many bespoke class branches
- grim stakes that undermine warmth
- cozy tone with no actual consequence
- epic tone with no everyday relevance

## 20. Definition of done
Launch narrative is done when:
- a user understands why their real-life action matters in Cyrane,
- each identity feels distinct,
- the first 7 days feel like a completed chapter,
- civilian and heroic fantasies both feel valid,
- the world feels like a place worth returning to even between rewards.


---

# Aevora Technical Architecture Spec
**Version:** 1.0  
**Status:** Locked as implementation baseline  
**Date:** 2026-03-14  

## 1. Technical thesis
Aevora should be built as a native iPhone app with a lightweight 2D scene layer, local-first interaction model, and a custom backend that becomes the authoritative source of truth for progression, content, and future social systems.

## 2. Platform decision
### Lock
**Native iOS, iPhone-first**

### Why
Aevora is:
- portrait-first
- utility-heavy
- system-integrated
- glance-surface dependent
- only lightly game-like in rendering needs

This is a better fit for native iOS than a general-purpose game engine for v1.

## 3. Client architecture lock
### Primary frameworks
- **SwiftUI** for app shell and most UI
- **SpriteKit** for 2D world presentation
- **SwiftData** for on-device persistence and cache
- **WidgetKit** for widgets
- **ActivityKit** for Live Activities
- **App Intents** for Shortcuts/Siri/system actions
- **HealthKit** for limited verified inputs
- **StoreKit 2** for purchases/subscriptions
- **AuthenticationServices / Sign in with Apple**

## 4. Why these frameworks
Validated against current Apple official documentation as of 2026-03-14.

- Apple describes SwiftUI as the modern declarative framework for building interfaces across Apple platforms.
- Apple’s SpriteKit docs continue to position `SKScene` and SpriteKit views as the way to display 2D SpriteKit content, which matches Aevora’s scene needs without dragging the whole app into a game-engine shell.
- Apple documents WidgetKit and ActivityKit as the stack for glanceable widgets and Live Activities, which is central to Aevora’s “witness” surfaces.
- Apple’s App Intents docs explicitly describe exposing app actions to Shortcuts and Siri, which fits fast logging and automation better than broad third-party integrations at launch.
- Apple’s HealthKit docs support workouts, activity, and related data, making it the right first verified-input surface.
- Apple’s StoreKit 2 materials position it as the current Swift/SwiftUI-friendly purchase and subscription stack.
- Apple’s Sign in with Apple documentation gives a first-party authentication path that is particularly strong for an iOS-native subscription app.
- Apple’s `ModelContainer` docs describe SwiftData’s local model management and note that CloudKit-backed sync can be enabled with entitlements, which is useful for device-level persistence, though not enough for Aevora’s long-term source of truth.

## 5. Architecture principles
### 5.1 Local first
The app must feel instant even without network access.

### 5.2 Server authoritative where it matters
The server becomes authoritative for:
- reward grants
- premium entitlements
- remote content config
- social/group systems
- anti-cheat-sensitive progression

### 5.3 Event-based model
Persist key user actions as events, not only current state snapshots.

### 5.4 Clear separation of layers
- utility layer
- progression engine
- game presentation
- backend ops/content

### 5.5 Tunable without app updates
Economy tables, quest pacing, and paywall logic should be adjustable remotely.

## 6. High-level system diagram
### Client
- SwiftUI shell
- SpriteKit world renderer
- local data store
- sync queue
- notification scheduling
- widget/live activity extensions
- purchase/auth adapters

### Backend
- auth/account service
- habit/vow service
- progression service
- content service
- rewards/economy service
- subscription service
- notification orchestration
- analytics/event ingestion
- social service (future)

### Data/infra
- Postgres
- object storage
- queue/cache
- analytics warehouse
- feature flags / remote config

## 7. Recommended backend stack
### Suggested implementation
- **API/Application:** TypeScript + NestJS
- **Database:** Postgres
- **Queue/Cache:** Redis or managed queue once needed
- **Object storage/CDN:** S3-compatible object storage + CDN
- **Analytics product:** PostHog or equivalent event analytics
- **Warehouse:** BigQuery/Snowflake equivalent based on team preference
- **Feature flags / remote config:** LaunchDarkly, GrowthBook, or equivalent
- **Observability:** Sentry + structured logging

Vendor choice can change. System boundaries should not.

## 8. Client modules
### 8.1 Auth module
Responsibilities:
- Sign in with Apple
- guest mode
- token refresh
- account linking

### 8.2 Habit module
Responsibilities:
- vow CRUD
- schedules
- local completion
- reminders
- category/tag assignment

### 8.3 Progression module
Responsibilities:
- local reward preview
- chain calculation
- ember state
- level state
- queued server reconciliation

### 8.4 World module
Responsibilities:
- scene load
- avatar movement
- NPC interaction
- district state rendering
- reward animations

### 8.5 Economy module
Responsibilities:
- inventory
- shop
- reward chest presentation
- local soft-currency display

### 8.6 Widgets / Activity module
Responsibilities:
- Today widget
- chapter widget
- Live Activity state rendering

### 8.7 Integrations module
Responsibilities:
- HealthKit adapter
- App Intents actions
- future source connectors

### 8.8 Subscription module
Responsibilities:
- StoreKit purchase flows
- entitlement caching
- restore purchase
- server verification handshake

## 9. Backend service boundaries
### 9.1 Account service
- user record
- auth provider linkage
- profile metadata

### 9.2 Vow service
- canonical vow definition
- schedule rules
- active vow limits
- category/tag normalization

### 9.3 Completion service
- ingest completion events
- validate schedule windows
- support manual and verified sources

### 9.4 Progression service
- calculate authoritative reward outputs
- chain/ember rules
- level advancement
- chapter progression

### 9.5 Content service
- chapter configs
- NPC dialogue packs
- shop tables
- reward tables
- district repair state configs

### 9.6 Subscription service
- entitlement snapshots
- trial eligibility
- premium feature gating
- server-side subscription state

### 9.7 Notification service
- reminder orchestration
- evening witness prompts
- streak risk messaging

### 9.8 Analytics ingestion
- event capture
- experiment assignment
- attribution metadata
- data quality checks

## 10. Data model overview
### Core entities
- User
- Profile
- Avatar
- OriginFamily
- IdentityShell
- Vow
- VowSchedule
- VowCompletionEvent
- RewardGrant
- LevelState
- ChainState
- EmberState
- ChapterState
- QuestState
- DistrictState
- InventoryItem
- ShopOffer
- NotificationPreference
- SourceConnection
- SubscriptionState
- ExperimentAssignment

## 11. Event-first schema
### Canonical event examples
- user_registered
- onboarding_completed
- vow_created
- vow_completed
- vow_rekindled
- reward_granted
- level_up
- district_progressed
- quest_completed
- paywall_viewed
- trial_started
- subscription_activated

### Why this matters
Event storage enables:
- analytics
- debugging
- reward audits
- anti-cheat review
- balance tuning
- future replays / time-travel support

## 12. Offline and sync model
### Client behavior
- every user action writes locally first
- UI updates immediately
- a sync queue pushes changes to the backend
- server responses reconcile authoritative state

### Conflict handling
#### Completion conflicts
If client and server disagree:
- keep user-visible completion record
- reconcile rewards server-side
- log discrepancy for diagnostics

#### Schedule conflicts
Server schedule definition wins after sync, but client never blocks immediate local logging.

## 13. Persistence strategy
### On-device
Use SwiftData for:
- user-local cache
- active vows
- recent completions
- inventory snapshot
- current chapter state
- widget/shareable state
- unsynced operations

### Server
Use Postgres as canonical source for:
- reward-authoritative data
- entitlements
- chapter progression
- future social/group data

### Important note
Do **not** make CloudKit the company’s long-term source of truth.  
Device sync is useful; product authority is broader than device sync.

## 14. Security and trust model
### Aevora is trust-forward but not naive
We accept manual logging because friction matters, but protect the systems that affect:
- premium value
- future social competition
- referral abuse
- economy exploits

### Server validations
- schedule-window validation
- duplicate completion checks
- reward cap enforcement
- entitlement checks
- experiment assignment integrity

### Risk scoring
Flag suspicious behavior patterns for internal review, not user punishment at launch.

## 15. Notification architecture
### Client-local
- scheduled reminders
- time-of-day prompts

### Server-informed
- chapter milestones
- dynamic streak-risk prompts
- remote campaign messaging

Rule:
Notification logic must be permission-aware and sparse. Over-notifying will destroy trust.

## 16. Widgets and Live Activities
### v1 widget types
- Today’s vows widget
- chapter progress widget

### v1 Live Activity
- current chapter problem / weekly boss progress
- optional focus on daily completion streak

### Deep link targets
- specific vow
- Today tab
- World scene
- chapter summary sheet

## 17. HealthKit integration strategy
### v1 supported domains
- workouts
- step-like movement where appropriate
- sleep-related completion support in a narrow, explicit way

### Rules
- ask permission in context only
- manual override allowed
- verified source should reduce friction, not change the core philosophy

## 18. Subscription implementation
### Client
StoreKit product display, purchase, restore, local entitlement cache.

### Server
Transaction verification pipeline, entitlement ledger, trial gating, premium feature unlock state.

## 19. Performance budgets
- app memory footprint should remain conservative for a habit app
- scene assets must stream or load in compact bundles
- world scenes should feel alive without high battery drain
- long-running loops or physics-heavy scenes are disallowed in v1

## 20. Testing strategy
### Unit tests
- reward calculations
- chain/ember rules
- schedule evaluation
- entitlement logic

### Integration tests
- sign in
- purchase restore
- sync queue
- HealthKit import flows
- widget state refresh

### UI tests
- onboarding funnel
- first magical moment
- quick log flow
- paywall
- offline completion and relaunch

### Beta tests
- TestFlight with instrumented cohort tags
- structured qualitative prompt after day 3 and day 7

## 21. CI/CD
- main branch protected
- staging + production environments
- feature flags for incomplete features
- TestFlight continuous distribution
- automated crash reporting and symbol upload

## 22. Build sequence
### Phase 0
Architecture, schemas, event taxonomy, design tokens

### Phase 1
Core data model, Today flow, local persistence, progression logic

### Phase 2
World scene integration, narrative content system, reward flows

### Phase 3
StoreKit, widgets, notifications, HealthKit, sync hardening

### Phase 4
Beta, performance, instrumentation, launch prep

## 23. Team recommendations
### Core squad
- 2 iOS engineers
- 1 backend engineer
- 1 product/design lead
- 1 game systems/content designer
- 1 pixel artist/animator
- QA/producer support

## 24. Technical failure modes to avoid
- building the whole app in SpriteKit
- making world state block utility flows
- over-using remote network calls for routine actions
- letting local and server reward math drift
- shipping without remote tuning
- postponing analytics instrumentation

## 25. Definition of done
The architecture is ready when:
- the app feels instant,
- local and server state reconcile safely,
- world presentation is smooth in portrait,
- premium and progression systems are reliable,
- the team can iterate on content and economy without rebuilding the app.


---

# Aevora Analytics + Event Taxonomy
**Version:** 1.0  
**Status:** Locked before production implementation  
**Date:** 2026-03-14  

## 1. Measurement philosophy
Aevora should not optimize for shallow engagement.  
We care about:
- meaningful behavior,
- repeated return,
- emotional payoff,
- monetization that does not break trust.

## 2. North-star metric
**Meaningful Progress Days per Weekly Active User (MPD/WAU)**

### Definition
A Meaningful Progress Day occurs when, on a given local calendar day, a user:
1. completes at least one planned vow, and  
2. sees at least one in-game consequence tied to that completion.

This is the heartbeat of the product.

## 3. Primary KPI stack
### Retention
- D1 retention
- D7 retention
- D30 retention
- 7-day arc completion rate
- 30-day chapter continuation rate

### Behavior
- average active vows per retained user
- average completions per active day
- perfect day rate
- rekindle usage rate
- widget usage rate
- world witness rate

### Monetization
- paywall view rate
- trial start rate
- trial conversion rate
- subscriber retention
- ARPU / ARPPU
- free-to-paid upgrade timing

### Quality
- crash-free session rate
- sync failure rate
- dropped event rate
- notification opt-in rate
- HealthKit permission acceptance rate

## 4. Event naming convention
### Format
Use **snake_case** and action-oriented names.

Examples:
- `onboarding_started`
- `vow_created`
- `vow_completed`
- `district_progressed`

### Rules
- past tense or action-complete naming
- one event per meaningful user action
- no ambiguous “clicked_button”
- use dedicated events rather than overloaded generic event names

## 5. Common event properties
Every event should include:
- `user_id`
- `anonymous_id`
- `event_time_utc`
- `local_date`
- `time_zone`
- `app_version`
- `build_number`
- `release_channel`
- `device_model`
- `os_version`
- `subscription_state`
- `origin_family`
- `identity_shell`
- `experiment_assignments`
- `session_id`

## 6. Identity and segmentation properties
Important segmentation dimensions:
- onboarding tone (`gentle`, `balanced`, `driven`)
- blocker type
- starter vow count chosen
- free vs premium
- source of completion (`manual`, `healthkit`, `shortcut`, etc.)
- user tenure day bucket
- country / locale
- cohort week

## 7. Event catalog
### 7.1 Acquisition / app lifecycle
#### `app_installed`
Fire:
first launch after install

#### `app_opened`
Fire:
every foreground open

Properties:
- source (`direct`, `notification`, `widget`, `live_activity`, `deep_link`)

#### `session_started`
Fire:
new session start

#### `session_ended`
Fire:
session timeout / background end

Properties:
- duration_seconds

### 7.2 Onboarding
#### `onboarding_started`
#### `onboarding_step_viewed`
Properties:
- `step_name`
- `step_index`

#### `onboarding_step_completed`
Properties:
- `step_name`
- `answers`

#### `origin_family_selected`
Properties:
- `family_id`

#### `identity_selected`
Properties:
- `identity_id`

#### `avatar_created`
Properties:
- selected cosmetic basics

#### `starter_vow_recommended`
Properties:
- recommendation metadata

#### `starter_vow_accepted`
Properties:
- vow template id

#### `starter_vow_edited`
Properties:
- changed fields

#### `onboarding_completed`
Properties:
- total time
- total vows created

#### `first_magical_moment_viewed`
Properties:
- scene id
- whether it was interactive

### 7.3 Habit / vow management
#### `vow_created`
Properties:
- vow_type
- user-facing category
- tags
- schedule pattern
- target_value
- difficulty_band

#### `vow_edited`
Properties:
- changed_fields

#### `vow_archived`
Properties:
- reason

#### `vow_deleted`
Properties:
- age_days

#### `reminder_enabled`
Properties:
- reminder_time
- vow_id

### 7.4 Completion and consistency
#### `vow_started`
For count/duration vows when user begins but has not yet completed.

#### `vow_progress_updated`
Properties:
- progress_value
- progress_pct

#### `vow_completed`
Properties:
- vow_type
- completion_source
- progress_pct
- chain_length_before
- chain_length_after
- ember_used (bool)
- same_day_witness_eligible (bool)

#### `day_completed_first_vow`
Fire:
first completed vow of local day

#### `all_planned_vows_completed`
Properties:
- total_planned
- total_completed

#### `vow_missed`
Properties:
- vow_id
- hours_since_due

#### `vow_rekindled`
Properties:
- vow_id
- time_since_miss_hours

### 7.5 Progression
#### `resonance_awarded`
Properties:
- amount
- source
- multiplier_breakdown

#### `gold_awarded`
Properties:
- amount
- source

#### `level_up`
Properties:
- new_level

#### `witness_mark_earned`
Properties:
- mark_id
- mark_category

### 7.6 World and narrative
#### `world_scene_opened`
Properties:
- district_id
- scene_variant

#### `npc_interaction_started`
Properties:
- npc_id

#### `npc_dialogue_completed`
Properties:
- npc_id
- dialogue_id

#### `district_progressed`
Properties:
- district_id
- progress_before
- progress_after
- cause

#### `problem_damage_dealt`
Properties:
- problem_id
- amount

#### `chapter_started`
Properties:
- chapter_id

#### `chapter_milestone_reached`
Properties:
- chapter_id
- milestone_id

#### `chapter_completed`
Properties:
- chapter_id
- days_since_start

### 7.7 Economy and inventory
#### `reward_chest_opened`
Properties:
- chest_type
- item_count

#### `item_awarded`
Properties:
- item_id
- rarity
- source

#### `shop_opened`
Properties:
- shop_id

#### `shop_item_viewed`
Properties:
- item_id

#### `shop_purchase_completed`
Properties:
- item_id
- price_gold
- balance_after

### 7.8 Widgets / Live Activities / system surfaces
#### `widget_viewed`
Approximate based on deep link / refresh context where available

#### `widget_tapped`
Properties:
- widget_kind

#### `live_activity_started`
Properties:
- activity_kind

#### `live_activity_tapped`
Properties:
- activity_kind

#### `shortcut_invoked`
Properties:
- action_name

### 7.9 Notifications
#### `notification_prompt_viewed`
Properties:
- prompt_context

#### `notification_permission_result`
Properties:
- granted (bool)

#### `notification_sent`
Properties:
- campaign_name
- trigger_type

#### `notification_opened`
Properties:
- campaign_name
- delay_minutes

### 7.10 HealthKit / integration
#### `healthkit_prompt_viewed`
#### `healthkit_permission_result`
Properties:
- data_types_requested
- granted_types

#### `verified_completion_imported`
Properties:
- source_type
- normalized_vow_id

### 7.11 Monetization
#### `paywall_viewed`
Properties:
- placement
- variant
- entitlements_shown

#### `trial_started`
Properties:
- plan
- offer_id

#### `purchase_started`
Properties:
- sku
- price_local

#### `purchase_completed`
Properties:
- sku
- plan
- trial_included

#### `purchase_failed`
Properties:
- sku
- error_class

#### `subscription_restored`
#### `subscription_renewed`
#### `subscription_canceled`
#### `subscription_expired`

### 7.12 Future social (instrument now if feature-flagged)
#### `friend_invite_sent`
#### `friend_invite_accepted`
#### `group_challenge_joined`
#### `group_challenge_completed`

## 8. Derived metrics
### Activation
User is activated when they:
- complete onboarding,
- create at least 3 vows,
- complete at least 1 vow,
- witness at least 1 in-game consequence.

### 7-day arc completion
User reaches the main value proof of v1.

### Return-with-recovery rate
% of users who miss and later return within 72 hours.

### Utility-to-delight ratio
Measure:
- Today screen sessions
- World scene sessions
Healthy outcome is not 50/50. Today should remain the most-used tab.

## 9. Dashboards
### Executive dashboard
- WAU / MAU
- MPD / WAU
- D1 / D7 / D30
- trial starts
- conversion
- chapter completion
- crash-free rate

### Product dashboard
- onboarding funnel
- vow creation funnel
- first magical moment rate
- witness return rate
- day 1 → day 7 drop points

### Economy dashboard
- RP earned/day
- Gold earned/spent
- item rarity distribution
- shop open vs purchase rate
- ember earn/use rates

### Growth dashboard
- acquisition source
- paywall conversion by source
- trial conversion by source
- seasonality and campaign lift

## 10. Experimentation framework
### Required experiment dimensions
- paywall placement
- trial wording
- recommended vow count
- onboarding order
- reminder cadence
- witness prompt timing
- economy tuning

### Experiment rules
- stable assignment per user
- experiment metadata on all core events
- no overlapping experiments on same primary KPI without coordination

## 11. Data quality rules
- client retries failed events
- server de-duplicates by event_id
- timestamps recorded client-side and server-side
- event schema version field required
- no silent event renames
- data contracts owned jointly by product and engineering

## 12. Privacy and ethical boundaries
- do not infer mental health diagnoses
- do not use sensitive journaling content as analytics payload
- avoid collecting freeform text unless clearly needed and handled carefully
- support deletion requests cleanly
- avoid manipulative re-engagement segmentation

## 13. Red flags to watch
- high onboarding completion but low first-magical-moment view
- high vow creation but low witness rate
- strong D1 but weak D7
- high paywall view with low trust sentiment
- heavy widget taps but low completion
- high world visits with low actual vow completion (novelty without behavior change)

## 14. Success thresholds for v1 beta
These are directional, not investor-deck vanity targets:
- onboarding completion > 55%
- activation > 35%
- first 7-day arc completion > 20% of activated users
- D7 retention > strong niche-app baseline
- meaningful progress days rising week over week in retained cohort

## 15. Definition of done
Analytics is done when:
- every critical funnel step is measurable,
- metrics match product philosophy,
- product, design, and engineering all trust the event data,
- the team can answer “where does delight break?” without guessing.


---

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
