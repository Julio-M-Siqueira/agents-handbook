from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol


class ProviderTimeout(Exception):
    pass


class PaymentDeclined(Exception):
    pass


class PaymentUnavailable(Exception):
    pass


class Payments(Protocol):
    def authorize(self, amount_cents: int, reference: str) -> str: ...


class ProviderClient(Protocol):
    def create_charge(self, *, amount: int, idempotency_key: str) -> dict[str, str]: ...


@dataclass
class ProviderPayments:
    client: ProviderClient

    def authorize(self, amount_cents: int, reference: str) -> str:
        raise NotImplementedError


@dataclass
class Checkout:
    payments: Payments

    def place_order(self, amount_cents: int, reference: str) -> str:
        return self.payments.authorize(amount_cents, reference)
