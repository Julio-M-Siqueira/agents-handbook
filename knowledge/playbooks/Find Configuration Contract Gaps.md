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

Find configuration that is unvalidated, duplicated, hidden in code, or normalized too late; rank the smallest contract-first refactor.

## Preconditions

- Read [[Configuration Is a Contract]].
- Identify configuration sources, schemas, loaders, and consumer modules.

## Steps

1. Search for environment reads, raw dictionary access, hard-coded tunables, string-to-enum conversions, and duplicated defaults.
2. Trace each value from source to first operational use.
3. Mark where validation, normalization, and cross-field rules currently happen.
4. Group findings by configuration domain rather than by raw key.
5. Score operational impact, likelihood of misconfiguration, duplication, and minimality from 1 to 5.
6. Select the smallest refactor that centralizes one domain in a typed loader or schema.
7. Define defaults, required values, constraints, and user-facing failure behavior.

## Example

```python
# Search signal: raw settings reach business logic.
timeout = int(os.environ.get("HTTP_TIMEOUT", "30"))

# Refactor target: settings are loaded once at the boundary.
client = HttpClient(settings.http_timeout_seconds)
```

The minimal refactor is usually the typed `settings` field and its loader, not a new check in every client call.
## Validation

- Does core logic receive a validated typed value?
- Is every tunable owned by one configuration boundary?
- Will invalid configuration fail before side effects begin?
- Are defaults intentional and documented in the schema or sample configuration?

## Failure handling

If compatibility requires legacy keys, normalize them at the boundary and add a deprecation path. Do not propagate aliases into core logic.

## Related

- [[Configuration Is a Contract]]
- [[Validated Configuration Loader]]
- [[Boundary Validated State]]

