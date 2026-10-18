---
name: pr-delivery
description: Assess completed changes and propose cohesive PR boundaries, dependencies, intermediate-state verification, and safe deployment order. Use during requested PR preparation or delivery, after implementation; it does not prescribe speculative implementation separation or publish PRs.
---
# PR Delivery

Assess the actual complete implementation and return an evidence-backed delivery plan. [Prepare and Create Pull Requests](../../knowledge/playbooks/Prepare%20and%20Create%20Pull%20Requests.md) owns construction, execution, publishing, and final handoff.

## Inputs

Use the agreed spec or task contract, starting base and final implementation revisions, any relevant local modifications, project standards, actual verification results, and action limits. Inspect needed callers, tests, persistence, configuration, and consumers. A delegated specialist needs this focused evidence, not full chat history. Identify missing inputs rather than assuming completion or safety.

## Assessment

1. Compare the actual changes with the complete agreed outcome. Identify uncovered requirements, unrelated additions, and incomplete verification; do not silently omit work to make a cleaner series.
2. Group changes by behavioral contract and human review decision. Prefer separate PRs for independent behavioral changes. File count, line limits, shared project membership, and a good description alone do not justify boundaries.
3. Accept dependent PRs when each resulting state is testable and safe to deploy after named predecessors. Keep callers, regression tests, relevant configuration, and documentation with each behavior. Final integration evidence supplements each PR's evidence; it cannot replace it.
4. Trace proposed intermediate states across real contracts. Keep coupled changes together when separation leaves inconsistent consumers, unsafe persistence or migration states, or requires temporary machinery solely to create smaller PRs. Explain the concrete coupling. Do not retroactively require implementation to preserve hypothetical separation.
5. State each PR's exact intended base or predecessor, scope, verification requirements, and deployment conditions. Cover relevant startup, compatibility, restart, migration, or failure semantics when affected. Cross-repository changes must identify compatible revisions and release order; coordinated release alone does not prove that an intermediate PR is safe. Group work that cannot meet the safety contract, or explicitly report an unresolved delivery constraint.
6. Distinguish proposed checks from executed results. Recommend evidence for every constructed state and the combined result. If available evidence cannot establish a split, recommend a coherent larger unit or name the unresolved limitation. Never claim deployability from final-head tests alone.

## Output

| PR / review decision | Behavioral contract | Base / predecessors | Included changes | Verification required and results available | Deployment conditions |
| --- | --- | --- | --- | --- | --- |

Follow the table with the rationale for retained coupling, complete-outcome coverage, combined verification, and unmet evidence needs. A single clear PR needs only a brief equivalent assessment. Return the proposal to the integrating owner; this skill does not create branches, rewrite history, publish PRs, or deploy.
