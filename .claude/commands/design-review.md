# /project:design-review — Post-Development GBU Review

> **Alias for `/project:gbu`** — This command runs a full Good/Bad/Ugly design review.

Perform a design review using the Good/Bad/Ugly method. Output the review to the **reviews/** folder.

## Output Location

```
docs/sprints/sprint_XX/reviews/DR_{sprint}_{topic}_{date}.md
```

> **IMPORTANT:** Reviews go to `reviews/`, not `reports/`. Reports are for dev/QA completion reports.

## Steps

1. **Identify scope** — what is being reviewed? (sprint deliverable, module, architecture change, PR)
2. **Read** all relevant source files, specs, and docs
3. **Read** `MUST_READ_MODULE_REUSE.md` — the #1 quality gate
4. **Run tests** — verify current state
5. **Assess** using the GBU framework below
6. **Fix** BAD and UGLY items (don't just report — implement fixes)
7. **Score** with Quality Scorecard
8. **Output** the review to `docs/sprints/sprint_XX/reviews/DR_{topic}.md`

## Review Framework

### GOOD (keep)
What works well and should be preserved. Give explicit credit with evidence (file:line or test output).

### BAD (fix before merge)
What needs fixing. Categorize by priority:
- **P0** — blocks merge/release
- **P1** — fix this sprint
- **P2** — fix next sprint
- **P3** — backlog / nice-to-have

### UGLY (systemic / tech debt)
Patterns or architectural issues that aren't broken today but will cause pain. Needs strategic attention.

## For each issue

```
- ID: B01 / U01
- Severity: P0/P1/P2/P3
- Location: exact file path + line range
- Problem: what's wrong
- Fix: concrete recommendation (or implement it directly)
- Effort: ~X vibes
```

## Standard Checks (all projects)

- [ ] No hardcoded values (use config/settings)
- [ ] No suppressed type errors
- [ ] No inline styles where design system classes exist
- [ ] Unit tests for all new logic
- [ ] E2E coverage for new user-facing flows
- [ ] No regressions on previously accepted features
- [ ] Module boundaries respected (no cross-module direct imports)
- [ ] AGENTS.md updated if module behavior changed
- [ ] No new dependencies added without CPTO FLAG
- [ ] Layout uses percentage-based constraints (no fixed-pixel `max-width`)
- [ ] E2E layout tests assert at multiple viewports (1024, 1280, 1920)
- [ ] Module reuse protocol followed (MUST_READ_MODULE_REUSE.md)
- [ ] No secrets in code or logs
- [ ] No TODO/FIXME left unresolved

## Quality Scorecard

| Dimension | Score (1-5) | Notes |
|-----------|-------------|-------|
| Requirements Coverage | | |
| Module Reuse Compliance | | |
| Test Coverage | | |
| Regression Safety | | |
| Documentation | | |
| Architecture Reversibility | | |
| Engineering Quality | | |
| Production Readiness | | |

**Weighted Score: X/10**

## Output

End with:
- **Verdict:** APPROVE / APPROVE WITH CONDITIONS / REVISE / REJECT
- Prioritized fix list (P0 first)
- What to cut or defer
- Explicit next steps
- Quality Scorecard summary

## Commit the report

```
git add docs/sprints/sprint_*/reviews/DR_*.md
git commit -m "[CPTO] DR-{sprint}-{topic}: {verdict} — Score {X}/10"
```
