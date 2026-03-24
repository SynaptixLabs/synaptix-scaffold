# Changelog

All notable changes to the **Windsurf Projects Template** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2026-03-24

### Added

#### KB Sync System (`docs/KB/`)
- **`sync-kb.ps1`**: v3 KB sync script for Claude Projects — collects local .md/.pdf/.txt files + web URLs into indexed output folders. Features:
  - **Bare run = help**: Running with no args shows full command reference
  - **`-Status`**: Quick file counts across all KB folders with extension breakdown
  - **`-Consolidate N`**: Merge files down to a target count (e.g., 95 files -> 10). Groups by tier/folder/prefix, concatenates with headers. Can only shrink, never grow
  - **`-Reset`**: Wipe KB folders with "type yes to confirm" safety prompt. `-ResetTarget` for selective wipe (project/external/archive/consolidated). `-Force` to skip prompt
  - **`-Source all`**: Full sync from project files
  - **`-Report`**: Find obsolete + stale files
  - **`-Stats`**: Full stats from kb-index.json
  - Tier system (1-3), web URL fetching, archive management, dry-run mode
- **`Sync KB.bat`**: Double-click launcher for Windows
- **`Sync KB - Help.bat`**: Quick reference card
- **`kb-urls.json`**: Template for web URL registry
- **`docs/00_INDEX.md`**: Updated with KB section and quick commands

## [0.5.0] - 2026-03-23

### Added

#### Module Reuse Protocol
- **`MUST_READ_MODULE_REUSE.md`**: Root-level module reuse protocol — the #1 quality gate. CHECK BEFORE YOU BUILD. Includes 4 rules, import table template, violation examples, and design review integration.

#### Skills System (`.claude/skills/`)
- **`design-review-gbu/`**: GBU review skill with SKILL.md, checklist.md, report-template.md
- **`implement-backend/`**: Backend dev workflow skill with SKILL.md, checklist.md
- **`implement-frontend/`**: Frontend dev workflow skill with SKILL.md, checklist.md
- **`qa-gate/`**: QA validation skill with SKILL.md, checklist.md, report-template.md
- **`release-readiness/`**: Pre-deploy gate skill with SKILL.md, checklist.md, report-template.md
- **`sprint-report-skill/`**: Sprint status reporting skill with SKILL.md, report-template.md
- **`sync-state/`**: Multi-window state sync skill with SKILL.md

#### Session State Management
- **`.claude/hooks/reinject_context.py`**: Auto-restores session state after context compaction. Reads git state + session-state.md.
- **`.claude/state/session-state.template.md`**: Template for persistent session state that survives compaction and enables multi-window work.
- **`.claude/settings.json`**: Plugin config + SessionStart hook for compaction recovery.

#### New Commands
- **`.claude/commands/gbu.md`**: Full 7-phase GBU review command — the two non-negotiable phases are Requirements Compliance and Fix Bad & Ugly.
- **`.claude/commands/dev-cso.md`**: Chief Security Officer agent with OWASP Top 10 checklist, 5 security domains, audit output format.

#### Project Management Structure
- **`project_management/KB/`**: Knowledge Base with README, sync scripts (sync-kb.ps1), subdirectories (Project docs, Archive, External docs), and kb-urls.json.
- **`project_management/STRATEGIC_BACKLOG.md`**: Long-term roadmap template with backlog items, decision queue, and archive.
- **`project_management/README.md`**: Project management index.

#### Infrastructure
- **`.claude/launch.json`**: VS Code debug configurations for backend (uvicorn:8000) and frontend (npm:3000).
- **`.claude/GUIDE.md`**: Complete operations guide — commands, skills, infrastructure, workflows, and tips.

#### Interactive Guide
- **`scaffold-guide.html`**: Interactive HTML dashboard with tabbed navigation, command search, workflow diagrams, Sprint-0 checklist, and role cards.

### Changed

#### Sprint TODO Template (3-Checkbox System)
- **`sprint_XX_team_dev_MODULE_todo_TEMPLATE.md`**: Complete rewrite with 3-checkbox system (Done + Report for DEV, Tested + Report for QA, GBU + Report for CPTO). Includes team instructions, report naming conventions, and structured Definition of Done split by role.
- **`sprint_00_team_dev_example_todo.md`**: Updated to demonstrate new template format.

#### Design Review Command
- **`design-review.md`**: Evolved from letter grades (A/B/C/D/F) to APPROVE/REVISE/REJECT verdicts. Output moved from `reports/` to `reviews/`. Added Quality Scorecard (8 dimensions), module reuse checks, and commit template.

#### Naming Updates
- `dev-ux.md`: "Nightingale (AGENTS)" → "Synaptix AGENTS"
- `aria_ux.md`: "Nightingale (case management)" → "Synaptix AGENTS"
- `start.ps1`: Comment updated from "Nightingale Agents" → "Synaptix AGENTS"

### Removed
- **`docs/KB/`**: Entire directory deleted — superseded by `project_management/KB/`
- **`docs/sprints/sprint_00/todo/.gitkeep`**: Directory now has content files
- **`scripts/.gitkeep`**: Directory now has audit_repo_structure.py

---

## [0.4.0] - 2026-02-19

### Added

#### 🟢 Claude Code CLI Infrastructure (Dual-Native Support)
- **`CLAUDE.md`**: Generic project context template with `{{PLACEHOLDERS}}` — auto-loaded by Claude Code CLI on session start. Covers identity, commands, testing gates, architecture non-negotiables, E2E flows, deployment, and role tags.
- **`.claude/settings.local.json`**: Pre-configured permissions covering npm, poetry, git, docker-compose, pytest, uvicorn, playwright, and common shell commands. Deny-list for destructive operations (`git push --force`, `rm -rf`, `npm publish`).
- **`.claude/commands/test.md`**: `/project:test` — structured full test suite runner with server-awareness.
- **`.claude/commands/e2e.md`**: `/project:e2e` — Playwright MCP browser tests with screenshot-every-step requirement.
- **`.claude/commands/plan.md`**: `/project:plan` — force plan mode before any task touching >2 files.
- **`.claude/commands/regression.md`**: `/project:regression` — pre-merge gate with full quality checklist.
- **`.claude/commands/release-gate.md`**: `/project:release-gate` — pre-production checklist (code, security, infra, docs, demo readiness).
- **`.claude/commands/sprint-report.md`**: `/project:sprint-report` — sprint status report generator.

#### 🟢 README: Claude CLI Section
- New **"Claude Code CLI Support"** section documenting what's included, setup steps, Windsurf vs Claude CLI comparison table, and updated Sprint-0 checklist (items 11-13).

### Changed

#### 🟡 README: Sprint-0 checklist extended
- Items 11-13 added for Claude CLI setup.

#### 🟡 Template structure
- `CLAUDE.md` and `.claude/` added to Template Structure diagram.

---

## [0.3.0] - 2025-01-12

### Added

#### 🟢 Extraction Mode Gates (Prevents Invented Code)
- **`00_synaptix_ops.md`**: New "Extraction vs Invention" section with hard rules for migrations
- **Sprint todo template**: Extraction gates checklist for migration/porting tasks
- **Module permissions**: References extraction requirements

#### 🟢 Developer Role Instance Templates
- **`role_backend_dev.md`**: Backend developer role with FastAPI/SQLAlchemy patterns
- **`role_frontend_dev.md`**: Frontend developer role with React/Next.js/Tailwind patterns
- **`role_ml_dev.md`**: ML/AI developer role with reproducibility requirements
- **`role_shared_dev.md`**: Shared frameworks developer with backward compatibility rules
- All roles include project-specific configuration tables (like CTO/CPO)

#### 🟢 Module AGENTS Generator Template
- **`docs/templates/module_AGENTS_TEMPLATE.md`**: Template for consistent Tier-3 AGENTS.md files
- Includes capability declaration, directory structure, testing gates, and escalation triggers

#### 🟢 Repository Audit Script
- **`scripts/audit_repo_structure.py`**: Validates template compliance
- Checks: structure, Python version, extraction gates, async subprocess docs
- Detects unassigned template variables (`{{PROJECT_NAME}}` → FAIL, `{{VAR:default}}` → WARN)
- Windows-compatible with UTF-8 encoding

#### 🟢 CTO Pre-Release Checklist
- Integrated into **`role_cto.md`** (not a separate file)
- Code integrity, testing, security, documentation, and deployment gates
- Includes extraction verification for migration tasks

#### 🟢 Async Subprocess Guidance (CLI/TUI)
- **`docs/04_TESTING.md`**: New section with patterns for async subprocess testing
- Required tests: responsiveness, cancellation, timeout, streaming
- Code examples for each pattern

### Changed

#### 🟡 Python Version Gate
- **`docs/02_SETUP.md`**: Explicit Python 3.11-3.13 requirement (NOT 3.14+)
- **`pyproject.toml`**: Prominent version comment at top
- DoD checklist includes interpreter verification

#### 🟡 Context Router & Module Permissions
- **`20_context_router.md`**: Comprehensive path-to-role mappings
- **`10_module_agent_permissions.md`**: Module ownership table with role instance references
- **`01_artifact_paths.md`**: Complete registry including new dev role templates

#### 🟡 Sprint Templates
- **Sprint index template**: References CTO pre-release checklist
- **Sprint todo template**: Includes extraction gates for migration tasks

### Deprecated
- None

### Removed
- `docs/release/CHECKLIST_CTO_PRE_RELEASE.md` (content moved into `role_cto.md`)

### Fixed
- None

### Security
- None

---

## [0.2.0] - 2025-01-08

### Added
- Vibe measurement system (1 Vibe = 1,000 tokens)
- `_example` module in `backend/modules/` as reference implementation
- Sprint system with todos, reports, and decisions
- UI Kit documentation (`docs/ui/UI_KIT.md`)

### Changed
- Restructured documentation index
- Improved module capability registry

---

## [0.1.0] - 2025-01-05

### Added
- Initial template structure
- Tiered AGENTS.md system (Tier-1 → Tier-2 → Tier-3)
- Role prompts for CTO and CPO
- Windsurf rules (`00_synaptix_ops`, `01_artifact_paths`, etc.)
- Documentation templates (PRD, DECISIONS, CHANGELOG, SECURITY)
- Basic project structure (backend, frontend, shared, ml-ai-data)

---

## Version Legend

| Badge | Meaning |
|-------|---------|
| 🟢 **Added** | New features |
| 🟡 **Changed** | Changes to existing functionality |
| 🟠 **Deprecated** | Features to be removed in future |
| 🔴 **Removed** | Features removed in this release |
| 🔵 **Fixed** | Bug fixes |
| 🟣 **Security** | Security-related changes |

---

[Unreleased]: https://github.com/SynaptixLabs/Windsurf-Projects-Template/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/SynaptixLabs/Windsurf-Projects-Template/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/SynaptixLabs/Windsurf-Projects-Template/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/SynaptixLabs/Windsurf-Projects-Template/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/SynaptixLabs/Windsurf-Projects-Template/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/SynaptixLabs/Windsurf-Projects-Template/releases/tag/v0.1.0
