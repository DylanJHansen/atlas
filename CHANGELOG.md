# Changelog

All notable changes to Atlas are documented here.
Format: [Semantic Versioning](https://semver.org) — Added / Changed / Fixed / Removed

---

## [1.1.0] — Unreleased

### Added
- `CONTRIBUTING.md` — contribution guide, branch naming, PR standards, code of conduct
- `ROADMAP.md` — public roadmap with versioned milestones and community request process
- `CHANGELOG.md` — this file

---

## [1.0.0] — 2026-03-12

### Added
- `CLAUDE.md` — root identity template with fully commented placeholder sections
- `context/state.yaml` — canonical system state template
- `context/handoff.md` — session journal template
- `context/sessions/INDEX.md` — session archive index
- `context/systems/registry.md` — machine registry template
- `agents/AGENTS.md` — full agent identity specification
- `agents/ops-agent/CLAUDE.md` — infrastructure and systems agent template
- `agents/study-agent/CLAUDE.md` — learning and cert tracking agent template
- `agents/research-agent/CLAUDE.md` — deep research and knowledge agent template
- `scripts/post-tool-use.sh` — PostToolUse hook: auto-commit on Write/Edit
- `scripts/stop-hook.sh` — Stop hook: commit remaining changes, push, clear session lock
- `scripts/boot.sh` — session start: crash recovery, git pull, state briefing
- `init.sh` — interactive setup wizard
- `docs/architecture.md` — hook system, data flow, why git as memory
- `docs/agents.md` — agent identity system in depth
- `docs/session-hygiene.md` — session start/end protocol reference
- `.gitignore` — secrets, OS files, sensitive inbox content excluded
- `README.md` — full project documentation, quick start, enterprise framing
