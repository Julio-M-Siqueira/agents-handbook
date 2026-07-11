# Agents Handbook

This repository is the source of truth for reusable agent workflows and project-specific guidance.

## Structure

- `global/` contains cross-project agent instructions.
- `skills/` contains reusable skill packages.
- `knowledge/` contains principles, patterns, and playbooks used by reusable skills.
- `projects/<project>/` contains project-specific `AGENTS.md`, skills, agents, rules, and a `project.json` target manifest.
- `templates/` contains Obsidian and instruction templates.
- `scripts/` contains synchronization helpers.

## Sync

Run a dry run first:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1
```

Publish the managed architecture to Codex and registered project roots:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Apply
```

To publish one project bundle only:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-codex.ps1 -Project algotrading-backend -Apply
```

The sync backs up replaced managed paths under `~/.codex/backups/agents-handbook/`. It does not touch Codex runtime state, credentials, plugins, sessions, or unmanaged skills.

