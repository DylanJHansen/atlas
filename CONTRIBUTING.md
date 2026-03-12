# Contributing to Atlas

Atlas is a Personal AI Operating System template. Contributions are welcome — bug fixes, new agent templates, documentation improvements, and pattern refinements all make it more useful for everyone.

---

## What Atlas Accepts

**Good contributions:**
- Bug fixes in hook scripts or init.sh
- New agent templates (`agents/[category]-agent/`) that are genuinely generic
- Documentation improvements — clearer explanations, better examples
- New `docs/` articles covering Atlas patterns (multi-device, team use, enterprise setup)
- Improvements to `context/` templates (state.yaml, handoff.md)
- Refinements to session hygiene protocol

**Out of scope:**
- Personal configurations or instance-specific content
- Integrations with specific third-party tools (unless they're a doc, not code)
- Changes that break the zero-PII guarantee of the template

---

## How to Contribute

### Reporting a Bug or Requesting a Feature

Open a GitHub Issue using the appropriate template:
- **Bug report** — something in Atlas doesn't work as documented
- **Feature request** — a capability that would make Atlas more useful
- **Agent template request** — a new agent category that would generalize well

Be specific. The more context you give, the faster it moves.

### Submitting a Change

1. **Fork** the repo
2. **Create a branch** — `feature/[what-it-does]` or `fix/[what-it-fixes]`
3. **Make your changes** — keep the scope tight, one thing per PR
4. **Test it** — run `./init.sh` on a clean clone and verify nothing breaks
5. **Open a PR** — fill in the PR template (what, why, how to test)

---

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| New feature | `feature/[name]` | `feature/security-agent-template` |
| Bug fix | `fix/[name]` | `fix/boot-crash-recovery` |
| Documentation | `docs/[name]` | `docs/team-usage-guide` |

---

## PR Standards

Every PR should:
- Have a clear title: what does it add or fix?
- Include a one-paragraph description of the change and why it belongs in Atlas
- Include test steps — how did you verify it works?
- Touch only what it says it touches — no scope creep

PRs that add agent templates must include:
- A complete `CLAUDE.md` following the spec in `agents/AGENTS.md`
- At least one example use case in the file

---

## Versioning

Atlas uses semantic versioning. When your PR is merged, the maintainer bumps the version:

| Change type | Bump |
|-------------|------|
| Bug fix, doc correction | Patch (`0.0.x`) |
| New agent, new doc, hook improvement | Minor (`0.x.0`) |
| Structural change to how Atlas works | Major (`x.0.0`) |

---

## Code of Conduct

- Be direct, not mean
- Disagree on ideas, not people
- If you're proposing a structural change, open an Issue for discussion before a PR
- Atlas is a tool for builders — keep the culture builder-focused

---

## Questions

Open a GitHub Discussion or Issue. No question is too small if it helps you understand the system better.
