# Research-to-live alignment review

Read this project reference for PR changes to ingestion, features, shared dependencies, inference, execution, model artifacts, or their configuration. Use the installed `code-quality` skill with both **Decisions Use Available Information** → **Audit Temporal Data Validity** and **Serving Preserves the Model Contract** → **Audit Model Serving and Execution**. The shared skill owns the evidence, ranking, reporting, and verification method; this reference owns the project's research-to-live comparison requirements.

A primary review goal is to detect whether the proposed PR introduces or worsens a mismatch between `algotrading-research` backtests and backend live inference/execution. Trace the affected research-to-live contract. For unrelated changes, record why this check is not applicable. Read [model handoff](model-handoff.md) when training-to-serving compatibility is involved.

## Cross-repository evidence

- Locate `algotrading-research` through an accessible sibling checkout (normally `../algotrading-research`) or an authorized repository connector. Inspect `algotrading-core` too when shared behavior or dependency versions affect the contract. Read each repository's applicable instructions before inspecting it; do not assume that separate repositories or a shared package imply matching behavior.
- Record the backend PR base/head, research commit, relevant core versions/revisions, and model/run/configuration identity used for comparison. Identify local modifications that affect the evidence. Prefer the research revision and artifacts associated with the strategy/model being served; an arbitrary latest research checkout is not proof of compatibility with the deployed model.
- Compare backend behavior before and after the PR against that identified research baseline. Distinguish newly introduced or worsened mismatches from pre-existing drift and documented intentional differences. Do not describe the backend branch as deployed production without deployment evidence.
- If code, revisions, artifacts, or deployment configuration are unavailable, continue the review that the available evidence supports and explicitly mark the affected alignment checks as unverified. Name the missing evidence and how to obtain it. Never infer parity from backend-only tests, a successful model load, or matching field names.

## Contracts to compare

Trace the affected path from market data through features, prediction, signal, position sizing, risk checks, and orders/fills. Compare relevant code, effective configuration, and tests on both sides:

- **Data and decision time:** instruments, price adjustments, sessions/timezones, bar completeness, timestamp meaning, resampling/alignment, feature availability, warm-up/history windows, and missing/stale data behavior. Preserve the documented bar-close convention and explicitly identify next-open strategies. A valid same-row feature does not by itself establish that a simulated same-close fill is attainable live.
- **Features and models:** feature definitions, ordering, dtypes, preprocessing/fit scope, missing values, categorical encoding, model output/class meaning, artifact provenance, and shared-library versions. Confirm that the exported model, preprocessing, and feature schema belong together.
- **Signals and portfolio behavior:** thresholds, side/size model interpretation, entry/exit rules, holding horizons, stops/targets, sizing units, leverage, portfolio state, and risk limits. Check that label/backtest assumptions map to the actual live decision and execution policy.
- **Execution assumptions:** order timing/type, reference and fill prices, fees/spread/slippage, latency, rounding/lot constraints, partial/rejected fills, and repeated or out-of-order events when relevant. Document intentional simulation approximations and assess whether the PR invalidates them; do not require identical simulated and live fills.

## Findings and verification

For each verified mismatch, cite producer and consumer locations with repository/revision, the changed behavior, a concrete input/timestamp/order scenario, and its effect on signals, exposure, or backtest comparability. Use the code-quality skill's severity/ranking procedure and keep unverified risks separate from findings.

Run or propose focused parity/replay checks for affected contracts using identical identified inputs, model artifacts, and configuration on both paths. Compare intermediate features, predictions, signals, and intended orders with justified tolerances and explicit intentional differences. Record commands, outcomes, and unrun checks; use the standard quality gate for substantive changes. Validation must not submit live orders or promote models. End the alignment assessment with the verified scope, mismatches found, and remaining evidence gaps; do not claim full parity from a limited comparison.
