import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parents[1] / "starter"))

from search import SearchQuery, SearchService  # noqa: E402


class FakeClient:
    def __init__(self):
        self.parameters = None

    def search(self, parameters):
        self.parameters = parameters
        return ["match"]


class SearchQueryTests(unittest.TestCase):
    def test_normalizes_and_exports_ready_parameters(self):
        query = SearchQuery("  architecture ", page=2, include_archived=True)
        self.assertEqual("architecture", query.term)
        self.assertEqual({"q": "architecture", "page": 2, "include_archived": True}, query.to_parameters())

    def test_rejects_blank_term(self):
        with self.assertRaisesRegex(ValueError, "term"):
            SearchQuery("   ")

    def test_rejects_invalid_page(self):
        with self.assertRaisesRegex(ValueError, "page"):
            SearchQuery("architecture", page=0)

    def test_service_receives_only_ready_parameters(self):
        client = FakeClient()
        self.assertEqual(["match"], SearchService(client).search(SearchQuery("patterns")))
        self.assertEqual({"q": "patterns", "page": 1, "include_archived": False}, client.parameters)
