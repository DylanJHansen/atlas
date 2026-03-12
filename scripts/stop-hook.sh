#!/bin/bash
# stop-hook.sh — Atlas Stop Hook
# Fires at the end of every Claude Code session.
# Commits any remaining changes and pushes to origin main.
# Deletes the session lock file.

set -e

REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null)"
LOCK_FILE="$HOME/.atlas.session.lock"
HOSTNAME_SHORT="$(hostname | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"

if [ -z "$REPO_ROOT" ]; then
  exit 0
fi

cd "$REPO_ROOT"

# ── Stage and commit any remaining changes ───────────────────────────────────
if ! git diff --quiet || ! git diff --staged --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  git add -A
  git commit -m "auto: session sync [$HOSTNAME_SHORT] $TIMESTAMP" || true
fi

# ── Push to remote ───────────────────────────────────────────────────────────
git push origin main 2>/dev/null || echo "[stop-hook] Push failed — changes committed locally, push manually."

# ── Clean up session lock ─────────────────────────────────────────────────────
rm -f "$LOCK_FILE"

echo "[atlas] Session committed and pushed. Lock cleared."
