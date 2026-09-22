from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol


@dataclass(frozen=True)
class Report:
    title: str


class Renderer(Protocol):
    def render(self, report: Report) -> str: ...


class ReportService:
    def __init__(self, renderer: Renderer) -> None:
        self._renderer = renderer

    def publish(self, report: Report) -> str:
        raise NotImplementedError
