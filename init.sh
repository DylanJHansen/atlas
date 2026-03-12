#!/bin/bash
# init.sh — Atlas Setup Wizard
# Run once after cloning. Walks you through filling in your CLAUDE.md and context files.
# Re-run at any time to update your configuration.

set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_MD="$REPO_ROOT/CLAUDE.md"
STATE_YAML="$REPO_ROOT/context/state.yaml"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║           Atlas Setup Wizard             ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "This wizard will walk you through the initial setup."
echo "You can re-run it at any time to update your config."
echo ""

# ── Helper ───────────────────────────────────────────────────────────────────
prompt() {
  local label="$1"
  local default="$2"
  local result
  if [ -n "$default" ]; then
    read -rp "  $label [$default]: " result
    echo "${result:-$default}"
  else
    read -rp "  $label: " result
    echo "$result"
  fi
}

echo "── Step 1: Identity ─────────────────────────────────────────────"
NAME=$(prompt "Your full name")
MACHINE=$(prompt "Primary machine name (e.g. workstation, laptop, homelab)" "my-machine")
GITHUB=$(prompt "GitHub username")
JOB=$(prompt "Your job title or role")

echo ""
echo "── Step 2: Current Focus ────────────────────────────────────────"
FOCUS=$(prompt "What are you primarily focused on right now?")

echo ""
echo "── Step 3: Git Remote ───────────────────────────────────────────"
echo "  Atlas needs a git remote to sync sessions across devices."
REMOTE=$(prompt "Remote URL (e.g. git@github.com:yourname/your-atlas.git)" "")

echo ""
echo "── Step 4: Hook Setup ───────────────────────────────────────────"
echo "  Atlas uses Claude Code hooks for auto-commit and session sync."
echo "  Hooks need to be registered in ~/.claude/settings.json."
echo ""
echo "  Add the following to your ~/.claude/settings.json:"
echo ""
cat <<EOF
  {
    "hooks": {
      "PostToolUse": [
        {
          "matcher": {"tool_name": "Write|Edit"},
          "hooks": [{"type": "command", "command": "bash $REPO_ROOT/scripts/post-tool-use.sh"}]
        }
      ],
      "Stop": [
        {
          "hooks": [{"type": "command", "command": "bash $REPO_ROOT/scripts/stop-hook.sh"}]
        }
      ]
    }
  }
EOF
echo ""
read -rp "  Press Enter to continue once you've reviewed the hook config..."

# ── Write initial state.yaml ──────────────────────────────────────────────────
echo ""
echo "── Writing context/state.yaml ───────────────────────────────────"
DATE="$(date '+%Y-%m-%d')"
MACHINE_LOWER="$(echo "$MACHINE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

cat > "$STATE_YAML" <<YAML
# context/state.yaml — Canonical System State
# Last updated: $DATE | Device: $MACHINE_LOWER

identity:
  name: "$NAME"
  system: "atlas"
  version: "1.0.0"
  machine: "$MACHINE_LOWER"

focus:
  primary: "$FOCUS"
  queue: []

sessions:
  last_session: S000
  next_session_number: 1
  last_device: "$MACHINE_LOWER"
  last_updated: "$DATE"

devices:
  last_active: "$MACHINE_LOWER"
  registered:
    - "$MACHINE_LOWER"

projects:
  active: []
  parked: []

open_todos: []
YAML

echo "  Written: context/state.yaml"

# ── Git remote ────────────────────────────────────────────────────────────────
if [ -n "$REMOTE" ]; then
  echo ""
  echo "── Configuring git remote ───────────────────────────────────────"
  cd "$REPO_ROOT"
  if git remote get-url origin &>/dev/null; then
    git remote set-url origin "$REMOTE"
    echo "  Updated remote: origin → $REMOTE"
  else
    git remote add origin "$REMOTE"
    echo "  Added remote: origin → $REMOTE"
  fi
fi

# ── Make scripts executable ───────────────────────────────────────────────────
chmod +x "$REPO_ROOT/scripts/"*.sh
echo ""
echo "  Scripts marked executable."

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║              Setup Complete              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "  Next steps:"
echo "  1. Open CLAUDE.md and fill in all placeholder sections"
echo "  2. Register your hooks in ~/.claude/settings.json (shown above)"
echo "  3. Run: git add -A && git commit -m 'init: atlas setup' && git push origin main"
echo "  4. Open Claude Code in this directory: claude"
echo ""
echo "  Read docs/architecture.md and docs/session-hygiene.md to understand how it works."
echo ""
