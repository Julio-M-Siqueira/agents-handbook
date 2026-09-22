from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol


class OutOfStock(RuntimeError):
    pass


@dataclass(frozen=True)
class PlaceOrder:
    order_id: str
    product_id: str
    quantity: int


class Inventory(Protocol):
    def reserve(self, product_id: str, quantity: int) -> None: ...


class Orders(Protocol):
    def add(self, command: PlaceOrder) -> None: ...


class UnitOfWork(Protocol):
    inventory: Inventory
    orders: Orders

    def __enter__(self) -> UnitOfWork: ...

    def __exit__(self, exc_type: object, exc: object, traceback: object) -> None: ...

    def commit(self) -> None: ...


def place_order(command: PlaceOrder, uow: UnitOfWork) -> None:
    raise NotImplementedError
