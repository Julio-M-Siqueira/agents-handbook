---
id: playbooks.find_contract_boundary_refactors
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
  - Find Weak Contracts
---
# Find Contract Boundary Refactors

## Goal

Find places where a public or cross-module operation has an implicit, ambiguous, or weak contract, then select a coherent refactor that makes the contract explicit across its affected consumers.

## Preconditions

- For requested refactors, apply [[Refactoring Simplifies the Whole Workflow]] and [[Design a Coherent Refactor]] before editing; include affected callers and consumers.
- Read [[Explicit Operational Contracts]] and [[Boundary Validated State]].
- Identify the subsystem and its public operations.
- Have search, type, and test context available.

## Steps

1. Locate boundaries: public methods, handlers, service entry points, adapters, and module exports.
2. Search for contract ambiguity: `Any`, untyped dictionaries, nullable required values, ambiguous `None` returns, repeated validation, and undocumented side effects. Distinguish omitted input, valid absence, not-found results, and dependency failure before selecting a replacement contract.
3. Inspect callers and tests to infer the actual contract currently relied on.
4. Group evidence by one missing contract, not by individual line.
5. Use [[Design a Coherent Refactor]] to score criticality, architectural improvement, and leverage separately, with impact and caller confusion as evidence. Record migration cost and risk separately.
6. Select the strongest supported target contract and data flow, comparing local and broader corrections when materially different. Use a precise type, result object, validated boundary, or explicit exception only when it fits; migrate affected callers rather than stopping at an adapter.
7. State the new contract, the migration impact, and the tests that prove it.

## Example

```python
# Before: callers must guess whether absence is an error.
def load_profile(user_id: str) -> Profile | None: ...

# After: the boundary defines the absence contract.
def load_profile(user_id: str) -> Profile:
    profile = repository.find(user_id)
    if profile is None:
        raise ProfileNotFound(user_id)
    return profile
```

Rank this highly when several callers repeat the same `None` check.
## Validation

- Can a caller determine success, failure, and side effects without reading implementation details?
- Is optionality real domain behavior or leaked initialization state?
- Does the refactor remove repeated caller-side defensive code?
- Does the selected change resolve the affected contract without unrelated redesign, and is each retained compatibility layer justified?

## Failure handling

If the actual contract differs between callers, record the incompatibility first. Do not invent one contract without identifying the required migration or compatibility layer.

## Related

- [[Explicit Operational Contracts]]
- [[Boundary Validated State]]
- [[Validated Configuration Loader]]
- [[Actionable Domain Failure]]
- [[Explicit Absence Model]]
- [[Software Design in Python Video Series]]

