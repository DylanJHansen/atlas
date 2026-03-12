#!/bin/bash
# post-tool-use.sh — Atlas PostToolUse Hook
# Fires on every Write/Edit tool call.
# Auto-commits changed files with a structured commit message.
# Tier 1 files (handoff.md, state.yaml, CLAUDE.md, sessions/, MEMORY.md) → commit + push immediately
# Tier 2 (everything else) → local commit only, Stop hook pushes at session end

set -e

# ── Config ──────────────────────────────────────────────────────────────────
REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
  exit 0  # Not in a git repo, do nothing
fi

HOSTNAME_SHORT="$(hostname | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]')"

# ── Detect changed file ──────────────────────────────────────────────────────
# The changed file path is passed via CLAUDE_TOOL_INPUT_FILE_PATH env var
# Fall back to git status if not set
CHANGED_FILE="${CLAUDE_TOOL_INPUT_FILE_PATH:-}"

if [ -z "$CHANGED_FILE" ]; then
  # Fall back: find recently modified tracked or untracked files
  CHANGED_FILE="$(git -C "$REPO_ROOT" status --porcelain | head -1 | awk '{print $2}')"
fi

if [ -z "$CHANGED_FILE" ]; then
  exit 0  # Nothing to commit
fi

BASENAME="$(basename "$CHANGED_FILE")"

# ── Determine namespace from file path ──────────────────────────────────────
REL_PATH="${CHANGED_FILE#$REPO_ROOT/}"
NAMESPACE="misc"
if [[ "$REL_PATH" == context/sessions/* ]]; then
  NAMESPACE="sessions"
elif [[ "$REL_PATH" == context/* ]]; then
  NAMESPACE="context"
elif [[ "$REL_PATH" == agents/* ]]; then
  NAMESPACE="agents"
elif [[ "$REL_PATH" == scripts/* ]]; then
  NAMESPACE="scripts"
elif [[ "$REL_PATH" == homelab/* ]] || [[ "$REL_PATH" == gitops/* ]]; then
  NAMESPACE="homelab"
elif [[ "$BASENAME" == "CLAUDE.md" ]]; then
  NAMESPACE="identity"
fi

# ── Stage and commit ─────────────────────────────────────────────────────────
cd "$REPO_ROOT"

git add "$CHANGED_FILE" 2>/dev/null || git add -A

COMMIT_MSG="auto[$NAMESPACE][$HOSTNAME_SHORT]: $BASENAME"
git commit -m "$COMMIT_MSG" --allow-empty-message 2>/dev/null || true

# ── Tier 1: push immediately ─────────────────────────────────────────────────
TIER1_FILES=("handoff.md" "state.yaml" "CLAUDE.md" "wins.md" "MEMORY.md" "INDEX.md")
PUSH_NOW=false

for f in "${TIER1_FILES[@]}"; do
  if [[ "$BASENAME" == "$f" ]]; then
    PUSH_NOW=true
    break
  fi
done

if [[ "$REL_PATH" == context/sessions/* ]]; then
  PUSH_NOW=true
fi

if $PUSH_NOW; then
  git push origin main 2>/dev/null || true
fi
