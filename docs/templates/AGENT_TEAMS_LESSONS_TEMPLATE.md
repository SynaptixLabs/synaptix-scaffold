# {Project Name} — Agent Teams Lessons Learned

**Last updated:** YYYY-MM-DD | Sprint XX
**Applies to:** All projects using Agent Teams (Claude Code)

---

## Purpose

Cumulative lessons from running Agent Teams across sprints. Feeds into the
`sprint-team-launch` skill and CPTO sprint planning. Add findings after every sprint.

---

## Lesson Registry

### L1: {Title}
**Sprint:** XX | **Severity:** HIGH/MEDIUM/LOW | **Recurrence:** {when it happens}

**What happened:** {1-2 sentences}

**Root cause:** {why it happened}

**Fix for future sprints:**
- {concrete action 1}
- {concrete action 2}

---

## Known Lessons (from SynaptixLabs experience)

Copy these into your registry if they apply. Source: `23_AGENT_TEAMS_LESSONS.md` in AGENTS project.

| ID | Lesson | Severity | Fix |
|----|--------|----------|-----|
| L1 | Teammates default to planning, not coding | HIGH | "WRITE CODE IMMEDIATELY" in every TaskCreate |
| L2 | Blocked teammates sit idle | MED | Give read-only prep tasks while waiting |
| L3 | Team-lead is often most productive | MED | Match team size to sprint size (see sizing guide) |
| L4 | Sequential deps kill parallelism | MED | Design parallel-first tasks |
| L5 | Commit discipline is non-negotiable | CRIT | "Commit after EVERY meaningful change" in every spawn |
| L6 | Teammates don't read AGENTS.md unless told | HIGH | Explicit "Read AGENTS.md first" in every spawn |
| L7 | TaskCreate must be verbatim from playbook | MED | Copy-paste, never paraphrase |

---

## Team Sizing Guide

| Sprint Size | Vibes | Tasks | Recommended Team |
|-------------|-------|-------|-----------------|
| Small | ≤60V | ≤15 | Solo or lead + 1 |
| Medium | 60-150V | 15-30 | Lead + 2 |
| Large | 150V+ | 30+ | Lead + 3-4 |

---

## Sprint History

| Sprint | Team Size | Tasks | Completed | Lessons Added |
|--------|-----------|-------|-----------|---------------|
| XX | lead + N | N | N | LN, LN |

---

*Agent Teams Lessons Template | SynaptixLabs Scaffold*
