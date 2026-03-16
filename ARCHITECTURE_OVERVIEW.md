# Aevora Architecture Overview

## Why this architecture exists
Aevora is not a pure game and not a pure utility app. It is a habit/product progression product with a lightweight explorable world. The architecture must protect instant logging, offline reliability, and Apple-native ergonomics while still supporting a living world and a tunable economy.

## High-level system model
Aevora has four core layers:

1. Utility layer
- vows / habits
- reminders
- quick logging
- Today experience
- widgets / Live Activities

2. Progression engine
- XP / Resonance / Gold
- Chains / Embers / Rekindling
- levels
- boss / restoration progress
- rewards and unlocks

3. Game presentation layer
- avatar
- world scenes
- NPC interaction
- Hearth / home scene
- inventory and shop presentation

4. Ops/backend layer
- sync
- content delivery
- entitlements
- analytics
- notification orchestration
- admin/content tools

## Client stack
- SwiftUI app shell
- SpriteKit for world/scene presentation
- SwiftData for local storage
- WidgetKit and ActivityKit
- App Intents
- HealthKit
- StoreKit 2
- Sign in with Apple

## Backend stack
- API service
- background worker(s)
- Postgres primary database
- object storage for content/assets
- remote config/content delivery
- analytics/event ingestion
- admin/content management surface

## Core design rules
- local-first and offline capable
- client should feel instant
- server becomes authoritative for progression/economy/social integrity
- event logging should be append-friendly
- content should be data-driven where possible

## Data model principle
Store events as well as current state.

Examples:
- vow_created
- vow_completed
- reward_granted
- quest_advanced
- boss_damaged
- item_awarded
- streak_rekindled
- paywall_viewed
- trial_started

This supports:
- analytics
- debugging
- balance tuning
- support audits
- future anti-cheat measures

## Context boundary rule
World terms may appear in content and UI copy, but the core technical contracts should remain plain-language and stable where possible.
