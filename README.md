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

Contains a single `AGENTS.md` deployed to the agent's root configuration. It routes applicable tasks
to playbooks and states essential evidence expectations. Detailed procedures and knowledge-route
indexes belong to their on-demand owners, rather than being repeated in every session.

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
| `playbooks/` | Coordinating workflows and procedures for applying principles | *Define an Implementation Spec*, *Find Boundary Validation Refactors* |
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
├── references/        # Canonical local standards and conditional project guidance
└── skills/            # Project-scoped skills (same structure as global skills/)
```

The sync script deploys each bundle: the `AGENTS.md` goes to the target repository root, and the
skills, agents, and rules go into the agent's config directory.

For algotrading-backend, the shared `code-quality` skill owns the review workflow. Reusable SOLID,
temporal-data, and model-serving guidance lives in knowledge; the project bundle keeps local
standards, timestamp conventions, artifact handoff context, and thin agent/rule adapters.
Its detailed research/live comparison procedure is loaded only through the relevant review trigger.
For exam-readness-tuttor, `references/code-standards.md` owns project requirements and validation
commands; the existing skill, agent, and rule names route to it and the shared quality method.
Project rules installed into shared configuration must guard their project identity before applying
local standards or commands. References use explicit source/install locators when a relative link
cannot survive both the bundle layout and the external repository copy.

### `practice/`

A learner-owned workspace for architecture exercises derived from real code changes. Each exercise
lives in its own `practice/<slug>/` with:

- `brief.md` — goal, context, constraints, acceptance checks, and hints
- starter code + focused tests

The `explain-diff-html` skill can generate exercises and review submissions here.

---

## Skills

### Spec and PR workflows

Global instructions route applicable tasks to two coordinating playbooks. The playbooks own
sequencing, focused delegation, authorization boundaries, and handoff; skills produce specific outputs.

| Playbook | When used | Focused skills |
|---|---|---|
| [Define an Implementation Spec](knowledge/playbooks/Define%20an%20Implementation%20Spec.md) | Substantial changes/refactors, requirements discussions, or materially open requirements | [spec-description](skills/spec-description/SKILL.md) |
| [Prepare and Create Pull Requests](knowledge/playbooks/Prepare%20and%20Create%20Pull%20Requests.md) | Requested PR preparation or creation, after implementation | [pr-delivery](skills/pr-delivery/SKILL.md), then [pr-description](skills/pr-description/SKILL.md) with [visual-explanation](skills/visual-explanation/SKILL.md) |

The spec defines the complete outcome; implementation stays coherent. PR boundaries are determined
in a dedicated delivery phase afterward. Prefer separate PRs for independent behaviors; each dependent
PR must be testable and safe to deploy after its predecessors, with its own evidence.

Active specs normally live at `specs/active/<task-slug>.md` in the target repository. Load only the
relevant spec. Retain it through delivery, preserve lasting contracts in maintained documentation
and self-contained delivery artifacts, then remove it at completed handoff without waiting for merges.
Incomplete work retains its spec. These are versionable working agreements, not a permanent archive.

PR descriptions open with concrete base/head behavior examples, verification evidence, and source
references, followed by an embedded before/after flow visual. Dependent PRs compare their immediate
base/head; a durable series overview compares original master with the final result. The
[description template](skills/pr-description/assets/pr-description.md) belongs to the writing skill.

```text
Use $spec-description to clarify this outcome and agree on acceptance examples.
Use $pr-delivery to assess these completed changes and propose safe PR boundaries.
Use $pr-description to explain this established PR scope with evidence and flow visuals.
```

### `explain-diff-html` — Interactive Code Change Tutor

Produces a self-contained HTML lesson for a code change, diff, branch, or pull request. Lessons
start with a compact reviewer overview: the motivation, a structural view of the change, and
consequential review notes when relevant. It invokes `$visual-explanation` for the visuals while
owning the lesson narrative, exercises, and quiz.

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
Install and sync it together with `visual-explanation`. Requests for only a quick visual are
routed to that skill without running the lesson workflow.

**Example invocations:**

```
Use $explain-diff-html to explain the changes in this PR.
Use $explain-diff-html to start exercise 2.
Use $explain-diff-html to review my solution in practice/policy-pipeline/.
```

---

### `visual-explanation` — Focused Software Visuals

Explains software behavior, architecture, contracts, and proposed changes through focused
diagrams, structural comparisons, and code sketches. It works independently of a diff or PR,
and can also supply embedded visuals to another skill such as `explain-diff-html`.

Selects inline Markdown or Mermaid for simple questions and self-contained HTML for richer
comparisons. The [structural view guide](skills/visual-explanation/references/structural-views.md)
covers logic, calls, data flow, contracts, file responsibilities, and UI state ownership, and
credits the HumanLayer skills that inspired the guidance. Lessons, exercises, and quizzes
remain in `explain-diff-html`.

**Example invocations:**

```
Use $visual-explanation to show how requests move through this service.
Use $visual-explanation to compare these two proposed component structures.
Use $visual-explanation to show only how the request flow changes in this diff.
```

---

### `code-quality` — Principle-Driven Refactor Discovery

Audits a codebase or change through the handbook's knowledge routes and guides requested refactors
toward the clearest, simplest architecture that preserves established contracts. Optimize the resulting
system rather than patch size; a small correction remains appropriate when it fully resolves the cause.

[Review Code Quality](knowledge/playbooks/Review%20Code%20Quality.md) is the coordinating entry point.
The skill owns the complete route index, evidence procedure, and report; the refactor playbook owns
the design method and rubric. Global and project instructions route to these owners.

For requested refactors, [Refactoring Simplifies the Whole Workflow](knowledge/principles/Refactoring%20Simplifies%20the%20Whole%20Workflow.md)
and [Design a Coherent Refactor](knowledge/playbooks/Design%20a%20Coherent%20Refactor.md) require workflow tracing,
target-flow design, credible alternative comparison, and behavioral plus architectural verification.
The playbook owns the scoring rubric, conditional delegation guidance, and illustrative CPO before/after
example with a verification checklist. Criticality, architectural improvement, and leverage are scored
separately; implementation cost and migration risk do not substitute for design quality.

**Knowledge routes** (principle → playbook → pattern):

| Signal | Principle | Typical pattern |
|---|---|---|
| Required state is nullable or validated repeatedly | Boundary Validated State | Validated Configuration Loader |
| Contracts are ambiguous, callers defend repeatedly | Explicit Operational Contracts | Actionable Domain Failure |
| Inheritance or conditionals hide a behavior variant | Composition Defines Variation | Strategy Injection |
| Raw settings or hard-coded tunables reach core logic | Configuration Is a Contract | Validated Configuration Loader |
| Collection transforms use row-by-row loops | Bulk Operations Preserve Intent | Bulk Transformation Pipeline |
| Errors are swallowed, vague, or lack recovery context | Failures Are Observable and Actionable | Actionable Domain Failure |

The composition route includes SOLID review lenses. Domain routes are selected only when relevant:

| Scope | Principle | Playbook |
|---|---|---|
| Time-series features, ingestion, labels, backtests | [Decisions Use Available Information](knowledge/principles/Decisions%20Use%20Available%20Information.md) | [Audit Temporal Data Validity](knowledge/playbooks/Audit%20Temporal%20Data%20Validity.md) |
| Model serving, promotion, inference, execution | [Serving Preserves the Model Contract](knowledge/principles/Serving%20Preserves%20the%20Model%20Contract.md) | [Audit Model Serving and Execution](knowledge/playbooks/Audit%20Model%20Serving%20and%20Execution.md) |

**Output format:**

```
## Code Quality Summary
Scope / Knowledge routes / Verification

### Principle sweep       (top finding, no verified finding, or not applicable with reason)
### Must fix              (criticality / architectural improvement / leverage · evidence · correction)
### Should fix
### Nice to have
### Selected design       (contracts · target flow · alternatives · retained complexity)
                          (cost · migration risk · verification · completion and limitations)
```

**Example invocations:**

```
Use $code-quality to review this codebase through the handbook knowledge.
Use $code-quality to audit the changes in this PR.
Use $code-quality to refactor this workflow while preserving its required contracts.
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

**Sync global instructions and knowledge only:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Global
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Global -Apply
```

Use this scope for handbook-wide guidance changes. It skips skills and project bundles,
including their repository destinations. Add `-Skill` or `-Project` to include explicitly
selected bundles alongside global instructions and knowledge.

**Apply the full sync:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Apply
```

**Sync a single project bundle only:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Project algotrading-backend -Apply
```

**Sync the lesson skill and its visual dependency together:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Skill explain-diff-html,visual-explanation
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Skill explain-diff-html,visual-explanation -Apply
```

**Sync spec/PR workflows and their shared dependencies:**

```powershell
.\scripts\sync-codex.ps1 -Global -Skill spec-description,pr-delivery,pr-description,visual-explanation,code-quality
.\scripts\sync-codex.ps1 -Global -Skill spec-description,pr-delivery,pr-description,visual-explanation,code-quality -Apply
```

This scope publishes global routing, knowledge, and the selected skills, including the description
template. It does not publish project bundles or their repository destinations.

`-Skill` and `-Project` accept comma-separated names. When either filter is present the script
synchronizes only those targets unless `-Global` is also present; an unfiltered run publishes
the complete managed architecture. Before publishing anything, both dry run and apply validate
all selected manifests, retirement names, required sources, and repository destinations.
Each selected manifest's `repositoryPath` must be a configured, fully qualified path to an existing
repository directory. Placeholder, blank, relative, and nonexistent destinations are rejected;
sync does not create missing repository roots. Unselected bundles do not need to be configured
for a filtered run. The exam bundle uses the established `D:/projects/exam-readness-tuttor` location.

The sync backs up replaced managed paths under `~/.codex/backups/agents-handbook/`, using a
timestamp plus a unique run suffix so repeated applies within the same second preserve separate
backups. It does not touch runtime state, credentials, plugins, sessions, or unmanaged skills.

A project manifest may list `retiredSkills` by exact skill directory name. Selecting that project
previews retirement and, with `-Apply`, backs up and removes those installed skill directories.
Retirement is explicit: removing a source alone never prunes installed skills. Active source names
and path-like names are rejected. Keep retirement entries so older installations migrate too.
For algotrading-backend's migration, publish the shared dependencies together:

```powershell
.\scripts\sync-codex.ps1 -Global -Skill code-quality -Project algotrading-backend
.\scripts\sync-codex.ps1 -Global -Skill code-quality -Project algotrading-backend -Apply
```

**Validate sync changes in both supported PowerShell runtimes:**

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\tests\test-sync-codex.ps1
pwsh -NoProfile -File .\scripts\tests\test-sync-codex.ps1
```

These regression checks use isolated temporary fixtures. They cover selection and retirement,
configuration/source rejection before writes, dry-run behavior, and preservation of separate backups
when repeated runs share a timestamp. They do not publish to configured Codex or project destinations.

---

## Adding a new skill

1. Create `skills/<your-skill>/SKILL.md` with YAML frontmatter (`name`, `description`) and your workflow instructions.
2. Create `skills/<your-skill>/agents/openai.yaml` with `display_name`, `short_description`, and `default_prompt`.
3. Run the sync script with `-Skill <your-skill> -Apply` to deploy it.

## Adding a new project bundle

1. Create `projects/<project>/project.json` with `id`, `repositoryPath`, and `description`.
2. Add an `AGENTS.md`, and optionally `skills/`, `agents/`, and `rules/` subdirectories.
3. Run the sync script with `-Project <project> -Apply` to deploy it.
