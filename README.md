# Agents Handbook

A curated library of reusable AI agent skills, architecture knowledge, and project-specific guidance.
The handbook is a single source of truth that can be synchronized into any AI coding assistant
(currently targeting [OpenAI Codex](https://openai.com/blog/openai-codex) and compatible agents).

---

## How it works

The handbook is organized into layers. Each layer has a clear role:

```
agents-handbook/
├── global/          # Cross-project agent instructions loaded by every session
├── skills/          # Self-contained, reusable agent skill packages
├── knowledge/       # Principles, playbooks, and patterns referenced by skills
├── projects/        # Project bundles: AGENTS.md, skills, agents, and rules per project
├── practice/        # Learner-authored architecture exercises and feedback artifacts
├── templates/       # Document templates (Obsidian vault)
└── scripts/         # Sync helpers
```

### `global/`

Contains a single `AGENTS.md` that is deployed to the agent's root configuration. It defines the
cross-project quality procedure every agent follows by default — pointing at the core knowledge
routes without duplicating them.

### `skills/`

Each subdirectory is a self-contained **skill package** with:

| File | Purpose |
|---|---|
| `SKILL.md` | The agent instruction file — frontmatter name/description + detailed workflow |
| `agents/openai.yaml` | Display metadata for the OpenAI Codex skill registry |

Skills are designed to be invoked by name from any project. They reference handbook knowledge via
relative paths so the agent can read principles and playbooks in context.

### `knowledge/`

Three layers of reusable knowledge, each with a specific role:

| Sublayer | Role | Example |
|---|---|---|
| `principles/` | Defines a named invariant and explains *why* it matters | *Boundary Validated State* |
| `playbooks/` | Step-by-step procedure for finding violations of a principle | *Find Boundary Validation Refactors* |
| `patterns/` | Named implementation recipe that resolves a finding | *Validated Configuration Loader* |

Each principle links to its playbook. Each playbook links to its pattern. The `code-quality` skill
routes from evidence → principle → playbook → pattern, keeping every recommendation grounded in
the handbook rather than generic advice.

### `projects/`

A project bundle groups everything needed to extend a specific codebase:

```
projects/<project>/
├── AGENTS.md          # Project-specific agent instructions (synced to the repo root)
├── project.json       # Sync manifest: id + target repositoryPath
├── agents/            # Named agent definitions (.md)
├── rules/             # Cursor / Windsurf rule files (.mdc)
└── skills/            # Project-scoped skills (same structure as global skills/)
```

The sync script deploys each bundle: the `AGENTS.md` goes to the target repository root, and the
skills, agents, and rules go into the agent's config directory.

### `practice/`

A learner-owned workspace for architecture exercises derived from real code changes. Each exercise
lives in its own `practice/<slug>/` with:

- `brief.md` — goal, context, constraints, acceptance checks, and hints
- starter code + focused tests

The `explain-diff-html` skill can generate exercises and review submissions here.

---

## Skills

### `explain-diff-html` — Interactive Code Change Tutor

Produces a single self-contained HTML lesson for any code change, diff, branch, or pull request.

**What it generates:**

1. **Background** — the system context needed to understand the change
2. **Intuition** — the core idea with toy inputs/outputs and before/after comparison
3. **Code walkthrough** — changes grouped by execution flow, not arbitrary file order
4. **Practice Lab** — two or three progressive coding exercises tied to real architecture decisions
5. **Interactive Quiz** — five medium-difficulty questions with immediate feedback

**Three modes:**

| Mode | Trigger | Output |
|---|---|---|
| `Explain` (default) | Open a diff, branch, or PR | HTML lesson + Practice Lab stubs |
| `Practice` | *"Start exercise N"* | Creates `practice/<slug>/` with starter code + tests |
| `Review` | *"Review my solution"* | Assesses learner code without solving it |

The HTML is fully offline — no CDN, no external assets, responsive CSS, accessible focus states.

**Example invocations:**

```
Use $explain-diff-html to explain the changes in this PR.
Use $explain-diff-html to start exercise 2.
Use $explain-diff-html to review my solution in practice/policy-pipeline/.
```

---

### `code-quality` — Principle-Driven Refactor Discovery

Audits a codebase or change through the handbook's knowledge routes and recommends the single
most valuable, minimal refactor — never a generic style review.

**Knowledge routes** (principle → playbook → pattern):

| Signal | Principle | Typical pattern |
|---|---|---|
| Required state is nullable or validated repeatedly | Boundary Validated State | Validated Configuration Loader |
| Contracts are ambiguous, callers defend repeatedly | Explicit Operational Contracts | Actionable Domain Failure |
| Inheritance or conditionals hide a behavior variant | Composition Defines Variation | Strategy Injection |
| Raw settings or hard-coded tunables reach core logic | Configuration Is a Contract | Validated Configuration Loader |
| Collection transforms use row-by-row loops | Bulk Operations Preserve Intent | Bulk Transformation Pipeline |
| Errors are swallowed, vague, or lack recovery context | Failures Are Observable and Actionable | Actionable Domain Failure |

**Output format:**

```
## Code Quality Summary
Scope / Knowledge routes / Verification

### Principle sweep       (one finding or "no verified finding" per route)
### Must fix              (criticality · path:line · evidence · minimal refactor)
### Should fix
### Nice to have
### Selected minimal refactor  (invariant · boundary · pattern · risk · tests)
```

**Example invocations:**

```
Use $code-quality to review this codebase through the handbook knowledge.
Use $code-quality to audit the changes in this PR.
```

---

### `pdf` — PDF Creation and Review

Handles PDF reading, generation, and layout validation using Python (`reportlab`, `pdfplumber`,
`pypdf`) with visual rendering via Poppler (`pdftoppm`).

**Workflow:** render pages to PNG → inspect visually → generate or fix → re-render → deliver.

**Example invocations:**

```
Use $pdf to create a summary report from these notes.
Use $pdf to review this PDF and fix the table alignment.
```

---

## Knowledge library

### Principles

| Principle | One-line statement |
|---|---|
| [Boundary Validated State](knowledge/principles/Boundary%20Validated%20State.md) | Core logic should receive values whose required invariants have already been validated at a clear boundary |
| [Explicit Operational Contracts](knowledge/principles/Explicit%20Operational%20Contracts.md) | Public interfaces must declare their optionality, failure modes, and pre/post-conditions explicitly |
| [Composition Defines Variation](knowledge/principles/Composition%20Defines%20Variation.md) | Behavior variation should be expressed through composed collaborators, not inheritance or conditionals |
| [Configuration Is a Contract](knowledge/principles/Configuration%20Is%20a%20Contract.md) | Configuration is a first-class contract: validate it at load time, fail fast, and never leak raw settings into core logic |
| [Bulk Operations Preserve Intent](knowledge/principles/Bulk%20Operations%20Preserve%20Intent.md) | Independent collection transforms should express their intent at the collection level, not row by row |
| [Failures Are Observable and Actionable](knowledge/principles/Failures%20Are%20Observable%20and%20Actionable.md) | Every failure should be named, carry recovery context, and be observable without reading source code |
| [Verification Is Part of the Change](knowledge/principles/Verification%20Is%20Part%20of%20the%20Change.md) | A change is only complete when its affected contracts are verified by focused tests or a quality gate |

### Patterns

| Pattern | Resolves |
|---|---|
| [Validated Configuration Loader](knowledge/patterns/Validated%20Configuration%20Loader.md) | Raw settings leaking into core logic |
| [Validated Parameter Object](knowledge/patterns/Validated%20Parameter%20Object.md) | Repeated nullable checks on required function inputs |
| [Explicit Absence Model](knowledge/patterns/Explicit%20Absence%20Model.md) | Ambiguous `None` that conflates missing, empty, and unknown |
| [Actionable Domain Failure](knowledge/patterns/Actionable%20Domain%20Failure.md) | Swallowed or vague errors lacking recovery context |
| [Strategy Injection](knowledge/patterns/Strategy%20Injection.md) | Conditionals or inheritance hiding a behavior variant |
| [Registry-Based Selection](knowledge/patterns/Registry-Based%20Selection.md) | Hard-coded dispatch tables that grow with every new variant |
| [Bulk Transformation Pipeline](knowledge/patterns/Bulk%20Transformation%20Pipeline.md) | Row-by-row loops over independent collection transforms |
| [Policy Pipeline](knowledge/patterns/Policy%20Pipeline.md) | Interleaved policy checks and business logic |
| [External Service Boundary](knowledge/patterns/External%20Service%20Boundary.md) | Core logic coupled directly to external service clients |
| [Transactional Unit of Work](knowledge/patterns/Transactional%20Unit%20of%20Work.md) | Multiple side effects with no atomicity guarantee |
| [Focused Test Matrix](knowledge/patterns/Focused%20Test%20Matrix.md) | Test suites that don't map to behavioral contracts |

---

## Sync

The `scripts/sync-codex.ps1` script deploys handbook content into the agent's configuration
directory (`~/.codex/`) and into registered project roots. Always run a dry run first.

**Dry run (preview what will change):**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1
```

**Apply the full sync:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Apply
```

**Sync a single project bundle only:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Project algotrading-backend -Apply
```

**Sync a single reusable skill only:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Skill explain-diff-html -Apply
```

`-Skill` and `-Project` accept comma-separated names. When either filter is present the script
synchronizes only those targets; an unfiltered run publishes the complete managed architecture.

The sync backs up replaced managed paths under `~/.codex/backups/agents-handbook/`. It does not
touch runtime state, credentials, plugins, sessions, or unmanaged skills.

---

## Adding a new skill

1. Create `skills/<your-skill>/SKILL.md` with YAML frontmatter (`name`, `description`) and your workflow instructions.
2. Create `skills/<your-skill>/agents/openai.yaml` with `display_name`, `short_description`, and `default_prompt`.
3. Run the sync script with `-Skill <your-skill> -Apply` to deploy it.

## Adding a new project bundle

1. Create `projects/<project>/project.json` with `id`, `repositoryPath`, and `description`.
2. Add an `AGENTS.md`, and optionally `skills/`, `agents/`, and `rules/` subdirectories.
3. Run the sync script with `-Project <project> -Apply` to deploy it.
