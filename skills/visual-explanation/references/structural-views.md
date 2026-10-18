# Choosing structural views

Choose a representation based on the reader's question, then keep only the context needed to answer it. These are options, not a checklist of required diagrams.

| Reader's question | Useful representation | Evidence to retain |
| --- | --- | --- |
| Which decision changes the result? | Pseudocode with a concrete input and outcome | Branch conditions, side effects, and failure behavior |
| Who invokes what? | Call hierarchy | Relevant caller, callee, and execution order |
| Where does data travel? | Labeled flow or sequence | Payload examples, transformations, and ownership boundaries |
| What can callers send or receive? | Contract table or a small schema comparison | Changed fields, types, optionality, and compatibility |
| Where does a responsibility live now? | Shallow file hierarchy with role annotations | Moved responsibility and its callers |
| How does the UI hold and share state? | Component hierarchy | State owner, relevant hooks, and module boundaries |

Do not conflate containment with execution. A file hierarchy describes organization; it does not establish runtime call order. A sequence should distinguish asynchronous handoff from a completed operation when that affects behavior. Label proposed or illustrative structures so readers cannot mistake them for inspected implementation.

## Show the difference or the resulting structure

Use a compact diff when a familiar structure changes locally. Include enough unchanged context to locate the edit. Prefer a complete after-view for a largely new structure or when removing context would obscure ownership, ordering, or the contract. Pair before/after panels when the reader needs to compare outcomes rather than individual lines.

In HTML, mark additions and removals with text or symbols as well as color. Escape code-like labels, including component names, so the browser displays them as text. Keep pseudocode visibly labeled and cite the actual source it summarizes; do not present it as a runnable patch.

For example, a change in where an invalid request is rejected can use the same input in two panels. Show which boundary rejects it, which downstream effects are prevented, and what the caller observes. Add a contract table only if the response also changes. An unrelated component tree would not help explain this question.

## Keep views connected to the explanation

When a view appears in a larger explanation, carry the same component names and example values into the surrounding text. Each view should point to the relevant file, symbol, or verified line when available. If only the new implementation was inspected, state that limitation instead of inventing an old path.

For UI comparisons, use the inspected product's terminology and visual conventions where useful. Clearly distinguish an explanatory mockup from an observed screenshot, and label invented example data.

## Inspiration

Adapted conceptually from HumanLayer's [visual-pr](https://github.com/humanlayer/skills/blob/main/plugins/visual-pr/skills/visual-pr/SKILL.md) and [show-me](https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md), consulted on 2026-10-12. These links are provenance, not runtime dependencies or instructions to publish a PR.
