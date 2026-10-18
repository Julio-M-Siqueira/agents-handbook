# algotrading-backend Agent Instructions

## Review workflow

Use the installed `code-quality` skill for reviews and substantive implementation verification. It owns the evidence, ranking, report, and verification procedure. Read the relevant sections of `documentation/code_standards.md` as the authoritative project standard.

Select domain knowledge through that skill:
- Feature engineering, ingestion, labels, and backtests: **Decisions Use Available Information** → **Audit Temporal Data Validity**.
- Inference, execution, model promotion, and production readiness: **Serving Preserves the Model Contract** → **Audit Model Serving and Execution**.

The knowledge lives in the handbook's `knowledge/` directory (installed at `~/.codex/knowledge/`). The skill contains resolvable links. Apply both domain routes when a change crosses their boundaries.

## Research-to-live alignment in PR reviews

For PR changes to ingestion, features, shared dependencies, inference, execution, model artifacts, or their configuration, apply both domain routes and read `~/.codex/projects/algotrading-backend/references/research-to-live-review.md` (handbook source: `projects/algotrading-backend/references/research-to-live-review.md`). For unrelated changes, record why this check is not applicable.

## Project contracts

- Read `documentation/BAR_TIMESTAMP_CONVENTIONS.md` for temporal reviews. OHLCV indices denote bar open; close-based quantities become available at bar end. The platform default is a bar-close decision; same-row features are not automatically leakage. Explicitly distinguish next-open strategies.
- Keep thin orchestrators, YAML tunables validated by Pydantic, boundary validators, module exceptions, and the project's ABC/registry extension contracts. Read the standard for public typing/docstrings, logging conventions, dependency commands, and coverage requirements.
- Keep computational stages explicit; resource contexts own actual lifetimes rather than hiding computation in preparation.
- Source acquisition and audit workflows belong to the owning pipeline; market-source acquisition belongs under `data_ingestion/`.
- `algotrading-research` owns offline training, `algotrading-core` owns shared signal/feature logic, and `algotrading-backend` owns inference and execution.
- Vectorize intensive feature-store and ingestion transformations. Follow the standard's configurable joblib parallelism and nested-worker limits; preserve genuine sequential semantics.
- Training handoff details are maintained in the installed project bundle's `references/model-handoff.md` (`~/.codex/projects/algotrading-backend/references/model-handoff.md`). Read it when reviewing training-to-serving compatibility.
- Use repository Make targets: `make check` for substantive changes and merge-readiness reviews; `make all` includes formatting, `make coverage` reports coverage, and `make install-dev` installs development dependencies. Report failed or unrun checks.

Edit project instructions, agent/rule adapters, and references in agents-handbook and publish through its sync script.
