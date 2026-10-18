---
id: principles.verification_is_part_of_the_change
type: principle
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/principle
aliases:
  - Executable Quality Gates
  - Change Verification
---
# Verification Is Part of the Change

## Statement

A change is not complete until the relevant automated and reviewable evidence shows that its contract still holds and its intended improvement has been achieved.

## Why

Code can look locally correct while violating integration behavior, error contracts, types, formatting, security expectations, or performance constraints. Focused verification converts those assumptions into evidence before the change reaches a wider audience.

## Example

```python
def test_rejects_zero_retry_attempts() -> None:
    with pytest.raises(ValueError, match="at least 1"):
        load_retry_settings({"RETRY_ATTEMPTS": "0"})
```

This test proves the failure contract introduced by the configuration boundary, rather than merely exercising its successful path.
## Implications

- Choose checks that match the risk: unit tests for behavior, integration tests for boundaries, static checks for contracts, and targeted performance checks for bulk paths.
- Test both successful and failure behavior when a unit defines an error contract.
- Keep tests near the behavior they verify and make them readable as contract examples.
- Run the repository's standard quality gate before declaring a substantive change complete.
- For refactors, verify the target responsibilities and data flow as well as behavioral preservation. Passing old tests alone does not show that unnecessary loading, persistence, duplicated state, or hidden computation was removed. Use [[Design a Coherent Refactor]] for architectural acceptance criteria.
- Confirm migration of affected callers, documentation, and automation. Explain retained complexity and distinguish incomplete implementation from incomplete verification; neither supports an unqualified completion claim.
- Treat a failed check as a finding to understand, not a result to suppress.
- For deployment-facing changes, include evidence for configuration loading, dependency failures, monitoring signals, and startup or rollback behavior when those concerns are part of the changed contract.

## Exceptions

- Documentation-only and mechanically generated changes may need narrower verification.
- An unavailable integration dependency can justify a documented partial verification result, not an unqualified completion claim.
- Exploratory work may defer full verification, but should label its conclusions as provisional.

## Related

- [[Verify a Change Against Quality Principles]]
- [[Focused Test Matrix]]
- [[Explicit Operational Contracts]]
- [[Software Design in Python Video Series]]
