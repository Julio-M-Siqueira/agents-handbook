---
id: principles.decisions_use_available_information
type: principle
status: [draft]
scope: [quant-research, time-series]
owner: julio
created: 2026-10-12
tags: [knowledge/principle]
---
# Decisions Use Available Information

## Statement

A decision or historical simulation may depend only on information available at its decision time. Evaluation must preserve that information boundary through data preparation, feature construction, fitting, and model selection.

## Why

A correctly typed feature table can still expose future observations or revised history. Such leakage makes offline results optimistic without producing an engineering error.

## Implications

- Distinguish event time, publication/availability time, processing time, and the timestamp used as an index. A bar-open index does not make its eventual close available at the open.
- Align coarse and fine timeframes by when aggregates become available; trace aggregation, lagging, and alignment together.
- Fit scaling, imputation, encoding, and feature selection on the permitted training information within each evaluation split.
- Keep future-dependent labels separate from predictors and account for overlapping label horizons when choosing validation splits.
- Preserve the meaning of gaps, sessions, timezones, revisions, corporate actions, universe membership, and futures roll adjustments.
- Record research choices and data provenance so consumers can distinguish point-in-time data from retrospectively adjusted history.

## Exceptions

Future observations are legitimate targets and descriptive retrospective analyses may use revised data. Neither should be presented as information available to a live decision. A suspicious operation such as `ffill` or `pct_change` is not itself proof of leakage.

## Related

- [[Audit Temporal Data Validity]]
- [[Serving Preserves the Model Contract]]
- [[Explicit Operational Contracts]]
- [[Focused Test Matrix]]
