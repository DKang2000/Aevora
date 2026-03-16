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

