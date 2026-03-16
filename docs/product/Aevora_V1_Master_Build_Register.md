# Aevora v1 Master Build Register

This is the canonical v1 build inventory. If a feature, asset, screen, service, or workflow is not on this list, it is not v1.

Each line item is a discrete deliverable that can be assigned to a sub-agent.

## 0. Scope lock
v1 includes:
- native iPhone app
- onboarding + soft paywall after first magical moment
- 3–5 daily vows
- manual logging
- yes/no, count, and duration vow types
- Chains, Embers, Rekindling
- Resonance + Gold + level progression
- Cyrane / Dawnmarch launch region
- 4 origin families / 10 selectable identities
- 7-day starter arc + 30-day Chapter One shell
- home/hearth, world scene, inventory, simple shop
- widgets + Live Activities
- Sign in with Apple + guest mode
- HealthKit verification for limited inputs
- analytics, remote config, subscription entitlements

v1 excludes:
- public social hub
- real-time multiplayer
- Android
- Apple Watch companion
- Notion/MyFitnessPal import layer
- open world beyond launch region
- dozens of bespoke class systems
- broad project/task management suite
- lifetime pricing at launch

## 1. Source-of-truth contracts
- ST-01 Canonical domain model
- ST-02 API contract pack (OpenAPI or equivalent)
- ST-03 Client local storage schema
- ST-04 Event taxonomy contract
- ST-05 Remote config schema
- ST-06 Content config schema
- ST-07 Subscription entitlement matrix
- ST-08 Permission matrix
- ST-09 Error / empty / offline state catalog
- ST-10 String key registry / copy token structure
- ST-11 Seed data / fixture pack
- ST-12 Acceptance criteria matrix

## 2. Product UX and screen specs
- UX-01 Global information architecture + tab navigation spec
- UX-02 Full screen inventory
- UX-03 Onboarding flow spec
- UX-04 Identity selection spec
- UX-05 Avatar setup spec
- UX-06 Starter vow recommendation flow spec
- UX-07 First magical moment spec
- UX-08 Paywall + trial flow spec
- UX-09 Today screen spec
- UX-10 Add / edit / archive vow flow spec
- UX-11 Vow detail + progress history spec
- UX-12 Quick-log interaction spec
- UX-13 Chapter card + quest journal spec
- UX-14 Reward modal + level-up + chest spec
- UX-15 World screen spec
- UX-16 NPC dialogue interaction spec
- UX-17 Hearth screen spec
- UX-18 Inventory spec
- UX-19 Shop spec
- UX-20 Profile + stats screen spec
- UX-21 Settings / account / permissions / subscription spec
- UX-22 Notification education and prompt timing spec
- UX-23 Widget UX spec
- UX-24 Live Activity UX spec
- UX-25 Loading / empty / error / offline UX spec
- UX-26 Motion + haptics behavior spec
- UX-27 Accessibility annotations for primary flows
- UX-28 Master copy deck

## 3. Game systems and progression logic
- GS-01 Vow data/rules spec
- GS-02 Vow schedule rules spec
- GS-03 Completion rules for yes/no, count, duration
- GS-04 Partial progress rules
- GS-05 Immediate reward rules
- GS-06 Resonance formula
- GS-07 Gold formula
- GS-08 Level curve and rank thresholds
- GS-09 Chain system rules
- GS-10 Ember state rules
- GS-11 Rekindling rules
- GS-12 Daily completion state model
- GS-13 7-day starter arc logic
- GS-14 30-day Chapter One logic
- GS-15 Boss/problem template rules
- GS-16 District restoration state machine
- GS-17 Identity affinity bonus rules
- GS-18 Inventory item types + rarity rules
- GS-19 Shop offer rules
- GS-20 Reward grant audit rules
- GS-21 Free vs premium gating rules
- GS-22 Anti-cheat / reconciliation rules

## 4. Narrative and content
- NC-01 Cyrane / Dawnmarch launch footprint narrative map
- NC-02 Origin family overview pack
- NC-03 Identity intro pack for 10 identities
- NC-04 First session script
- NC-05 First magical moment variants
- NC-06 7-day starter arc full script
- NC-07 Chapter One content pack
- NC-08 NPC cast bible for launch NPCs
- NC-09 NPC dialogue pack
- NC-10 Quest journal text pack
- NC-11 Reward / level-up / chapter-complete copy pack
- NC-12 Shopkeeper and vendor dialogue pack
- NC-13 Notification copy pack
- NC-14 Diegetic lexicon / allowed lore vocabulary
- NC-15 World-state narration variants
- NC-16 Tone pack for Gentle / Balanced / Driven modes

## 5. Art, illustration, and animation
- ART-01 Visual target sheets
- ART-02 Brand mark + app icon direction
- ART-03 Color, typography, and design token kit
- ART-04 UI component art kit
- ART-05 Onboarding illustration/card set
- ART-06 Avatar base system
- ART-07 Avatar customization assets
- ART-08 Identity outfit variants for 10 identities
- ART-09 NPC portrait/bust system
- ART-10 NPC sprite set
- ART-11 Cyrane district tileset
- ART-12 Hearth / home environment set
- ART-13 Core prop pack (oven, lantern, canal, archive, stall, charter seals, etc.)
- ART-14 District repair-state variants
- ART-15 Item and cosmetic asset pack
- ART-16 Reward FX / particle kit
- ART-17 Character animation pack
- ART-18 Environment animation pack
- ART-19 Chapter / reward / promo card art
- ART-20 Screenshot / App Store marketing art

## 6. Native iOS app implementation
- IOS-01 App shell and navigation architecture
- IOS-02 Sign in with Apple + guest mode + account linking
- IOS-03 Onboarding implementation
- IOS-04 Identity and avatar setup implementation
- IOS-05 Starter vow recommendation implementation
- IOS-06 Paywall + trial + StoreKit purchase flow
- IOS-07 Local persistence layer (SwiftData)
- IOS-08 Networking client + sync queue
- IOS-09 Vow CRUD module
- IOS-10 Schedule and reminder module
- IOS-11 Today screen implementation
- IOS-12 Quick logging + partial progress interactions
- IOS-13 Reward presentation flows
- IOS-14 Quest journal + chapter state views
- IOS-15 World tab container (SwiftUI + SpriteKit)
- IOS-16 Avatar movement + NPC interaction system
- IOS-17 Hearth tab implementation
- IOS-18 Inventory implementation
- IOS-19 Shop implementation
- IOS-20 Profile / stats / settings / account flows
- IOS-21 Notification permission + local notification handling
- IOS-22 Widget implementation
- IOS-23 Live Activity implementation
- IOS-24 HealthKit integration
- IOS-25 App Intents / Shortcuts actions
- IOS-26 Remote config + feature flags client
- IOS-27 Analytics instrumentation layer
- IOS-28 Crash reporting + structured client logging
- IOS-29 Accessibility support (VoiceOver, reduced motion, touch targets, contrast)
- IOS-30 Offline banners + sync/conflict UI
- IOS-31 Restore purchase + entitlement refresh + delete account flow
- IOS-32 Internal debug menu + seed/dev utilities

## 7. Backend services and APIs
- BE-01 Backend repo/service skeleton
- BE-02 Account/auth service
- BE-03 Guest identity + account linking service
- BE-04 Profile/avatar service
- BE-05 Vow service
- BE-06 Completion ingestion service
- BE-07 Progression/reward calculation service
- BE-08 Chain / ember / rekindling service
- BE-09 Chapter / quest state service
- BE-10 District state service
- BE-11 Inventory service
- BE-12 Shop service
- BE-13 Content/config delivery service
- BE-14 Subscription / entitlements service
- BE-15 Trial eligibility logic
- BE-16 StoreKit server notification handling
- BE-17 Notification orchestration service
- BE-18 Verified-source ingestion contract
- BE-19 Analytics ingestion service
- BE-20 Feature flag / remote config service
- BE-21 Admin/content ops console
- BE-22 Asset storage + CDN pipeline
- BE-23 Security, rate limiting, audit logging
- BE-24 Account deletion / data export service
- BE-25 Backend observability and alerts

## 8. Data, analytics, and experimentation
- DATA-01 Canonical relational database schema
- DATA-02 Migration plan and migration scripts
- DATA-03 Analytics event schema implementation
- DATA-04 Warehouse/event model setup
- DATA-05 North-star + KPI dashboard suite
- DATA-06 Onboarding funnel dashboard
- DATA-07 Paywall / trial / subscription dashboard
- DATA-08 Retention / cohort dashboard
- DATA-09 Economy health dashboard
- DATA-10 Data quality checks and event validation
- DATA-11 Experiment assignment framework
- DATA-12 Privacy/redaction rules for analytics
- DATA-13 Support/admin reporting queries
- DATA-14 Test and demo datasets

## 9. Ops, infra, and internal tooling
- OPS-01 Dev / staging / prod environments
- OPS-02 iOS CI/CD pipeline
- OPS-03 Backend CI/CD pipeline
- OPS-04 Secrets management
- OPS-05 Monitoring and alerting stack
- OPS-06 Backup / restore process
- OPS-07 Remote config publishing workflow
- OPS-08 Content publishing workflow
- OPS-09 Asset ingestion / versioning workflow
- OPS-10 TestFlight distribution workflow
- OPS-11 Internal runbooks for incidents and hotfixes
- OPS-12 Access control / admin roles

## 10. QA, release, and compliance
- QA-01 Master acceptance test plan
- QA-02 iOS unit tests
- QA-03 iOS UI/snapshot tests
- QA-04 Backend unit tests
- QA-05 Backend integration tests
- QA-06 API contract tests
- QA-07 Offline / sync / retry test suite
- QA-08 Subscription / trial / restore test suite
- QA-09 HealthKit test suite
- QA-10 Widget + Live Activity test suite
- QA-11 Notification delivery and timing test suite
- QA-12 Performance benchmark suite
- QA-13 Accessibility QA suite
- QA-14 Device / screen-size QA matrix
- QA-15 Crash / recovery / cold-start QA suite
- QA-16 Content QA and narrative consistency pass
- QA-17 App Store metadata pack
- QA-18 App Store screenshots / preview assets
- QA-19 Privacy policy + terms + support site
- QA-20 App Privacy / nutrition label submission data
- QA-21 Age rating / content disclosure pack
- QA-22 Launch FAQ + support macros

## 11. Minimum screen inventory for design + implementation
### Onboarding
- welcome promise
- problem/solution carousel
- sign in / continue
- goals
- life areas
- blockers
- daily load
- tone
- family selection
- identity selection
- avatar basics
- starter vow recommendations
- quest setup preview
- first magical moment
- paywall/trial

### Core app
- Today
- add vow
- edit vow
- vow detail/history
- chapter detail
- reward modal
- World
- NPC dialogue panel
- Hearth
- inventory
- shop
- Profile
- stats
- settings
- subscription/manage premium
- notification settings
- HealthKit permissions
- account/delete account
- offline/sync state

## 12. Minimum content inventory for v1
- 4 origin families
- 10 selectable identities
- 1 launch city region
- 1 home/hearth progression surface
- 1 first-session arrival sequence
- 1 first magical moment sequence
- 1 seven-day starter arc
- 1 thirty-day Chapter One shell
- 1 boss/problem template
- 1 district restoration system with visible states
- 6 key NPCs with dialogue sets
- starter reward/item pool
- starter cosmetics pool
- starter shop inventory
- notification copy set

## 13. Minimum platform surfaces for v1
- iPhone app
- Today widget
- progress widget
- Live Activity
- local notifications
- Sign in with Apple
- HealthKit (limited)
- StoreKit 2 subscriptions
- internal admin/config surfaces

## 14. Hard v1 rule
Logging a vow must always be faster than visiting the world.
The world is the reward surface, not the input tax.
