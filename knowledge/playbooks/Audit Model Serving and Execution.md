---
id: playbooks.audit_model_serving_and_execution
type: playbook
status: [draft]
scope: [mlops, execution]
owner: julio
created: 2026-10-12
tags: [knowledge/playbook]
---
# Audit Model Serving and Execution

## Goal

Verify model handoff and the inference → risk → external execution contract, prioritizing incorrect signals and unintended effects.

## Preconditions

- For requested refactors, apply [[Refactoring Simplifies the Whole Workflow]] and [[Design a Coherent Refactor]] before editing; include affected callers and consumers.
- Read [[Serving Preserves the Model Contract]] and [[Failures Are Observable and Actionable]]. Identify the execution mode, effect owner, availability requirement, and project-specific artifact contract before proposing recovery or rollout machinery.

## Steps

1. Trace the built model, preprocessor, ordered feature list, schema/version, training revision, and data snapshot where available. Compare producer outputs with loader/configuration consumers; do not assume training and serving repositories agree.
2. Check transform order, encoding and unseen categories, missing-value defaults, feature-store layout, and decision-time availability. Use [[Audit Temporal Data Validity]] when temporal correctness is affected.
3. Trace a trigger through scoring, risk validation, submission, partial fills, and reconciliation. Inspect stable effect identity, deduplication lifetime, concurrent/out-of-order events, restart behavior, and broker timeouts with uncertain outcomes. Establish which layer owns each invariant.
4. Compare ingest, feature, model, network, and broker latency with the stated budget. Inspect timeouts, bounded queues/memory, and observable shedding policy. Preserve required determinism; document intentional nondeterminism relevant to replay or reconciliation.
5. Inspect environment/credential separation, model and risk-parameter change history, promotion authority, and rollback compatibility. Assess shadow or canary evidence when warranted by rollout requirements. A review does not authorize live promotion.
6. Verify non-secret logs and metrics for artifact/run/signal identity, stage latency (including p99 where required), errors, queue depth, order outcomes, and reconciliation gaps. Check incident/runbook changes when operator actions change.
7. Group verified findings by contract and use [[Design a Coherent Refactor]] to score criticality, architectural improvement, and leverage separately. Select a coherent correction across affected producers and consumers; record implementation cost, migration risk, and verification effort separately. Prefer existing boundaries and ordinary exception propagation where sufficient; justify retries, circuit breakers, and fallback against concrete failures.

## Validation

Select focused checks for changed behavior: artifact/schema mismatch, feature order or preprocessing skew, repeated triggers, uncertain submission outcomes, out-of-order delivery, risk rejection, and compatible rollback. Run the repository's standard gate. Report production integration or latency checks that remain unrun.

## Failure handling

Do not infer readiness from a successful model load or green unit tests. Missing broker, training, or deployment evidence limits the conclusion. Distinguish proven defects from unverified risks; do not introduce live side effects to validate a review without authorization.

## Related

- [[Serving Preserves the Model Contract]]
- [[Audit Temporal Data Validity]]
- [[External Service Boundary]]
- [[Focused Test Matrix]]
- [[Verify a Change Against Quality Principles]]
