---
id: patterns.actionable_domain_failure
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
  - Contextual Domain Error
---
# Actionable Domain Failure

## Problem

A low-level error reaches callers without domain context, or a broad handler hides the error behind a fallback value.

## Context

The current layer understands the operation, safe identifiers, and the recovery category better than the underlying dependency does.

## Solution

Translate expected dependency failures into a specific domain error, preserve the cause, and log safe operational context where the failure can be acted on.

```python
class DocumentPublishError(RuntimeError):
    pass


def publish(document: Document, client: Publisher) -> None:
    try:
        client.send(document)
    except ConnectionError as error:
        raise DocumentPublishError(
            f"Could not publish document {document.id}; retry later"
        ) from error
```

## Use when

- Callers need distinct recovery behavior.
- A dependency error lacks meaningful operation context.
- A failure must be observable to operators.

## Avoid when

- The layer cannot add useful context.
- The error represents ordinary domain absence better modeled as a result.

## Tradeoffs

Adds error types and translation code, but produces clearer recovery behavior and diagnostics.

## Related

- [[Failures Are Observable and Actionable]]
- [[Find Failure Observability Gaps]]
- [[Explicit Operational Contracts]]
