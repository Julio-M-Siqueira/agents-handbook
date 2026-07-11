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

Find behavior coupled through inheritance or concrete construction, rank the candidates, and propose the smallest composition-based refactor.

## Preconditions

- Read [[Composition Defines Variation]].
- Identify extension points, interfaces, and construction paths in the selected subsystem.

## Steps

1. Search for inheritance declarations, base classes with concrete logic, `super()` chains, and direct construction inside business methods.
2. For each candidate, distinguish semantic substitution from implementation reuse.
3. Identify the changing behavior, stable orchestration, and smallest interface needed between them.
4. Search for condition chains that select implementations; check whether a registry would make the selection data-driven.
5. Group findings by behavior axis, such as storage, parsing, policy, or transport.
6. Score impact, change frequency, test difficulty, and minimality from 1 to 5. Prefer the highest total with a bounded migration.
7. Recommend strategy injection, a helper collaborator, or a registry entry. Keep existing public behavior unchanged unless a contract change is intentional.

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
- Does the refactor shorten or clarify the inheritance chain?
- Is the selection point explicit and validated?

## Failure handling

If a base class has true shared semantics and stable substitutability, record it as a non-finding. Do not replace sound inheritance merely because composition is fashionable.

## Related

- [[Composition Defines Variation]]
- [[Strategy Injection]]
- [[Registry-Based Selection]]

