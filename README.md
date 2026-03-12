# Atlas

**A structured Claude Code context framework that turns a git repository into a persistent, versioned AI operating system — for individuals and teams.**

Atlas gives Claude persistent memory across sessions, a defined identity and operating rules, a multi-agent architecture, and a GitOps-backed session journal — all version-controlled in git.

---

## What Problem This Solves

Every Claude Code session starts from zero. You re-explain your stack, your goals, your preferences, your context. Atlas eliminates that by making the repository itself the brain. Clone it, fill it in, and Claude knows who you are, what you're working on, and how you think — every session.

---

## Core Concepts

### 1. Identity Layer (`CLAUDE.md`)
The root `CLAUDE.md` is your operating system. It defines:
- Who you are and what you're working on
- Your machines and infrastructure
- Your agents and what they do
- How you want Claude to behave
- Your operating rules and non-negotiables

Claude Code reads this automatically on every session start.

### 2. Persistent State (`context/`)
- `context/state.yaml` — canonical system state: focus, homelab status, open todos, active projects
- `context/handoff.md` — session journal: what was done, what's pending, current blockers
- `context/sessions/` — archived session logs with YAML frontmatter, one file per session

### 3. Agent System (`agents/`)
Named agents with scoped context. Each agent is a subdirectory with its own `CLAUDE.md` defining its purpose, tools, and trigger conditions. You can deploy multiple agents for different domains of your life or work.

### 4. Hook Architecture (`scripts/`)
Two shell hooks make the system self-managing:
- **PostToolUse hook** — auto-commits every file write/edit with a structured commit message
- **Stop hook** — commits any remaining changes and pushes to origin at session end

Every session is a snapshot. Commit history = session history. No manual saving required.

### 5. Inbox (`inbox/`)
Drop any file (screenshot, log, config, PDF) into `inbox/` and tell Claude the filename. Claude reads it directly. Files are versioned automatically.

---

## Quick Start

```bash
# 1. Fork or clone this repo
git clone https://github.com/DylanJHansen/atlas my-atlas
cd my-atlas

# 2. Run the setup wizard
./init.sh

# 3. Open Claude Code in your repo
cd my-atlas
claude
```

The setup wizard walks you through filling in `CLAUDE.md` with your identity, machines, and goals.

---

## Directory Structure

```
atlas/
├── CLAUDE.md                  # Your identity file — fill this in
├── README.md                  # This file
├── init.sh                    # Setup wizard for new users
│
├── context/
│   ├── state.yaml             # Canonical system state
│   ├── handoff.md             # Session journal — current state + open TODOs
│   ├── sessions/
│   │   └── INDEX.md           # Session archive index
│   └── systems/
│       └── registry.md        # Approved machines/devices
│
├── agents/
│   ├── AGENTS.md              # Spec: how to define an agent
│   ├── ops-agent/
│   │   └── CLAUDE.md          # Infrastructure/homelab agent template
│   ├── study-agent/
│   │   └── CLAUDE.md          # Learning/cert tracking agent template
│   └── research-agent/
│       └── CLAUDE.md          # Knowledge/reading agent template
│
├── scripts/
│   ├── post-tool-use.sh       # PostToolUse hook — auto-commit on write/edit
│   └── boot.sh                # Session start — crash recovery, state briefing
│
├── inbox/                     # Drop files here for Claude to read
│   └── .gitkeep
│
└── docs/
    ├── architecture.md        # How the hook system works
    ├── agents.md              # Agent identity system in depth
    └── session-hygiene.md     # Session start/end protocol
```

---

## Hook Setup

Atlas uses Claude Code hooks for automation. After cloning, register the hooks in your Claude settings:

**`~/.claude/settings.json`** — add these hooks:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": {"tool_name": "Write|Edit"},
        "hooks": [{"type": "command", "command": "bash ~/your-atlas-dir/scripts/post-tool-use.sh"}]
      }
    ],
    "Stop": [
      {
        "hooks": [{"type": "command", "command": "bash ~/your-atlas-dir/scripts/stop-hook.sh"}]
      }
    ]
  }
}
```

See `docs/architecture.md` for the full hook configuration.

---

## Agents

Atlas ships with three starter agents. Copy and customize:

| Agent | Purpose |
|-------|---------|
| `ops-agent` | Infrastructure, homelab, server management |
| `study-agent` | Cert tracking, course progress, learning sprints |
| `research-agent` | Reading notes, knowledge management, research threads |

To add your own agent: read `agents/AGENTS.md` for the spec.

---

## Session Protocol

**Session start (Claude does this automatically):**
1. `git pull origin main` — sync latest
2. Read `context/state.yaml` — current system state
3. Read `context/handoff.md` — open TODOs and last session context

**Session end (Claude does this automatically):**
1. Create `context/sessions/YYYY-MM-DD_S###_keywords.md` — archive this session
2. Update `context/handoff.md` — update state, add/close TODOs
3. Stop hook commits + pushes everything

See `docs/session-hygiene.md` for the full protocol.

---

## Enterprise Use

Atlas scales from personal use to team deployments:

- **Individual:** One repo per person. Your Claude knows your stack, your goals, your history.
- **Team:** Shared `context/` for team state, individual `CLAUDE.md` per engineer via branch or fork.
- **Department:** Org-level context in a shared base repo, team-level config layered on top.

The pattern: **one repo = one identity = one persistent AI context.**

---

## Philosophy

Atlas is not a chatbot wrapper. It is a context architecture — a way of making AI collaboration stateful, versioned, and intentional. The git history is the memory. The hooks are the nervous system. The agents are the roles.

You own the context. You version the context. You deploy the context.

---

## License

MIT — fork it, extend it, ship your own version.
