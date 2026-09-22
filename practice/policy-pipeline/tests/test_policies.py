import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parents[1] / "starter"))

from policies import AccessDenied, Request, UnknownPolicy, apply_policies, resolve_policies  # noqa: E402


class PolicyPipelineTests(unittest.TestCase):
    def setUp(self):
        self.request = Request("u-1", frozenset({"member"}), False)

    def test_applies_resolved_policies_in_configured_order(self):
        calls = []
        registry = {
            "record": lambda request: calls.append(request.user_id),
            "member": lambda request: None if "member" in request.roles else (_ for _ in ()).throw(AccessDenied("member required")),
        }
        apply_policies(self.request, resolve_policies(["record", "member"], registry))
        self.assertEqual(["u-1"], calls)

    def test_stops_after_first_denial(self):
        calls = []
        policies = [lambda request: (_ for _ in ()).throw(AccessDenied("blocked")), lambda request: calls.append("must not run")]
        with self.assertRaisesRegex(AccessDenied, "blocked"):
            apply_policies(self.request, policies)
        self.assertEqual([], calls)

    def test_unknown_name_fails_before_any_policy_runs(self):
        calls = []
        registry = {"record": lambda request: calls.append(request.user_id)}
        with self.assertRaisesRegex(UnknownPolicy, "missing"):
            resolve_policies(["record", "missing"], registry)
        self.assertEqual([], calls)
