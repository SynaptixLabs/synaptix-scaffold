# QA Gate Checklist

## Test Verification
- [ ] Dev wrote unit tests for new logic
- [ ] Dev wrote E2E tests for user-facing changes
- [ ] Coverage meets threshold (≥80% logic, ≥60% infra)

## Test Execution
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] No regressions on full suite

## Additional Validation
- [ ] Edge cases tested
- [ ] Error paths verified
- [ ] Performance acceptable
- [ ] Security checks passed (no secrets, proper auth)

## Verdict
- [ ] PASS — all gates green
- [ ] FAIL — list blocking issues
