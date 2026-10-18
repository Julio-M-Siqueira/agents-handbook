---
name: explain-diff-html
description: Teach a code change, diff, branch, or pull request through a self-contained HTML lesson with architecture exercises and an interactive quiz. Use for an in-depth walkthrough, hands-on coding practice, or review of a learner's solution.
---

# Explain Diff HTML

Teach how a specified code change works through a full HTML lesson. Investigate the surrounding system before explaining the diff: the result should make sense to a beginner while still giving an experienced engineer a concise path to the changed behavior. This skill owns the narrative, exercises, and quiz; `$visual-explanation` supplies its visuals.

## Choose the scope

- **Explain** (default): produce the full HTML lesson, including the Practice Lab and quiz. Start with a compact reviewer overview so experienced readers can orient themselves quickly.
- **Practice**: when the user explicitly asks to start an exercise, create `practice/<slug>/` in the active `agents-handbook` workspace. Add `brief.md`, the smallest runnable starter code, and focused tests when the toolchain is available. Do not create a complete solution.
- **Review**: when the user asks to review a practice solution, inspect the learner's files and run focused checks when practical. Assess the work against the exercise brief and architecture trade-offs. Do not edit or complete the learner's code unless explicitly asked.

Explanation does not require committing, pushing, creating a PR, or editing its description. Only perform those actions when separately requested. For Practice and Review, follow `practice/AGENTS.md`; the HTML lesson workflow below applies when producing a lesson, not to every practice follow-up.

If the user requests only a quick visual rather than a lesson, invoke `$visual-explanation` for that request instead of running the lesson workflow.

## Workflow

1. Identify the change and its scope. Use the current checkout, diff, branch, PR metadata, or user-supplied files as the source of truth. If the target is ambiguous, infer the most likely change from the available context and state the assumption in the page.
2. Explore relevant surrounding code, tests, configuration, callers, data models, and documentation. Trace the old and new paths far enough to explain behavior, not merely file-by-file edits. Prefer checked-in examples and tests over speculation.
3. Build the lesson narrative, then invoke `$visual-explanation` as described below to illustrate it:
   - what problem or constraint motivated the change;
   - how the old system behaved;
   - the smallest useful mental model of the new behavior;
   - how the implementation realizes that model;
   - edge cases, trade-offs, and observable consequences.
4. Ground the explanation in relevant software-architecture theory. For each material design decision, connect implementation evidence to a principle such as boundaries, coupling and cohesion, dependency direction, state ownership, SOLID, or consistency and availability. Explain why the decision fits the system's constraints, which alternatives were available, and what trade-offs each choice creates. Use the quiz as illustrative, scenario-based exercises that ask readers to reason about those decisions, alternatives, and consequences; do not introduce abstract theory that the inspected code does not support.
5. Design a **Practice Lab** with two or three progressive coding exercises. Tie every exercise to a material architecture decision in the change. State the goal, starter context, constraints, acceptance checks, one relevant trade-off, and progressive hints. Start with a small implementation or contract test, then progress to a refactor or design choice. Do not expose a complete solution in the HTML page.
6. Write the output as one self-contained HTML file with inline CSS and JavaScript. Do not depend on external fonts, CDNs, images, JavaScript packages, or network access. Save it outside the repository in an available artifact or temporary directory, using `YYYY-MM-DD-explanation-<slug>.html` with the current date. Do not create learner code in Explain mode.
7. Validate the artifact before handing it off: confirm it exists, is a complete HTML document, contains no external asset dependencies, and satisfies the code-block checks below. For lessons, also verify quiz interactions and the quiz rules. Check that structural views preserve the inspected contracts, ownership, and execution order, and visibly identify simplifications. If practical, open HTML in a browser or use a local HTML inspection tool to catch layout or JavaScript errors. Report checks that could not be run.

## Full lesson structure

Include a clear title and a compact reviewer overview: one sentence describing the problem and resulting behavior, a structural view of the main change, and up to three evidence-backed notes about migrations, compatibility, or consequential trade-offs when relevant. Link the overview to the detailed explanation rather than repeating it. This overview is explanatory, not a claim that a code review or test run passed.

Follow it with a table of contents linking to these sections in this order:

1. **Background** — Explain only the system needed for the change. Start with an optional beginner-friendly mental model, then narrow to the exact components, contracts, and prior behavior involved.
2. **Intuition** — Explain the core idea before implementation detail. Use small concrete toy inputs and outputs. Show the old and new behavior when comparison makes the change clearer.
3. **Code** — Walk through the changes in conceptual groups, ordered by execution or dependency flow rather than arbitrary file order. Include precise file and line references when available, but do not dump the whole diff.
4. **Practice Lab** — Include two or three practical, progressively harder coding exercises. For each one, show the goal, constraints, acceptance checks, architecture decision, trade-off, and progressive hints. Link to its practice-directory path only after the user explicitly starts it.
5. **Quiz** — Include exactly five medium-difficulty, interactive multiple-choice questions. Clicking an option must immediately show whether it is correct and explain why, including the relevant behavior or code path.

Use smooth transitions, plain language, and precise systems-oriented prose. Explain jargon on first use. Use callouts for definitions, invariants, important edge cases, and practical consequences. Keep the page readable on phones with responsive CSS. Do not use top-level tabs; make it one continuous page.

## Visual skill integration

Use `$visual-explanation`: load and follow the [visual-explanation skill](../visual-explanation/SKILL.md) when producing the overview and lesson visuals. Supply:

- the question each visual should answer and the reader's assumed knowledge;
- inspected source references, old/new behavior, and concrete examples from the lesson;
- the embedded output contract: HTML/CSS content for this single offline page, with no external assets or separate artifact handoff.

Integrate the resulting views beside the relevant explanation, keeping terminology and examples consistent. Visual selection and rendering rules live in `$visual-explanation`; this skill retains ownership of the page structure, teaching sequence, Practice Lab, quiz, and final artifact validation. Install and sync both skills together.

## Quiz quality rules

Treat quiz design as part of the explanation, not decoration. Before emitting the page, inspect all five questions as a set.

- Randomize the option order independently for each question. Do not always place the correct answer first, second, or in any fixed position. A deterministic shuffle with a per-page seed is acceptable; the visible order must vary across questions.
- Balance correct-answer positions across the five questions as evenly as possible. Never let position, letter, punctuation, or a repeated pattern reveal the answer.
- Keep options comparable in length, grammar, specificity, and confidence. Do not make the correct option conspicuously longer, more qualified, or more technically precise than distractors. Shorten or enrich distractors as needed.
- Make every distractor plausible and tied to a real misunderstanding of the change. Avoid joke answers, obviously impossible claims, “all/none of the above,” and trivia that cannot be inferred from the page.
- Ask about behavior, causality, contracts, edge cases, or trade-offs. Avoid questions whose answer can be guessed from a single copied phrase.
- Keep the correct answer and explanation in the page’s JavaScript data or DOM so the interaction works offline. Reveal feedback only after selection. Mark the selected option and explain both the right reasoning and, when useful, the misconception behind the distractors.
- Ensure the UI does not expose the answer through styling before selection, DOM labels, `title` attributes, source ordering, or accessibility text. Accessibility labels should describe the option, not its correctness.

## Practice review rules

- Treat the learner's implementation as an answer to assess, not a draft to silently finish.
- Start feedback with observed behavior and the architecture decision the exercise targets. Then state what is correct, the first meaningful gap, the relevant trade-off, and one next-step hint.
- Run focused tests or static checks when practical and distinguish their evidence from design feedback.
- Do not reveal or write a full reference solution unless the learner explicitly asks to see it or asks for implementation help after a review.

## HTML and code-block constraints

- Escape user/code-derived text for HTML and JavaScript contexts. Preserve meaningful whitespace in code examples.
- Use `<pre><code>...</code></pre>` for code blocks. The CSS for `pre` must explicitly include `white-space: pre` or `white-space: pre-wrap`; verify every code block in the saved source before delivery.
- Keep JavaScript small, namespaced, and dependency-free. Use event listeners rather than inline handlers when convenient, and handle repeated quiz cards without relying on fragile global selectors.
- Include visible focus states and sufficient color contrast. Do not make correctness depend on color alone.
- Avoid claiming behavior that the inspected source does not support. Distinguish observed facts from reasonable interpretation.

## Final handoff

For generated HTML, return the exact absolute path as a clickable local-file link and open it with the available artifact preview when supported. Briefly state what was inspected and any assumptions or validation limitations. In Practice mode, also link the created `practice/<slug>/` directory. In Review mode, summarize the observed behavior, checks run, architecture assessment, and next hint; do not modify learner code unless requested.
