from __future__ import annotations

from collections.abc import Callable, Mapping, Sequence
from dataclasses import dataclass


class AccessDenied(Exception):
    pass


class UnknownPolicy(ValueError):
    pass


@dataclass(frozen=True)
class Request:
    user_id: str
    roles: frozenset[str]
    is_suspended: bool


Policy = Callable[[Request], None]


def resolve_policies(names: Sequence[str], registry: Mapping[str, Policy]) -> list[Policy]:
    raise NotImplementedError


def apply_policies(request: Request, policies: Sequence[Policy]) -> None:
    raise NotImplementedError
