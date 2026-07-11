---
id: patterns.strategy_injection
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
  - Injected Strategy
---
# Strategy Injection

## Problem

An orchestrator embeds several behavior variants through conditionals, subclass overrides, or direct construction of concrete collaborators.

## Context

One workflow is stable, but one policy or mechanism changes independently: pricing, serialization, validation, storage, retry, routing, or calculation.

## Solution

Define a narrow behavior contract and provide the implementation as a collaborator. Keep orchestration responsible for sequence and outcome, while the strategy owns the variable behavior.

```python
from typing import Protocol


class Formatter(Protocol):
    def __call__(self, report: Report) -> str: ...


class ReportService:
    def __init__(self, formatter: Formatter) -> None:
        self._formatter = formatter

    def render(self, report: Report) -> str:
        return self._formatter(report)
```

## Use when

- Behavior varies while the surrounding workflow remains stable.
- Variants need independent tests.
- A subclass exists mainly to replace one method.

## Avoid when

- The variation is a one-off branch with no likely reuse.
- The collaborator would need access to most of the orchestrator's private state.

## Tradeoffs

Adds one explicit dependency and a small interface, but makes variation visible and testable.

## Related

- [[Composition Defines Variation]]
- [[Find Composition Refactors]]
- [[Registry-Based Selection]]

