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

