# {{SPRINT_ID}} — TODO: {{TASK_NAME}}

**Team:** {{TEAM_NAME}}
**Owner:** `[DEV:{{MODULE_NAME}}|{{DOMAIN_TAG}}]`
**Module path:** `{{MODULE_PATH}}`

---

## Instructions

> **Each team is responsible for checking its box and creating a report when work is complete.**
>
> - **DEV team:** Check ✅ Done when implementation is complete. Create a report in `reports/` folder.
> - **QA team:** Check ✅ Tested when QA validation passes. Create a report in `reports/` folder.
> - **CPTO/Review:** Check ✅ GBU when design review is complete. Create a review in `reviews/` folder.
>
> A task is only considered COMPLETE when all 3 checkboxes are checked.

---

## Sprint Goals

- {{goal-1}}
- {{goal-2}}

---

## Tasks

| ID | Task | Team | Acceptance Criteria | Done + Report | Tested + Report | GBU + Report |
|----|------|------|---------------------|---------------|-----------------|--------------|
| T001 | {{task}} | {{team}} | {{AC}} | ⬜ [📄]() | ⬜ [📄]() | ⬜ [📄]() |
| T002 | {{task}} | {{team}} | {{AC}} | ⬜ [📄]() | ⬜ [📄]() | ⬜ [📄]() |
| T003 | {{task}} | {{team}} | {{AC}} | ⬜ [📄]() | ⬜ [📄]() | ⬜ [📄]() |

### Legend

| Symbol | Meaning |
|--------|---------|
| ⬜ | Not started |
| ✅ | Complete |
| 🔄 | In progress |
| ❌ | Blocked |
| [📄]() | Link to report (fill in path when created) |

### Report Naming Convention

| Report Type | Path | Naming |
|-------------|------|--------|
| Dev Report | `reports/` | `{{SPRINT_ID}}_DEV_{{TASK_ID}}_{{module}}.md` |
| QA Report | `reports/` | `{{SPRINT_ID}}_QA_{{TASK_ID}}_{{module}}.md` |
| GBU Review | `reviews/` | `DR_{{SPRINT_ID}}_{{TASK_ID}}_{{topic}}.md` |

---

## Definition of Done

### For DEV (✅ Done)
- [ ] Code implemented per acceptance criteria
- [ ] Unit tests written and passing
- [ ] Integration/E2E tests where applicable
- [ ] No regressions on existing tests
- [ ] README + AGENTS.md updated if behavior/contract changed
- [ ] `docs/03_MODULES.md` updated if capabilities changed
- [ ] Dev report created in `reports/`

### For QA (✅ Tested)
- [ ] Dev tests verified (not just run — reviewed for quality)
- [ ] Additional QA validation tests written if gaps found
- [ ] Full test suite passes
- [ ] Edge cases and error paths tested
- [ ] QA report created in `reports/`

### For GBU (✅ Reviewed)
- [ ] Requirements compliance checked (every requirement → PASS/FAIL)
- [ ] Module reuse compliance verified
- [ ] Code quality assessed (production readiness)
- [ ] GBU assessment complete (Good/Bad/Ugly tables)
- [ ] BAD and UGLY items fixed or carry-forwarded
- [ ] Design review report created in `reviews/`

---

## Extraction Mode Gates (if applicable)

> Complete these BEFORE any implementation if this sprint involves extracting/migrating existing code.

| Gate | Status | Notes |
|------|--------|-------|
| Source path confirmed | ⬜ | `{{SOURCE_PATH}}` |
| File inventory created | ⬜ | See `reviews/{{SPRINT_ID}}_DR_extraction_inventory.md` |
| DR checkpoint created | ⬜ | |
| Allowlist approved by CTO | ⬜ | |
| Copy-only phase complete | ⬜ | |
| Modifications tracked | ⬜ | |

---

## Risks / Blockers

| Risk | Impact | Mitigation | Owner |
|------|--------|------------|-------|
| {{risk-1}} | | | |
