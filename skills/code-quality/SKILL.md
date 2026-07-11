---
name: code-quality
description: Discover, rank, and recommend minimal code-quality refactors using the agents-handbook principles, playbooks, and patterns. Use when asked to review code quality, find refactoring opportunities, assess maintainability, audit a change, or prioritize technical debt.
---

# Code Quality

Use the handbook as the source of method and terminology. Produce evidence-backed findings and a minimal refactor recommendation; do not perform a generic style review.

## Procedure

1. Define the review scope and identify public boundaries, side effects, data transformations, configuration, and extension points.
2. Iterate through every knowledge route below. For each route, read its principle and playbook before searching the code.
3. For each route, search for concrete signals, inspect callers and tests, and group findings by the underlying invariant or behavior axis rather than by file.
4. For each route, record the highest-priority verified finding, or explicitly record that no verified finding was found for that principle.
5. Score each route winner from 1 to 5 for criticality, refactor leverage, and minimality. Use the route winners to build the final ranked list.
6. Select the smallest refactor that resolves the highest-ranked cause across all route winners. Link the selected refactor to a pattern only when the pattern fits the evidence.
7. Verify changed contracts with focused tests and the repository's standard quality gate. Record unrun checks and residual risk.

## Knowledge routing

| Evidence or intent | Principle | Playbook | Typical pattern |
| --- | --- | --- | --- |
| Required state is nullable or validated repeatedly | [Boundary Validated State](../../knowledge/principles/Boundary%20Validated%20State.md) | [Find Boundary Validation Refactors](../../knowledge/playbooks/Find%20Boundary%20Validation%20Refactors.md) | [Validated Configuration Loader](../../knowledge/patterns/Validated%20Configuration%20Loader.md) |
| Contracts are ambiguous, optionality is unclear, or callers defend repeatedly | [Explicit Operational Contracts](../../knowledge/principles/Explicit%20Operational%20Contracts.md) | [Find Contract Boundary Refactors](../../knowledge/playbooks/Find%20Contract%20Boundary%20Refactors.md) | [Actionable Domain Failure](../../knowledge/patterns/Actionable%20Domain%20Failure.md) |
| Inheritance, conditionals, or direct construction hide a behavior variant | [Composition Defines Variation](../../knowledge/principles/Composition%20Defines%20Variation.md) | [Find Composition Refactors](../../knowledge/playbooks/Find%20Composition%20Refactors.md) | [Strategy Injection](../../knowledge/patterns/Strategy%20Injection.md) or [Registry-Based Selection](../../knowledge/patterns/Registry-Based%20Selection.md) |
| Raw settings, duplicated defaults, or hard-coded tunables reach core logic | [Configuration Is a Contract](../../knowledge/principles/Configuration%20Is%20a%20Contract.md) | [Find Configuration Contract Gaps](../../knowledge/playbooks/Find%20Configuration%20Contract%20Gaps.md) | [Validated Configuration Loader](../../knowledge/patterns/Validated%20Configuration%20Loader.md) |
| Independent collection transformations use row-by-row or element-by-element loops | [Bulk Operations Preserve Intent](../../knowledge/principles/Bulk%20Operations%20Preserve%20Intent.md) | [Find Bulk Data Refactors](../../knowledge/playbooks/Find%20Bulk%20Data%20Refactors.md) | [Bulk Transformation Pipeline](../../knowledge/patterns/Bulk%20Transformation%20Pipeline.md) |
| Errors are swallowed, vague, unsafe, or lack recovery context | [Failures Are Observable and Actionable](../../knowledge/principles/Failures%20Are%20Observable%20and%20Actionable.md) | [Find Failure Observability Gaps](../../knowledge/playbooks/Find%20Failure%20Observability%20Gaps.md) | [Actionable Domain Failure](../../knowledge/patterns/Actionable%20Domain%20Failure.md) |

Use [Verify a Change Against Quality Principles](../../knowledge/playbooks/Verify%20a%20Change%20Against%20Quality%20Principles.md) and [Focused Test Matrix](../../knowledge/patterns/Focused%20Test%20Matrix.md) for every substantive implementation or review conclusion.

## Report

```markdown
## Code Quality Summary

Scope: [paths or subsystem]
Knowledge routes: [principle and playbook sweep performed]
Verification: [commands and result, or limitation]

### Principle sweep
- [Principle] -> [top verified finding, or "no verified finding"]

### Must fix
- [criticality] `path:line` - evidence and violated contract - minimal refactor

### Should fix
- [priority score] `path:line` - evidence - minimal refactor

### Nice to have
- [priority score] `path:line` - improvement

### Selected minimal refactor
- Invariant:
- Boundary or behavior axis:
- Pattern:
- Expected simplification:
- Risk and tests:
```

## Constraints

- Treat legitimate optional domain state and intentional sequential processing as non-findings.
- Do not equate a search match with a defect; inspect context and exceptions.
- Prefer a localized contract, factory, collaborator, or boundary change over broad redesign.
- Keep project-specific standards in the project, not in this reusable skill.
