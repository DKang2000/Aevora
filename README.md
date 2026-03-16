# Aevora

A native iPhone life-RPG where consistent real-life habits create visible in-world progress.

## What this repo is for
This repository is the delivery system for Aevora v1. It contains the iOS client, backend services, shared contracts, world/content data, and internal documentation required to ship the first playable and usable version of the product.

## Why the repo exists
Aevora only works if every team builds against the same truth: the same product promise, the same progression rules, the same content scope, and the same technical contracts. This repo exists to prevent fragmentation across swarms.

## Start here
1. Read `AGENTS.md`
2. Read `ARCHITECTURE_OVERVIEW.md`
3. Read `docs/SOURCE_OF_TRUTH_INDEX.md`
4. Read `docs/product/README.md`
5. Use `docs/AGENT_BRIEF_TEMPLATE.md` for any new sub-agent task
6. Do not start implementation before dependencies are clear

## Sub-agent rule
- never assign a sub-agent from raw chat history alone
- every sub-agent must receive a section ID, `AGENTS.md`, relevant source docs, and a brief built from `docs/AGENT_BRIEF_TEMPLATE.md`
- treat `docs/product/Aevora_V1_Master_Build_Register.md` as the assignment index

## Product guardrails
- Build for portrait iPhone first
- Utility first, delight rich
- Logging must be faster than world navigation
- Lore is flavor, not friction
- Single-player first for v1
- Only HealthKit as first verified integration

## v1 launch frame
- launch region: Cyrane / Dawnmarch
- 4 mechanical origin families
- 10 selectable identity shells
- one 7-day starter arc
- one 30-day Chapter One
- one district restoration arc
- subscription product

## Repo conventions
- prefer canonical schemas over chat descriptions
- prefer one source of truth over duplicated constants
- do not add speculative future scope to v1 modules
- document any architectural deviation with an ADR
