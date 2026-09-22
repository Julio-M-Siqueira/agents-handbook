---
id: patterns.transactional_unit_of_work
type: pattern
status:
  - draft
scope:
  - code-quality
owner: julio
created: 2026-09-20
tags:
  - knowledge/pattern
aliases:
  - Unit of Work
  - Transaction Boundary
---
# Transactional Unit of Work

## Problem

A business operation changes several repositories or records. If one write fails after another succeeds, the system exposes partial state and callers cannot tell what committed.

## Context

The changes share one transactional resource and form one business outcome. The application service should define the transaction boundary without depending on a database session directly.

## Solution

Provide repositories through a unit of work that owns one transaction. Enter it before loading or changing state, commit once after all invariants hold, and roll back when the scope exits without a successful commit.

```python
def place_order(command: PlaceOrder, uow: UnitOfWork) -> None:
    with uow:
        product = uow.products.get(command.product_id)
        product.reserve(command.quantity)
        uow.orders.add(Order.from_command(command))
        uow.commit()
```

The unit of work contract should make commit, rollback, and repository lifetime explicit. Preserve the original error when rollback follows a failure.

## Use when

- One use case must update multiple records atomically.
- Several repositories must share a transaction or persistence session.
- Tests need to prove that failure cannot commit partial work.

## Avoid when

- The operation performs one independent write with an already-clear transaction.
- The resources cannot participate in one transaction; use an explicit distributed workflow, compensation, or outbox instead.
- A repository abstraction would only duplicate the underlying persistence API without protecting a domain contract.

## Tradeoffs

The pattern introduces repository and lifecycle boundaries. It is valuable for atomic business operations, but creates needless indirection for simple persistence. Query-heavy reads may use a separate direct read model.

## Related

- [[Explicit Operational Contracts]]
- [[Failures Are Observable and Actionable]]
- [[External Service Boundary]]
- [[Software Design in Python Video Series]]
