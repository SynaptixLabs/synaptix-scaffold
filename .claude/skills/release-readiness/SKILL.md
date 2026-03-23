# Skill: Release Readiness

> Pre-production release checklist. Ensures code, security, infra, docs, and demo readiness.

## Trigger

Invoked via `/project:release-gate` before production deployment or public demo.

## Process

1. Run full test suite (unit + E2E)
2. Security scan (no hardcoded secrets, dependency audit)
3. Infrastructure check (env vars, health endpoints)
4. Documentation check (README, API docs, deployment guide)
5. Demo readiness (all user flows work end-to-end)
6. Produce GO/NO-GO recommendation

## Output

Release readiness report with explicit blockers and GO/NO-GO verdict.
