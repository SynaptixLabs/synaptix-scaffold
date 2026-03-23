# Skill: Sprint Report

> Generate a sprint status report from sprint docs, TODOs, reports, and actual code state.

## Trigger

Invoked via `/project:sprint-report` at any point during a sprint.

## Process

1. Read sprint index and all TODO files
2. Read completed reports
3. Check code state vs plans (git log, test results)
4. Generate Done / In Progress / Blocked / Deferred lists
5. Produce quality gates summary
6. Save to reviews/ folder

## Output

Sprint report saved to `docs/sprints/sprint_XX/reviews/SPRINT_REPORT_{date}.md`
