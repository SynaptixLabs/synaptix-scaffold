# Sprint XX{sub} — Agent Teams Playbook
## Launch Instructions for Dedicated CLI Session

**Sprint:** XX{sub} — {Goal}
**Team name:** `sprint-XX{sub}`
**Teammates:** {N} ({role1}, {role2}, ...)
**Effort:** ~{N}V total

---

## PRE-FLIGHT CHECKLIST

Before launching, confirm:
- [ ] Previous sub-sprint gate passed (all deliverables committed)
- [ ] Kickoff file exists: `sprint_XX/todo/KICKOFF_XX{sub}_DEV.md`
- [ ] Spec file exists: `sprint_XX/specs/SPRINT_XX{sub}_SPEC.md`
- [ ] CLAUDE.md updated with current sprint reference
- [ ] All previous work committed to git

---

## LAUNCH SEQUENCE

### Step 1: Open dedicated CLI session

```
cd C:\Synaptix-Labs\projects\{project}
claude
```

### Step 2: Create the team

```
Create an agent team called "sprint-XX{sub}" with {N} teammates:

1. "{role1}" — {responsibility} (Tasks {T1-TN})
2. "{role2}" — {responsibility} (Tasks {T1-TN})

Both teammates MUST read these files before any work:
- AGENTS.md
- MUST_READ_MODULE_REUSE.md
- {spec file path}
- {kickoff file path}

RENAME-ON-TOUCH: When editing any file, apply pending renames (see CLAUDE.md).
```

### Step 3: Assign tasks via TaskCreate

After the team is created, assign tasks using the prompts below.
**COPY VERBATIM — do not paraphrase (Lesson L7).**

---

## TASK ASSIGNMENTS — {role1}

### Task {batch} — {TITLE} ({role1})

```
Subject: "{task-ids}: {short description}"
Description: "You are {role1}.

READ FIRST (in this order):
1. AGENTS.md
2. MUST_READ_MODULE_REUSE.md
3. {specific spec file}
4. {specific kickoff section}

YOUR TASK:
{exact instructions from kickoff — VERBATIM}

WRITE CODE IMMEDIATELY. Do NOT produce a plan document. (Lesson L1)
Your output is CODE FILES at {exact paths}, not markdown.

ACCEPTANCE CRITERIA:
- [ ] {criterion 1}
- [ ] {criterion 2}
- [ ] {criterion 3}

DO NOT:
- {scope guard 1}
- {scope guard 2}

COMMIT after EVERY meaningful change: (Lesson L5)
  git commit -m '[XX{sub}] {task-id}: {what changed}'

When done, message team-lead with: deliverable path + summary."
```


{Repeat TaskCreate block for each task batch per teammate}

---

## SEQUENCING

{Describe dependency order. Which teammate goes first? When does the second unblock?}

```
PHASE 1 ({role1} — critical path):
  {T1} → {T2} → {T3}
        ↓
     unlocks {role2}
        ↓
PHASE 2 ({role2} — after Phase 1 delivers):
  {T4} → {T5} → {T6}
```

**Key dependency:** {role2} starts when {role1} delivers {specific deliverable}.
Give blocked teammates read-only prep work while waiting. (Lesson L2)

---

## EXIT CRITERIA

All must pass:

| Check | Owner | Method |
|-------|-------|--------|
| {check 1} | {role} | {how to verify} |
| {check 2} | {role} | {how to verify} |
| {check 3} | {role} | {how to verify} |

When all checks pass, report to FOUNDER for gate approval.

---

## ANTI-PATTERNS (reminders from lessons registry)

| # | Don't | Do Instead | Lesson |
|---|-------|-----------|--------|
| 1 | Produce plans instead of code | "WRITE CODE IMMEDIATELY" in every TaskCreate | L1 |
| 2 | Leave blocked teammates idle | Give read-only prep tasks | L2 |
| 3 | Skip commits | "Commit after EVERY meaningful change" | L5 |
| 4 | Assume teammates read AGENTS.md | Explicit instruction in every spawn | L6 |
| 5 | Paraphrase playbook in TaskCreate | Copy VERBATIM | L7 |
| 6 | {sprint-specific anti-pattern} | {alternative} | — |

---

*Sprint XX{sub} Team Playbook v1.0 | {Author} | {Date}*
