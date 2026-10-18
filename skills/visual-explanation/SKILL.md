---
name: visual-explanation
description: Explain software behavior, architecture, contracts, or proposed changes with focused diagrams, structural comparisons, and code sketches. Use for a quick visual explanation or to supply visuals within a larger document; no diff or pull request is required.
---

# Visual Explanation

Answer a concrete software question with the smallest useful visual and brief supporting text. Own visual selection and rendering; leave lesson sequencing, exercises, and quizzes to the calling workflow.

## Workflow

1. Identify the question, audience, and requested output. Use the caller's evidence and constraints when this skill is invoked from another workflow. Inspect additional code or documentation only where needed to establish behavior, ownership, or ordering. Distinguish inspected implementation from a proposal or illustrative example.
2. Read [Choosing structural views](references/structural-views.md). Choose only the representations that help answer the question: logic, calls, data flow, contracts, file responsibilities, or UI state ownership. A repository change is optional; an existing system or proposed design is also a valid subject.
3. Render the selected views next to the short text they support. Keep names and example values consistent, preserve important boundaries, and cite the source when available. For a change, show a focused diff or before/after comparison; for an existing or new structure, show the relevant complete shape.
4. Verify that the visual preserves the evidence's contracts, ownership, and execution order. Identify simplifications and unverified assumptions visibly. Validate the output as described below and report any checks that could not be run.

## Output contract

- **Standalone:** prefer inline Markdown code sketches, tables, or Mermaid when they explain the point. Create one focused HTML artifact when the user requests HTML or the comparison needs richer layout or interaction. Present inline output directly; for HTML, save outside the repository in an available artifact or temporary directory, link its absolute path, and open it with the available preview when supported.
- **Embedded in another workflow:** accept the question, source evidence, target format, and host constraints from the caller. Produce the visual content and necessary captions for integration into that output. Do not create a separate page, add lesson sections, or perform a separate final handoff. The caller owns the surrounding document and its final validation.

When invoked by name, load and follow this skill's instructions. A caller can request, for example: `Use $visual-explanation to show where request validation occurs, using the inspected caller and validator. Produce an embeddable HTML/CSS view for an offline lesson.`

## HTML rendering and validation

- Use semantic HTML and CSS for diagrams, nested lists for hierarchies, and `<pre><code>` for code, pseudocode, and compact textual diffs. Set `white-space: pre` or `pre-wrap` for code blocks. Do not use ASCII art for HTML diagrams.
- Keep HTML self-contained, with inline CSS and any necessary JavaScript; use no external fonts, images, packages, or CDN dependencies. Mermaid is suitable for inline responses, but do not add a Mermaid runtime to offline HTML.
- Escape source-derived labels and code for their HTML or JavaScript context. Label arrows, include example values for data movement, and provide captions or accessible text. Additions, removals, and states must be distinguishable without color alone.
- Use responsive layouts, visible focus states, and scoped styles or identifiers that will not collide with a host document. Add interaction only when it helps answer the question.
- For standalone HTML, check the saved document, external dependencies, and any controls; inspect it in a browser when practical. For embedded views, check the fragment and its integration into the caller's document, including code formatting and layout.

Creating an explanation does not authorize publishing it or changing the system being explained.
