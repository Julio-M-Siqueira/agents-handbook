from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol


@dataclass(frozen=True)
class SearchQuery:
    term: str
    page: int = 1
    include_archived: bool = False

    def __post_init__(self) -> None:
        raise NotImplementedError

    def to_parameters(self) -> dict[str, str | int | bool]:
        raise NotImplementedError


class SearchClient(Protocol):
    def search(self, parameters: dict[str, str | int | bool]) -> list[str]: ...


@dataclass
class SearchService:
    client: SearchClient

    def search(self, query: SearchQuery) -> list[str]:
        return self.client.search(query.to_parameters())
