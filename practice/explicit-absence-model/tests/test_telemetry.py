import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).parents[1] / "starter"))

from telemetry import InvalidTelemetry, RawTelemetry, normalize_telemetry, route_delivery


class ExplicitAbsenceTests(unittest.TestCase):
    def test_missing_zones_become_the_neutral_value(self) -> None:
        ready = normalize_telemetry(RawTelemetry("dock-7", None, "nominal"))
        self.assertEqual((), ready.avoid_zones)
        self.assertEqual("dock-7:", route_delivery(ready))

    def test_valid_diagnostic_absence_remains_explicit(self) -> None:
        ready = normalize_telemetry(RawTelemetry("dock-7", ["storm"], None))
        self.assertIsNone(ready.diagnostic)
        self.assertEqual(("storm",), ready.avoid_zones)

    def test_missing_required_location_fails_at_the_boundary(self) -> None:
        for location in (None, "  "):
            with self.subTest(location=location):
                with self.assertRaises(InvalidTelemetry):
                    normalize_telemetry(RawTelemetry(location, [], None))


if __name__ == "__main__":
    unittest.main()
