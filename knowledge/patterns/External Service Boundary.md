---
id: patterns.external_service_boundary
type: pattern
status:
  - draft
scope:
  - code-quality
owner: julio
created: 2026-09-19
tags:
  - knowledge/pattern
aliases:
  - Anti-Corruption Layer
  - Third-Party API Adapter
---
# External Service Boundary

## Problem

Domain code receives third-party SDK objects, provider-specific errors, or transport payloads directly. A provider change then spreads through callers and tests.

## Context

The application needs a capability supplied by an HTTP API, SDK, queue, or payment provider. The external model, naming, errors, and lifecycle are not the domain model.

## Solution

Define the narrow capability the domain needs, then implement it in one owned adapter or facade. Translate requests into the provider's format and translate successful responses and provider failures back into domain vocabulary at that boundary.

```python
from typing import Protocol


class Payments(Protocol):
    def authorize(self, amount_cents: int, reference: str) -> str: ...


class ProviderPayments:
    def __init__(self, client: ProviderClient) -> None:
        self._client = client

    def authorize(self, amount_cents: int, reference: str) -> str:
        try:
            response = self._client.create_charge(amount=amount_cents, key=reference)
        except ProviderTimeout as error:
            raise PaymentUnavailable(reference) from error
        if response.state == "declined":
            raise PaymentDeclined(reference)
        return response.authorization_id
```

The domain calls `Payments`; only the adapter understands `ProviderClient` and its failure vocabulary.

## Use when

- Provider data structures or errors appear in more than one domain-facing module.
- Business logic needs a stable, testable capability rather than a provider client.
- A provider replacement should affect one integration module.

## Avoid when

- A one-off infrastructure script is the only consumer.
- The proposed interface merely renames every provider method without establishing a domain boundary.

## Tradeoffs

The adapter introduces an owned interface and translation code. It is valuable when it prevents provider concepts from becoming part of the application's operational contract.

## Related

- [[Explicit Operational Contracts]]
- [[Failures Are Observable and Actionable]]
- [[Strategy Injection]]
- [[Design Patterns Video Series]]
