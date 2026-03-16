# AGENTS.md — Global Context for All Aevora Agents

This file is mandatory reading for every implementation agent working on Aevora v1.

## Product in one sentence
Aevora is a native iPhone life-RPG where consistent real-life habits create visible in-world progress, so the user feels their real growth mirrored by a fantasy avatar and a living world.

## Why this product exists
Most habit trackers are functional but emotionally flat. They ask users to record behavior without making progress feel meaningful. Aevora exists to solve the motivation problem by making real-life effort feel witnessed, consequential, and rewarding.

The app is not about shaming users into quitting bad behaviors. It is about helping users add meaningful actions to their lives and seeing those actions reshape both themselves and the world of Aevora.

## North-star promise
Level up in Aevora as you level up in real life.

## v1 user promise
A user can choose a fantasy identity, create or accept a small set of daily vows, log completion quickly, and see their avatar and launch district visibly progress over a 7-day starter arc and a 30-day first chapter.

## v1 target user
Initial wedge:
- iPhone users who want to improve their lives
- who have tried habit tracking or productivity tools before
- who respond to fantasy/cozy-game progression more than sterile utilities

Eventual market is broader, but v1 is optimized for this wedge.

## What v1 is
- daily habit / vow tracker
- progression engine
- light explorable 2D world presentation
- story-backed reward loop
- single-player first
- subscription product

## What v1 is not
- a full life OS
- a Notion replacement
- a time-blocking platform
- a deep MMO/social network
- a fully open-world RPG
- a content-heavy class simulator with dozens of bespoke systems

## Core product loop
Morning:
- see today’s vows
- recommit or adjust
- pick a focus

During the day:
- log vow completion in 1–2 taps
- optionally add quantity or notes

Evening:
- receive XP / Resonance / Gold
- see the world respond
- progress a local crisis, boss, or restoration beat

Weekly:
- resolve a local arc
- unlock dialogue, district restoration, or reward tier

## Hard product rules
1. Logging a vow is always faster than navigating the world.
2. Every meaningful real action should have a visible game consequence.
3. Missing a day should cool momentum, not erase identity.
4. Lore can enrich the experience but must never obscure utility.
5. Portrait iPhone ergonomics outrank landscape-style game composition.
6. Manual logging is acceptable and central; verified logging is additive.
7. v1 is single-player first.
8. Build only what is in the v1 register.

## Locked v1 scope
Launch footprint:
- Cyrane / Dawnmarch
- one home base / hearth scene
- one district progression arc
- one 7-day starter arc
- one 30-day Chapter One

Identity system:
- 4 mechanical origin families
- 10 selectable identity shells

Core systems:
- vows / habits
- streak-like Chains
- Embers / Rekindling recovery mechanic
- XP / Resonance / Gold
- level progression
- simple shop and inventory
- quest journal
- district restoration and one boss/problem template

Platform scope:
- iPhone native only
- portrait first
- offline capable
- widgets + Live Activities
- HealthKit only as first verified integration

## Technical stack assumptions
Client:
- SwiftUI
- SpriteKit for 2D world/scene presentation
- SwiftData for on-device persistence
- WidgetKit / ActivityKit
- App Intents
- HealthKit
- StoreKit 2
- Sign in with Apple

Backend:
- custom backend as long-term source of truth
- event-driven analytics and progression recording
- remote config / content delivery
- subscription entitlement support

## Content and tone rules
Tone:
- warm
- earnest
- motivating
- lightly mythic
- never cringey, preachy, or juvenile

World framing:
- the world responds to repeated meaningful action
- civilian roles matter as much as combat roles
- restoration, stewardship, craft, and courage are equally valid expressions of growth

## Deliverable contract for all agents
Every major deliverable should include:
1. Purpose — what is being built
2. Why it exists — what user or system problem it solves
3. Inputs / dependencies
4. Output / canonical artifact
5. Edge cases
6. Acceptance criteria
7. Explicit non-goals

## Mandatory sub-agent briefing rule
No sub-agent may be assigned from raw chat history alone.

Every sub-agent handoff must include:
1. the relevant section ID from `docs/product/Aevora_V1_Master_Build_Register.md`
2. `AGENTS.md`
3. the relevant source docs or contracts
4. a task brief built from `docs/AGENT_BRIEF_TEMPLATE.md`
5. explicit non-goals
6. the required output format

If any one of these is missing, stop and request a corrected handoff before implementation begins.

## Repo conduct rules
- Do not add speculative features under “future-proofing.”
- Do not rename core concepts casually.
- Do not invent second systems when one canonical system already exists.
- Do not mix lore terminology into core data schemas unless approved.
- Do not make paywall assumptions without entitlement rules.
- Do not turn UI delight into logging friction.

## Escalation rule
If a task reveals a conflict with the locked v1 scope, stop and escalate with a written conflict note rather than silently broadening the build.
