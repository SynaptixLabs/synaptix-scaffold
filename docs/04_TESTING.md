# {{PROJECT_NAME}} — Testing

Testing is part of the product. If it’s not tested, it’s not done.

This doc defines:
- Test types and where they live
- Coverage expectations (by domain)
- Regression policy (every bug gets a test)
- How to run tests locally and in CI

---

## Testing pyramid (default)

1. **Unit** tests (fast, deterministic)
2. **Integration** tests (real dependencies where possible)
3. **E2E** tests (critical flows only)
4. **Regression** tests (golden sets / bug repros)

---

## Coverage & gates (by domain)

> Use these as defaults. If a project deviates, record the decision in `0l_DECISIONS.md`.

| Domain | Primary gate | Coverage target (meaningful code) | Notes |
|---|---|---:|---|
| BE | Unit + integration must pass | ≥90% | Focus on business logic, validators, adapters |
| FE | Unit/component + key flow tests | “Meaningful coverage” | Don’t chase vanity %; cover critical paths |
| ML | Reproducibility + eval gates + regression | ≥90% (transforms/validators) | Golden sets + baseline comparison required |
| SHARED | Unit + contract compatibility | ≥90% | Backward compatible APIs unless approved |

---

## Test types

### Unit tests

- What: pure functions, validators, feature builders, UI components
- Where: `**/tests/unit/`

#### Example (pytest)

```python
def test_parse_amount():
    assert parse_amount("₪12.30") == 12.30
```

### Integration tests

- What: service + DB, API + dependency, pipeline end-to-end
- Where: `**/tests/integration/`
- Prefer real infra via containers when feasible.

#### Example (FastAPI + TestClient)

```python
def test_health_endpoint(client):
    r = client.get("/health")
    assert r.status_code == 200
```

### E2E tests

- What: critical user flows across modules
- Where: `tests/e2e/` (shared suite)
- Keep small and stable.

#### Example (Playwright)

```ts
test("login flow", async ({ page }) => {
  await page.goto("/");
  // ...
});
```

### Regression tests (mandatory for bug fixes)

- Every bug fix must add a test that would fail before the fix.
- Keep a **golden set** where it makes sense (ML and critical data transforms).

---

## Mocks, fixtures, and global stubs

- Prefer **SynaptixLabs testing/mocks** when available (don’t build competing test harnesses).
- Shared fixtures should live under: `shared/testing/` (or equivalent).
- Module-specific fixtures go under the module test tree.

---

## How to run tests (examples)

> Replace with project-specific commands.

```bash
# Unit + integration (Python)
pytest -q

# Frontend
pnpm test

# E2E
pnpm test:e2e
```

---

## CLI/TUI Testing Requirements

### Async Subprocess Pattern (CRITICAL for CLI/TUI work)

Any external process invocation in a TUI or CLI tool **MUST** follow this pattern:

1. **Use async subprocess** — never blocking `subprocess.run()` in TUI contexts
2. **Implement cancellation** — user must be able to cancel long-running operations
3. **Stream output** — don't buffer entire output; stream line-by-line
4. **Test responsiveness** — UI must remain responsive during subprocess execution

#### Required Pattern (Python)

```python
import asyncio
from asyncio.subprocess import PIPE

async def run_external_command(cmd: list[str], timeout: float = 30.0):
    """
    Run external command with proper async handling.

    - Streams output
    - Supports cancellation
    - Has timeout protection
    """
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=PIPE,
        stderr=PIPE,
    )

    try:
        stdout, stderr = await asyncio.wait_for(
            proc.communicate(),
            timeout=timeout
        )
        return proc.returncode, stdout.decode(), stderr.decode()
    except asyncio.TimeoutError:
        proc.kill()
        await proc.wait()
        raise
    except asyncio.CancelledError:
        proc.kill()
        await proc.wait()
        raise
```

#### Required Tests for CLI/TUI

| Test Type | What to Test | Example |
|-----------|--------------|---------|
| Responsiveness | UI remains interactive during long ops | Key events processed within 100ms |
| Cancellation | User can cancel running operations | Ctrl+C terminates subprocess cleanly |
| Timeout | Long operations don't hang forever | 30s timeout with graceful failure |
| Streaming | Output appears progressively | Lines appear as generated, not all at once |
| Error handling | Subprocess failures don't crash TUI | Non-zero exit shows error, doesn't crash |

#### Anti-Patterns (DO NOT USE)

```python
# ❌ WRONG: Blocks entire event loop
result = subprocess.run(["slow_command"], capture_output=True)

# ❌ WRONG: No timeout protection
await asyncio.create_subprocess_exec(*cmd)  # hangs forever if command hangs

# ❌ WRONG: Buffering entire output
output = await proc.stdout.read()  # OOM risk on large output
```

---

## E2E Testing Protocols (Cross-Project — Mandatory)

> **Source:** Papyrus Sprint 10 DR — Wide/Narrow Layout Bug (P1, 5 failed rounds).
> **Applies to:** All E2E tests across ALL SynaptixLabs projects.
> **Why:** A P1 layout bug survived 4 fix rounds and passed all E2E tests at every round because tests validated at ONE viewport width while the bug existed at narrower widths.

### Protocol 1: Diagnostic-First for Layout/CSS Bugs

**BEFORE writing any CSS/layout fix**, measure actual dimensions:

```
Step 1: Navigate to the affected page on the user's dev server
Step 2: Measure actual element dimensions:
        document.querySelector('.target-element').offsetWidth
        document.querySelector('.parent-container').offsetWidth
        window.innerWidth
Step 3: Compute the CSS math at the user's ACTUAL width
        (substitute measured values into calc()/min()/max() expressions)
Step 4: Take a screenshot for baseline comparison
Step 5: ONLY THEN write the fix
Step 6: Re-measure after fix to verify the output actually changed
```

**Why:** The single most impactful diagnostic action — measuring `el.offsetWidth` — was never done in the first 4 rounds. This single number would have immediately revealed why every fix failed.

**Tools:** Use Playwright MCP `browser_evaluate` or ask the user to run JS in DevTools.

### Protocol 2: Multi-Viewport E2E for Layout Tests

Layout E2E tests MUST assert at multiple viewport widths. A test that passes at 1280px but fails at 1024px is a **false safety net**.

**Minimum viewport matrix:**

| Width | Represents |
|-------|-----------|
| 1024px | Small laptop / tablet landscape |
| 1280px | Standard laptop (Playwright default) |
| 1920px | Full HD desktop |

**Core assertion for toggle/mode features:** Always assert a minimum pixel difference (e.g., `widthDifference >= 50`), not just "A > B" (which passes at 1px difference).

### Protocol 3: No Fixed-Pixel Layout Constraints

**Rule:** Never use fixed-pixel values as the sole constraint for responsive features.

| BAD — breaks at narrow viewports | GOOD — works at any width |
|---|---|
| `max-width: 780px` | `width: min(780px, 75%)` |
| `calc(50% - 390px)` | `width: 75%` |
| `padding: max(48px, calc(50% - 390px))` | `width` + `mx-auto` |

**Why:** `max-width: Xpx` has **zero effect** when the parent container is already ≤X pixels wide.

### Protocol 4: Scripted E2E vs Interactive MCP Diagnostics

| | Scripted E2E (Playwright) | Interactive MCP (`browser_*`) |
|---|---|---|
| **Purpose** | Repeatable regression suite | Ad-hoc diagnostic investigation |
| **When** | CI pipeline, pre-merge gates | During bug investigation, before writing fix |
| **Viewport** | Fixed (per config) | Match user's actual setup |
| **What it catches** | Regressions from known-good state | Root cause of reported visual bugs |

**Key insight:** Scripted E2E validates "does the code still work?" but NOT "does this fix solve the user's problem?" For the latter, use interactive MCP diagnostics against the user's live dev server.

### Layout Bug Fix Checklist

Before declaring any layout/CSS fix complete:

- [ ] Measured actual element width on user's viewport (not just Playwright's default)
- [ ] CSS math verified at 3+ viewport widths (1024, 1280, 1920)
- [ ] Used percentage-based or `min()`/`max()` constraints (no fixed-pixel-only)
- [ ] E2E asserts minimum pixel difference (not just "A > B")
- [ ] User confirmed visual change on their machine
- [ ] No secondary regressions (toolbar overlap, scroll issues, button interception)
