# Skill: Implement Backend

> Execute an assigned backend TODO with module-reuse checks, explicit planning, test discipline, and clean handoff.

## Trigger

Activated by `/project:dev-backend` with a specific TODO assignment.

## Process

1. **Read** — MUST_READ_MODULE_REUSE.md + module contracts + assigned TODO
2. **Plan** — Impact assessment: which files change, which modules touched, which tests needed
3. **Reuse** — Check existing modules before writing new code
4. **Implement** — Minimal changes, follow module patterns
5. **Test** — Write tests FIRST (TDD), then implement. Run full suite.
6. **Verify** — Run the server, hit the endpoint, check the output
7. **Handoff** — Update session state, commit with descriptive message

## Output

- Implementation code + tests
- Updated README/AGENTS.md if contracts changed
- Clean test run output
