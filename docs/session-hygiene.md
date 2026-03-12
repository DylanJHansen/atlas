# Session Hygiene — Protocol Reference

Atlas sessions follow a consistent start and end protocol. Claude executes this automatically when the pattern is established. This document defines the protocol so you can verify Claude is following it and onboard others.

---

## Session Start Protocol

Claude does these steps at the beginning of every session — without being asked:

1. **`git pull origin main`** — sync to latest before any work
2. **Read `context/state.yaml`** — get the canonical system state: focus, homelab status, open todos, last session
3. **Read `context/handoff.md`** — get the detailed current state and open TODOs

If `context/state.yaml` doesn't exist yet: prompt to run `init.sh` or fill in manually.

---

## Session End Protocol

Claude does these steps at the end of every session — without being asked:

1. **Create session archive file** — `context/sessions/YYYY-MM-DD_S###_keywords.md`
2. **Update `context/handoff.md`** — update state table, add/close TODOs
3. **Update `context/state.yaml`** — update `sessions.last_session`, `sessions.next_session_number`, `sessions.last_updated`
4. Stop hook commits + pushes everything automatically

Missing the session end = context drift next session. Don't skip it.

---

## Session File Format

File name: `YYYY-MM-DD_S###_keyword1-keyword2-keyword3.md`
- Max 5 keywords, dash-separated, lowercase
- Session number is sequential across all time — check `INDEX.md` for last number used

```yaml
---
date: 2024-01-15
session: S001
keywords: [setup, init, first-session]
components: [atlas, context, agents]
summary: Initial Atlas setup — filled in CLAUDE.md, configured hooks, deployed first agents
status: archived
---

## What Was Done
- [bullet list of major actions]

## Decisions Made
- [any decisions that should be remembered]

## Open Questions
- [anything unresolved]
```

---

## handoff.md Protocol

`context/handoff.md` is a **current state snapshot**, not a history log.

- Remove completed items — they go to the session archive file
- Keep the file short and scannable
- Every TODO entry needs an `opened:` date
- Update the state table to reflect actual current state

When it gets long, it means you haven't been closing items. Review and archive.

---

## state.yaml Protocol

`context/state.yaml` is the **canonical single source of truth**.

- Update here first, then let other files reflect it
- `sessions.last_session` and `sessions.next_session_number` update every session
- `focus.primary` updates when your primary goal changes
- `homelab.status` updates after every health check

---

## Multi-Device Protocol

When switching machines:

1. Before leaving current machine: ensure Stop hook has pushed (`git log origin/main..HEAD` should be empty)
2. On new machine: `git pull origin main` before any work
3. Update `identity.machine` in `context/state.yaml` to the new machine name
4. Ensure new machine is in `context/systems/registry.md`

---

## Crash Recovery

If a session crashes without the Stop hook running:

1. Boot script detects the session lock file
2. Checks for unpushed commits
3. Pushes them automatically
4. Clears the lock

If boot.sh is not configured, run manually:
```bash
cd /path/to/your-atlas
git log origin/main..HEAD --oneline  # see what's unpushed
git push origin main                 # push manually
```
