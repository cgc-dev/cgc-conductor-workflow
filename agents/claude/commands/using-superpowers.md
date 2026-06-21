---
description: Reference guide for all available agents and commands
---

# Using Skills (Superpowers)

If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST check and use the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.

## The Rule

**Check for skills BEFORE ANY RESPONSE.** This includes clarifying questions. Even 1% chance means check for and invoke the skill first.

**Flow:**
1. User message received
2. Might any skill apply? → If yes (even 1%): read the skill and invoke it
3. Announce: "Using [skill] to [purpose]"
4. If skill has a checklist: create a todo item per checklist item
5. Follow skill exactly
6. Respond (including clarifications)

## Red Flags

These thoughts mean STOP — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) — these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, etc.) — these guide execution

"Let's build X" → /brainstorming first, then implementation skills.
"Fix this bug" → /bug-logger first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.

## Available Skills (Claude Code Commands)

- `/brainstorming` — Turn ideas into designs through collaborative dialogue
- `/writing-plans` — Write comprehensive implementation plans (use after brainstorming)
- `/executing-plans` — Execute a written plan in batches with checkpoints
- `/spec-writer` — Convert raw ideas into structured feature specs (PRDs)
- `/verification-before-completion` — Verify evidence before claiming work is complete
- `/bug-logger` — Log bugs to `docs/bugs/` without interrupting workflow
- `/frontend-design` — Create distinctive, production-grade UI
- `/update-docs` — Enforce README.md updates after code changes
- `/webapp-testing` — Test local web apps with Playwright
- `/create-agents-md` — Generate or refresh AGENTS.md
- `/excalidraw-diagram` — Create visual argument diagrams

## Available Agents

- **conductor** — Full Planning → Implementation → Review → Commit orchestration
- **planning-subagent** — Research context for the Conductor
- **implement-subagent** — Execute TDD implementation tasks
- **code-review-subagent** — Review code changes for quality
- **security-subagent** — OWASP security review
- **test-subagent** — Write and run tests
- **documentation-subagent** — Update docs after code changes
