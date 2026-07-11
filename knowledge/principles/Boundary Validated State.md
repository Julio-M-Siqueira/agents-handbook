---
id: principles.boundary_validated_state
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
  - Class Early Validation
  - Class-Based Early Validation
---
# Boundary Validated State

## Statement

Core business logic should receive values whose required invariants have already been validated at a clear boundary.

The principle is not limited to classes. It applies to any object, dependency, configuration, payload, state snapshot, or runtime handle that core code treats as operationally required.

Repeated validation inside core functions can obscure the function's actual purpose:

```python
def process_order(
    order: Order | None,
    broker: BrokerClient | None,
) -> ExecutionResult:
    if order is None:
        raise ValueError("Order is required")

    if order.symbol is None:
        raise ValueError("Order symbol is required")

    if broker is None:
        raise ValueError("Broker client is required")

    ...
```

When several functions repeat checks for the same invariant, validation should move to the boundary where raw input becomes trusted operational state. This boundary can be a constructor, parser, factory, configuration loader, dependency initializer, or state transition.

```python
from dataclasses import dataclass


@dataclass(frozen=True)
class ReadyOrderExecution:
    order: Order
    broker: BrokerClient

    def __post_init__(self) -> None:
        if not self.order.symbol:
            raise ValueError("Order symbol is required")
```

Core code can then accept the strongest valid type available:

```python
def process_order(ctx: ReadyOrderExecution) -> ExecutionResult:
    return ctx.broker.submit(ctx.order)
```

The objective is not merely to move validation code. It is to ensure that the type, object, or state accepted by core code represents a valid operational state.

## Why

Validating state before it enters core logic:

- keeps business functions focused on their primary responsibility;
- avoids duplicated defensive checks across functions;
- centralizes invariant definitions;
- prevents partially valid state from propagating through the system;
- makes function contracts clearer;
- reduces inconsistent validation behavior;
- improves static type checking;
- fails before expensive, irreversible, or externally visible work begins.

## Implications

- Required values should not remain typed as optional after validation.
- Objects should be immutable when mutation could break established invariants.
- Validation should occur at a clear boundary, such as parsing, construction, configuration loading, dependency initialization, request handling, or state transition.
- Core functions should accept the strongest valid type available.
- Validation errors should be raised before expensive or irreversible processing begins.
- Repeated checks for the same invariant may indicate that the domain model is too weak.
- When raw input and validated state differ, separate staged types may be appropriate.
- Lazy initialization should be explicit as a lifecycle state, not leaked into every core operation.

## Search Signals

Look for code where core logic repeatedly asks whether required state exists:

- parameters or attributes typed as optional but treated as required;
- repeated `is None`, empty-list, empty-string, or missing-key checks around the same concept;
- methods that start by validating object shape before doing business work;
- nullable service dependencies initialized in `__init__` and checked before each operation;
- config schemas that validate a field but still expose weak optional aliases to core code;
- state flags such as `loaded`, `connected`, `initialized`, or `ready` that coexist with nullable operational dependencies;
- repeated error messages for the same missing invariant.

## Refactoring Pattern

Separate raw or transitional state from validated operational state.

```python
@dataclass(frozen=True)
class RawExecutionContext:
    order: Order | None
    broker: BrokerClient | None


@dataclass(frozen=True)
class ReadyExecutionContext:
    order: Order
    broker: BrokerClient


def prepare_execution_context(raw: RawExecutionContext) -> ReadyExecutionContext:
    if raw.order is None:
        raise ValueError("Order is required")

    if raw.broker is None:
        raise ValueError("Broker client is required")

    return ReadyExecutionContext(order=raw.order, broker=raw.broker)
```

Core code should depend on `ReadyExecutionContext`, not `RawExecutionContext`.

## Exceptions

- Optional state is valid when absence is part of the domain behavior, not merely an initialization gap.
- Boundary adapters may validate raw input directly because validation is their primary responsibility.
- Performance-sensitive paths may keep local assertions when they document impossible states, but the upstream boundary should still establish the invariant.
- Transitional lifecycle objects may expose optional fields if the lifecycle stages are explicit and core operations accept only the ready stage.

## Related

- Validate at boundaries
- Make invalid states unrepresentable
- Staged state modeling
- Strong function contracts
- Immutable validated objects
- Fail fast
