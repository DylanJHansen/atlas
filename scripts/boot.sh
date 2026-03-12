#!/bin/bash
# boot.sh — Atlas Session Start Script
# Run at the start of every Claude Code session.
# Handles crash recovery, syncs with remote, and prints a session briefing.

set -e

REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null)"
LOCK_FILE="$HOME/.atlas.session.lock"
HOSTNAME_SHORT="$(hostname | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]')"

echo "── Atlas Boot ──────────────────────────────────────────────────"
echo "  Machine : $HOSTNAME_SHORT"
echo "  Repo    : $REPO_ROOT"
echo "  Date    : $(date '+%Y-%m-%d %H:%M')"
echo "────────────────────────────────────────────────────────────────"

# ── Crash recovery ───────────────────────────────────────────────────────────
if [ -f "$LOCK_FILE" ]; then
  echo ""
  echo "  [!] Session lock found — previous session may have crashed."
  echo "      Checking for unpushed commits..."

  cd "$REPO_ROOT"
  UNPUSHED=$(git log origin/main..HEAD --oneline 2>/dev/null | wc -l)

  if [ "$UNPUSHED" -gt 0 ]; then
    echo "      Found $UNPUSHED unpushed commit(s). Pushing now..."
    git push origin main && echo "      Push complete." || echo "      Push failed — check network."
  else
    echo "      No unpushed commits. Clean state."
  fi

  rm -f "$LOCK_FILE"
fi

# ── Sync with remote ─────────────────────────────────────────────────────────
echo ""
echo "  Syncing with remote..."
cd "$REPO_ROOT"
git pull origin main --rebase 2>/dev/null && echo "  Up to date." || echo "  [!] Pull failed — working offline."

# ── Session lock ─────────────────────────────────────────────────────────────
touch "$LOCK_FILE"

# ── State briefing ───────────────────────────────────────────────────────────
echo ""
echo "  Reading state.yaml..."
if [ -f "$REPO_ROOT/context/state.yaml" ]; then
  grep -E "^\s*(primary|last_session|last_updated|status):" "$REPO_ROOT/context/state.yaml" | sed 's/^/  /'
fi

echo ""
echo "  Atlas session started. Read context/state.yaml and context/handoff.md."
echo "────────────────────────────────────────────────────────────────"
