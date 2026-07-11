---
name: exam-readness-code-quality
description: >-
  Final-pass code quality audit for the exam-readness-tuttor project. Use when
  working in D:\projects\exam-readness-tuttor, after substantive Python changes,
  before publishing/merging, or when the user asks for standards compliance,
  architecture review, tests, security, maintainability, uv dependency hygiene,
  or a code quality audit.
---

# Exam Readiness Tutor Code Quality Audit

## Shared baseline

Use the installed `code-quality` skill to discover and rank general design findings through the shared principles, playbooks, and patterns. Apply this skill for exam-readness-tuttor standards, toolchain, and repository-specific validation; when they differ, this project-specific skill takes precedence.
## Role

Perform the review as a strict senior software engineer. Be evidence-based,
specific, and oriented toward maintainability. Prefer clear findings over broad
approval. Use this skill for this repository, not the algotrading backend.

If the repository later contains a local `AGENTS.md`, `documentation/code_standards.md`,
or similar project standard, treat that local file as authoritative and use this
skill as the checklist map.

## Scope

Default scope is the changed files in `D:\projects\exam-readness-tuttor`.
Broaden scope when the change touches shared behavior, project structure,
configuration, dependency management, user-facing workflows, or security.

Do not apply algotrading-only standards such as vectorized market data rules,
bar timestamp conventions, ABC registries for trading backends, or live trading
MLOps expectations unless the user explicitly asks to reuse them here.

## Design Principles

- Apply SOLID where it matters; name the violated letter when a finding depends
  on it.
- Prefer composition over inheritance for behavior reuse.
- Keep orchestrators thin; put reusable behavior in services, helpers,
  validators, or small modules.
- Keep public APIs typed and documented with concise docstrings.
- Keep functions focused; split code when control flow or responsibilities
  become hard to test.
- Make invalid states hard to represent with validation at boundaries.

## Dependency and Project Management

- Use `uv` for dependency management.
- Add runtime dependencies with `uv add <package>`.
- Add development dependencies with `uv add --dev <package>`.
- Keep `pyproject.toml` and `uv.lock` in sync.
- Do not use raw `pip install` instructions for this project unless the user
  explicitly asks for a one-off diagnostic.
- Keep `.venv/`, caches, build artifacts, and secrets ignored by Git.

## Configuration and Boundaries

- Prefer configuration files or typed settings objects for tunables that may vary
  by environment.
- Validate external inputs, file contents, environment variables, and API
  responses before deeper business logic uses them.
- Fail fast with actionable messages: what failed, why it matters, and how to fix
  it.
- Avoid hard-coded paths outside the repository unless they are clearly user
  supplied or documented.

## Errors, Logging, and Security

- Avoid bare `except:` and broad catches that hide root causes.
- Preserve exception context when wrapping errors.
- Use `logging.getLogger(__name__)` in modules instead of print-based diagnostics,
  except for intentional CLI output.
- Never log secrets, tokens, passwords, private keys, or full `.env` contents.
- Keep generated files and automation artifacts out of commits unless they are
  intentional project assets.

## Tests and Validation

Run the most relevant checks before marking work complete:

| Goal | Preferred command |
| --- | --- |
| Run app smoke test | `uv run python main.py` |
| Run tests | `uv run pytest` |
| Lint | `uv run ruff check .` |
| Format check | `uv run ruff format --check .` or project formatter |

If a tool is not configured yet, say so and recommend the smallest useful next
step instead of inventing a heavy toolchain.

For substantive code changes, expect tests that cover success and failure paths.
For narrow scaffolding or docs changes, a smoke test or Git status check may be
enough.

## Review Checklist

### Must Fix

- Failing relevant tests or smoke checks.
- Dependency changes not reflected in `uv.lock`.
- Secrets committed or logged.
- Bare `except:` or swallowed exceptions around important behavior.
- User input, file parsing, or external data used without validation.
- Architecture that makes normal extension require editing unrelated modules.

### Should Fix

- Untyped public functions in non-trivial modules.
- Large functions with multiple responsibilities.
- Duplicated logic that should be a helper or service.
- Hard-coded tunables likely to change between environments.
- Missing tests around newly introduced branches.

### Nice To Have

- Clearer naming, smaller helpers, or improved docs that reduce future confusion.
- Better local developer ergonomics, such as documented `uv` commands.
- Lightweight CI once the project has meaningful tests or linting.

## Output Template

```markdown
## Code Quality Summary

**Scope:** [files / diff / command]
**Automated:** `[command]` -> [PASS | FAIL | not run - reason]

### Must Fix
- [severity] `path:line` - issue - standard/checklist topic

### Should Fix
- ...

### Nice To Have
- ...

### Compliant Areas
- ...
```

Lead with findings. If there are no issues, say so directly and list any residual
risk or checks that were not run.

