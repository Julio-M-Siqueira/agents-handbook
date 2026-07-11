---
id: principles.configuration_is_a_contract
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
  - Validated Configuration
  - Configuration Boundary
---
# Configuration Is a Contract

## Statement

Configuration is an external interface. Parse, validate, normalize, and version it at the boundary before the application depends on it.

## Why

Configuration controls behavior without compiler feedback. When validation is deferred or values are scattered through code, failures arrive late and operators cannot reliably discover supported behavior. A validated configuration contract turns raw settings into trusted application input.

## Example

```python
@dataclass(frozen=True)
class CacheSettings:
    ttl_seconds: int


def load_cache_settings(raw: Mapping[str, str]) -> CacheSettings:
    ttl = int(raw.get("CACHE_TTL_SECONDS", "300"))
    if ttl <= 0:
        raise ValueError("CACHE_TTL_SECONDS must be positive")
    return CacheSettings(ttl_seconds=ttl)
```

Consumers receive `CacheSettings`, not raw strings or repeated fallback logic.
## Implications

- Keep environment-specific or tunable behavior outside source code.
- Define defaults, ranges, required combinations, and deprecations in one schema or loader.
- Normalize aliases and raw string values once; core logic should receive typed, validated settings.
- Fail at startup or configuration load for invalid required settings.
- Keep configuration ownership close to the subsystem it controls.

## Exceptions

- Compile-time constants that are intrinsic to an algorithm are not configuration.
- A deliberate runtime experiment may accept dynamic values, but still needs a validation boundary and traceability.
- Secrets may be sourced separately, but their presence and format remain part of the configuration contract.

## Related

- [[Find Configuration Contract Gaps]]
- [[Validated Configuration Loader]]
- [[Boundary Validated State]]
- [[Explicit Operational Contracts]]

