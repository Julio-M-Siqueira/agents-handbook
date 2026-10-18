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
- Thin orchestration means explicit sequencing of cohesive operations, not a short wrapper around hidden work. Keep major computations visible as named stages; context managers own actual resources or lifecycle invariants rather than computational preparation merely for reuse.
- Choose collaborators from the target workflow responsibilities, not existing file boundaries. Shared code is an improvement only when it resolves the demonstrated coupling or duplication; justify remaining adapters and handoffs using [[Design a Coherent Refactor]].
- Inject dependencies or resolve them from a narrowly owned registry rather than constructing concrete implementations in business logic.
- Prefer one clear interface and several small implementations over a hierarchy that accumulates optional hooks.
- Use registries when selection is data-driven or configured, and validate registry entries at startup.
- Treat an abstract base class as an interface boundary, not a container for unrelated concrete behavior.
- Place a structural `Protocol` near the consumer when independently owned or third-party implementations should satisfy the contract without inheritance. Prefer an abstract base class when one owned implementation family needs nominal membership or shared lifecycle rules.

## SOLID as review lenses

Use SOLID to explain a demonstrated design problem, not to require a class hierarchy or an abstraction for every function.

| Lens | Evidence to inspect | Responsibility or contract to clarify |
| --- | --- | --- |
| Single responsibility (S) | One unit changes for unrelated policy, persistence, and orchestration reasons | Extract the independently changing responsibility |
| Open/closed (O) | Adding an established variant repeatedly edits stable orchestration | Inject the variation; use a registry when selection is configured |
| Liskov substitution (L) | An implementation strengthens preconditions, weakens guarantees, or changes promised side effects/failures | Restore the shared contract or separate incompatible interfaces |
| Interface segregation (I) | Consumers depend on unused methods or implementations provide meaningless stubs | Define the narrow interface the consumer actually needs |
| Dependency inversion (D) | Domain policy constructs infrastructure clients or imports their details | Inject a collaborator through a consumer-owned contract |

For substitution, test observable behavior through the same consumer; matching method signatures alone is insufficient. See [[Explicit Operational Contracts]]. Stable conditionals and cohesive concrete implementations are valid when there is no demonstrated variation pressure.

## Exceptions

- Inheritance is appropriate for a stable semantic "is a" relationship with true substitutability.
- Framework-required inheritance is acceptable when wrapped or isolated from domain logic.
- A small template-method base can be useful when its fixed algorithm is genuinely shared and extension points are minimal.

## Related

- [[Find Composition Refactors]]
- [[Strategy Injection]]
- [[Registry-Based Selection]]
- [[Explicit Operational Contracts]]
- [[Software Design in Python Video Series]]
