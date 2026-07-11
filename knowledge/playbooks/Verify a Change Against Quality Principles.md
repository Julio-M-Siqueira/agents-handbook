---
id: playbooks.verify_change_against_quality_principles
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
  - Quality Verification Pass
---
# Verify a Change Against Quality Principles

## Goal

Produce proportionate evidence that a change preserves its contract, follows the relevant principles, and is ready for review or delivery.

## Preconditions

- Read [[Verification Is Part of the Change]].
- Know the changed behavior, affected boundaries, and repository-standard commands.

## Steps

1. Classify the change: pure logic, boundary adapter, configuration, persistence, integration, bulk data, or structural refactor.
2. Select relevant principles and linked playbooks. Avoid checking unrelated concerns mechanically.
3. Review the diff for contract, composition, configuration, failure, and data-shape consequences.
4. Run the smallest targeted tests first, then the repository's standard quality gate when the change is substantive.
5. Inspect failures before rerunning; classify them as change defects, pre-existing issues, or environment limitations.
6. Record commands, results, unverified risks, and any intentional exceptions.
7. Report findings by severity with file references and the principle or contract they affect.

## Example

```text
Change: add typed retry configuration
Focused evidence: tests for valid default, invalid zero, and invalid text
Repository evidence: standard lint, type, and test gate
Residual risk: environment-only configuration source not exercised locally
```

The result is a compact evidence record, not an unqualified statement that the change "looks correct."
## Validation

- Does evidence cover both expected success and meaningful failure behavior?
- Were changed public or cross-module contracts tested?
- Did relevant static, format, and integration checks run?
- Are remaining limitations stated plainly?

## Failure handling

If a required check cannot run, record why, run the closest available alternative, and leave the related risk explicit. Never report an unrun gate as passed.

## Related

- [[Verification Is Part of the Change]]
- [[Focused Test Matrix]]
- [[Find Contract Boundary Refactors]]

