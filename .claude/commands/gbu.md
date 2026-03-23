# /project:gbu — Post-Development GBU Review & Fix

> **Purpose:** Run at the END of a dev session to verify work meets requirements,
> assess code quality, fix issues found, and produce a formal Design Review report.
>
> **Usage:** `/project:gbu` — typically invoked by FOUNDER or CPTO after dev-backend completes work.
>
> **What GBU Means:**
> - **G (Good):** What works well. Keep these. Evidence-based — cite specific code, tests, or outputs.
> - **B (Bad):** What must be fixed before merge. Each item gets a concrete fix (not just a description).
> - **U (Ugly):** Structural issues that will hurt later. Tech debt, coupling, scaling risks.
>   Ugly items get either an immediate fix OR a documented carry-forward with sprint target.

---

## TL;DR — THE TWO NON-NEGOTIABLE PHASES

No matter what, ALWAYS do these two:
- **Phase 2 (Requirements Compliance):** Check EVERY requirement from the spec → PASS/FAIL with evidence.
- **Phase 5 (Fix Bad & Ugly):** Actually IMPLEMENT fixes and commit them — don't just list problems.

Everything else improves quality. These two are the minimum.

## Sizing Guide

| Task Size | What to Run | Effort Budget |
|-----------|------------|---------------|
| Small (<3V, 1-2 files) | Phase 1 + 2 + 4 + 5 + 7 only | ~15 min |
| Medium (3-10V) | All 7 phases | ~30 min |
| Large (>10V, multi-file) | All 7 phases + extra depth on Phase 3 | ~45 min |

**Rule of thumb:** GBU effort = ~15-20% of task effort. Don't spend 10V reviewing a 5V fix.

---

## PHASE 1: Gather Context (DO NOT SKIP)

1. **Read the task spec** that was given to the dev session:
   - Check `project_management/sprints/sprint_*/todo/` for the active TODO
   - Identify EVERY requirement, acceptance criterion, and constraint

2. **Read MUST_READ_MODULE_REUSE.md** — the #1 quality gate

3. **Read the diff** — what files were actually changed:
   ```
   git log --oneline -5
   git diff HEAD~N --stat   (where N = number of commits in this session)
   git diff HEAD~N          (full diff for review)
   ```

4. **Read the changed files** — full source, not just diffs

5. **Run the tests:**
   ```
   {{TEST_COMMAND}}
   ```

6. **Run domain-specific validation** (if applicable):
   ```
   {{VALIDATION_COMMAND}}
   ```

7. **Verify generated artifacts** (DO NOT SKIP):
   - Open/read the ACTUAL output files — not just the code that generates them
   - For APIs: call the endpoint and verify the response
   - For UI: check the rendered output in browser
   - For pipelines: read the generated output — does it match expectations?
   - **If the output looks wrong to a human, it IS wrong — regardless of what tests say**

8. **Regression comparison** (if iterating on existing functionality):
   - Compare current output to the PREVIOUS version's output
   - If you can run before-and-after: do it. If not: read the previous run's artifacts.
   - v2 must be >= v1 on every dimension. Flag any regression.

---

## PHASE 2: Requirements Compliance Check

For EVERY requirement in the task spec, produce a row:

```markdown
| # | Requirement | Met? | Evidence |
|---|------------|------|----------|
| R1 | [exact text from spec] | PASS/FAIL/PARTIAL | [file:line or test output] |
| R2 | ... | ... | ... |
```

**Rules:**
- Copy requirements VERBATIM from the spec — do not paraphrase
- PASS = implemented AND tested. Code exists but untested = PARTIAL
- Evidence must be specific: file path + line number, test name, or command output
- If a requirement was NOT addressed at all → FAIL with explanation

---

## PHASE 3: Code Quality Assessment

### 3a. Module Reuse Checklist (MANDATORY — every review)

| Check | Result | Evidence |
|-------|--------|----------|
| {{REUSE_CHECK_1}} | PASS/FAIL | [where] |
| {{REUSE_CHECK_2}} | PASS/FAIL | [where] |
| {{REUSE_CHECK_3}} | PASS/FAIL | [where] |
| Config via settings (not hardcoded) | PASS/FAIL | [where] |
| No hardcoded model/service strings | PASS/FAIL | [where] |
| No parallel infrastructure created | PASS/FAIL | [where] |
| Module contracts respected | PASS/FAIL | [where] |
| Version tag present in outputs | PASS/FAIL | [where] |
| PII/secrets redacted in logs | PASS/FAIL | [where] |

> **Customize this table during Sprint-0.** Add checks specific to your project's modules.

### 3b. Production Readiness

| Check | Result | Notes |
|-------|--------|-------|
| No `print()` statements (use logger) | PASS/FAIL | |
| No hardcoded paths (use Path/settings) | PASS/FAIL | |
| No bare `except:` (catch specific exceptions) | PASS/FAIL | |
| Error messages are actionable | PASS/FAIL | |
| Type hints on public functions | PASS/FAIL | |
| Docstrings on public functions | PASS/FAIL | |
| No TODO/FIXME/HACK left unresolved | PASS/FAIL | List them |
| No commented-out code blocks | PASS/FAIL | |
| Imports are clean (no unused) | PASS/FAIL | |
| No secrets/keys in code | PASS/FAIL | |
| Binary files excluded from git | PASS/FAIL | Check .gitignore |
| File paths use Path() not string concatenation | PASS/FAIL | (cross-platform) |

### 3c. Anti-Pattern Check

Reference `AGENTS.md` Known Anti-Patterns section:

| Anti-Pattern | Violated? | Where |
|-------------|-----------|-------|
| {{AP1_NAME}}: {{AP1_DESC}} | YES/NO | |
| {{AP2_NAME}}: {{AP2_DESC}} | YES/NO | |
| {{AP3_NAME}}: {{AP3_DESC}} | YES/NO | |
| Parallel infrastructure (duplicate module) | YES/NO | |
| Regression shipping (v2 < v1) | YES/NO | |
| Session loss (uncommitted work) | YES/NO | |
| Instruction-only enforcement (prompts instead of tools/gates) | YES/NO | |
| Copy-paste extraction (two sources of truth, guaranteed drift) | YES/NO | |
| One-dimensional quality gate (no engineering review) | YES/NO | |
| Undocumented module reuse mandate (no README = can't comply) | YES/NO | |

> **Customize this table during Sprint-0.** Add anti-patterns specific to your project's domain.

---

## PHASE 4: GBU Assessment

### GOOD — What works well (keep these)

| # | What | Why It Works | Evidence |
|---|------|-------------|----------|
| G1 | ... | ... | [file:line or test] |

### BAD — Must fix before acceptance

| # | What | Impact | Fix | Effort |
|---|------|--------|-----|--------|
| B1 | ... | ... | [specific code change] | Xmin |

### UGLY — Will hurt later (tech debt, coupling, scaling)

| # | What | Impact | Fix | Sprint Target |
|---|------|--------|-----|---------------|
| U1 | ... | ... | [fix or carry-forward] | Current/Next |

---

## PHASE 5: Fix the Bad and Ugly (MANDATORY)

**Do not just report problems — FIX THEM.**

For each BAD item:
1. Implement the fix
2. Run tests to verify the fix
3. Commit with message: `[DR-fix] B{N}: {description}`

For each UGLY item that can be fixed in <3V:
1. Implement the fix
2. Commit with message: `[DR-fix] U{N}: {description}`

For UGLY items that need >3V:
1. Document as carry-forward with sprint target
2. Add to sprint backlog

---

## PHASE 6: Quality Scorecard

| Dimension | Score (1-5) | Notes |
|-----------|-------------|-------|
| Requirements Coverage | _ | All spec requirements met? |
| Module Reuse Compliance | _ | Used existing modules? |
| Test Coverage | _ | New code has tests? >=80% logic? |
| Regression Safety | _ | v2 >= v1? All existing tests pass? |
| Documentation | _ | README, docstrings, commit messages? |
| Architecture Reversibility | _ | Any one-way doors? |
| Engineering Quality | _ | DRY, static analysis, security, config hygiene? |
| Production Readiness | _ | No debug code, proper error handling? |

**Weighted Score: X/10**

---

## PHASE 7: Produce the Design Review Report

Save the complete report to:
```
project_management/sprints/sprint_{current}/reviews/DR_{sprint}_{topic}.md
```

The report MUST include ALL sections above:
1. Executive Summary (verdict + score)
2. Requirements Compliance table
3. Module Reuse Checklist
4. Production Readiness Checklist
5. Anti-Pattern Check
6. GBU Assessment (Good/Bad/Ugly tables)
7. Fixes Applied (commits)
8. Quality Scorecard
9. Carry-Forwards (if any)
10. Verdict: APPROVE / APPROVE WITH CONDITIONS / REVISE / REJECT

**Commit the report:**
```
git add project_management/sprints/sprint_*/reviews/DR_*.md
git commit -m "[CPTO] DR-{sprint}-{topic}: {verdict} — Score {X}/10"
```

---

## Verdict Criteria

| Verdict | When |
|---------|------|
| **APPROVE** | All requirements met. 0 BAD items remaining. Score >= 8/10. |
| **APPROVE WITH CONDITIONS** | Most requirements met. BAD items are minor (<1V each). Score >= 7/10. |
| **REVISE** | Requirements partially met. BAD items are significant. Score 5-7/10. |
| **REJECT** | Requirements not met. Structural problems. Score < 5/10. Rework needed. |
