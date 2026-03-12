# Agents — Identity System Reference

Atlas supports multiple named agents. This document explains the agent system in depth.

---

## What Agents Are (and Aren't)

Agents in Atlas are **context boundaries** — not separate processes, not separate model instances.

Each agent is a scoped `CLAUDE.md` that tells Claude: "in this domain, you are [name], focused on [scope], with these rules." When you trigger an agent, Claude loads that context file and operates within it.

Think of it like roles on a team:
- The **Ops Agent** is your infrastructure engineer — it knows your servers, your services, your runbooks
- The **Study Agent** is your tutor — it knows your cert queue, your progress, your learning style
- The **Research Agent** is your analyst — it goes deep on topics and captures what it finds

Each role has a defined scope and knows when to hand back to the root context.

---

## Agent vs Root Context

The root `CLAUDE.md` is the **Jarvis layer** — it knows everything about you. Agents are **specialized lenses** on top of that.

When in doubt: root context handles anything that doesn't clearly belong to an agent. Agents handle focused, repeatable work within a defined domain.

---

## Creating an Agent

See `agents/AGENTS.md` for the full spec. Short version:

1. Create `agents/[your-agent-name]/`
2. Copy an existing agent CLAUDE.md as a template
3. Fill in: Identity, Purpose, Tools, Operating Rules, Context Files, Handoff to Root
4. Add the agent to the Agents table in your root `CLAUDE.md`
5. Define a trigger — a phrase or context that tells Claude to load this agent

---

## Invoking an Agent

Two ways:

**Explicit:** "Load the ops agent" / "Switch to study mode" / "Research agent: look into [topic]"

**Implicit:** Claude recognizes the trigger context and loads the appropriate agent automatically. This requires that your root `CLAUDE.md` has a clear Agents table with trigger phrases.

---

## Agent State Files (Optional)

Agents can have their own state files under `agents/[name]/context/`:
- `state.yaml` — agent-specific state (e.g. study progress, active infra incidents)
- `handoff.md` — agent-specific journal

Use these when an agent's state is complex enough that it would clutter the root state files. For simple agents, just track state in the root `context/` files.

---

## Scope Discipline

The most important agent design rule: **keep scope tight**.

A good agent has a clear answer to:
- What does it handle exclusively?
- What does it explicitly NOT handle?
- When does it hand back to root?

Agents that try to do everything are just a second root context — useless. The value is in specialization.

---

## Example Agent Configurations

**Infrastructure-heavy user:**
- `ops-agent` — servers, K8s, networking
- `security-agent` — threat scanning, firewall rules, audit logs
- `cloud-agent` — AWS/Azure/GCP specific work

**Developer:**
- `backend-agent` — API, database, services
- `frontend-agent` — UI, components, CSS
- `devops-agent` — CI/CD, deployments, infra-as-code

**Enterprise team:**
- Shared base `CLAUDE.md` with team context
- Individual `agents/[name]/` per team member
- `oncall-agent` — incident response runbooks and escalation paths

---

## Multi-Agent Handoffs

When work crosses agent boundaries:

1. Finish current task or reach a clean stopping point
2. Tell Claude explicitly: "Hand off to [agent name]"
3. Claude loads the new context and continues

For complex cross-domain work, use root context rather than trying to stitch agents together mid-task.
