# CLAUDE.md — Atlas Identity File
# This is your operating system. Fill in every section.
# Claude Code reads this automatically at the start of every session.
# Lines starting with # are comments — remove them once you've filled in a section.

---

## WHO I AM

**Name:** [Your full name]
**Age:** [Your age]
**Location:** [City, State/Country]
**Machine(s):** [Primary machine name and type — e.g. "Workstation (Ubuntu 22.04)"]
**GitHub:** github.com/[your-username]
**Email:** [your-email]

**Job:** [Your role / title]
**Background:** [Relevant education, experience, or domain context]

---

## MACHINES

# List every machine you work from. Claude uses this to understand your environment.
# Format: Name — Type — OS — key specs

| Machine | Type | OS | Notes |
|---------|------|----|-------|
| [name] | [desktop/laptop/server/WSL] | [OS + version] | [anything relevant] |

---

## CURRENT FOCUS

# What are you actively working on RIGHT NOW? Be specific.
# This is what Claude will default to helping you with.

**Primary:** [Your main goal or project — e.g. "AZ-104 cert study" or "shipping v2 of my app"]
**Secondary:** [Anything else you're juggling]

**Active projects:**
- [project name] — [one line description]

**Queued (next up):**
- [project name] — [one line description]

---

## INFRASTRUCTURE

# Optional — fill in if you have a homelab, server, cloud infra, or anything Claude should know about.
# Delete this section if not applicable.

**Primary server:** [hostname] at [IP] — [OS, key services]
**Networking:** [router, DNS, any tunnels or VPN]
**Storage:** [NAS, cloud, local — capacity and mount points]
**Orchestration:** [K8s, Docker Compose, bare metal, etc.]

**Services running:**
- [service name] — [URL if applicable] — [status]

---

## GOALS

# What are you trying to accomplish? Give Claude the long view.

**Career:** [What you're building toward professionally]
**Technical:** [Skills, certs, or systems you want to master]
**Personal:** [Anything else Claude should factor in — finances, location, lifestyle]

---

## OPERATING SYSTEM

# These are the rules you run by. Claude will reinforce and respect them.

### Daily Non-Negotiables
# List 3-5 things you do every day without exception
- [habit 1]
- [habit 2]
- [habit 3]

### Hard Rules
# Lines Claude will not help you cross, and will call out if you're approaching
- [rule 1]
- [rule 2]

### What Stabilizes You
# When things go sideways, these are your reset mechanisms
- [stabilizer 1]
- [stabilizer 2]

### What Destabilizes You
# Claude uses this to catch patterns before they spiral
- [destabilizer 1]
- [destabilizer 2]

---

## AGENTS

# List every agent you've deployed. Each agent has its own CLAUDE.md in agents/[name]/
# Format: Agent name | trigger phrase or context | purpose

| Agent | Trigger | Purpose |
|-------|---------|---------|
| [agent-name] | [how you invoke it] | [what it does] |

# Starter agents are in agents/ — copy, rename, and fill in as needed.

---

## HOW TO TALK TO ME

# Tell Claude exactly how you want it to collaborate with you.
# Be honest — this shapes every response.

- [communication preference 1 — e.g. "I'm a visual thinker, use diagrams and tables"]
- [communication preference 2 — e.g. "Don't pad responses, lead with the answer"]
- [communication preference 3]

# Optional: tone, language level, what to do when you're stuck or spiraling
- When I'm stuck: [how you want Claude to respond]
- When I'm in build mode: [how you want Claude to respond]

---

## CONTEXT

# Anything else Claude should know that doesn't fit above.
# Personal history, relationships, values, faith, anything that shapes how you operate.
# This section is private to your repo — it never leaves your machine unless you push it.

[Write freely here. The more Claude knows, the more it can tailor its responses to you.]
