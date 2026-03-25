# Multi-Agent Handoff Pattern

How agents in Atlas pass control back and forth with the root context — and with each other.

---

## The Core Problem

In a single-agent system, context bleeds. Your study agent knows about your infrastructure. Your ops agent knows your cert schedule. Over time, Claude's context window fills with irrelevant details and responses get muddier.

Atlas solves this with **scoped agent contexts**: each agent is a focused Claude context with its own CLAUDE.md, its own purpose, and clear rules about when to hand back.

The handoff pattern defines how that boundary works.

---

## The Pattern: Root → Agent → Root

```
Root Context (CLAUDE.md)
  │
  ├── Detects trigger (topic, phrase, or file type)
  │
  ▼
Agent Context (agents/[name]/CLAUDE.md)
  │
  ├── Handles the task within its defined scope
  ├── Updates agent-specific state files (if any)
  │
  ▼
Handoff Event (scope boundary hit)
  │
  └── Agent summarizes what it did
  └── Returns to Root Context
```

The root context always knows which agents exist (via the Agents table in `CLAUDE.md`). Agents know when to hand back (via the "Handoff to Root" section in their `CLAUDE.md`).

---

## Defining Handoff Triggers

Every agent `CLAUDE.md` should have a clear `## Handoff to Root` section that defines exactly when the agent stops and passes control back:

```markdown
## Handoff to Root

Hand back to root context when:
- The task requires infrastructure access outside this agent's scope
- The user asks about a topic handled by a different agent
- The task is complete and root state needs to be updated (e.g. handoff.md)
- The user explicitly asks to switch context

When handing off: summarize what was accomplished, what state was updated,
and what the root context or next agent needs to know.
```

Specific, not vague. "When the task is done" is too broad — define the actual triggers.

---

## State at the Boundary

The handoff point is also where state transfers. There are two types of state:

### Agent-owned state
Agents that have their own persistent context store it in `agents/[name]/context/`. Examples:
- Study agent: `agents/study-agent/context/progress.md` — exam scores, session counts
- Finance agent: `agents/finance-agent/context/snapshot.md` — current balances

This state is agent-local. Root context doesn't need to read it unless summarizing.

### Root-visible state
When an agent finishes a significant task, it updates root-visible files:
- `context/handoff.md` — what the agent did, what's pending
- `context/state.yaml` — if canonical state changed (e.g., a cert passed, a project closed)

The agent writes these updates before handing back. Root context reads them on the next session.

---

## Agent-to-Agent Handoff

Agents can hand directly to each other — root context doesn't need to be the middleman every time.

```
Study Agent
  └── Hits a scope boundary (financial question about cert costs)
  └── Summarizes what it was doing
  └── Invokes Finance Agent with context

Finance Agent
  └── Handles the financial question
  └── Returns result to Study Agent (or to root, depending on scope)
```

For this to work cleanly:
1. Each agent must define not just "when to hand to root" but "which agent handles X"
2. The handoff summary must include enough context for the receiving agent to pick up mid-task
3. If the receiving agent changes any root-visible state, it updates handoff.md before passing back

---

## Handoff Summary Format

When handing back to root or to another agent, include a brief summary:

```
HANDOFF FROM [Agent Name]
Task: [what was being done]
Completed: [what was finished]
Pending: [what's still open, if anything]
State updated: [which files were changed]
Next: [what root or the next agent needs to do, if anything]
```

This keeps context transfers clean and prevents the receiving context from having to re-derive what happened.

---

## Example: Study Agent Hands Back

The study agent is running an exam drill. The user asks a question about their homelab — clearly out of scope.

**Study agent behavior:**
1. Notes the question is infrastructure-scoped
2. Stops the drill cleanly (saves progress to `agents/study-agent/context/progress.md`)
3. Provides the handoff summary
4. Signals root context to load the ops agent or answer directly

**Handoff summary output:**
```
HANDOFF FROM Study Agent
Task: SC-900 mixed drill, 5/10 questions complete
Completed: Q1-Q5 scored, saved to study-agent/context/progress.md
Pending: Q6-Q10 remaining — resume drill to continue
State updated: study-agent/context/progress.md
Next: Answer infrastructure question, then return to drill if user wants
```

Root context picks up, handles the question, and offers to resume.

---

## Common Mistakes

**No handoff trigger defined** — agent keeps handling everything, context bleeds.
Fix: Add a `## Handoff to Root` section with specific trigger conditions.

**Handoff with no summary** — receiving context has to re-derive what was happening.
Fix: Always include a 3-5 line summary at the boundary.

**State not written before handoff** — progress is lost if the session ends mid-handoff.
Fix: Write any agent-local state updates before signaling the handoff.

**Agent invokes tools outside its scope** — ops agent edits study notes, study agent touches K8s.
Fix: Each agent `CLAUDE.md` should have a `## Scope` section that explicitly lists what it does NOT touch.

---

## Adding Handoff Support to an Existing Agent

If you have an agent that lacks clear handoff rules:

1. Open `agents/[name]/CLAUDE.md`
2. Add or update the `## Handoff to Root` section with specific trigger conditions
3. Add a `## Scope` section that lists what the agent does NOT handle
4. If the agent has persistent state, document it in `## Context Files`
5. Test: invoke the agent, hit a scope boundary, and verify it hands back cleanly with a summary

---

## Reference: Agent CLAUDE.md Sections That Support Handoff

| Section | Purpose |
|---------|---------|
| `## Identity > Scope` | Defines what the agent does and does NOT handle |
| `## Handoff to Root` | Trigger conditions + summary format |
| `## Context Files` | Where agent-local state lives |
| `## Operating Rules` | Behavioral guardrails that prevent scope bleed |
