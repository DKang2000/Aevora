# Contributing to Aevora

## Why these rules exist
Aevora has multiple agent swarms and disciplines working in parallel. These rules exist to keep the build coherent and prevent drift from the locked v1 product.

## Before starting work
Every contributor must read:
- `AGENTS.md`
- `ARCHITECTURE_OVERVIEW.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- the task-specific brief generated from `docs/AGENT_BRIEF_TEMPLATE.md`

## Required deliverable format for major tasks
Each major task should define:
1. purpose
2. why it exists
3. inputs / dependencies
4. output
5. edge cases
6. acceptance criteria
7. non-goals

## Branch naming
Examples:
- `feat/ios-today-screen`
- `feat/backend-progression-engine`
- `spec/content-day1-starter-arc`
- `fix/ios-widget-refresh`
- `docs/analytics-event-contract`

## Commit guidance
Commits should be small and explain what changed, not just that something changed.

Good:
- `Add canonical VowCompletion event schema`
- `Implement Today screen empty and loading states`

Bad:
- `updates`
- `stuff`

## Pull request checklist
- linked to a canonical brief or spec
- scope stays within v1
- acceptance criteria addressed
- screenshots or payload examples included where relevant
- tests or validation notes included
- no duplicated source of truth introduced

## Architectural decision rule
If you need to break an existing pattern or make a foundational change, add an ADR in `docs/adr/`.

## Anti-drift rules
- Do not invent future scope inside v1 tickets
- Do not change naming of canonical domain objects casually
- Do not create “temporary” duplicate schemas
- Do not hide assumptions in code without documenting them
