---
id: principles.serving_preserves_the_model_contract
type: principle
status: [draft]
scope: [mlops, execution]
owner: julio
created: 2026-10-12
tags: [knowledge/principle]
---
# Serving Preserves the Model Contract

## Statement

A served prediction must identify its model and compatible feature/preprocessing contract. Its external effects must obey the execution system's ordering, repeat-safety, and risk requirements.

## Why

A model can load successfully while consuming reordered columns or different preprocessing. A valid prediction can still create duplicate effects after a timeout. Promotion and execution therefore need observable compatibility and side-effect contracts.

## Implications

- Version model, preprocessing, ordered feature schema, and training provenance together. Record artifact/run identity in serving outcomes without exposing secrets.
- Preserve transform order, encoding, missing-value semantics, and point-in-time availability between training and serving.
- Promote a built, identified artifact; separate development, paper, and live environments and their credentials. Rollback restores a compatible artifact/configuration combination.
- Define latency budgets and bounded resource use where availability requires them; make queue shedding, stale-input treatment, and out-of-order handling explicit.
- Enforce risk preconditions at the boundary owning external effects. A retry after an uncertain outcome requires idempotency or reconciliation, not merely another request.
- Preserve operator evidence of model version, signal identity, latency, risk decision, execution result, and reconciliation state. Define halt/fail-closed behavior from actual requirements.

## Exceptions

Offline scoring without external effects does not need an order lifecycle. Canary, shadow, circuit breakers, and fallback are mechanisms to select for demonstrated requirements, not mandatory infrastructure for every model. Research failures normally stop the affected operation.

## Related

- [[Audit Model Serving and Execution]]
- [[Decisions Use Available Information]]
- [[Failures Are Observable and Actionable]]
- [[External Service Boundary]]
