# Source of Truth Index

## Why this file exists
When multiple agents work in parallel, the biggest failure mode is conflicting truth. This index defines where each class of truth lives.

## Canonical sources by category
### Product intent
- `AGENTS.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
- `docs/product/08_Art_UI_System_Spec.md`

### Assignment and scope lock
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/SUBAGENT_HANDOFF_PROTOCOL.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`

### System architecture
- `ARCHITECTURE_OVERVIEW.md`
- `docs/engineering/`
- ADRs in `docs/adr/`

### API contracts
- `shared/contracts/api/`

### Event schema
- `shared/contracts/events/`

### Content schema
- `shared/contracts/content/`

### Entitlements and monetization contract
- `shared/contracts/entitlements/`

### Shared fixtures and sample payloads
- `shared/fixtures/`

### Narrative and game content
- `content/`

### Design tokens and style primitives
- `shared/tokens/`

### Reference-only convenience docs
- `docs/product/reference/00_Foundation_Pack_README.md`
- `docs/product/reference/Aevora_Foundation_Master.md`

Reference-only docs are useful orientation aids, but when they disagree with split source files, the split source files win.

## Conflict resolution order
1. source contracts
2. locked product docs and the v1 master build register
3. architecture docs and latest accepted ADR
4. implementation
5. ticket or chat guidance

## Orchestrator rule
If two sources conflict and neither obviously outranks the other, escalate to the orchestrator before implementation continues.
