# {{PROJECT_NAME}} — Claude Code Operations Guide

> **Canonical source.** Edit here only.
> Reference for all slash commands, skills, and workflows available in this project.

---

## Quick Reference

| Command | Role | When to Use |
|---------|------|-------------|
| `/project:cpto` | CPTO (PM/CTO) | Sprint planning, architecture decisions, specs, TODOs |
| `/project:dev-backend` | Backend Developer | Implement backend features, fix bugs |
| `/project:dev-frontend` | Frontend Developer | Implement UI features, components |
| `/project:dev-devops` | DevOps Engineer | Deploy, infrastructure, CI/CD |
| `/project:dev-qa` | QA Engineer | Test plans, regression gates, bug reports |
| `/project:dev-cso` | Security Officer | Security audits, auth reviews, encryption |
| `/project:dev-ux` | ARIA (UX Creative) | UI/UX design, animations, design system |
| `/project:gbu` | Reviewer | Post-dev Good/Bad/Ugly review + fix |
| `/project:test` | Any | Run full test suite |
| `/project:e2e` | Any | Playwright browser tests |
| `/project:plan` | Any | Force Plan Mode before complex work |
| `/project:regression` | Any | Pre-merge quality gate |
| `/project:release-gate` | Any | Pre-production checklist |
| `/project:sprint-kickoff` | CPTO | Create a new sprint |
| `/project:sprint-report` | CPTO | Sprint status report |
| `/project:design-review` | Reviewer | Alias for /project:gbu |

---

## Skills

Skills are reusable process procedures with checklists and templates.

| Skill | Location | Purpose |
|-------|----------|---------|
| `design-review-gbu` | `.claude/skills/design-review-gbu/` | Structured GBU review process |
| `implement-backend` | `.claude/skills/implement-backend/` | Backend dev workflow with reuse checks |
| `implement-frontend` | `.claude/skills/implement-frontend/` | Frontend dev with Playwright validation |
| `qa-gate` | `.claude/skills/qa-gate/` | QA validation + PASS/FAIL report |
| `release-readiness` | `.claude/skills/release-readiness/` | Pre-deploy GO/NO-GO gate |
| `sprint-report-skill` | `.claude/skills/sprint-report-skill/` | Sprint status reporting |
| `sprint-team-launch` | `.claude/skills/sprint-team-launch.md` | Multi-agent team orchestration |
| `sync-state` | `.claude/skills/sync-state/` | Multi-window state sync |

---

## Infrastructure

| Component | Path | Purpose |
|-----------|------|---------|
| Session State | `.claude/state/session-state.md` | Survives compaction, enables multi-window |
| Reinject Hook | `.claude/hooks/reinject_context.py` | Auto-restores state after compaction |
| Settings | `.claude/settings.json` | Plugin config + hooks |
| Permissions | `.claude/settings.local.json` | Bash command allow-list |
| Launch Config | `.claude/launch.json` | VS Code debug configurations |
| Roles | `.claude/roles/` | System prompts for specialized agents |

---

## System Commands (Built-in)

| Command | Purpose |
|---------|---------|
| `/clear` | Clear conversation history |
| `/compact` | Compress conversation context |
| `/resume` | Resume from previous session |
| `/branch` | Create a branch from current state |
| `/diff` | Show pending changes |
| `/cost` | Show current session cost |
| `/model` | Switch model |
| `/fast` | Toggle fast mode (same model, faster output) |
| `/exit` | Exit Claude Code |

---

## Workflows by Use Case

### Starting a Sprint
```
/project:sprint-kickoff
→ Creates sprint_index.md, decisions_log.md, specs/, todo/, reports/, reviews/
→ MUST reference MUST_READ_MODULE_REUSE.md in reading order
```

### Implementing a Feature (Backend)
```
/project:dev-backend
→ Reads MUST_READ_MODULE_REUSE.md + TODO
→ Plans → Implements → Tests → Commits
→ Then: /project:gbu for review
```

### Implementing a Feature (Frontend)
```
/project:dev-frontend
→ Reads UI Kit + TODO
→ Plans → Implements → Playwright tests → Commits
→ Then: /project:gbu for review
```

### Running Tests
```
/project:test          # Full suite
/project:e2e           # Browser tests only
/project:regression    # Pre-merge gate
```

### Reviewing Work
```
/project:gbu           # Full GBU review (7 phases)
/project:design-review # Alias for gbu
```

### Pre-Production
```
/project:release-gate  # GO/NO-GO checklist
```

### Multi-Window Work
```
1. Save state: run sync-state skill
2. Switch windows
3. New window auto-loads state via reinject hook on compaction
```

---

## Tips

1. **Always read before writing.** Check module contracts before creating new modules.
2. **Use Plan Mode** (`/project:plan`) before complex multi-file changes.
3. **Session state survives compaction** — the reinject hook restores context automatically.
4. **GBU reviews fix problems** — Phase 5 implements fixes, not just reports them.
5. **Effort in Vibes** — 1V = 1K tokens. Never use hours/days/story points.
6. **Module reuse is the #1 quality gate** — MUST_READ_MODULE_REUSE.md before any code.
