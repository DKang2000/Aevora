# Aevora Repo Bootstrap Pack

This pack is the canonical repository starter for Aevora v1.

It exists for one reason: every agent swarm needs the same operating context before implementation begins.

## Why the repo is being created now
The repo was intentionally deferred until the product spine was stable enough to avoid churn. We now have that spine locked:
- native iPhone app first
- SwiftUI app shell + SpriteKit world layer
- daily vows / habits as the primary product wedge
- Cyrane / Dawnmarch as the launch footprint
- 4 mechanical origin families with 10 selectable identities
- single-player first, social later
- subscription monetization, no lifetime option at launch
- local-first client with a custom backend as long-term source of truth

Creating the repo before those decisions were locked would have caused immediate rework in structure, naming, APIs, schemas, and ownership.

## What this pack includes
- global context for all agents
- recommended monorepo structure
- repo conventions and contribution rules
- architecture overview
- agent brief template that includes "why this exists"
- starter GitHub files and workflow stubs

## Hard rules
1. If a task does not support the locked v1 scope, it does not belong in this repo.
2. Logging a vow must always be faster than visiting the world.
3. The app is utility-first and delight-rich, not game-first and input-heavy.
4. World/lore language is flavor, not friction.
5. Build for portrait iPhone first.
6. The repo is a delivery machine, not a brainstorming space.

## Recommended next use
- create the GitHub repo from this structure
- pin `AGENTS.md` and `ARCHITECTURE_OVERVIEW.md`
- issue each sub-agent a copy of `docs/AGENT_BRIEF_TEMPLATE.md`
- start generating source-of-truth contracts before UI implementation
