---
id: playbooks.review_code_quality
type: playbook
status: [draft]
scope: [code-quality]
owner: julio
created: 2026-10-18
tags: [knowledge/playbook]
---
# Review Code Quality

## Goal and trigger

Coordinate requested refactors, code-quality reviews, refactor discovery, maintainability assessments, and substantive implementation verification through one shared method.

## Workflow

1. Establish the authorized task and relevant project instructions. A review authorizes findings and recommendations; implementation and delivery follow the user's actual scope. Load project standards and conditional references only where the task makes them applicable.
2. Invoke the [code-quality skill](../../skills/code-quality/SKILL.md). It owns the complete core/domain knowledge routing, evidence sweep, ranking, report, and verification procedure. Project adapters supply local requirements and commands; they do not maintain another copy of that method.
3. For authorized substantial implementation or unresolved requirements, reuse the agreement or follow [Define an Implementation Spec](Define%20an%20Implementation%20Spec.md). For refactors, the skill applies [Design a Coherent Refactor](Design%20a%20Coherent%20Refactor.md), which owns target-flow design, alternative selection, scoring, delegation, and architectural acceptance. When PR preparation is requested after implementation, follow [Prepare and Create Pull Requests](Prepare%20and%20Create%20Pull%20Requests.md).

## Handoff and verification

The skill returns evidence-backed findings or an explicit no-finding result, relevant verification results, and remaining limits. Keep one integrating owner responsible for the authorized outcome. Validate routing with the applicable project standards and the skill's full route index rather than a second checklist here.
