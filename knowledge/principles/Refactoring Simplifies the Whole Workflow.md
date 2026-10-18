---
id: principles.refactoring_simplifies_the_whole_workflow
type: principle
status: [draft]
scope: [code-quality]
owner: julio
created: 2026-10-13
tags: [knowledge/principle]
---
# Refactoring Simplifies the Whole Workflow

## Statement

During a requested refactor, optimize for the clearest, simplest architecture that satisfies the established behavioral contracts. Minimize unnecessary complexity in the resulting system—not merely disruption to its current implementation.

## Why

A small diff can preserve an expensive or confusing workflow. Merging entrypoints or extracting a shared helper may reduce textual duplication while retaining redundant loading, hidden computation, and unnecessary persistence dependencies. Architectural completion depends on the resulting responsibilities and data flow.

## Implications

- Trace the complete affected workflow before editing: configuration, data, computation, persistence, provenance, side effects, callers, and consumers. Establish required behavior from evidence, including operational and compatibility requirements.
- Design target responsibilities and data flow independently of existing file boundaries. Use a flowchart when ownership or sequencing is complex.
- Existing helpers, intermediate files, context managers, schemas, and compatibility layers must justify their continued existence. Preserve required behavior, not accidental structure.
- Compare credible alternatives when a local patch and a broader coherent refactor differ materially. Evaluate correctness, clarity, duplication, coupling, operational cost, migration risk, and verification effort.
- Keep major computation visible as named workflow stages. Resource scopes own acquisition, release, transactions, or concrete lifecycle invariants; generic preparation abstractions should not conceal the algorithm merely to share code.
- Explain retained reloads, repeated validation, duplicated state, adapters, and persistence handoffs in terms of a required contract or demonstrated constraint.
- Finish the authorized refactor across callers, tests, documentation, and automation; remove obsolete paths. Passing old tests or consolidating files alone does not prove the design problem is resolved.

## Proportionality and limits

“Optimal” means the best-supported design for the stated requirements and constraints. A small patch is appropriate when it produces the strongest design. This principle does not authorize unrelated rewrites, speculative abstractions, behavior changes, or destructive migrations.

Necessary process boundaries, memory limits, restart checkpoints, external consumers, provenance, and new trust boundaries can justify persistence or revalidation. Identify the actual requirement rather than retaining complexity simply because it exists. If constraints prevent completion, state the remaining problem, reason, and required next step; label the result partial.

## Related

- [[Design a Coherent Refactor]]
- [[Configuration Is a Contract]]
- [[Boundary Validated State]]
- [[Composition Defines Variation]]
- [[Explicit Operational Contracts]]
- [[Verification Is Part of the Change]]
