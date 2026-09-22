import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parents[1] / "starter"))

from payments import Checkout, PaymentDeclined, PaymentUnavailable, ProviderPayments, ProviderTimeout  # noqa: E402


class FakeProvider:
    def __init__(self, result):
        self.result = result
        self.calls = []

    def create_charge(self, *, amount, idempotency_key):
        self.calls.append((amount, idempotency_key))
        if isinstance(self.result, Exception):
            raise self.result
        return self.result


class ProviderPaymentsTests(unittest.TestCase):
    def test_returns_domain_authorization_id(self):
        provider = FakeProvider({"status": "approved", "authorization_id": "auth-7"})
        self.assertEqual("auth-7", Checkout(ProviderPayments(provider)).place_order(1250, "order-7"))
        self.assertEqual([(1250, "order-7")], provider.calls)

    def test_decline_does_not_leak_provider_response(self):
        with self.assertRaises(PaymentDeclined):
            ProviderPayments(FakeProvider({"status": "declined"})).authorize(1250, "order-7")

    def test_timeout_becomes_domain_failure_with_cause(self):
        with self.assertRaises(PaymentUnavailable) as raised:
            ProviderPayments(FakeProvider(ProviderTimeout("slow"))).authorize(1250, "order-7")
        self.assertIsInstance(raised.exception.__cause__, ProviderTimeout)
