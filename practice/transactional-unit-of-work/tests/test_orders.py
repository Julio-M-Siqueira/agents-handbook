import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).parents[1] / "starter"))

from orders import OutOfStock, PlaceOrder, place_order


class FakeInventory:
    def __init__(self, events: list[str], failure: Exception | None = None) -> None:
        self.events = events
        self.failure = failure

    def reserve(self, product_id: str, quantity: int) -> None:
        self.events.append(f"reserve:{product_id}:{quantity}")
        if self.failure:
            raise self.failure


class FakeOrders:
    def __init__(self, events: list[str], failure: Exception | None = None) -> None:
        self.events = events
        self.failure = failure

    def add(self, command: PlaceOrder) -> None:
        self.events.append(f"add:{command.order_id}")
        if self.failure:
            raise self.failure


class FakeUnitOfWork:
    def __init__(self, inventory_failure: Exception | None = None, order_failure: Exception | None = None) -> None:
        self.events: list[str] = []
        self.inventory = FakeInventory(self.events, inventory_failure)
        self.orders = FakeOrders(self.events, order_failure)

    def __enter__(self):
        self.events.append("enter")
        return self

    def __exit__(self, exc_type, exc, traceback) -> None:
        self.events.append("rollback" if exc_type else "exit")

    def commit(self) -> None:
        self.events.append("commit")


class TransactionalUnitOfWorkTests(unittest.TestCase):
    command = PlaceOrder("order-7", "product-3", 2)

    def test_commits_after_all_writes_succeed(self) -> None:
        uow = FakeUnitOfWork()
        place_order(self.command, uow)
        self.assertEqual(["enter", "reserve:product-3:2", "add:order-7", "commit", "exit"], uow.events)

    def test_domain_failure_rolls_back_without_commit(self) -> None:
        uow = FakeUnitOfWork(inventory_failure=OutOfStock("product-3"))
        with self.assertRaises(OutOfStock):
            place_order(self.command, uow)
        self.assertEqual(["enter", "reserve:product-3:2", "rollback"], uow.events)

    def test_repository_failure_preserves_original_error(self) -> None:
        error = OSError("database unavailable")
        uow = FakeUnitOfWork(order_failure=error)
        with self.assertRaises(OSError) as raised:
            place_order(self.command, uow)
        self.assertIs(error, raised.exception)
        self.assertNotIn("commit", uow.events)
        self.assertEqual("rollback", uow.events[-1])


if __name__ == "__main__":
    unittest.main()
