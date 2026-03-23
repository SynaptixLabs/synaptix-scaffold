# Skill: QA Gate

> Validate a completed task or PR. Verify dev-written tests, add QA validation where needed, and issue an explicit PASS/FAIL report.

## Trigger

Invoked after dev completes implementation, before merge.

## Process

1. Read the task spec and acceptance criteria
2. Verify dev wrote tests (unit + E2E where applicable)
3. Run full test suite
4. Write additional QA validation tests if gaps found
5. Check for regressions
6. Produce PASS/FAIL report

## Output

QA Gate report saved to `docs/sprints/sprint_XX/reports/QA_{topic}.md`
