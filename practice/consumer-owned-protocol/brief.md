# Consumer-owned protocol

Define the rendering capability where the report service consumes it, while accepting independently owned implementations structurally.

## Goal

Implement `ReportService.publish` in `starter/rendering.py`.

## Constraints

- Keep `Renderer` in the consumer module.
- Depend only on its `render(report)` capability.
- Do not require renderers to inherit from a handbook-owned base class.
- Propagate renderer failures; the service has no recovery policy for them.

## Acceptance checks

Run `python -m unittest discover -s tests -v` from this exercise directory. The tests use an independently defined renderer and verify delegation and failure behavior.

## Hints

1. The protocol documents what the consumer needs.
2. Structural typing means the implementation does not mention `Renderer`.
3. Avoid catching an error you cannot classify or recover from.

## Source and guidance

Based on [Protocol Or ABC In Python](https://www.youtube.com/watch?v=xvb5hGLoK0A), especially 20:31–21:33. Read [[Composition Defines Variation]] and [[Strategy Injection]].
