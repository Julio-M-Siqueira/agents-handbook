# AGENTS.md instructions for D:\projects\exam-readness-tuttor

## Project Skill Routing

- Use `exam-readness-code-quality` for final-pass code quality audits,
  standards compliance, pre-merge QA, dependency hygiene, or substantive Python
  changes in this repository.
- Use `uv` for Python dependency management. Keep `pyproject.toml` and
  `uv.lock` synchronized.
- Do not apply algotrading-specific standards to this project unless the user
  explicitly asks for them.

## Code Quality Baseline

- Prefer SOLID design where it improves maintainability.
- Prefer composition over inheritance for behavior reuse.
- Keep functions focused, typed, and easy to test.
- Validate inputs at boundaries and fail fast with actionable messages.
- Avoid bare `except:` and swallowed exceptions.
- Use module loggers for diagnostics; do not log secrets.
- Add or update focused tests for substantive behavior changes.

## Validation

- For a simple scaffold, `uv run python main.py` is enough.
- When tests exist, prefer `uv run pytest`.
- When lint/format tools are configured, run the project commands through `uv`.

Skip a full audit only for trivial edits or when the user explicitly opts out.
