# Validated parameter object

Turn a repeated group of search arguments into a narrow value object that establishes its own invariant.

## Goal

Implement `SearchQuery` validation and `to_parameters` in `starter/search.py`.

## Constraints

- Reject blank terms and pages below one during construction.
- Normalize the term by trimming surrounding whitespace.
- Return provider-ready parameters without exposing invalid or optional state to `SearchService`.
- Do not put provider calls or caching in `SearchQuery`.

## Acceptance checks

Run `python -m unittest discover -s tests -v` from this exercise directory. The tests cover normalization, both invalid states, and the service contract.

## Hints

1. `__post_init__` is a useful boundary for a frozen dataclass.
2. `object.__setattr__` can normalize a field during that boundary.
3. The service should simply use the already-valid object.

## Source and guidance

Based on [Too Many Parameters? Use This Pattern](https://www.youtube.com/watch?v=43sDzyanzR0), especially 05:00–06:04, and [Too Many Function Arguments? Use This Pattern](https://www.youtube.com/watch?v=UG5jbLReDiM), especially 18:55–19:00. Read [[Validated Parameter Object]].
