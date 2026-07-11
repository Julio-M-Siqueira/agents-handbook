---
id: principles.failures_are_observable_and_actionable
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
  - Actionable Failures
  - Observable Errors
---
# Failures Are Observable and Actionable

## Statement

A failure should preserve enough structured context for a caller or operator to understand what failed, why it failed, and what action is appropriate, without exposing sensitive data.

## Why

Silent fallback, broad exception handling, and vague messages turn correctable faults into long investigations. A visible, bounded failure contract enables recovery decisions and makes production behavior diagnosable.

## Example

```python
try:
    gateway.send(invoice)
except TimeoutError as error:
    logger.warning("Invoice delivery timed out: invoice_id=%s", invoice.id)
    raise DeliveryRetryableError(
        f"Invoice {invoice.id} could not be delivered; retry later"
    ) from error
```

The caller receives a recoverable domain failure, while operations retain a safe identifier and the original cause.
## Implications

- Catch only errors that the current layer can handle, translate, or enrich.
- Use domain-specific error types where callers need distinct recovery behavior.
- Preserve the original cause when translating an error.
- Log failures at the layer that has operational context, with stable identifiers and no secrets.
- Make intentional recovery, retry, skip, or fallback behavior explicit in the result or log.
- Fail before irreversible work when a required invariant is missing.

## Exceptions

- Expected absence can be modeled as a result variant rather than an exception.
- Low-level libraries may expose their native errors when higher layers can interpret them directly.
- Security boundaries may intentionally omit sensitive details from user-visible errors while retaining safe diagnostic context in logs.

## Related

- [[Find Failure Observability Gaps]]
- [[Actionable Domain Failure]]
- [[Boundary Validated State]]
- [[Explicit Operational Contracts]]

