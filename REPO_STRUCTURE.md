# Aevora Monorepo Structure — Canonical v1 Layout

## Why this structure exists
Aevora is one product with multiple tightly coupled delivery surfaces: native iOS client, backend services, world/content pipeline, shared contracts, and internal tooling. A monorepo keeps schemas, APIs, content, and app code in sync.

## Recommended repo name
`aevora`

## Top-level tree
```text
/
├── AGENTS.md
├── README.md
├── CONTRIBUTING.md
├── ARCHITECTURE_OVERVIEW.md
├── REPO_STRUCTURE.md
├── CODEOWNERS
├── .editorconfig
├── .gitignore
├── .github/
│   ├── workflows/
│   └── ISSUE_TEMPLATE/
├── docs/
│   ├── adr/
│   ├── product/
│   ├── design/
│   ├── engineering/
│   ├── operations/
│   ├── SOURCE_OF_TRUTH_INDEX.md
│   ├── SUBAGENT_HANDOFF_PROTOCOL.md
│   └── AGENT_BRIEF_TEMPLATE.md
├── shared/
│   ├── contracts/
│   │   ├── api/
│   │   ├── events/
│   │   ├── content/
│   │   ├── entitlements/
│   │   └── schemas/
│   ├── tokens/
│   └── fixtures/
├── ios/
│   ├── AevoraApp/
│   ├── AevoraWidgetExtension/
│   ├── AevoraLiveActivities/
│   ├── Packages/
│   │   ├── AevoraCore/
│   │   ├── AevoraDesignSystem/
│   │   ├── AevoraGameScene/
│   │   ├── AevoraNetworking/
│   │   ├── AevoraModels/
│   │   ├── AevoraPersistence/
│   │   ├── AevoraFeatures/
│   │   └── AevoraDebug/
│   └── Tests/
├── backend/
│   ├── apps/
│   │   ├── api/
│   │   ├── worker/
│   │   └── admin/
│   ├── packages/
│   │   ├── domain/
│   │   ├── content-engine/
│   │   ├── analytics/
│   │   └── auth/
│   ├── migrations/
│   └── tests/
├── content/
│   ├── narrative/
│   ├── quests/
│   ├── districts/
│   ├── items/
│   ├── npc/
│   ├── notifications/
│   └── remote-config/
├── infra/
│   ├── env/
│   ├── terraform/
│   ├── monitoring/
│   └── runbooks/
├── tools/
│   ├── scripts/
│   ├── linters/
│   └── generators/
└── assets/
    ├── art/
    ├── audio/
    ├── app-store/
    └── marketing/
```

## Directory ownership intent
- `shared/contracts` is the canonical source for cross-team truth.
- `ios` contains only client implementation.
- `backend` contains only server/admin/worker implementation.
- `content` contains versioned game and narrative data, not app code.
- `docs` contains human-readable specs and decision records.
- `assets` contains source art and export packages, not implementation logic.

## Source-of-truth order
When documents disagree, this is the authority order:
1. locked source contracts in `shared/contracts`
2. architecture and product docs in `docs/`
3. implementation code
4. tickets and chat threads

## Rule for sub-agents
No sub-agent should create a new top-level folder without approval from the orchestrator.
