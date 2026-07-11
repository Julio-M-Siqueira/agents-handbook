---
id: playbooks.find_boundary_validation_refactors
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
  - Search Code Quality Refactors From Principles
  - Find Class Early Validation Refactors
---
# Find Boundary Validation Refactors

## Goal

Find code quality refactor opportunities where core logic accepts raw, partial, nullable, or weakly validated state, then rank the findings and identify the most critical minimal refactor.

This playbook applies the [[Boundary Validated State]] principle. It should produce generalizable findings, not one-off fixes tied to the first example discovered.

## Preconditions

- A principle is selected and understood before searching.
- The principle has been translated into a search lens:
  - invariant being protected;
  - weak state that can violate the invariant;
  - boundary where validation should happen;
  - core logic that should receive validated state;
  - exceptions where optional or transitional state is legitimate.
- Repository context is available.
- Search tools such as `rg` are available.

## Steps

1. Restate the principle in abstract terms.

   Avoid naming a specific module, class, or feature too early. For this principle, use language such as: "core logic repeatedly defends against missing required operational state that should have been validated at a boundary."

2. Define the invariant candidates.

   Look for state that core code appears to require:

   - loaded dependencies;
   - parsed configuration;
   - non-empty feature lists or column lists;
   - authenticated clients;
   - connected services;
   - validated payloads;
   - initialized repositories, ledgers, brokers, models, writers, or collectors.

3. Generate search queries from the principle.

   Useful `rg` patterns:

   ```text
   is None
   is not None
   not self\.
   if not .*(features|columns|config|client|model|broker|writer|collector)
   raise ValueError
   raise .*ValidationError
   loaded|connected|initialized|ready
   Optional\[| \| None
   getattr\(self,
   hasattr\(
   ```

   Narrow the search by high-risk domains first: execution, inference, ingestion, persistence, and external integrations.

4. Inspect candidates in context.

   Do not treat every `None` check as a violation. Decide whether absence is valid domain behavior or a leaked invalid state.

   A strong candidate usually has at least two of these signs:

   - the same invariant is checked in multiple methods;
   - the object is nullable only because of lifecycle timing;
   - a config/schema already validates the invariant elsewhere;
   - core logic silently skips important behavior when required state is absent;
   - the same error message appears in multiple places;
   - the function's main responsibility is hidden behind defensive checks.

5. Group findings by invariant, not by file.

   Example groups:

   - "service readiness is represented by nullable dependencies";
   - "validated config still exposes optional aliases to core code";
   - "writer selection is checked after orchestration starts";
   - "payload shape is validated inside business logic instead of at request parsing."

6. Rank each finding.

   Score each group from 1 to 5 in three dimensions:

   - Criticality: impact if invalid state reaches core logic.
   - Refactor leverage: how many checks or unclear contracts disappear.
   - Minimality: how small and localized the refactor can be.

   Suggested scale:

   ```text
   Criticality
   5 = can affect trading, money movement, external side effects, or production availability
   4 = can silently skip core behavior or produce misleading output
   3 = obscures central business logic through repeated defensive checks
   2 = local duplication with low runtime impact
   1 = cosmetic or naming-level issue

   Refactor leverage
   5 = one boundary change removes several checks
   4 = one validated type or factory clarifies a major workflow
   3 = small helper/type improvement removes some duplication
   2 = minor local cleanup
   1 = refactor is larger than the benefit

   Minimality
   5 = constructor, factory, or type narrowing in one module
   4 = one module plus focused tests
   3 = two or three modules with clear ownership
   2 = cross-module migration
   1 = broad architectural redesign
   ```

   Priority can be estimated as:

   ```text
   priority = criticality + refactor_leverage + minimality
   ```

7. Select the most critical minimal refactor.

   Prefer the refactor that changes the boundary contract rather than adding more defensive checks.

   Good outputs use this structure:

   ```text
   Finding: core logic accepts weak state.
   Invariant: what must already be true.
   Boundary: where validation should move.
   Minimal refactor: smallest type/factory/state transition that makes the invariant explicit.
   Expected simplification: which checks disappear or become assertions.
   Risk: tests or behavior most likely to break.
   ```

8. Keep the example subordinate to the principle.

   If the first example is about inference model loading, write the generalized finding as "required runtime dependency is represented as nullable service state," then cite inference as one instance.

## Validation

A good playbook result answers:

- What invariant is currently validated too late?
- Which code path is core logic and which code path is the boundary?
- Why is the current type or state model too weak?
- What stronger type, factory, constructor, parser, or lifecycle stage should exist?
- Which repeated checks become unnecessary after the refactor?
- Is absence truly invalid, or is it valid domain behavior?
- Is the chosen refactor minimal enough to do safely?

## Failure handling

If findings are too specific, restate them using the invariant and boundary language before writing the recommendation.

If findings are too broad, restrict the search to one subsystem and require repeated checks for the same invariant.

If every result is a legitimate optional domain state, record that as a negative finding and choose another principle or subsystem.

If the minimal refactor would require a large migration, propose a staged type or factory first and defer broad rewiring.

If the principle document is too example-specific, update the principle before creating more playbooks from it.

## Related

- [[Boundary Validated State]]
- Validate at boundaries
- Make invalid states unrepresentable
- Staged state modeling
- Strong function contracts
- Fail fast
