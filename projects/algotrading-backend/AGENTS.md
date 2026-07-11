# algotrading-backend Agent Instructions

## Shared Baseline

Use the generic `code-quality` skill for principle-driven refactor discovery and verification. Apply the specialist routing below when the work is specific to this project.

## Specialist Routing

- Use `algotrading-code-quality` for standards compliance, pre-merge QA, or substantive Python changes under `src/`. Treat `documentation/code_standards.md` as authoritative and run `make check` when practical.
- Use `algotrading-quant-research-audit` for feature engineering, ingestion, leakage analysis, bar-timestamp alignment, ML/backtest methodology, and feature validity. Treat `documentation/BAR_TIMESTAMP_CONVENTIONS.md` as authoritative.
- Use `algotrading-mlops-execution` for execution, inference, relevant entrypoints, model promotion, production readiness, observability, and rollback safety.

## Project Constraints

- Vectorize computationally intensive feature-store and ingestion paths. Use configurable parallelism and prevent nested worker oversubscription.
- For execution and inference work, check latency, determinism, idempotency, train/serve feature contracts, observability, rollback behavior, and fail-closed safety.
- Keep the project-specific agents, rules, and specialist skills in this project bundle synchronized from agents-handbook.
