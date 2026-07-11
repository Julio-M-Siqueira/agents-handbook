---
id: patterns.registry_based_selection
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
  - Strategy Registry
---
# Registry-Based Selection

## Problem

A growing conditional chain selects an implementation from a name, type, or configuration value.

## Context

The set of supported implementations is explicit, selection is data-driven, and callers should not know concrete implementation details.

## Solution

Own a mapping from validated keys to constructors or strategy instances at the extension boundary. Validate keys before the core workflow runs.

```python
FORMATTERS: dict[str, type[Formatter]] = {
    "json": JsonFormatter,
    "text": TextFormatter,
}


def resolve_formatter(kind: str) -> Formatter:
    try:
        return FORMATTERS[kind]()
    except KeyError as error:
        raise ValueError(f"Unsupported formatter: {kind}") from error
```

## Use when

- New implementations are added independently.
- Selection comes from configuration or an external request.
- Conditional selection is repeated across callers.

## Avoid when

- Construction requires a complex lifecycle better owned by a factory.
- The mapping is dynamic, untrusted, or has unclear ownership.

## Tradeoffs

Centralizes supported variants and validation, but adds a registration point that must be kept complete and tested.

## Related

- [[Composition Defines Variation]]
- [[Strategy Injection]]
- [[Configuration Is a Contract]]
