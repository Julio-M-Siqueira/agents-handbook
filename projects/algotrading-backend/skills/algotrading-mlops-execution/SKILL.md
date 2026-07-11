---
name: algotrading-mlops-execution
description: >-
  MLOps and real-time quant trading: deploys and operates low-latency
  inference-to-execution paths with SLOs, idempotency, model versioning, train/
  serve parity (algotrading-research training → backend inference), observability,
  and safe rollouts. Use for execution, inference, entrypoints, live runbooks,
  or when the user asks about MLOps, MLflow handoff, DVC training, canary, or
  production ML for this platform.
---

# Algotrading MLOps & real-time execution

## Role

Advise and implement as a **staff MLOps / production ML** engineer for **real-time** algorithmic trading: the goal is a **reliable, observable, reversible** path from market/feature updates → model scoring → risk → broker — without data leakage, silent skew, or unbounded operational risk.

Normative project standards remain **`documentation/code_standards.md`**; this skill adds **production ML + trading operations** depth.

---

## When to apply

- Code or config under `src/algotrading_backend/execution/`, `inference/`, `entrypoints/`, or `config/execution.yaml`, `config/inference.yaml`.
- Questions about: deployment, rollbacks, monitoring, SLOs, canary, shadow mode, “production readiness,” live vs backtest, or how **algotrading-research** training artifacts map to this repo.

**Deep audit**: use the subagent [mlops-quant-auditor](../../agents/mlops-quant-auditor.md) when the user wants a **dedicated** pass; otherwise follow this document inline.

---

## System design (real-time quant)

| Concern | Practice |
|--------|----------|
| **Latency** | Define **p99** budget (ingest + features + model + network + broker). Hot path: no blocking I/O without timeouts; no unbounded in-memory growth. |
| **Backpressure** | Bounded queues; drop or shed load with **explicit** policy; surface queue depth in metrics. |
| **Time correctness** | Event time vs processing time; clock skew; session boundaries. No lookahead from future bars. |
| **Idempotency** | Every external trigger (webhook, poll tick) that can **retry** must be safe: natural keys, `idempotency_key`, or persistent dedup with TTL. |
| **Ordering** | Where order matters, one writer per key or versioned sequence; document what happens on reorder. |
| **Failure modes** | Circuit breakers / kill switch for runaway loss; “fail closed” for risk when requirements say so. |

---

## MLOps lifecycle

1. **Artifacts** — Version **model + preprocessor + feature contract** (e.g. manifest: schema hash, training git SHA, data snapshot id if used).
2. **Environments** — `dev` / `paper` / `live` **separation**; no shared secrets; config-driven endpoints.
3. **Rollout** — Prefer **canary** or **shadow** (log-only compare) for new models; **pin** previous artifact for instant rollback.
4. **Data & labels** — If retraining, define **reproducible** training data and avoid leakage; align with [quant research audit](../algotrading-quant-research-audit/SKILL.md) for methodology.
5. **Governance** — Change log for model/risk parameter changes; who approved live promotion.

---

## Research repo → backend (training MLOps)

**algotrading-research** (sibling repository) is **offline**: Parquet in, no broker. It depends on **algotrading-core** for shared signal/feature logic; this backend does **inference + execution** only.

| Step | Research repo | This backend |
|------|----------------|--------------|
| **Train** | `python -m algotrading_research.entrypoints.train --config config/training/side_model.yaml` (optional `--register` for MLflow Model Registry) | N/A |
| **Artifacts** | `model_path` (joblib on disk), `features_path` (newline-separated `side_features`), `cv_metrics.json` (DVC metrics) | `inference` loads **joblib** via `model.local_path` or `model.s3_uri` (`model_loader.py`) |
| **Data parity** | `data.loader: s3_feature_store` uses the **same S3 key layout** as `AwsS3FeatureWriter` here | Live features must match that contract and column order expected by the saved model |
| **Tracking** | MLflow: params, CV metrics, plots, `mlflow.sklearn.log_model` (skops); `MLFLOW_DISABLE` / `MLFLOW_TRACKING_URI` | Log **which** artifact is live (version, run id, or s3 key in non-secret form) |
| **CI** | DVC/CI: `dvc repro train`, `dvc push` — pin outputs | Promote by updating inference config to the **built** artifact, not an ad-hoc retrain |

**Promotion checklist (minimal):** (1) joblib + feature list from the **same** training run, (2) `config/inference.yaml` points to that artifact, (3) feature pipeline in live code matches `side_features` / preprocessing, (4) MLflow or ticket records **run id** or **registry version** for rollback.

---

## Train / serve parity (non-negotiable for quant)

- Same **feature definitions** and **order of transforms** in training and inference.
- **Defaults**: avoid silent `fillna(0)` unless in both train and serve; document.
- **Embargo / point-in-time**: serving must only use data **known at decision time** (no future columns).
- **Categoricals**: same encoding; handle unseen levels explicitly.

---

## Observability (minimum)

- **Structured logs**: model version, strategy/run id, latency steps, result class — **no secrets**, no full credential-bearing payloads.
- **Metrics**: requests, errors, p99 latencies, queue depth, order outcomes, reconciliation gaps.
- **Traces** (if used): one coherent trace across inference → risk → execution when feasible.

**Gate** (if allowed): from repo root run `make check` after material changes; report pass/fail.

---

## Security & compliance

- Secrets only via **env / secret manager**; configs reference key names, not values.
- Audit trail for **who sent what** (internal actor id) without storing unnecessary PII.

---

## Output style for reviews

- Prioritize **highest severity** (money loss, unbounded risk, data leakage) first.
- Each issue: **what** / **where** (path or pattern) / **fix** (concrete).
- Cite or align with `documentation/code_standards.md` and existing patterns (Pydantic, `validators.py`, thin orchestrators).

## Additional resource

- For static standards sweep, [algotrading-code-quality](../algotrading-code-quality/SKILL.md) complements this skill.
