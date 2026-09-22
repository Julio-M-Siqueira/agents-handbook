---
id: patterns.policy_pipeline
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
  - Composed Policies
  - Policy Chain
---
# Policy Pipeline

## Problem

Boolean flags and nested conditionals select or combine rules inside an otherwise stable workflow. Adding a rule increases branching and makes rule order hard to test.

## Context

Several independent rules operate on the same request and have a meaningful, explicit order. Each rule can return an allow decision or stop the pipeline with a denial.

## Solution

Represent each rule as a small callable with one result contract. Run a configured sequence in order, stopping at the first failure. Resolve configured names at the boundary through a validated registry.

```python
from collections.abc import Callable, Sequence

Policy = Callable[[Request], None]


def apply_policies(request: Request, policies: Sequence[Policy]) -> None:
    for policy in policies:
        policy(request)
```

A policy raises a meaningful denial error when its rule fails; successful policies return normally. The registry belongs outside `apply_policies`, after configuration has been validated.

## Use when

- Rules can be added, removed, or ordered independently.
- Configuration selects from an explicit set of trusted rules.
- Every caller should receive the same rule order and failure contract.

## Avoid when

- One conditional expresses a stable, local domain decision.
- Rules require hidden shared mutable state or an unclear execution order.

## Tradeoffs

The pipeline makes rule order and selection explicit. It adds a registry and a small result contract, both of which need focused tests.

## Related

- [[Strategy Injection]]
- [[Registry-Based Selection]]
- [[Configuration Is a Contract]]
- [[Failures Are Observable and Actionable]]
- [[Design Patterns Video Series]]
