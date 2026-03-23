#!/usr/bin/env python3
"""Re-inject session state after context compaction.

This hook runs on SessionStart when compaction is detected.
It reads .claude/state/session-state.md and prints it so Claude
picks up where it left off.
"""

import subprocess
import sys
from pathlib import Path


def main():
    root = Path(__file__).resolve().parent.parent.parent
    state_file = root / ".claude" / "state" / "session-state.md"

    # Git context
    try:
        branch = subprocess.check_output(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            cwd=root, text=True, stderr=subprocess.DEVNULL,
        ).strip()
    except Exception:
        branch = "unknown"

    try:
        sha = subprocess.check_output(
            ["git", "rev-parse", "--short", "HEAD"],
            cwd=root, text=True, stderr=subprocess.DEVNULL,
        ).strip()
    except Exception:
        sha = "unknown"

    try:
        status = subprocess.check_output(
            ["git", "status", "--short"],
            cwd=root, text=True, stderr=subprocess.DEVNULL,
        ).strip()
    except Exception:
        status = ""

    print(f"## Session State Recovery (post-compaction)")
    print(f"- **Branch:** {branch}")
    print(f"- **Commit:** {sha}")
    if status:
        recent = "\n".join(status.splitlines()[:15])
        print(f"- **Modified files:**\n```\n{recent}\n```")

    # Session state file
    if state_file.exists():
        content = state_file.read_text(encoding="utf-8")
        lines = content.splitlines()
        capped = "\n".join(lines[:120])
        print(f"\n---\n## Preserved Session State\n{capped}")
    else:
        print("\nNo session-state.md found. Start fresh or run /sync-state.")

    print("\n---")
    print("**Guidance:** Preserve the above context. Pick up where you left off.")
    print("If session-state.md lists active files, blockers, or next actions — honor them.")


if __name__ == "__main__":
    main()
