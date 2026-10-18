# Exam Readiness Tutor Code Standards

This reference owns the maintained baseline for `D:\projects\exam-readness-tuttor`.
Repository-local `AGENTS.md`, `documentation/code_standards.md`, or equivalent
authoritative standards take precedence over these baseline details. Use this
reference as the checklist map when a more specific local standard exists.

Use the [shared code-quality skill](../../../skills/code-quality/SKILL.md) for
analysis, complete affected-workflow tracing, design, ranking, verification,
and reporting. This reference adds local contracts and priorities to that method.
Perform a strict, evidence-based senior engineering review: specific findings
and maintainability evidence take precedence over broad approval.

## Scope

Use the project audit for final-pass code quality, standards compliance,
pre-merge/publishing QA, substantive Python changes, and changes to dependencies,
project structure, configuration, testing, logging, security, or user-facing
workflows. Skip a full audit only for trivial edits or when the user explicitly
opts out; use proportional verification for the remaining work.

Changed files are the starting scope. Include `pyproject.toml`, `uv.lock`, tests,
configuration, and documentation when the change depends on them; broaden for
shared behavior or affected workflows. For refactors, the shared method owns
tracing of every affected caller and consumer before editing and target-flow
design before file boundaries. Preserve established contracts.

Do not apply algotrading-only standards such as vectorized market data rules,
bar timestamp conventions, trading-backend ABC registries, or live trading
MLOps expectations unless the user explicitly asks to reuse them here.

## Design and boundaries

- Apply SOLID where it improves maintainability; name the violated letter when
  a finding depends on it. Prefer composition over inheritance for behavior reuse.
- Keep orchestrators thin and reusable behavior in services, helpers, validators,
  or small modules; avoid unnecessary hierarchies. Keep major computations
  explicit as named stages. Resource scopes manage actual lifetimes; generic
  preparation helpers must not hide computation merely to share code.
- Keep functions focused, typed, and testable. Give public APIs concise docstrings;
  split code when control flow or responsibilities become hard to test.
- Make invalid states hard to represent. Validate external inputs, file contents,
  environment variables, and API responses at boundaries before business logic.
- Prefer configuration files or typed settings for tunables that vary by
  environment. Avoid hard-coded paths outside the repository unless clearly
  supplied by the user or documented.

## Dependencies and repository hygiene

- Use `uv`: runtime dependencies use `uv add <package>` and development
  dependencies use `uv add --dev <package>`. Keep `pyproject.toml` and `uv.lock`
  synchronized. Do not recommend raw `pip install` unless the user explicitly
  asks for a one-off diagnostic.
- Keep `.venv/`, caches, build artifacts, and secrets ignored by Git. Keep
  generated files and automation artifacts out of commits unless they are
  intentional project assets.

## Errors, logging, and security

- Fail fast with actionable messages identifying what failed, why it matters,
  and how to fix it. Avoid bare `except:`, swallowed exceptions, and broad catches
  that hide root causes. Preserve exception context when wrapping errors.
- Use `logging.getLogger(__name__)` for module diagnostics, reserving print-based
  output for intentional CLI output. Never log secrets, tokens, passwords,
  private keys, or full `.env` contents.

## Validation

Run the relevant configured checks through `uv` before marking work complete:

| Project state or check | Command |
| --- | --- |
| Simple scaffold smoke test | `uv run python main.py` |
| Tests, once present | `uv run pytest` |
| Configured lint | `uv run ruff check .` or the project's lint command |
| Configured formatter | `uv run ruff format --check .` or the project's formatter check |

A simple scaffold needs only its smoke test. Substantive behavior changes need
focused tests for success and failure paths, including newly introduced branches.
Narrow scaffolding or documentation edits may need only a smoke test or Git
status check. If a tool is unconfigured, say so and recommend the smallest useful
next step rather than inventing a heavy toolchain. Record commands as PASS,
FAIL, or not run with the reason.

## Local finding priorities

Apply these priorities within the shared report and ranking procedure; they do
not establish a separate report template or replace evidence-based scoring.

| Priority | Local expectations |
| --- | --- |
| Must fix | Failing relevant tests/smoke checks; dependency changes not reflected in `uv.lock`; secrets committed or logged; bare `except:` or swallowed exceptions around important behavior; unvalidated user input, file parsing, or external data; architecture that makes normal extension require edits to unrelated modules. |
| Should fix | Untyped public functions in non-trivial modules; functions with multiple responsibilities; duplicated logic better owned by a helper/service; hard-coded environment-dependent tunables; missing tests for new branches. |
| Nice to have | Clearer naming, smaller helpers, or documentation that reduces confusion; developer ergonomics such as documented `uv` commands; lightweight CI once meaningful tests or linting exist. |

Use the shared report, scaled to the task. Lead with findings and connect each to
its source location and applicable standard. Note compliant areas supported by
the review. If there are no verified issues, state that directly. Always disclose
unrun checks and residual risk; preserve shared design, alternatives, retained
complexity, architectural evidence, and completion fields where relevant.
