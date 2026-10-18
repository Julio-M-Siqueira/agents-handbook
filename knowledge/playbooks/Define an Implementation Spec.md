---
id: playbooks.define_an_implementation_spec
type: playbook
status: [draft]
scope: [engineering-workflow]
owner: julio
created: 2026-10-18
tags: [knowledge/playbook]
---
# Define an Implementation Spec

## Goal

Agree on the complete project outcome before substantial implementation, using proportionate requirements discovery. Keep active specifications useful and temporary.

## When to use

Use for substantial changes or refactors, explicit requirements or design discussions, or materially open requirements. A small, clear change can use the task's acceptance examples without a separate spec file. A request to discuss requirements authorizes discussion and drafting, not implementation.

## Workflow

1. Establish the requested scope, existing agreements, relevant project standards, and inspected behavior. Apply [Explicit Operational Contracts](../principles/Explicit%20Operational%20Contracts.md). Load only the spec relevant to this task, if one already exists.
2. Invoke [spec-description](../../skills/spec-description/SKILL.md) with the objective, established preferences, repository context, evidence, and uncertainties. Use focused questions to resolve material behavior and tradeoffs. Seek agreement on unresolved choices before dependent implementation; do not repeat approvals for established requirements.
3. For substantial authorized implementation, save the current agreement in `specs/active/<task-slug>.md` in the target repository, using an established project convention when available. For discussion-only work, return a draft unless saving is requested or already authorized. The file is ordinary versionable source; avoid a permanent archive, transcript, or automatic loading of all specs. Record outcome, scope, current/intended examples, target flow, constraints, acceptance criteria, verification approach, and open questions.
4. Implement the complete authorized outcome coherently. For refactors, use [Design a Coherent Refactor](Design%20a%20Coherent%20Refactor.md). Do not prescribe PR boundaries or require speculative separation. Update the agreement when evidence changes; discuss newly unclear behavior or material tradeoffs before implementing those decisions. Continue independent work where possible.
5. Verify completion against the spec. When PR preparation is requested, hand the implemented outcome to [Prepare and Create Pull Requests](Prepare%20and%20Create%20Pull%20Requests.md); retain the spec through that delivery phase.
6. At completed delivery handoff, preserve lasting contracts in maintained project documentation and examples, references, verification results, and dependencies in self-contained PR descriptions or other delivery artifacts. Remove the active spec and include that removal in the final change. Refresh any affected revision references and verification after cleanup. Handoff does not wait for PR merges. Without PRs, use maintained documentation and the final task handoff for the necessary information.

## Completion and incomplete work

Cleanup requires the complete outcome to satisfy its acceptance criteria, with the agreed evidence and durable handoff available. Git history preserves previously committed versions; descriptions must not depend on a link to a deleted spec. If implementation, required verification, or delivery remains incomplete, retain the spec with explicit remaining work and reasons. Never delete based on age or describe partial completion as finished. Do not remove another task's spec.

## Delegation

Delegate focused discovery when useful, not by default. Give the specialist the user objective, agreed decisions, relevant sources and revisions, unresolved questions, intended output, and action limits. The specialist returns the spec and focused questions rather than inferring missing preferences. One integrating owner manages user agreement, implementation, verification, and cleanup; full chat history is not required.

## Validation

- Can the implementer identify the complete outcome and acceptance examples without reconstructing the discussion?
- Are observed behavior, proposals, unresolved questions, and authorized work distinguishable?
- Can coherent implementation proceed without preserving hypothetical PR boundaries?
- Is durable information preserved before cleanup, and incomplete work still represented?

## Related

- [Verification Is Part of the Change](../principles/Verification%20Is%20Part%20of%20the%20Change.md)
- [Prepare and Create Pull Requests](Prepare%20and%20Create%20Pull%20Requests.md)
