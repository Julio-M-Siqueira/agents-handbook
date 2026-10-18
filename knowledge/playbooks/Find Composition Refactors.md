---
id: playbooks.find_composition_refactors
type: playbook
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/playbook
aliases:
  - Find Inheritance Refactors
---
# Find Composition Refactors

## Goal

Find behavior coupled through inheritance or concrete construction, rank the candidates, and propose a coherent composition-based refactor that resolves the affected behavior axis.

## Preconditions

- For requested refactors, apply [[Refactoring Simplifies the Whole Workflow]] and [[Design a Coherent Refactor]] before editing; include affected callers and consumers.
- Read [[Composition Defines Variation]].
- Identify extension points, interfaces, and construction paths in the selected subsystem.

## Steps

1. Search for inheritance declarations, base classes with concrete logic, `super()` chains, and direct construction inside business methods.
2. For each candidate, distinguish semantic substitution from implementation reuse.
3. Identify the changing behavior, stable orchestration, and smallest interface needed between them.
   Place a structural protocol near the consumer when separately owned implementations already have the needed shape. Retain or introduce an abstract base class when nominal membership and an owned implementation lifecycle are part of the contract.
4. Search for condition chains that select implementations; check whether a registry would make the selection data-driven.
   Apply the SOLID lenses in [[Composition Defines Variation]]: inspect unrelated reasons to change, consumer-unused methods, substitution preconditions and guarantees, and dependency direction. Name the relevant letter only when it explains a verified problem; do not infer a defect from hierarchy depth or function length alone.
5. Group findings by behavior axis, such as storage, parsing, policy, or transport.
6. Use the ranking and alternative-selection rubric in [[Design a Coherent Refactor]]: score criticality, architectural improvement, and leverage separately. Use impact and change frequency as evidence; record test effort and migration risk separately.
7. Design the target responsibilities across the affected workflow before choosing a strategy, collaborator, or registry. Keep computation explicit rather than hiding it in a preparation context. Complete authorized caller migration and preserve required public behavior.

## Example

```python
# Before: behavior changes through subclass overrides.
class CsvExporter(Exporter):
    def serialize(self, report: Report) -> bytes: ...

# After: the stable workflow receives a serializer.
class ExportService:
    def __init__(self, serializer: Serializer) -> None:
        self._serializer = serializer
```

The candidate is stronger when `Exporter` otherwise exists only to share the workflow.
## Validation

- Does the proposed interface represent one coherent responsibility?
- Can implementations be tested without the orchestrator?
- Does the resulting workflow clarify responsibilities and remove the demonstrated coupling, rather than merely moving it?
- Is the selection point explicit and validated?

## Failure handling

If a base class has true shared semantics and stable substitutability, record it as a non-finding. Do not replace sound inheritance merely because composition is fashionable.

## Related

- [[Composition Defines Variation]]
- [[Strategy Injection]]
- [[Registry-Based Selection]]
- [[Software Design in Python Video Series]]

