# Agents Handbook Instructions

This repository is the source of truth for reusable agent workflows and project-specific guidance.

## Repository Layout

- `global/` contains cross-project agent instructions.
- `skills/` contains reusable skill packages.
- `knowledge/` contains principles, patterns, and playbooks.
- `projects/` contains project bundles with their own `AGENTS.md`, skills, agents, rules, and sync manifest.
- `templates/` contains document templates.
- `scripts/` contains installation and synchronization helpers.

## Synchronization

Use `scripts/sync-codex.ps1` to publish handbook-managed files. Run it without `-Apply` first. Do not manually edit managed targets in `~/.codex` or registered project roots; edit the handbook source and sync.
