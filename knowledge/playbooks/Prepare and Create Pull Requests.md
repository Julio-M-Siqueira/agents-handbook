---
id: playbooks.prepare_and_create_pull_requests
type: playbook
status: [draft]
scope: [engineering-workflow]
owner: julio
created: 2026-10-18
tags: [knowledge/playbook]
---
# Prepare and Create Pull Requests

## Goal

Deliver a completed implementation through cohesive, reviewable PRs whose resulting states are testable and safe to deploy after their predecessors.

## When to use

Use when tasked with preparing or opening PRs. Ordinary implementation does not automatically start delivery. Preparing a plan or description does not authorize publishing, merging, deployment, or destructive history changes. Continue routine work within existing authorization without repeated approval.

## Workflow

1. Establish the complete outcome, relevant spec or task acceptance criteria, actual changes, exact starting base and final head, repository standards, and verification evidence. Identify existing staged/uncommitted work and preserve unrelated changes. Inspect [Verification Is Part of the Change](../principles/Verification%20Is%20Part%20of%20the%20Change.md).
2. Invoke [pr-delivery](../../skills/pr-delivery/SKILL.md) after implementation to assess behavioral contracts and propose PR boundaries, dependencies, intermediate-state verification, and deployment conditions. Preserve coherent implementation; do not demand earlier speculative separation. Scale a single clear PR to a brief assessment.
3. Construct the proposed states within authorization, using separate branches/checkouts as appropriate. Keep each PR's necessary callers, tests, documentation, and configuration together. Do not overwrite unrelated work or rewrite published history without authorization. Run each state's focused checks and repository quality gate as applicable, plus relevant combined integration verification. Final-head tests alone do not establish intermediate-state correctness. Revise or combine slices when evidence does not support a split; report unresolved limitations explicitly.
4. Invoke [pr-description](../../skills/pr-description/SKILL.md) for each established boundary with its exact base/head, behavioral contract, relevant spec decisions, dependency plan, code evidence, and actual verification results. It invokes [visual-explanation](../../skills/visual-explanation/SKILL.md) for embedded before/after views.
5. For a series, prepare one durable overview with original-master-to-final behavior, the complete outcome, PR links or prepared branch identities, dependency/merge order, safe deployment conditions, and combined verification. Link each PR to it. The overview can live in the first PR description or an established tracking artifact; do not create a permanent spec archive. Each PR primarily compares its own base/head and remains understandable on its own.
6. Preserve lasting knowledge and perform active-spec cleanup according to [Define an Implementation Spec](Define%20an%20Implementation%20Spec.md#completion-and-incomplete-work). Include cleanup in an appropriate PR and refresh affected checks, base/head identities, source references, descriptions, and overview before finalizing. Do not claim cleanup complete while delivery is incomplete.
7. Create or update PRs when authorized, using the host's native Markdown and concrete descriptions. After any operation that changes a PR base/head, refresh the affected comparison and verification evidence. Deliver all authorized slices and integration evidence; a series is not permission to stop after its first PR. End with PR links or prepared artifacts, merge/deployment order, verification results, and any remaining work. If creation is blocked after spec removal, restore the active spec with the outstanding delivery work.

## Delegation and handoffs

Use specialized subagents when independent work justifies coordination. Keep one integrating owner accountable. Provide each specialist the objective, applicable instructions, agreed decisions, exact sources/revisions, verification results, expected artifact, and authorization limits. Missing evidence must be surfaced, not guessed.

- Delivery specialist: complete spec or task contract, final implementation and starting base, standards, and verification evidence; returns the delivery plan and unmet evidence needs.
- Description specialist: assigned scope, exact base/head, relevant decisions, delivery plan, and verification record; inspects source and returns the description with embedded visuals.
- Visual specialist, when useful: concrete question, inspected source evidence, exact comparison, example values, and host Markdown format; returns an embeddable view and captions.

Descriptions can be prepared independently once boundaries and revisions are stable. Keep mutations to shared branches and final integration under the integrating owner.

## Validation

- Every accepted requirement is covered by the complete delivery; each PR has a concrete review decision.
- Every resulting state is testable and safe to deploy after named predecessors, with its own evidence. Coupled changes stay together when separation cannot establish this contract.
- Tests and documentation accompany their behavior changes; essential evidence is not deferred to a final tests-only PR.
- Before/after examples, visuals, and source references agree with actual revisions; unrun checks and operational limitations are explicit.
- Durable handoff supports removal of completed specs without relying on merges or loading unrelated specs.
