---
name: sprint-team-launch
description: >
  Use this skill when launching an Agent Team for a sprint. Covers team creation,
  task board setup, teammate spawning with role-specific prompts, coordination
  protocol, and review workflow. Applicable to any sprint in any SynaptixLabs project.
tools: Read, Write, Bash, Glob, Grep
model: opus
---

# Sprint Team Launch — Reusable Skill

You are the **team lead** launching an Agent Team for a sprint. Follow this protocol exactly.

## Pre-Launch Checklist

Before spawning ANY teammate, verify these files exist:

1. **Sprint index** — `project_management/sprints/sprint_XX/sprint_index.md`
2. **Kickoff file** — `project_management/sprints/sprint_XX/todo/KICKOFF_*.md`
3. **Team playbook** — `project_management/sprints/sprint_XX/todo/TEAM_PLAYBOOK_*.md`
4. **Decisions log** — `project_management/sprints/sprint_XX/decisions_log.md`
5. **CLAUDE.md** — Updated with current sprint reference
6. **CODEX.md** — Updated with current sprint reference

If any are missing, create them or ask the FOUNDER before proceeding.

## Step 1: Read Context

Read in this exact order:
```
1. The team playbook (TEAM_PLAYBOOK_*.md) — your operational instructions
2. The kickoff file (KICKOFF_*.md) — task details and acceptance criteria
3. MUST_READ_MODULE_REUSE.md — module reuse protocol (if it exists)
4. Any specs referenced in the playbook
```

## Step 2: Create Task Board

For each task in the playbook, call TaskCreate with:
- `subject`: Short task name (matches teammate assignment)
- `description`: VERBATIM from the playbook — do NOT paraphrase or summarize
- Include reading order, deliverables, and acceptance criteria in the description
- Mark dependencies: "⛔ DO NOT START until team-lead confirms Task N complete"

### Task Description Template
```
You are {teammate-name}. Your job is {one-sentence summary}.

⛔ BLOCKED BY: {Task N — description} (wait for team-lead confirmation)
   — OR —
✅ NO DEPENDENCIES: Start immediately.

READ FIRST (in this order):
- AGENTS.md
- MUST_READ_MODULE_REUSE.md (if it exists)
- {specific spec file}
- {specific kickoff section}

YOUR TASK:
{detailed instructions from kickoff file}

WRITE CODE IMMEDIATELY. Do NOT produce a plan document. Your output is CODE FILES, not markdown.

DELIVERABLE: {exact file path for output}
COMMIT after EVERY meaningful change: git commit -m "[sprint]: [task#] [what changed]"
When done, message team-lead with summary + deliverable path.
```

## Step 3: Spawn Teammates

Rules for spawning:
- **Name** teammates by role: `dev-audit`, `dev-cascade`, `dev-skills`, `dev-qa`, etc.
- **Spawn prompt** should say: "Read your task from the task board. Start by reading {first file}."
- **Independent teammates** (no dependencies): spawn immediately, set `run_in_background: true`
- **Dependent teammates** (blocked by others): spawn but instruct to WAIT for lead's go signal
- **Max teammates**: 3-4. More causes coordination overhead that exceeds benefit.

### Spawn Template
```
Teammate({
  operation: "spawnTeammate",
  name: "{role-name}",
  prompt: "You are {role-name}. Read your task from the task board.
    Start by reading {first-file-path}.
    Then read {second-file-path}.
    Commit after every meaningful change.
    Message team-lead when your task is complete."
})
```

## Step 4: Coordinate

### When a teammate delivers:
1. Read their deliverable
2. Check against acceptance criteria in the kickoff file
3. If acceptable: acknowledge, unblock dependent tasks, message blocked teammates
4. If issues: message teammate with SPECIFIC fix requests (not vague "try again")
5. Do NOT rewrite their work — send feedback, let them fix

### Unblocking pattern:
```
SendMessage({
  recipient: "dev-cascade",
  content: "Task 1 (audit) is COMPLETE. Read the report at 
    {path}. You are now cleared to start Tasks 2 and 3.
    Key findings from audit: {1-2 sentence summary}."
})
```

### If a teammate is stuck:
1. Ask what's blocking them
2. If code issue: provide guidance, not code
3. If missing context: point to specific file + line
4. If fundamentally wrong approach: redirect with clear alternative
5. Last resort: shut down teammate, spawn a replacement with better instructions

### If a teammate crashes:
1. Check their latest commit — what was saved?
2. Spawn a replacement teammate with same role
3. In spawn prompt, include: "Previous session crashed. Resume from {last commit}. Read {deliverable so far}."

## Step 5: Produce Sprint Deliverable

When ALL tasks are complete:
1. Read all teammate deliverables
2. Verify each against acceptance criteria
3. Produce a summary document (sprint report or decision doc as required)
4. Place in `project_management/sprints/sprint_XX/reports/`
5. Message FOUNDER with the summary + paths to all deliverables

## Step 6: Shutdown

1. Confirm all teammates have committed their work
2. Request shutdown for each teammate:
```
Teammate({
  operation: "requestShutdown",
  target_agent_id: "{teammate-name}"
})
```
3. Wait for shutdown confirmations
4. Produce final status message to FOUNDER

---

## Anti-Patterns (DO NOT)

| # | Anti-Pattern | Why | Instead |
|---|-------------|-----|---------|
| 1 | Lead writes code | Lead is coordinator, not implementer | Send task to teammate |
| 2 | Spawn >4 teammates | Coordination overhead exceeds benefit | 2-3 teammates optimal |
| 3 | Vague task descriptions | Teammate starts from zero, wastes context reading everything | Verbatim from playbook with specific file paths |
| 4 | No commit discipline | Crash = work lost | "Commit after every meaningful change" in every spawn prompt |
| 5 | Lead rewrites teammate output | Wastes lead context on implementation details | Send feedback, let teammate fix |
| 6 | Skip dependency checks | Teammate builds on incomplete foundation | Explicit ⛔ blocks + lead confirmation |
| 7 | Batch all reviews at end | Late discovery of fundamental issues | Review each deliverable as it arrives |
| 8 | TaskCreate says "your job is to..." without demanding code | Teammates produce plans instead of code (L1) | Add "WRITE CODE IMMEDIATELY. Do NOT produce a plan document." |
| 9 | All tasks have sequential dependencies | Zero parallelism — blocked teammates sit idle (L2, L4) | Design tasks with parallel-first mindset. Split "deploy then integrate" into parallel tracks. |
| 10 | Lead paraphrases playbook instead of copy-paste | Diluted instructions, missed acceptance criteria (L7) | Copy TaskCreate blocks VERBATIM from playbook |
| 11 | Assume teammates read AGENTS.md | They don't — only CLAUDE.md auto-loads (L6) | Every spawn prompt must say "Read AGENTS.md first" |

---

## Team Sizing Guide

| Sprint Size | Vibes | Tasks | Recommended Team | Rationale |
|-------------|-------|-------|-----------------|-----------|
| Small | ≤60V | ≤15 | Solo agent or lead + 1 | Team overhead exceeds parallelism gain |
| Medium | 60-150V | 15-30 | Lead + 2 | Sweet spot: meaningful parallelism, manageable coordination |
| Large | 150V+ | 30+ | Lead + 3-4 | Needs tracks with independent work streams |

---

## Validation Protocol

ALL evaluation results follow this standard across ALL sprints:
1. Run system tests from simple → complex prompts
2. Place ALL results in the project's `system-tests/` directory
3. Each run gets its own dated folder
4. Each folder contains: report.json, index.html, per-prompt subfolders
5. Evaluate by reading reports + viewing HTML outputs

---

*Sprint Team Launch Skill v1.1 | SynaptixLabs Scaffold | 2026-03-19*
*Updated with lessons from Sprint 11a-b. See your project's Agent Teams Lessons doc (create from `docs/templates/AGENT_TEAMS_LESSONS_TEMPLATE.md` if missing).*
