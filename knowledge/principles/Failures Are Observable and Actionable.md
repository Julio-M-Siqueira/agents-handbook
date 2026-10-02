---
id: principles.failures_are_observable_and_actionable
type: principle
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/principle
aliases:
  - Actionable Failures
  - Observable Errors
---
# Failures Are Observable and Actionable

## Statement

A failure should preserve enough context for a caller or operator to understand what failed, why it failed, and what action is appropriate, without exposing sensitive data. Failure handling should be proportional to the execution context and preserve the meaning of the requested result.

A safeguard needs a concrete failure scenario and an invariant to protect. Ordinary exception propagation is sufficient when it already produces the required unsuccessful outcome and useful diagnostic context.

## Why

Silent fallback, broad exception handling, and vague messages turn correctable faults into long investigations. Additional recovery paths can also obscure errors: a batch job may finish successfully after skipping required inputs, substituting defaults, or loading results from an earlier run.

Every additional branch, status flag, and exception wrapper creates behavior that must be understood and maintained. Its value comes from protecting a required contract, improving a caller's decision, or supplying missing diagnostic context. The possibility that an operation might raise an exception does not, by itself, justify another abstraction.

Research and batch workloads often benefit from stopping on an unexpected error. A failed experiment remains visibly incomplete. A plausible result computed from stale or partial inputs can be harder to detect and may invalidate later conclusions. Streaming and online workloads may need continued availability, but continuation must still preserve their data and side-effect contracts.

## Execution context

| Context | Default failure behavior | When additional handling is justified |
| --- | --- | --- |
| Research or batch computation | Propagate unexpected errors and fail the affected job or item visibly. | The workflow explicitly supports a bounded retry, a declared partial result, or an identified prior input, and consumers can distinguish that outcome. |
| Streaming or online service | Surface the failure and preserve the service's correctness contract. | An availability requirement supports bounded recovery, item isolation, or degraded operation with explicit semantics. |
| Irreversible side effect | Establish required preconditions before acting and preserve evidence of the outcome. | Idempotency, transaction boundaries, or recovery address a concrete risk of duplicate or partial effects. This applies to batch jobs too. |

The execution model informs the decision; it does not replace evidence about the operation. A batch payment job needs protection against duplicate transfers. A streaming calculation must not silently invent missing measurements.

## Example

### Sequential batch computation

```python
# A failed current build becomes an apparently successful older result.
def run_experiment(source):
    try:
        dataset = build_dataset(source)
    except Exception:
        dataset = load_latest_successful_dataset()
    return train(dataset)
```

If the contract requires a new dataset, let its build failure stop the dependent computation:

```python
def run_experiment(source):
    dataset = build_dataset(source)
    return train(dataset)
```

The sequence already prevents training after a failed build. It needs no extra status gate to enforce that ordering. Reusing a previously published dataset can be a separate, explicit request with a selected artifact identity.

Keeping an older artifact available is different from selecting it for the current request. A `latest_successful` reference may be useful for browsing or deliberate reuse. After a failed rebuild, an independent consumer must not assume that reference identifies the requested rebuild. The contract must state which artifact it consumes and how that identity is exposed.

### Actionable translation at a boundary

```python
try:
    store.read(dataset_uri)
except FileNotFoundError as error:
    raise DatasetInputError(
        f"Required dataset {dataset_uri} is missing; publish it before running this job"
    ) from error
```

This translation supplies a required-input relationship the storage error may not explain. Use a native exception directly when it already gives the caller adequate context. A custom type is useful when a caller actually distinguishes it; it is not required for every dependency error.

## Implications

- Identify the failure scenario, protected invariant, and affected caller before introducing defensive behavior.
- Compare the proposed handling with normal propagation. If it adds no required behavior or useful context, omit it or remove it.
- Catch only errors that the current layer can handle, translate, or enrich. Preserve the original cause and avoid repeated translation at every layer.
- Use domain-specific error types where callers need distinct behavior. Log at the boundary with operational context; avoid logging and rethrowing the same failure at every layer.
- Keep boundary validation for external inputs, model/data compatibility, and consequential side effects. Do not repeatedly validate state already established by its owning boundary.
- For batch and research work, default to an unsuccessful outcome when required computation or publication fails. Do not convert failures to empty results, neutral values, skipped work, or older artifacts without an explicit contract.
- Make accepted recovery, retry, skip, or fallback outcomes visible to consumers through the result, provenance, or job outcome as appropriate. A warning alone is insufficient when the returned result otherwise looks complete and current.
- Retry only failures known to be transient, with a bound and a safe repeat operation. Do not retry deterministic validation errors or potentially duplicate side effects without a defined contract.
- Preserve valid published artifacts when useful, but distinguish availability of previous work from successful completion of the current request.
- Introduce a context manager, state machine, or shared failure wrapper only when concrete resource ownership, lifecycle invariants, or repeated behavior justify it. Sequential execution alone is not such a requirement.

## Exceptions

- Expected absence can be modeled as a result variant when absence is a valid domain outcome.
- An explicitly best-effort batch may continue after item failures if its output identifies omitted items and callers accept partial completion.
- A bounded retry may be appropriate for a transient read failure in any execution model, including a batch job.
- Cleanup, resource release, rollback, and protection around irreversible effects can require handling even when an exception is already visible.
- Low-level libraries may expose their native errors when higher layers can interpret them directly.
- Security boundaries may intentionally omit sensitive details from user-visible errors while retaining safe diagnostic context in logs.

## Related

- [[Find Failure Observability Gaps]]
- [[Actionable Domain Failure]]
- [[Boundary Validated State]]
- [[Explicit Operational Contracts]]
- [[Transactional Unit of Work]]
- [[Focused Test Matrix]]
- [[Software Design in Python Video Series]]
