---
name: pr-description
description: Write review-ready PR descriptions with concrete base/head behavior examples, verification evidence, source references, and embedded before/after flow visuals. Use for an established PR scope or description update; it does not choose delivery boundaries or publish PRs.
---
# PR Description

Explain an established change to a reviewer who has not seen the conversation. The caller follows [Prepare and Create Pull Requests](../../knowledge/playbooks/Prepare%20and%20Create%20Pull%20Requests.md) and owns delivery, authorization, and final validation.

## Inputs

Receive the assigned PR contract, exact base/head revisions, relevant spec decisions, project conventions, dependency plan, durable series-overview location when applicable, and verification record. Inspect the relevant diff, callers, and tests. Identify uncommitted changes affecting the comparison. If boundaries are unresolved, return that need to the caller or [pr-delivery](../pr-delivery/SKILL.md); do not invent a scope or claim a guessed revision was inspected.

## Writing

1. Use the single [description template](assets/pr-description.md), adapting headings to host conventions while preserving the opening behavior table followed by the visual. Lead examples with the concrete problem and resulting behavior; omit task chronology and abandoned approaches unless needed to explain a tradeoff.
2. Use representative and consequential boundary/failure inputs. For each, state base and head behavior, evidence and result, and relevant source references. Behavior-preserving refactors explicitly show the same result; the visual explains the structural improvement. Label proposed expectations, synthetic examples, inspected source conclusions, and executed reproductions accurately.
3. Cite verified file/line locations at the appropriate base or head revision. Prefer immutable host links for durable PR text; do not publish local filesystem links as reviewer evidence. If table references are crowded, point to a nearby annotated code comparison carrying those references. Code references locate implementation; test/reproduction references and results establish verification. Preserve both.
4. Invoke [visual-explanation](../visual-explanation/SKILL.md) in embedded mode with the concrete question, exact source comparison, consistent example values, and PR-host Markdown constraints. Include a focused before/after flow view; for a local change, pair compact flow sketches with annotated code where useful. Use native Mermaid when supported, otherwise a readable Markdown flow/sequence with labeled steps and source-linked snippets. Do not depend on a local HTML file or add lessons, exercises, or quizzes. Preserve important ordering, ownership, failures, and side effects; label simplifications.
5. Explain the implementation and consequential decisions briefly. Record actual commands/results and material limitations; never present unrun checks as passed. Include dependencies, merge/deployment order, and relevant operational steps. Scope detail to the change while retaining the required table and visual.
6. For stacked PRs, primarily compare this PR's immediate base with its head. Link to the durable overview comparing original master (or the named target branch) with the final series outcome. Make this PR independently understandable; do not attribute a predecessor's behavior change to it. Do not rely on an active spec link that will be deleted.
7. Verify table, visual, snippets, tests, and references against the same revisions. On updates, rewrite around the final scope and refresh stale comparisons. Return the title, complete description, and any unresolved evidence gaps to the caller; writing does not authorize publication.
