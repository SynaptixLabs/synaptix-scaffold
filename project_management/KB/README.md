# Knowledge Base (KB)

> Centralized documentation mirror for Claude Code and AI agent consumption.

## Structure

```
KB/
├── README.md              # This file
├── Project docs/          # Auto-synced from codebase (flat file structure)
├── Archive/               # Deprecated or superseded KB entries
├── External docs/         # Fetched from external URLs (when enabled)
├── kb-index.json          # Auto-generated index of all synced docs
├── kb-sync-log.txt        # Sync history
├── kb-urls.json           # External URLs for web-fetch sync
├── sync-kb.ps1            # PowerShell sync script
└── Sync KB.bat            # Windows batch wrapper
```

## How It Works

The KB is a **flat-file mirror** of project documentation. The sync script (`sync-kb.ps1`) scans the codebase for `.md` files and copies them into `Project docs/` using a double-dash naming convention:

```
backend/modules/agent_core/README.md  →  backend--modules--agent_core--README.md
```

This allows fast lookup without deep directory traversal.

## Syncing

```bash
# Full sync (all tiers, local only)
powershell -File project_management/KB/sync-kb.ps1

# Sync specific tier
powershell -File project_management/KB/sync-kb.ps1 -Tier 1

# Sync including web sources
powershell -File project_management/KB/sync-kb.ps1 -Source all
```

## Tiers

| Tier | What | Examples |
|------|------|---------|
| **1** | Root governance docs | AGENTS.md, CLAUDE.md, CODEX.md, README.md |
| **2** | Domain-level docs | backend/AGENTS.md, frontend/AGENTS.md |
| **3** | Module-level docs | backend/modules/*/README.md, backend/modules/*/AGENTS.md |

## When to Sync

- After significant documentation changes
- At sprint boundaries
- Before uploading KB to Claude Projects or external AI tools
- When onboarding new team members

## File Naming Convention

Source paths are converted to flat filenames using `--` as separator:
- `project_management/docs/03_MODULES.md` → `project_management--docs--03_MODULES.md`
- `backend/modules/platform/README.md` → `backend--modules--platform--README.md`

This enables easy searching and prevents deep nesting in the KB directory.
