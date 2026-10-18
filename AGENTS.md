# Agents Handbook Instructions

This repository is the source of truth for reusable agent workflows and project-specific guidance.

## Repository Layout

- `global/` contains cross-project agent instructions.
- `skills/` contains reusable skill packages.
- `knowledge/` contains principles, patterns, and playbooks.
- `projects/` contains project bundles with their own `AGENTS.md`, skills, agents, rules, and sync manifest.
- `practice/` contains learner-authored architecture exercises and their feedback artifacts.
- `templates/` contains document templates.
- `scripts/` contains installation and synchronization helpers.

## Practice Hub

Use `practice/` for hands-on exercises derived from code changes and architecture lessons. Create each exercise in `practice/<slug>/` and follow `practice/AGENTS.md` when creating, reviewing, or discussing learner code.

## Task Routing

For substantial changes or refactors, explicit requirements or design discussions, or materially open requirements, follow [Define an Implementation Spec](knowledge/playbooks/Define%20an%20Implementation%20Spec.md). When tasked with preparing or opening PRs, follow [Prepare and Create Pull Requests](knowledge/playbooks/Prepare%20and%20Create%20Pull%20Requests.md).

For requested refactors, quality reviews, maintainability assessments, or substantive implementation verification, follow [Review Code Quality](knowledge/playbooks/Review%20Code%20Quality.md). Keep handbook guidance authoritative and project adapters consistent with its shared owners.

## Synchronization

Use `scripts/sync-codex.ps1` to publish handbook-managed files. Run it without `-Apply` first. Do not manually edit managed targets in `~/.codex` or registered project roots; edit the handbook source and sync.
