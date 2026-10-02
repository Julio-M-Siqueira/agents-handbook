---
id: playbooks.find_failure_observability_gaps
type: playbook
status:
  - draft
scope:
  - code-quality
owner: julio
created:
  "{ date:YYYY-MM-DD }":
tags:
  - knowledge/playbook
aliases:
  - Audit Error Handling
---
# Find Failure Observability Gaps

## Goal

Find failure paths that hide errors, change result semantics, or add defensive complexity without a demonstrated benefit. Recommend the smallest change that preserves the operation's contract and makes failures actionable.

## Preconditions

- Read [[Failures Are Observable and Actionable]].
- Identify the execution context: research, batch, streaming, online, or a combination.
- Establish the requested result, its input identity, consequential side effects, and how callers observe success or failure.
- Identify existing validation, exception propagation, scheduler behavior, and operational logs before proposing new mechanisms.

## Steps

1. State the success and failure contract.

   Determine whether partial results, omitted items, retries, or previously published inputs are supported. Use requirements, callers, tests, and operational documentation as evidence. Do not infer a need for recovery solely because an external dependency can fail.

2. Search for both hidden failures and unnecessary defensive behavior.

   Look for broad exception handlers, empty handlers, generic errors, fallback values, automatic retries, `continue` after failures, `latest_successful` selection, default empty collections, duplicate validation, and status wrappers around sequential work. A match is a candidate, not a finding.

3. Trace the ordinary failure path before assessing the safeguard.

   Follow the original exception through the command, worker, scheduler, or caller. Establish whether normal propagation already stops dependent work, produces an unsuccessful outcome, and supplies enough context. For sequential pipelines, verify actual exception propagation rather than assuming another status gate is needed.

4. Trace the proposed or existing handled path through its consumers.

   Check the exit status, returned data, selected artifact identity, published outputs, and downstream behavior. Follow later commands as well as the current process: after a failed rebuild, a fresh consumer might still select an older publication. For transactional operations, trace partial effects and whether cleanup or rollback preserves the original error.

5. Evaluate the safeguard's benefit and cost.

   Record the concrete failure scenario, invariant, and caller decision it changes. Compare that benefit with added branches, mutable state, coupling, duplicated checks, and recovery semantics. For retries, establish that the failure is transient and repeating the operation is safe. For fallback, establish who accepts the changed result and how consumers recognize it.

6. Group and rank verified findings by contract.

   Group by hidden partial completion, unrequested stale-data reuse, lost failure context, or redundant lifecycle handling. Score criticality, refactor leverage, and minimality from 1 to 5, as in [[Find Boundary Validation Refactors]]. A plausible but incorrect successful result generally deserves higher criticality than redundant code with no demonstrated behavioral defect. Do not score a streaming path higher merely because it is continuously running.

7. Select the smallest corrective change.

   Prefer removing an unnecessary catch, fallback, or duplicated status check when normal propagation already fulfills the contract. Preserve required boundary validation and resource cleanup. Add [[Actionable Domain Failure]] only when translation supplies missing context or a caller needs a distinct outcome. Retain justified retries or partial-result handling and make their contracts explicit.

8. Verify the affected behavior.

   Use [[Focused Test Matrix]] and the repository's standard gate for substantive code changes. Test the requested result and the concrete failure scenario; when recovery is supported, verify the selected inputs, reported completeness, and relevant side effects. Avoid tests that merely assert the existence of a new wrapper or duplicate framework guarantees.

## Example

### A batch fallback hides the requested build failure

```python
# Candidate: a failed current build silently selects older inputs.
def train_current(source):
    try:
        dataset = build_dataset(source)
    except Exception:
        dataset = load_latest_successful_dataset()
    return train(dataset)
```

First inspect callers to establish whether they requested a fresh build or explicitly allowed reuse. If they require a fresh build, the minimal correction is:

```python
def train_current(source):
    dataset = build_dataset(source)
    return train(dataset)
```

A focused failure test should demonstrate that the build error reaches the caller and training is not invoked. If an older artifact remains stored, separately check that downstream selection cannot present it as the failed rebuild's output. Explicitly selecting an older publication for a new training command may be valid; do not label that policy a defect without evidence about the caller's expectation.

### A boundary needs additional context

```python
try:
    dataset = store.read(dataset_uri)
except FileNotFoundError as error:
    raise DatasetInputError(
        f"Required dataset {dataset_uri} is missing; publish it before running this job"
    ) from error
```

Retain the translation when the dependency error does not explain the required dataset relationship. Remove a wrapper that merely repeats the native error without changing a caller decision or adding context.

## Validation

- What concrete failure and invariant justify each retained safeguard?
- Would ordinary exception propagation already meet the failure contract?
- Does the execution context actually require continued operation, partial results, or fallback?
- Can consumers distinguish current, prior, partial, and failed results without inferring them from logs?
- Can a failed rebuild leave a later consumer unknowingly using an older publication?
- Are retry bounds, transient failure categories, and repeat safety established where retries remain?
- Are external-input validation and necessary cleanup preserved while redundant checks are removed?
- Is the original cause preserved, and is the error reported at a useful boundary without duplicate noise?
- Are safe identifiers available without exposing sensitive data?
- Does verification cover the behavior promised to callers rather than the internal shape of the safeguard?

## Failure handling

If the required recovery policy is unknown, record the uncertainty and identify the caller whose expectation resolves it. For new batch behavior, prefer propagating the error until a different outcome is justified. Do not silently introduce retry, skip, fallback, partial success, or stale-data reuse.

For existing behavior, inspect its consumers before removing recovery; it may implement a legitimate operational contract. When the evidence shows that ordinary propagation already meets the contract, explicitly recommend no additional safeguard. If the review finds no concrete issue, record that result rather than inventing a defensive abstraction.

## Related

- [[Failures Are Observable and Actionable]]
- [[Actionable Domain Failure]]
- [[Boundary Validated State]]
- [[Explicit Operational Contracts]]
- [[Find Boundary Validation Refactors]]
- [[Transactional Unit of Work]]
- [[Focused Test Matrix]]
- [[Verify a Change Against Quality Principles]]
- [[Software Design in Python Video Series]]
