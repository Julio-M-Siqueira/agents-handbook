---
id: playbooks.audit_temporal_data_validity
type: playbook
status: [draft]
scope: [quant-research, time-series]
owner: julio
created: 2026-10-12
tags: [knowledge/playbook]
---
# Audit Temporal Data Validity

## Goal

Find verified information-set violations and fragile evaluation assumptions in ingestion, features, and research pipelines.

## Preconditions

- For requested refactors, apply [[Refactoring Simplifies the Whole Workflow]] and [[Design a Coherent Refactor]] before editing; include affected callers and consumers.
- Read [[Decisions Use Available Information]]. Establish live versus retrospective use, decision time, horizon, instruments, and the project's timestamp convention from code and documentation. State unresolved assumptions.

## Steps

1. Trace one decision: source availability → transformation → feature → prediction → future label. Explain exactly what is knowable at that time.
2. Inspect as-of joins, `ffill`/`bfill`, shift direction, centered rolling windows, returns, resample label/closed settings, timezones, and session boundaries. For multi-timeframe features, verify aggregation → lag → alignment against actual availability.
3. Trace ingestion ordering, deduplication, gaps, and overwrite/incremental merge modes. Inspect whether later files or revised records change historical information sets. Check corporate actions, historical universe selection, and futures roll conventions for incompatible levels or returns.
4. Inspect fit scopes for normalization, imputation, winsorization, encoding, and feature selection. Trace overlapping labels across train/test boundaries and model selection across repeated experiments. Consider purging, embargo, or nested evaluation only when the dependence structure or selection procedure justifies them.
5. Distinguish proven leakage from untested robustness assumptions such as regime drift, scaling stability, execution costs, or sampling choices. Tie any advanced method suggestion to an observed problem and label it as a proposal.
6. Group findings by information boundary and use [[Design a Coherent Refactor]] to score criticality, architectural improvement, and leverage separately. Cite the producer, consumer, and timestamp counterexample; select a correction that resolves the cause across the affected data flow, with migration risk and verification effort recorded separately.

## Validation

Use [[Focused Test Matrix]] for affected contracts: a later observation must not alter an earlier decision's feature; a coarse bar must not appear before availability; held-out data must not change fitted training preprocessing. Select cases relevant to the change, then run the project's standard gate. Green engineering tests alone do not prove absence of leakage.

## Failure handling

Missing data or unavailable cross-repository code limits the conclusion. Record the missing evidence rather than claiming no leakage or reporting an unverified suspicion as a finding. Failed batch preparation follows [[Failures Are Observable and Actionable]]; no silent fills, skipped inputs, or prior datasets without an explicit consumer contract.

## Related

- [[Decisions Use Available Information]]
- [[Audit Model Serving and Execution]]
- [[Verify a Change Against Quality Principles]]
