# MUST READ: Module Reuse Protocol

> **Read this BEFORE writing ANY code.** This is the #1 quality gate for {{PROJECT_NAME}}.
>
> Last updated: {{DATE}}

---

## Why This Exists

Module duplication is the #1 source of bugs, drift, and maintenance burden in multi-module projects. This document prevents it.

**The cost of checking is ~2 minutes. The cost of duplicating is hours of debugging and drift.**

---

## The 4 Rules

### Rule 1: CHECK BEFORE YOU BUILD

Before writing ANY new infrastructure, utility, or service:

1. Read `docs/03_MODULES.md` — the capability registry
2. Search existing modules for similar functionality
3. **USE** if it exists → import and call it
4. **EXTEND** if it's close → add to the existing module
5. **BUILD** only if nothing fits → and register it immediately

### Rule 2: Mandatory Module Usage

| Need | Module | Import |
|------|--------|--------|
| {{NEED_1}} | {{MODULE_1}} | `from {{IMPORT_1}}` |
| {{NEED_2}} | {{MODULE_2}} | `from {{IMPORT_2}}` |
| {{NEED_3}} | {{MODULE_3}} | `from {{IMPORT_3}}` |
| Database access | {{DB_MODULE}} | `from {{DB_IMPORT}}` |
| Configuration | {{CONFIG_MODULE}} | `from {{CONFIG_IMPORT}}` |
| Logging | {{LOG_MODULE}} | `from {{LOG_IMPORT}}` |

> **Fill this table during Sprint-0.** Every module's public API goes here.
> This is the SINGLE SOURCE OF TRUTH for "what exists."

### Rule 3: New Modules Must Register

When you create a new module:

1. Create `README.md` in the module root (what it does, public API, dependencies)
2. Create `AGENTS.md` (Tier-3) in the module root
3. Add an entry to `docs/03_MODULES.md`
4. Update this file's import table (Rule 2)

### Rule 4: Every Module Has a README

**No README = module doesn't exist** (as far as reuse is concerned).

Minimum README contents:
- What the module does (1-2 sentences)
- Public API (exported classes/functions)
- Dependencies (what it imports from other modules)
- How to test it

---

## How to Check (2-Minute Protocol)

```bash
# 1. Search for existing functionality
grep -rn "your_keyword" --include="*.py" backend/modules/
grep -rn "your_keyword" --include="*.ts" frontend/

# 2. Check the module registry
cat docs/03_MODULES.md

# 3. Check the nearest AGENTS.md
cat backend/modules/<module>/AGENTS.md
```

---

## Violation Examples

These are REAL anti-patterns found in production codebases:

| Violation | What Happened | Correct Approach |
|-----------|--------------|-----------------|
| Manual cost tracking | Developer wrote custom cost dicts instead of using the resource manager | Import and use the existing cost tracking module |
| Direct vendor SDK calls | Developer imported vendor SDK directly instead of using the LLM abstraction | Use the LLM core module's provider factory |
| Hardcoded model strings | Developer wrote `"claude-3-sonnet"` instead of using the model router | Use the model router for dynamic selection |
| Custom event JSON | Developer created ad-hoc event dicts instead of using the event system | Use the event/memory module's write controller |
| No version tag | Outputs had no provenance — couldn't trace which code version produced them | Include LOGIC_VERSION in all manifests/outputs |
| Secrets in logs | PII and API keys appeared in log output | Use the redaction utility before logging |

---

## In Design Reviews

Every GBU review MUST include a **Module Reuse Checklist**:

| Check | Result | Evidence |
|-------|--------|----------|
| Existing modules used where applicable | PASS/FAIL | [where] |
| No parallel infrastructure created | PASS/FAIL | [where] |
| Config via settings (not hardcoded) | PASS/FAIL | [where] |
| No direct vendor SDK imports in pipeline | PASS/FAIL | [where] |
| Module contracts respected | PASS/FAIL | [where] |

---

## In Sprint Planning

Every sprint kickoff reading order MUST include this file as **Item #0**.

```
Reading Order:
0. MUST_READ_MODULE_REUSE.md  <-- YOU ARE HERE
1. AGENTS.md
2. Current sprint index
3. Assigned TODO
4. Relevant module README + AGENTS.md
```

---

## Quick Reference: Module Boundaries

```
Module A <--> Module B    NEVER import directly
Module A --> shared/      Use shared utilities
Module A --> db_core      Use shared DB module
Module A --> config       Use shared config
```

**Modules are independent "Lego Blocks."** They communicate through:
- Well-defined interfaces (documented in `docs/03_MODULES.md`)
- Shared infrastructure modules (db, config, logging)
- API layer orchestration (not direct module-to-module imports)

---

*This document is referenced by CLAUDE.md, AGENTS.md, and every sprint kickoff.*
*If you find it missing from a reading order — that's a bug. Fix it.*
