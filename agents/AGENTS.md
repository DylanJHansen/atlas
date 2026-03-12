# AGENTS.md — Agent Identity Specification

Atlas supports multiple named agents. Each agent is a scoped Claude context — a role with its own purpose, tools, and behavior rules.

---

## What Is an Agent?

An agent is a subdirectory under `agents/` with its own `CLAUDE.md`. When you tell Claude to load a specific agent context, it reads that file and operates within that scope.

Agents are not separate processes or separate models. They are **context boundaries** — ways of telling Claude "in this mode, you are X, focused on Y, using Z tools."

---

## Agent Directory Structure

```
agents/
└── [agent-name]/
    ├── CLAUDE.md        # Required — agent identity, purpose, tools, rules
    └── context/         # Optional — agent-specific state files
        ├── state.yaml
        └── handoff.md
```

---

## CLAUDE.md Spec for Agents

Every agent `CLAUDE.md` should define:

```markdown
# [Agent Name] — Agent Context

## Identity
**Name:** [Agent name]
**Role:** [One line — what this agent does]
**Trigger:** [How you invoke it — a phrase, a topic, a file type]
**Scope:** [What this agent handles — and what it does NOT handle]

## Purpose
[2-4 sentences on what problem this agent solves and why it exists as a separate context]

## Tools & Capabilities
- [tool or capability 1]
- [tool or capability 2]

## Operating Rules
- [rule specific to this agent]
- [what it should always do]
- [what it should never do]

## Context Files
- [path to any state files this agent reads]
- [path to any handoff or journal files]

## Handoff to Root
[When this agent should hand back to the root Jarvis context — e.g. "when the task touches infrastructure outside my scope"]
```

---

## Starter Agents

Three agents ship with Atlas. Copy and customize:

| Agent | Directory | Default Trigger | Purpose |
|-------|-----------|----------------|---------|
| Ops Agent | `agents/ops-agent/` | infrastructure, server, homelab | System administration, infra management |
| Study Agent | `agents/study-agent/` | studying, cert, course, learning | Cert tracking, study sprints, progress |
| Research Agent | `agents/research-agent/` | research, reading, notes | Knowledge management, deep research |

---

## Adding a New Agent

1. Create `agents/[your-agent-name]/`
2. Copy `agents/ops-agent/CLAUDE.md` as a starting point
3. Fill in Identity, Purpose, Tools, Rules
4. Add the agent to the Agents table in your root `CLAUDE.md`
5. Tell Claude the trigger phrase so it knows when to load the context

---

## Scope Boundaries

Agents are most useful when they have clear boundaries. Ask:
- What does this agent handle exclusively?
- When should it hand back to root context?
- Does it have its own state files, or does it share root state?

Clear boundaries prevent agents from stepping on each other.
