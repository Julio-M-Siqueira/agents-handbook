---
id: patterns.bulk_transformation_pipeline
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
  - Declarative Data Transformation
---
# Bulk Transformation Pipeline

## Problem

A collection transformation is implemented as a loop that interleaves filtering, mapping, aggregation, and mutable accumulation.

## Context

Each output can be computed from input values and explicit grouping or ordering rules, without per-item external side effects.

## Solution

Represent the work as a sequence of bulk stages: select relevant data, transform values, group or aggregate, then return a named result.

```python
def total_by_customer(orders: DataFrame) -> Series:
    paid_orders = orders.loc[orders["status"].eq("paid")]
    return paid_orders.groupby("customer_id")["amount"].sum()
```

## Use when

- The same transformation applies independently to many values.
- The volume is material or the loop obscures the data rules.
- The underlying collection API supports bulk operations.

## Avoid when

- The next item depends on prior mutable state.
- The loop performs required external effects.
- Bulk syntax would hide essential domain sequencing.

## Tradeoffs

Requires care with nulls, ordering, and grouping, but makes data semantics visible and often improves performance.

## Related

- [[Bulk Operations Preserve Intent]]
- [[Find Bulk Data Refactors]]
- [[Verification Is Part of the Change]]
