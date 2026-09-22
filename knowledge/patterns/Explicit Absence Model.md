---
id: patterns.explicit_absence_model
type: pattern
status:
  - draft
scope:
  - code-quality
owner: julio
created: 2026-09-20
tags:
  - knowledge/pattern
aliases:
  - Model Absence Explicitly
  - Optional State Contract
---
# Explicit Absence Model

## Problem

`None` represents several different situations: omitted input, an empty collection, unavailable data, a failed lookup, or a value that was explicitly cleared. Callers repeat checks because the contract does not say which meaning applies.

## Context

Raw input or an integration can legitimately omit data, but core code needs one precise interpretation of that absence.

## Solution

Classify absence at the boundary and expose the narrowest honest contract:

- use an empty collection or neutral value only when it behaves exactly like absence;
- retain an optional field when absence is meaningful domain state;
- use a sentinel when omitted and explicitly `None` mean different things;
- return a result variant or raise a domain failure when an operation was required to succeed.

```python
class _Unset:
    pass


UNSET = _Unset()


def update_note(current: str | None, replacement: str | None | _Unset = UNSET) -> str | None:
    if replacement is UNSET:
        return current
    return replacement
```

Normalize raw optional data before it reaches core operations. Do not replace `None` mechanically when the replacement changes domain meaning.

## Use when

- The same nullable value causes checks in several callers.
- A public operation uses `None` for more than one outcome.
- Omitted input and an explicit null update must be distinguished.

## Avoid when

- Absence already has one clear, local meaning.
- Introducing a result type would obscure a small private helper.

## Tradeoffs

More precise result types and sentinels add vocabulary. They pay for themselves when they remove repeated branching or prevent callers from confusing absence with failure.

## Related

- [[Boundary Validated State]]
- [[Explicit Operational Contracts]]
- [[Actionable Domain Failure]]
- [[Software Design in Python Video Series]]
