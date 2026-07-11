---
id: principles.composition_defines_variation
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
  - Composition over Inheritance
  - Compose Behavior
---
# Composition Defines Variation

## Statement

Model changing behavior by composing stable collaborators behind small interfaces. Use inheritance only when substitutability is real and the base abstraction remains small.

## Why

Inheritance combines a type relationship with implementation reuse. When used chiefly for reuse, it hides dependencies, creates fragile base classes, and makes local changes affect distant subclasses. Composition keeps variation explicit and lets each collaborator be tested and replaced independently.

## Example

```python
class PricingService:
    def __init__(self, policy: PricingPolicy) -> None:
        self._policy = policy

    def quote(self, order: Order) -> Money:
        return self._policy.price(order)
```

`PricingService` owns the workflow; the injected policy owns the changing pricing rule.
## Implications

- Keep orchestration focused on sequencing; place domain behavior in collaborators, strategies, validators, and adapters.
- Inject dependencies or resolve them from a narrowly owned registry rather than constructing concrete implementations in business logic.
- Prefer one clear interface and several small implementations over a hierarchy that accumulates optional hooks.
- Use registries when selection is data-driven or configured, and validate registry entries at startup.
- Treat an abstract base class as an interface boundary, not a container for unrelated concrete behavior.

## Exceptions

- Inheritance is appropriate for a stable semantic "is a" relationship with true substitutability.
- Framework-required inheritance is acceptable when wrapped or isolated from domain logic.
- A small template-method base can be useful when its fixed algorithm is genuinely shared and extension points are minimal.

## Related

- [[Find Composition Refactors]]
- [[Strategy Injection]]
- [[Registry-Based Selection]]
- [[Explicit Operational Contracts]]

