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

## Synchronization

Use `scripts/sync-codex.ps1` to publish handbook-managed files. Run it without `-Apply` first. Do not manually edit managed targets in `~/.codex` or registered project roots; edit the handbook source and sync.
