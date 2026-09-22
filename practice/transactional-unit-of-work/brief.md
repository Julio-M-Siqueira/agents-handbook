# Transactional unit of work

Protect one order placement across inventory and order repositories with an explicit transaction boundary.

## Goal

Implement `place_order` in `starter/orders.py`.

## Constraints

- Enter the supplied unit of work before using its repositories.
- Reserve inventory and add the order before committing.
- Commit exactly once after both operations succeed.
- Let failures escape so the unit of work can roll back and preserve the original cause.

## Acceptance checks

Run `python -m unittest discover -s tests -v` from this exercise directory. The tests cover successful commit, domain failure, and repository failure.

## Hints

1. The context manager owns rollback behavior.
2. Put `commit` at the end of the successful path.
3. Do not catch failures merely to call rollback manually.

## Source and guidance

Based on [The Unit of Work Design Pattern Explained](https://www.youtube.com/watch?v=HX6vkP-QD7U), especially 01:02–03:24, and [Deep Dive Into the Repository Design Pattern](https://www.youtube.com/watch?v=9ymRLDfnDKg), especially 10:17–10:39. Read [[Transactional Unit of Work]] and [[Failures Are Observable and Actionable]].
