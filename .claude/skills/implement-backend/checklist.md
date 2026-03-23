# Backend Implementation Checklist

## Pre-Implementation
- [ ] Read MUST_READ_MODULE_REUSE.md
- [ ] Read assigned TODO with acceptance criteria
- [ ] Check module contracts (docs/03_MODULES.md)
- [ ] Identify reusable modules

## Implementation
- [ ] Tests written FIRST (TDD)
- [ ] Module reuse verified (no parallel infrastructure)
- [ ] Config via settings (no hardcoded values)
- [ ] Error handling with specific exceptions
- [ ] Type hints on public functions
- [ ] Logging via logger (no print statements)

## Post-Implementation
- [ ] All unit tests pass
- [ ] Server starts and endpoints work
- [ ] No regressions on existing tests
- [ ] README updated if needed
- [ ] Commit with descriptive message
