# Sub-Agent Handoff Protocol

## Why this protocol exists
Aevora will fail from parallel work if sub-agents receive only task fragments without product intent. This protocol ensures every agent receives the same context, scope, and acceptance bar.

## Required handoff package
Every sub-agent receives:
1. the relevant section ID from `docs/product/Aevora_V1_Master_Build_Register.md`
2. `AGENTS.md`
3. the relevant source-of-truth spec or contract
4. a task brief created from `docs/AGENT_BRIEF_TEMPLATE.md`
5. explicit non-goals
6. expected output format

## Handoff rules
- Never assign a sub-agent from raw chat history alone
- Never send only a chat summary when a canonical spec exists
- Never omit the “why this exists” section
- Never omit dependencies and interfaces
- Never ask a sub-agent to infer v1 scope from scratch
- Never let two agents define the same source-of-truth object independently

## Required deliverable review before merge
Before a deliverable is accepted, confirm:
- it matches the canonical object names
- it does not exceed v1 scope
- it includes acceptance criteria
- it names any unresolved assumptions
- it does not create a second source of truth

## Escalation triggers
Escalate if a sub-agent:
- broadens scope
- invents new systems
- changes core vocabulary
- adds third-party integrations beyond locked scope
- turns world flavor into UX friction
