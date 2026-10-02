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

Translate expected dependency failures into a specific domain error only when the caller needs that distinction or the boundary can supply missing context. Preserve the cause and report safe operational context where the failure can be acted on. If the native exception already meets the contract, let it propagate.

```python
class DocumentPublishError(RuntimeError):
    pass


def publish(document: Document, client: Publisher) -> None:
    try:
        client.send(document)
    except ConnectionError as error:
        raise DocumentPublishError(
            f"Could not publish document {document.id}; check the connection and publication status"
        ) from error
```

## Use when

- Callers need distinct recovery behavior.
- A dependency error lacks meaningful operation context.
- Existing error reporting lacks the safe identifiers operators need to diagnose the failed operation.

## Avoid when

- The layer cannot add useful context.
- The error represents ordinary domain absence better modeled as a result.
- A native exception already gives the batch caller a clear failure and sufficient diagnostic context.
- The wrapper exists only to log and rethrow an unchanged failure already reported at another boundary.
- Translation would imply that retry is safe without knowing whether the original side effect occurred.

## Tradeoffs

Adds error types and translation code that must have a concrete consumer or diagnostic benefit. Translation does not implement recovery, make an operation safe to repeat, or require a lifecycle wrapper. Avoid combining it with an unrequested fallback that makes stale or partial results look successful.

## Related

- [[Failures Are Observable and Actionable]]
- [[Find Failure Observability Gaps]]
- [[Explicit Operational Contracts]]
