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

