---
id: playbooks.find_configuration_contract_gaps
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
  - Audit Configuration Boundaries
---
# Find Configuration Contract Gaps

## Goal

Find configuration that is unvalidated, duplicated, hidden in code, or normalized too late; select a coherent configuration contract for the affected workflow.

## Preconditions

- For requested refactors, apply [[Refactoring Simplifies the Whole Workflow]] and [[Design a Coherent Refactor]] before editing; include affected callers and consumers.
- Read [[Configuration Is a Contract]].
- Identify configuration sources, schemas, loaders, and consumer modules.

## Steps

1. Search for environment reads, raw dictionary access, hard-coded tunables, string-to-enum conversions, and duplicated defaults.
2. Trace each value from source through every affected consumer, including serialization, reloads, derived settings, provenance, and later commands.
3. Mark where validation, normalization, and cross-field rules currently happen.
4. Group findings by configuration domain rather than by raw key.
5. Use [[Design a Coherent Refactor]] to score criticality, architectural improvement, and leverage separately. Operational impact, misconfiguration likelihood, and duplication supply evidence; cost and migration risk remain separate.
6. Design the configuration flow around one owning boundary per domain. Compare a local loader correction with passing trusted settings through the workflow when materially different; do not introduce a second schema when an existing validated representation suffices.
7. Define defaults, required values, constraints, and user-facing failure behavior.

## Example

```python
# Search signal: raw settings reach business logic.
timeout = int(os.environ.get("HTTP_TIMEOUT", "30"))

# Refactor target: settings are loaded once at the boundary.
client = HttpClient(settings.http_timeout_seconds)
```

A typed `settings` field and its loader can fully resolve a local problem. When the workflow also serializes and reloads trusted settings, assess that handoff and its consumers before declaring the configuration refactor complete.
## Validation

- Does core logic receive a validated typed value without unnecessary serialization, reloads, or repeated checks?
- Are retained reloads justified by a new trust boundary, supported dynamic update, or another concrete contract? Can provenance be recorded without making the current computation reload it?
- Is every tunable owned by one configuration boundary?
- Will invalid configuration fail before side effects begin?
- Are defaults intentional and documented in the schema or sample configuration?

## Failure handling

If compatibility requires legacy keys, normalize them at the boundary and add a deprecation path. Do not propagate aliases into core logic.

## Related

- [[Configuration Is a Contract]]
- [[Validated Configuration Loader]]
- [[Boundary Validated State]]
- [[Software Design in Python Video Series]]

