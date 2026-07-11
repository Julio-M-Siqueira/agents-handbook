---
id: principles.explicit_operational_contracts
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
  - Strong Function Contracts
  - Explicit Contracts
---
# Explicit Operational Contracts

## Statement

A unit of code should declare the inputs, outputs, failure modes, and side effects that its caller must understand to use it safely.

A contract is stronger than a type annotation. It includes the valid state of each input, the result that is produced, the errors that may occur, and whether the operation reads, writes, or contacts an external system.

## Why

Implicit contracts force callers to infer behavior from implementation details. This creates defensive code, duplicated validation, and accidental coupling. Explicit operational contracts make units easier to compose, test, replace, and review.

## Example

```python
class InvalidDocument(ValueError):
    pass


def publish(document: Document, publisher: Publisher) -> Publication:
    if not document.title:
        raise InvalidDocument("Document title is required")
    return publisher.publish(document)
```

The signature exposes the required collaborators, a meaningful successful result, and a failure callers can handle.
## Implications

- Prefer precise types and domain values over generic containers and `Any`.
- Keep public operations narrow enough that their behavior can be stated clearly.
- Separate raw input from validated operational state; see [[Boundary Validated State]].
- Return a meaningful result or raise a meaningful domain error. Avoid ambiguous `None` results for operations that must succeed.
- Document public APIs when names and types cannot state the contract completely.
- Keep side effects visible at the unit boundary and inject collaborators that perform them.

## Exceptions

- Small private helpers may rely on a nearby, stronger enclosing contract.
- A best-effort operation may intentionally return a partial result, but must make that status explicit.
- Dynamic extension points may accept broad types at the boundary, then normalize them to a narrow internal contract.

## Related

- [[Boundary Validated State]]
- [[Find Contract Boundary Refactors]]
- [[Validated Configuration Loader]]
- [[Actionable Domain Failure]]

