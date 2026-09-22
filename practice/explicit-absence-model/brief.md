# Explicit absence model

Normalize raw telemetry so each absent value has one deliberate meaning.

## Goal

Implement `normalize_telemetry` in `starter/telemetry.py`.

## Constraints

- Reject a missing or blank location with `InvalidTelemetry`.
- Treat missing avoidance zones as an empty immutable collection because it means “no zones.”
- Preserve `diagnostic=None`; it represents a valid unavailable diagnostic, not invalid telemetry.
- Do not add `None` checks to `route_delivery`.

## Acceptance checks

Run `python -m unittest discover -s tests -v` from this exercise directory. The tests cover required state, neutral defaults, and legitimate optional state.

## Hints

1. Decide what each `None` means before replacing it.
2. Normalize only at the raw-to-ready boundary.
3. Construct `ReadyTelemetry` only after the required location is valid.

## Source and guidance

Based on [Stop Checking for None Everywhere](https://www.youtube.com/watch?v=h8ZwhU3PpVw), especially 12:37–12:39, 15:56–16:37, and 20:04–20:06. Read [[Explicit Absence Model]] and [[Boundary Validated State]].
