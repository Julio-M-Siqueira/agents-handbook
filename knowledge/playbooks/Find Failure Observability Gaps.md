---
id: playbooks.find_failure_observability_gaps
type: playbook
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/playbook
aliases:
  - Audit Error Handling
---
# Find Failure Observability Gaps

## Goal

Find failure paths that lose context, silently continue, expose sensitive data, or prevent callers from taking the right recovery action.

## Preconditions

- Read [[Failures Are Observable and Actionable]].
- Identify the subsystem's external effects and operational logs.

## Steps

1. Search for broad exception handlers, empty handlers, generic error messages, unlogged failures, and fallback values returned after errors.
2. Trace each candidate from the original failure to the caller or operator-visible outcome.
3. Identify the layer that has enough context to classify and log the failure safely.
4. Group findings by lost context or unclear recovery behavior.
5. Score user or operational impact, probability of silent corruption, recoverability, and minimality from 1 to 5.
6. Select the most critical localized fix: preserve a cause, introduce a domain error, log safe context, or return an explicit result state.
7. Add success, translated-failure, and recovery tests as applicable.

## Example

```python
# Candidate: the failure disappears and callers cannot react.
try:
    send_receipt(receipt)
except Exception:
    return False

# Refactor target: retain a meaningful recovery contract.
except ConnectionError as error:
    raise ReceiptDeliveryError(receipt.id) from error
```

Rank it more highly when the `False` result can be mistaken for a valid business outcome.
## Validation

- Can a caller distinguish retryable, invalid-input, and terminal failure paths?
- Does the message explain what failed and what action is possible?
- Is the original cause preserved where useful?
- Are secrets and sensitive payloads excluded from logs and errors?

## Failure handling

If the desired recovery policy is unknown, report the ambiguity as the finding. Do not silently choose retry, skip, or fallback behavior.

## Related

- [[Failures Are Observable and Actionable]]
- [[Actionable Domain Failure]]
- [[Explicit Operational Contracts]]

