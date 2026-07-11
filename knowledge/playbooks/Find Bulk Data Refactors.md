---
id: playbooks.find_bulk_data_refactors
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
  - Find Vectorization Opportunities
---
# Find Bulk Data Refactors

## Goal

Find collection and dataset transformations expressed as avoidable element-by-element loops, rank them, and propose the smallest correct bulk transformation.

## Preconditions

- Read [[Bulk Operations Preserve Intent]].
- Know the data shape, ordering semantics, and expected output for the target path.

## Steps

1. Search for loops over rows, records, elements, or dataframe iterators in transformation code.
2. Separate pure transformations from loops that perform I/O, maintain sequence state, or call external systems.
3. For pure candidates, write the transformation as selection, mapping, grouping, and aggregation.
4. Verify required ordering, null behavior, grouping keys, and data types before choosing an API.
5. Score runtime volume, correctness risk, readability gain, and minimality from 1 to 5.
6. Choose the highest-value candidate with clear equivalence tests.
7. Replace the loop with a bulk operation and add edge-case tests for empty, missing, and grouped data.

## Example

```python
# Candidate
for _, row in frame.iterrows():
    frame.loc[row.name, "gross"] = row["quantity"] * row["unit_price"]

# Bulk refactor
frame["gross"] = frame["quantity"] * frame["unit_price"]
```

This is a high-value candidate because each row is independent and the equivalent expression is direct.
## Validation

- Is the result equivalent for representative and boundary inputs?
- Are ordering and grouping explicit?
- Does the new expression expose the business transformation more clearly?
- Is iteration retained only where it represents genuine sequential or side-effecting behavior?

## Failure handling

If vectorization would hide sequential semantics or make the code less correct, retain the loop and document why it is intentional.

## Related

- [[Bulk Operations Preserve Intent]]
- [[Bulk Transformation Pipeline]]
- [[Verification Is Part of the Change]]

