---
id: patterns.validated_parameter_object
type: pattern
status:
  - draft
scope:
  - code-quality
owner: julio
created: 2026-09-19
tags:
  - knowledge/pattern
aliases:
  - Parameter Object
  - Validated Query Object
---
# Validated Parameter Object

## Problem

Several operations accept the same related arguments, repeatedly validate them, or must evolve together. Their long parameter lists hide a coherent concept.

## Context

The arguments describe one request, query, command, or configuration value. Core operations need that value in a ready, valid state.

## Solution

Model the related values as one immutable object that validates its own invariant at construction. Pass that object to the operations that use the whole concept.

```python
from dataclasses import dataclass


@dataclass(frozen=True)
class SearchQuery:
    term: str
    page: int = 1
    include_archived: bool = False

    def __post_init__(self) -> None:
        if not self.term.strip():
            raise ValueError("Search term is required")
        if self.page < 1:
            raise ValueError("Page must be at least 1")
```

The service can accept `SearchQuery` without repeating checks for its required state.

## Use when

- The values are meaningful together and travel together through several operations.
- One validation boundary can establish their shared invariants.
- Adding a field would otherwise require coordinated signature changes.

## Avoid when

- The arguments are unrelated dependencies; inject those collaborators separately.
- The object becomes a broad bag of fields used by unrelated workflows.

## Tradeoffs

The object makes a concept explicit and localizes validation, but it can create coupling when it crosses boundaries that need only a small subset. Keep it narrow and immutable.

## Related

- [[Boundary Validated State]]
- [[Explicit Operational Contracts]]
- [[Validated Configuration Loader]]
- [[Design Patterns Video Series]]
