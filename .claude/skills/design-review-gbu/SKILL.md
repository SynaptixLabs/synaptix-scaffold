# Skill: Design Review (GBU)

> Run a Good/Bad/Ugly review on completed work.

## Trigger

Invoked via `/project:gbu` or `/project:design-review` after dev completes work.

## Inputs

- Task spec or TODO file
- Changed files (git diff)
- Test results

## Process

1. Read the task spec and MUST_READ_MODULE_REUSE.md
2. Read the diff and changed files
3. Run tests
4. Assess against requirements (Phase 2 — NON-NEGOTIABLE)
5. Check module reuse compliance
6. Produce GBU assessment
7. Fix BAD and UGLY items (Phase 5 — NON-NEGOTIABLE)
8. Score with Quality Scorecard
9. Save report to `docs/sprints/sprint_XX/reviews/DR_{topic}.md`

## Output

Design Review report with verdict: APPROVE / APPROVE WITH CONDITIONS / REVISE / REJECT
