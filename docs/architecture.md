# Architecture — How Atlas Works

Atlas is built on three layers: **identity**, **state**, and **automation**.

---

## Layer 1: Identity (`CLAUDE.md`)

The root `CLAUDE.md` is read by Claude Code automatically on every session start. It defines who you are, what you're working on, your infrastructure, your agents, and how you want Claude to behave. No prompting required — the context is always loaded.

Every agent also has its own `CLAUDE.md` in `agents/[name]/`. When you invoke an agent by trigger phrase, Claude loads that context and operates within its scope.

---

## Layer 2: State (`context/`)

Three files form the persistent state layer:

### `context/state.yaml`
The canonical source of truth. Contains:
- Active focus and cert/project queue
- Infrastructure status
- Session tracking (last session #, next session #)
- Open TODOs (ID, description, date opened)

Claude reads this first at session start. When state changes, update here first.

### `context/handoff.md`
The session journal. Contains:
- Current state snapshot (tables, not prose)
- Open TODOs with dates
- Blockers and what's needed to unblock them
- Key commands

This file is NOT a history log. Old session content gets archived to `context/sessions/` and removed from here.

### `context/sessions/`
One file per session. Named `YYYY-MM-DD_S###_keyword1-keyword2.md`. Each file has YAML frontmatter and session notes. The `INDEX.md` file is a fast lookup table for all sessions.

---

## Layer 3: Automation (Hooks)

### PostToolUse Hook (`scripts/post-tool-use.sh`)
Fires after every `Write` or `Edit` tool call.

- Determines the namespace from the file path (context, agents, homelab, etc.)
- Commits with message: `auto[namespace][hostname]: filename`
- **Tier 1 files** (handoff.md, state.yaml, CLAUDE.md, sessions/, MEMORY.md) → commit + push immediately
- **Tier 2 files** (everything else) → local commit only

### Stop Hook (`scripts/stop-hook.sh`)
Fires when the Claude Code session ends.

- Stages any remaining changes
- Commits: `auto: session sync [hostname] YYYY-MM-DD HH:MM`
- Pushes to origin main
- Deletes the session lock file

### Boot Script (`scripts/boot.sh`)
Run manually or via a shell function at session start.

- Detects orphaned session lock (crash recovery) → pushes unpushed commits
- `git pull origin main` — syncs to latest
- Creates session lock file
- Prints a briefing from `context/state.yaml`

---

## Hook Configuration

Register hooks in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": {"tool_name": "Write|Edit"},
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/your-atlas/scripts/post-tool-use.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/your-atlas/scripts/stop-hook.sh"
          }
        ]
      }
    ]
  }
}
```

Replace `/path/to/your-atlas/` with the absolute path to your Atlas repo.

---

## Data Flow

```
Session Start
  └── boot.sh → git pull → read state.yaml → read handoff.md

During Session
  └── Claude edits files → post-tool-use.sh → auto-commit (+ push if Tier 1)

Session End
  └── Claude updates handoff.md + creates session file
  └── stop-hook.sh → commit remaining → push → clear lock
```

---

## Why Git as Memory

Git gives you:
- **Versioned context** — every state is recoverable
- **Multi-device sync** — pull on any machine, pick up where you left off
- **Audit trail** — commit history shows what Claude did and when
- **Conflict detection** — git catches diverged state across devices

The repo IS the brain. The commit history IS the memory.
