---
id: patterns.validated_configuration_loader
type: pattern
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/pattern
aliases:
  - Typed Configuration Boundary
---
# Validated Configuration Loader

## Problem

Application code reads raw configuration values directly and repeats defaults, parsing, or validity checks at the point of use.

## Context

Settings come from files, environment variables, command-line input, or remote configuration and control runtime behavior.

## Solution

Load raw values once, validate and normalize them into a typed configuration object, then pass that object to the owning subsystem.

```python
@dataclass(frozen=True)
class RetrySettings:
    attempts: int
    delay_seconds: float


def load_retry_settings(raw: Mapping[str, str]) -> RetrySettings:
    attempts = int(raw.get("RETRY_ATTEMPTS", "3"))
    if attempts < 1:
        raise ValueError("RETRY_ATTEMPTS must be at least 1")
    return RetrySettings(attempts=attempts, delay_seconds=1.0)
```

## Use when

- More than one consumer needs the same setting.
- Values require parsing, cross-field validation, or normalization.
- Invalid configuration should prevent startup or an operation.

## Avoid when

- The value is an intrinsic algorithmic constant with no operational reason to vary it.
- A framework already supplies an authoritative validated settings object.

## Tradeoffs

Introduces a schema and loading step, but removes raw configuration handling from core logic.

## Related

- [[Configuration Is a Contract]]
- [[Find Configuration Contract Gaps]]
- [[Boundary Validated State]]
