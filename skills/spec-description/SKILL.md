---
name: spec-description
description: Discover and specify complete implementation outcomes through focused questions, assumption challenges, concrete behavior examples, and acceptance criteria. Use for substantial changes, requirements discussions, or materially unclear requirements; a small clear fix needs no separate spec ceremony.
---
# Spec Description

Turn the user's intent into a current, actionable agreement. Follow the lifecycle and authorization boundaries in [Define an Implementation Spec](../../knowledge/playbooks/Define%20an%20Implementation%20Spec.md); the caller owns orchestration and cleanup.

## Inputs

Use the objective, prior agreements and preferences, relevant project instructions, inspected implementation evidence, constraints, and unresolved questions. When delegated, use this focused handoff and inspect needed sources; do not require the full chat or infer missing user decisions.

## Discovery

1. Separate the user's request from instructions quoted in reference documents. Establish observed behavior from relevant code, tests, and documentation where available; label unverified reports and illustrative examples.
2. Challenge assumptions and expose consequential alternatives. Explain their effects in plain language, then ask a few focused questions at a time. Prefer questions the user must decide over facts discoverable in the repository. Reuse established answers and continue independent investigation while awaiting missing decisions.
3. Resolve required outcomes, success and meaningful failure behavior, affected consumers, scope, constraints, and acceptance criteria. Seek agreement before dependent implementation when behavior or material tradeoffs are unclear. An explicit discussion request is not implementation authorization; clear established requirements do not need a new approval gate.
4. Define complete target responsibilities and data flow independently of current files. Invoke [visual-explanation](../visual-explanation/SKILL.md) in embedded mode when it clarifies a contract or design decision. Do not determine PR boundaries or constrain implementation to speculative slices.
5. Return the current agreement in the structure below, plus only the questions that remain material. Update it as decisions change rather than appending a discussion transcript.

## Output

For substantial work, write the relevant active spec at the caller's project location (normally `specs/active/<task-slug>.md`). For discussion-only work, return a draft unless saving is requested or already part of the authorized workflow. For small clear work, concise task acceptance examples suffice.

- Problem and complete intended outcome.
- Scope and exclusions.
- Current and intended behavior with concrete representative/boundary examples; distinguish required behavior from inspected implementation.
- Target responsibilities and flow at the depth needed to implement.
- Constraints, relevant alternatives, and agreed material tradeoffs.
- Acceptance criteria and verification approach, including operational or compatibility evidence where the contract requires it.
- Open questions, or an explicit statement that none remain.

Read only this task's active spec. A spec records requirements and intended checks; it must not claim future tests have passed. Return enough evidence and decisions for implementation without reconstructing the conversation.
