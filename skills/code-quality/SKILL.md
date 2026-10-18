---
name: code-quality
description: Assess code quality and guide coherent refactors using the agents-handbook principles, playbooks, and patterns. Use for requested refactors, code-quality reviews, maintainability assessments, change audits, or technical-debt prioritization.
---

# Code Quality

Use the handbook as the source of method and terminology. Produce evidence-backed findings and select the clearest, simplest architecture that satisfies established contracts. Minimize unnecessary complexity in the resulting system, not patch size; do not perform a generic style review.

For substantial implementation/refactors or materially unclear requirements, use [Define an Implementation Spec](../../knowledge/playbooks/Define%20an%20Implementation%20Spec.md), reusing an existing agreement. Implement the complete outcome coherently. When PR preparation is requested, [Prepare and Create Pull Requests](../../knowledge/playbooks/Prepare%20and%20Create%20Pull%20Requests.md) determines delivery boundaries after implementation.

## Procedure

1. Define the authorized scope. Read the project's AGENTS.md and relevant authoritative standards; apply local conventions and quality commands without copying them into this skill. For requested refactors, read [Refactoring Simplifies the Whole Workflow](../../knowledge/principles/Refactoring%20Simplifies%20the%20Whole%20Workflow.md) and [Design a Coherent Refactor](../../knowledge/playbooks/Design%20a%20Coherent%20Refactor.md). Before editing, trace configuration, data, computation, persistence, provenance, side effects, and relevant callers/consumers across the complete affected workflow.
2. Check applicability of every core knowledge route below and select domain routes relevant to the scope or project instructions. Read each applicable principle and playbook before searching the code. Record an inapplicable route briefly with its reason; do not force unrelated searches or findings.
3. For each route, search for concrete signals, inspect callers and tests, and group findings by the underlying invariant or behavior axis rather than by file.
4. Record verified findings or explicitly record no verified finding for each applicable principle. Merge overlapping route findings by underlying cause so the same issue is not counted repeatedly.
5. For candidate corrections, describe target responsibilities and data flow independently of current file boundaries; use a flowchart when ownership or sequencing is complex. Compare credible local and broader alternatives when materially different, using correctness, clarity, duplication, coupling, operational cost, migration risk, and verification effort. Link a pattern only when it fits the evidence.
6. Score verified finding/proposal pairs from 1 to 5 for criticality, architectural improvement, and refactor leverage using [Design a Coherent Refactor](../../knowledge/playbooks/Design%20a%20Coherent%20Refactor.md#ranking-and-design-selection). Identify each route's highest-priority finding and build a deduplicated ranked list. Prioritize demonstrated contract failures, then design quality and leverage; record implementation cost, migration risk, and verification effort separately. Do not sum patch size into architectural merit or assign defect scores to justified retained complexity. Select the strongest supported design for the authorized scope.
7. If implementation is authorized, complete the affected callers, tests, documentation, and automation and remove obsolete paths. Keep computation explicit and resource ownership distinct. Justify retained reloads, repeated validation, duplicated state, adapters, and persistence handoffs. Conditional explorer/implementer delegation follows the shared playbook; one integrating owner remains accountable.
8. Verify behavioral preservation and the intended architectural improvement with focused evidence and the repository's standard quality gate. Record unrun checks, remaining work, its reason, and residual risk. Consolidation, relocation, or green old tests alone do not establish architectural completion.

## Core knowledge routing

| Evidence or intent | Principle | Playbook | Typical pattern |
| --- | --- | --- | --- |
| Required state is nullable or validated repeatedly | [Boundary Validated State](../../knowledge/principles/Boundary%20Validated%20State.md) | [Find Boundary Validation Refactors](../../knowledge/playbooks/Find%20Boundary%20Validation%20Refactors.md) | [Validated Configuration Loader](../../knowledge/patterns/Validated%20Configuration%20Loader.md) or [Explicit Absence Model](../../knowledge/patterns/Explicit%20Absence%20Model.md) |
| Contracts are ambiguous, optionality is unclear, or callers defend repeatedly | [Explicit Operational Contracts](../../knowledge/principles/Explicit%20Operational%20Contracts.md) | [Find Contract Boundary Refactors](../../knowledge/playbooks/Find%20Contract%20Boundary%20Refactors.md) | [Actionable Domain Failure](../../knowledge/patterns/Actionable%20Domain%20Failure.md) or [Explicit Absence Model](../../knowledge/patterns/Explicit%20Absence%20Model.md) |
| Inheritance, conditionals, or direct construction hide a behavior variant | [Composition Defines Variation](../../knowledge/principles/Composition%20Defines%20Variation.md) | [Find Composition Refactors](../../knowledge/playbooks/Find%20Composition%20Refactors.md) | [Strategy Injection](../../knowledge/patterns/Strategy%20Injection.md) or [Registry-Based Selection](../../knowledge/patterns/Registry-Based%20Selection.md) |
| Raw settings, duplicated defaults, or hard-coded tunables reach core logic | [Configuration Is a Contract](../../knowledge/principles/Configuration%20Is%20a%20Contract.md) | [Find Configuration Contract Gaps](../../knowledge/playbooks/Find%20Configuration%20Contract%20Gaps.md) | [Validated Configuration Loader](../../knowledge/patterns/Validated%20Configuration%20Loader.md) |
| Independent collection transformations use row-by-row or element-by-element loops | [Bulk Operations Preserve Intent](../../knowledge/principles/Bulk%20Operations%20Preserve%20Intent.md) | [Find Bulk Data Refactors](../../knowledge/playbooks/Find%20Bulk%20Data%20Refactors.md) | [Bulk Transformation Pipeline](../../knowledge/patterns/Bulk%20Transformation%20Pipeline.md) |
| Errors are swallowed, vague, unsafe, or lack recovery context | [Failures Are Observable and Actionable](../../knowledge/principles/Failures%20Are%20Observable%20and%20Actionable.md) | [Find Failure Observability Gaps](../../knowledge/playbooks/Find%20Failure%20Observability%20Gaps.md) | [Actionable Domain Failure](../../knowledge/patterns/Actionable%20Domain%20Failure.md) |

Use [Verify a Change Against Quality Principles](../../knowledge/playbooks/Verify%20a%20Change%20Against%20Quality%20Principles.md) and [Focused Test Matrix](../../knowledge/patterns/Focused%20Test%20Matrix.md) for every substantive implementation or review conclusion.

## Domain knowledge routing

These routes extend the same evidence, ranking, and verification procedure when relevant. Do not claim statistical validity or production readiness from the core design sweep alone.

| Evidence or intent | Principle | Playbook |
| --- | --- | --- |
| Time-series features, ingestion, labels, or backtest validity | [Decisions Use Available Information](../../knowledge/principles/Decisions%20Use%20Available%20Information.md) | [Audit Temporal Data Validity](../../knowledge/playbooks/Audit%20Temporal%20Data%20Validity.md) |
| Model serving, promotion, inference, or external execution | [Serving Preserves the Model Contract](../../knowledge/principles/Serving%20Preserves%20the%20Model%20Contract.md) | [Audit Model Serving and Execution](../../knowledge/playbooks/Audit%20Model%20Serving%20and%20Execution.md) |

## Report

```markdown
## Code Quality Summary

Scope: [paths or subsystem]
Knowledge routes: [principle and playbook sweep performed]
Verification: [commands and result, or limitation]

### Principle sweep
- [Principle] -> [top verified finding, "no verified finding", or "not applicable" with reason]

### Must fix
- [criticality / architectural improvement / leverage] `path:line` - evidence and violated contract - proposed correction

### Should fix
- [criticality / architectural improvement / leverage] `path:line` - evidence - proposed correction

### Nice to have
- [criticality / architectural improvement / leverage] `path:line` - improvement

### Selected design
- Required contracts and current affected flow:
- Target responsibilities and data flow (diagram when useful):
- Credible alternatives and selection rationale:
- Pattern (only if applicable):
- Expected simplification and retained complexity:
- Implementation cost, migration risk, and verification effort:
- Behavioral and architectural evidence:
- Completion status, remaining work, reasons, and residual risks:
```

## Constraints

- Treat legitimate optional domain state and intentional sequential processing as non-findings.
- Do not equate a search match with a defect; inspect context and exceptions.
- Preserve required behavior, not accidental helpers, intermediate files, schemas, or lifecycle abstractions. A small change is appropriate when it fully resolves the cause and yields the strongest supported design.
- Keep work within requirements and constraints; do not infer permission for unrelated rewrites, speculative abstractions, behavior changes, or destructive migrations. Scale analysis and reporting to the decision; do not invent alternatives for a routine correction.
- Keep project-specific standards in the project, not in this reusable skill.
