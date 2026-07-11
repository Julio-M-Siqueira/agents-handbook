---
id: principles.bulk_operations_preserve_intent
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
  - Declarative Bulk Processing
  - Vectorized Transformations
---
# Bulk Operations Preserve Intent

## Statement

When a transformation applies independently across a collection or dataset, express it with an operation over the collection rather than an element-by-element control loop.

## Why

Bulk operations reveal the transformation itself, reduce accidental state, and usually let the underlying runtime choose an efficient implementation. Row-by-row loops often obscure data semantics, introduce ordering bugs, and fail to scale.

## Example

```python
# Element-by-element accumulation
# totals = {}
# for order in orders:
#     if order.status == "paid":
#         totals[order.customer_id] = totals.get(order.customer_id, 0) + order.amount

paid = orders.loc[orders["status"].eq("paid")]
totals = paid.groupby("customer_id")["amount"].sum()
```

The bulk form makes filtering, grouping, and aggregation explicit.
## Implications

- Prefer declarative collection, query, array, or dataframe operations for independent transformations.
- Separate selection, transformation, and aggregation so each operation has a visible data contract.
- Use explicit grouping and ordering whenever a calculation depends on them.
- Measure before optimizing operations with dependencies between elements; do not force an unsuitable vectorized form.
- Keep per-item side effects at an explicit integration boundary, outside pure bulk transformations.

## Exceptions

- Sequential algorithms, state machines, and external side effects may require iteration.
- Small collections may use a clear loop when a bulk API would hide essential domain rules.
- A vectorized expression that is materially less correct or less reviewable is not an improvement.

## Related

- [[Find Bulk Data Refactors]]
- [[Bulk Transformation Pipeline]]
- [[Explicit Operational Contracts]]

