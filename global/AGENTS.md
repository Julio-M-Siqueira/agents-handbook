# Global Agent Instructions

## Code Quality Procedure

For code-quality reviews, refactor discovery, maintainability assessments, or substantive implementation verification, use the [code-quality skill](../skills/code-quality/SKILL.md).

1. Select a principle and its linked playbook before searching or reviewing.
2. Gather contextual evidence and group findings by invariant or behavior axis.
3. Rank findings from 1 to 5 for criticality, refactor leverage, and minimality.
4. Recommend the highest-value minimal refactor, using a linked pattern only when it fits.
5. Verify the affected contract with focused tests and the repository's standard quality gate.

Core knowledge routes:

- [Boundary Validated State](../knowledge/principles/Boundary%20Validated%20State.md) -> [Find Boundary Validation Refactors](../knowledge/playbooks/Find%20Boundary%20Validation%20Refactors.md)
- [Composition Defines Variation](../knowledge/principles/Composition%20Defines%20Variation.md) -> [Find Composition Refactors](../knowledge/playbooks/Find%20Composition%20Refactors.md)
- [Configuration Is a Contract](../knowledge/principles/Configuration%20Is%20a%20Contract.md) -> [Find Configuration Contract Gaps](../knowledge/playbooks/Find%20Configuration%20Contract%20Gaps.md)
- [Bulk Operations Preserve Intent](../knowledge/principles/Bulk%20Operations%20Preserve%20Intent.md) -> [Find Bulk Data Refactors](../knowledge/playbooks/Find%20Bulk%20Data%20Refactors.md)
- [Failures Are Observable and Actionable](../knowledge/principles/Failures%20Are%20Observable%20and%20Actionable.md) -> [Find Failure Observability Gaps](../knowledge/playbooks/Find%20Failure%20Observability%20Gaps.md)

Do not report an unverified assumption as a finding. State unrun checks, project-specific standards, and residual risk explicitly.
