# {{PROJECT_NAME}} — Docs Index

This folder is the **source of truth** for how the project is specified, built, tested, and shipped.

---

## Quick links

| Doc | What it's for | Owner |
|-----|---------------|-------|
| [PRD](0k_PRD.md) | Product requirements + acceptance criteria | `[CPO]` |
| [Architecture](01_ARCHITECTURE.md) | System design, boundaries, NFRs | `[CTO]` |
| [Setup](02_SETUP.md) | Local dev setup + env management | `[CTO]` / `[DEV:*]` |
| [Modules](03_MODULES.md) | Module registry + ownership | `[CTO]` |
| [Testing](04_TESTING.md) | Testing policy + gates | `[CTO]` / `[DEV:*]` |
| [Deployment](05_DEPLOYMENT.md) | CI/CD + releases + rollback | `[CTO]` |
| [Decisions](0l_DECISIONS.md) | Project decision log | `[CTO]` / `[CPO]` |
| [UI Kit](ui/UI_KIT.md) | Design tokens, components, accessibility | `[DESIGNER]` / `[DEV:*|FE]` |
| [KB Sync](KB/) | Knowledge base for Claude Projects — sync, consolidate, export | `[CPTO]` |

---

## Knowledge Base (KB)

The `KB/` directory builds a curated knowledge base for Claude Projects:

```
docs/KB/
  sync-kb.ps1         # Main sync script (PowerShell)
  Sync KB.bat          # Double-click launcher
  Sync KB - Help.bat   # Quick reference
  kb-urls.json         # Web URL registry
  Project docs/        # Synced local .md files (flat-named)
  External docs/       # Fetched web content
  Consolidated/        # Merged output (after -Consolidate)
  Archive/             # Archived obsolete files
  kb-index.json        # Generated metadata index
```

**Quick commands:**
- `.\sync-kb.ps1` — show help
- `.\sync-kb.ps1 -Status` — file counts
- `.\sync-kb.ps1 -Source all` — sync everything
- `.\sync-kb.ps1 -Consolidate 10` — merge to 10 files
- `.\sync-kb.ps1 -Reset` — wipe all (with confirmation)

---

## Bootstrap docs (root-level)

| File | What it's for |
|------|---------------|
| `CLAUDE.md` | Claude Code context — loaded automatically by Claude CLI; keep current |
| `CODEX.md` | Internal project handbook — architecture, conventions, key decisions narrative |
| `AGENTS.md` | Global agent constitution — roles, tags, decision rights |

---

## Current sprint

- Sprint index: `sprints/{{SPRINT_ID}}/{{SPRINT_ID}}_index.md`
- Requirements delta: `sprints/{{SPRINT_ID}}/reviews/{{SPRINT_ID}}_requirements_delta.md`

---

## Reading order (recommended)

1. `00_INDEX.md` (this file)
2. `0k_PRD.md` — what we're building + why
3. `01_ARCHITECTURE.md` — how it fits together
4. `03_MODULES.md` — what each module owns
5. `04_TESTING.md` — Definition of Done gates
6. `05_DEPLOYMENT.md` — how we ship + rollback
7. `0l_DECISIONS.md` — why we made key calls

---

## Directory map

```text
docs/
├── 00_INDEX.md
├── 0k_PRD.md
├── 0l_DECISIONS.md
├── 01_ARCHITECTURE.md
├── 02_SETUP.md
├── 03_MODULES.md
├── 04_TESTING.md
├── 05_DEPLOYMENT.md
├── ui/
│   └── UI_KIT.md
├── sprints/
│   ├── README.md
│   └── sprint_XX/
│       ├── sprint_XX_index.md
│       ├── sprint_XX_decisions_log.md
│       ├── todo/
│       ├── reports/
│       └── reviews/
├── knowledge/           # Domain knowledge, research, reference docs
└── templates/
    ├── sprints/         # Copy-from templates for sprint artifacts
    │   ├── sprint_XX_index_TEMPLATE.md
    │   ├── sprint_XX_decisions_log_TEMPLATE.md
    │   ├── sprint_XX_team_dev_MODULE_todo_TEMPLATE.md
    │   ├── sprint_XX_team_dev_MODULE_report_TEMPLATE.md
    │   ├── sprint_XX_team_playbook_TEMPLATE.md     # ← Agent Teams launch playbook
    │   ├── sprint_XX_DR_TOPIC_TEMPLATE.md
    │   └── sprint_XX_requirements_delta_TEMPLATE.md
    ├── AGENT_TEAMS_LESSONS_TEMPLATE.md              # ← Cumulative lessons registry
    ├── CPTO_agent_TEMPLATE.md
    ├── module_AGENTS_TEMPLATE.md
    ├── PRD_TEMPLATE.md
    ├── DECISIONS_TEMPLATE.md
    ├── CHANGELOG_TEMPLATE.md
    └── SECURITY_TEMPLATE.md
```

---

## Rules of the road

- **One source of truth:** if two docs say different things → raise a FLAG and resolve.
- **Keep docs runnable:** prefer concrete paths, commands, and acceptance criteria over prose.
- **When adding capabilities:** update `03_MODULES.md` + the owning module's README/AGENTS.

---

## Agent Teams — Sprint Execution Process

For projects using Claude Code Agent Teams to execute sprints:

| Resource | Location | Purpose |
|----------|----------|---------|
| Sprint Team Launch Skill | `.claude/skills/sprint-team-launch.md` | Reusable skill loaded by team leads — covers creation, task board, coordination, shutdown |
| Team Playbook Template | `docs/templates/sprints/sprint_XX_team_playbook_TEMPLATE.md` | Copy-paste TaskCreate prompts for FOUNDER to launch team |
| Lessons Learned Template | `docs/templates/AGENT_TEAMS_LESSONS_TEMPLATE.md` | Cumulative registry — add findings after every sprint |

**End-to-end process:**
1. CPTO writes sprint spec + kickoff (tasks, acceptance criteria)
2. CPTO writes team playbook (verbatim TaskCreate blocks per teammate)
3. FOUNDER opens dedicated CLI, creates team, pastes TaskCreate blocks
4. Team lead coordinates — unblocks dependencies, reviews deliverables
5. FOUNDER intervenes only for auth/config/decisions that need human access
6. Team lead produces sprint report, shuts down teammates
7. CPTO runs GBU review on deliverables, logs lessons learned
8. FOUNDER approves gate → next sub-sprint

**Worked examples:** See `agents/project_management/sprints/sprint_11/todo/` for real playbooks (11a, 11b).
