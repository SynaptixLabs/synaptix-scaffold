# Design Review Checklist

## Requirements Compliance
- [ ] Every requirement from spec checked (PASS/FAIL/PARTIAL)
- [ ] Evidence provided for each (file:line or test output)

## Module Reuse
- [ ] Existing modules used where applicable
- [ ] No parallel infrastructure created
- [ ] Module contracts respected

## Code Quality
- [ ] No hardcoded values (use config/settings)
- [ ] No bare except clauses
- [ ] Type hints on public functions
- [ ] No TODO/FIXME left unresolved
- [ ] No commented-out code blocks
- [ ] No secrets in code

## Testing
- [ ] New code has tests
- [ ] All tests pass
- [ ] No regressions

## Documentation
- [ ] README updated if behavior changed
- [ ] AGENTS.md updated if contracts changed
- [ ] Module registry updated if capabilities changed
