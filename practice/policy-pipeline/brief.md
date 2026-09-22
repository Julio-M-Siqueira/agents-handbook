# Policy pipeline

Replace flag-directed authorization logic with a deterministic sequence of policy functions.

## Goal

Implement the policy resolution and application functions in `starter/policies.py`.

## Constraints

- Resolve only configured names from the supplied registry.
- Reject an unknown policy name with `UnknownPolicy` before applying any rule.
- Apply policies in the configured order and stop at the first `AccessDenied`.
- Keep individual policy functions independent; do not add flags to `apply_policies`.

## Acceptance checks

Run `python -m unittest discover -s tests -v` from this exercise directory. The tests cover ordering, short-circuiting, and invalid configuration.

## Hints

1. A policy can be a callable whose normal result means success.
2. Build the selected list before the loop so configuration errors occur at the boundary.
3. Do not catch `AccessDenied` in the loop.

## Source and guidance

Based on [Don't Use Boolean Flags in Python, Use Policies Instead](https://www.youtube.com/watch?v=wYeDGkdMi3g), especially 04:40–09:17 and 11:15–11:33. Read [[Policy Pipeline]] and [[Registry-Based Selection]].
