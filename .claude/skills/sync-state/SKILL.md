# Skill: Sync State

> Refresh `.claude/state/session-state.md` for multi-window work and handoffs.

## When to Use

- Before switching to a different Claude Code window
- After a complex sequence of changes
- Before handing off to a teammate agent
- After context compaction

## Required Structure

The session state file MUST contain:

1. **Snapshot** — Last updated timestamp, window ID, focus area
2. **Current Delivery Context** — Sprint, branch, service, environment
3. **Active Files** — What was changed and why
4. **Blockers/Risks** — Anything blocking progress
5. **Next 3 Actions** — Concrete next steps
6. **Exact Commands** — Verification/test commands to run
7. **Handoff Notes** — Anything the next session needs to know

## Process

1. Read current git state (branch, status, recent commits)
2. Read active TODO or spec
3. Compose session-state.md with all required sections
4. Write to `.claude/state/session-state.md`

## Output

Updated `.claude/state/session-state.md` — survives compaction via the reinject hook.
