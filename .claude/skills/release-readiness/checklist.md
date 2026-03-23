# Release Readiness Checklist

## Code Quality
- [ ] All tests pass (unit + integration + E2E)
- [ ] Type check clean
- [ ] No TODO/FIXME in shipped code
- [ ] No debug/console.log statements

## Security
- [ ] No hardcoded secrets or API keys
- [ ] Dependency audit clean (no critical CVEs)
- [ ] Auth endpoints tested
- [ ] Environment variables documented

## Infrastructure
- [ ] Health check endpoint works
- [ ] Environment variables set for target env
- [ ] Database migrations applied
- [ ] Rollback procedure documented

## Documentation
- [ ] README up to date
- [ ] API documentation current
- [ ] Deployment guide reviewed
- [ ] CHANGELOG updated

## Demo Readiness
- [ ] All critical user flows verified
- [ ] Performance acceptable
- [ ] No visual regressions

## Verdict
- [ ] GO — all green, deploy approved
- [ ] NO-GO — blockers listed above
