---
id: patterns.focused_test_matrix
type: pattern
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/pattern
aliases:
  - Contract Test Matrix
---
# Focused Test Matrix

## Problem

Tests cover only the happy path or rely on a broad end-to-end suite to reveal a local contract regression.

## Context

A changed unit has a clear set of success, invalid-input, dependency-failure, and boundary behaviors.

## Solution

List the contract cases first, then add the smallest focused tests that prove each meaningful branch. Use a wider quality gate as confirmation rather than the only evidence.

```text
Case                 Expected result
valid input          successful domain result
invalid input        explicit validation failure
dependency failure   translated or propagated contract error
boundary value       documented edge behavior
```

## Example

```python
@pytest.mark.parametrize("attempts", ["0", "-1"])
def test_rejects_non_positive_attempts(attempts: str) -> None:
    with pytest.raises(ValueError, match="at least 1"):
        load_retry_settings({"RETRY_ATTEMPTS": attempts})


def test_uses_default_attempts() -> None:
    assert load_retry_settings({}).attempts == 3
```

The examples name the contract cases directly: default success and invalid boundary values.
## Use when

- A refactor changes contracts, validation, error handling, or data transformations.
- A bug fix has a reproducible failure mode.
- A public operation has several meaningful outcomes.

## Avoid when

- The behavior is already fully covered by a stable, narrow test that directly asserts the same contract.
- The matrix would merely duplicate framework behavior with no application assertion.

## Tradeoffs

Requires identifying behavior explicitly, but makes tests a compact specification and shortens debugging feedback.

## Related

- [[Verification Is Part of the Change]]
- [[Verify a Change Against Quality Principles]]
- [[Explicit Operational Contracts]]

