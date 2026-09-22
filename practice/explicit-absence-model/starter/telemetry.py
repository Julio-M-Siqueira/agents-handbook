from __future__ import annotations

from dataclasses import dataclass


class InvalidTelemetry(ValueError):
    pass


@dataclass(frozen=True)
class RawTelemetry:
    location: str | None
    avoid_zones: list[str] | None
    diagnostic: str | None


@dataclass(frozen=True)
class ReadyTelemetry:
    location: str
    avoid_zones: tuple[str, ...]
    diagnostic: str | None


def normalize_telemetry(raw: RawTelemetry) -> ReadyTelemetry:
    raise NotImplementedError


def route_delivery(telemetry: ReadyTelemetry) -> str:
    return f"{telemetry.location}:{','.join(telemetry.avoid_zones)}"
