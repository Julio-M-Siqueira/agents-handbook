import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).parents[1] / "starter"))

from rendering import Report, ReportService


class ExternalRenderer:
    def __init__(self) -> None:
        self.seen: list[Report] = []

    def render(self, report: Report) -> str:
        self.seen.append(report)
        return f"<h1>{report.title}</h1>"


class FailingRenderer:
    def render(self, report: Report) -> str:
        raise OSError("template unavailable")


class ConsumerOwnedProtocolTests(unittest.TestCase):
    def test_structural_implementation_is_accepted(self) -> None:
        renderer = ExternalRenderer()
        report = Report("Architecture")
        self.assertEqual("<h1>Architecture</h1>", ReportService(renderer).publish(report))
        self.assertEqual([report], renderer.seen)

    def test_unknown_renderer_failure_is_preserved(self) -> None:
        with self.assertRaisesRegex(OSError, "template unavailable"):
            ReportService(FailingRenderer()).publish(Report("Architecture"))


if __name__ == "__main__":
    unittest.main()
