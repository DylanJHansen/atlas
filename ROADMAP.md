# Atlas Roadmap

This is the public roadmap for Atlas. It tracks what's planned, what's in progress, and what's been shipped. It's not a commitment — it's a direction.

If you want something on this list, open an Issue or a PR.

---

## Status Key

| Symbol | Meaning |
|--------|---------|
| `[done]` | Shipped in current version |
| `[active]` | In progress now |
| `[planned]` | Confirmed, not started |
| `[considering]` | Thinking about it, not confirmed |
| `[backlog]` | Good idea, no timeline |

---

## v1.x — Foundation

### v1.0.0 — Initial Release *(current)*

- `[done]` Root `CLAUDE.md` identity template
- `[done]` `context/state.yaml` — canonical system state
- `[done]` `context/handoff.md` — session journal template
- `[done]` `context/sessions/` — session archive structure
- `[done]` Agent system — `agents/AGENTS.md` spec
- `[done]` Three starter agents: ops, study, research
- `[done]` Hook scripts: `post-tool-use.sh`, `stop-hook.sh`, `boot.sh`
- `[done]` `init.sh` — setup wizard
- `[done]` Docs: architecture, agents, session hygiene
- `[done]` `CONTRIBUTING.md` and `ROADMAP.md`

---

### v1.1.0 — Stability + Onboarding

- `[active]` `init.sh` — full end-to-end test on clean clone
- `[done]` `docs/multi-agent-handoff.md` — root→agent→agent→root handoff pattern, state at boundaries, common mistakes
- `[planned]` GitHub Issue templates — bug report, feature request, agent request
- `[planned]` `CHANGELOG.md` — running change log per version
- `[planned]` `docs/multi-device.md` — guide for using Atlas across multiple machines
- `[planned]` README improvements — clearer quick start, screenshot/diagram of the system

---

### v1.2.0 — Agent Expansion

- `[planned]` `agents/security-agent/` — generic threat scanning, audit log, firewall review agent
- `[planned]` `agents/finance-agent/` — budget tracking, spend review, financial goals
- `[planned]` `agents/project-agent/` — project tracking, milestone management, status reporting
- `[considering]` `agents/health-agent/` — fitness tracking, habit logging, biometric context

---

## v2.x — Team & Enterprise

### v2.0.0 — Team Context Layer

- `[backlog]` `team/` directory pattern — shared context for a squad
- `[backlog]` `docs/team-usage.md` — multi-user Atlas deployment guide
- `[backlog]` Org-level CLAUDE.md inheritance — global → team → individual
- `[backlog]` `docs/enterprise-setup.md` — Atlas for departments and organizations

---

## v3.x — Advanced Automation

### v3.0.0 — Deeper Automation

- `[backlog]` Richer hook system — pre-session briefing, auto-state-diff, anomaly detection
- `[backlog]` `docs/siem-pipeline.md` — building a SIEM log pipeline from Atlas session data
- `[backlog]` `docs/observability.md` — OTel integration for Atlas sessions and infra agents
- `[backlog]` CI/CD example — GitHub Actions to validate CLAUDE.md structure on PR

---

## Community Requests

Have a feature idea? Open a [GitHub Issue](https://github.com/DylanJHansen/atlas/issues) with the label `feature-request`.

Requests that get traction here will be promoted to a versioned milestone.
