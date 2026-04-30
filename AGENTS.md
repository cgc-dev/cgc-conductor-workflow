# AGENTS.md

> Context for AI agents working in this codebase. Keep this file up to date when the tech stack,
> project structure, agents, or conventions change.
>
> **TEMPLATE INSTRUCTIONS** — Fill in each `> TEMPLATE:` section when starting a new project.
> The agents, commands, and workflow sections below are pre-configured and ready to use.

---

## Tech Stack

> **TEMPLATE:** Fill in once the project tech stack is decided.

- **Language/Runtime:**
- **Framework:**
- **Key Libraries:**
- **Package Manager:**
- **Database:**

## Build & Run Commands

> **TEMPLATE:** Fill in once the project is scaffolded.

| Command | Purpose |
|---|---|
| `` | Install dependencies |
| `` | Build / compile |
| `` | Start dev server |
| `` | Run all tests |
| `` | Lint the codebase |

## Project Structure

> **TEMPLATE:** Generate an annotated folder tree once the structure is established.
> Run `/create-agents-md` to auto-populate this section from the live codebase.

```
# TEMPLATE: Add annotated folder tree here
```

## Coding Standards

- **Instruction file:** `CLAUDE.md` — loaded automatically in every Claude Code conversation
- **Linting config:** *(add path once configured)*
- **Key rules:** *(fill in project-specific rules — e.g. "no `any` in TypeScript", "use Result pattern for errors")*

> See `CLAUDE.md` for full coding standards. Add project-specific overrides in that file's
> "Project-Specific Standards" section.

## Testing Strategy

> **TEMPLATE:** Fill in once the test framework is decided.

- **Framework:**
- **Unit tests:** `tests/unit/` —
- **Integration tests:** `tests/integration/` —
- **When to run:** Before every commit; CI runs on every PR

## Key Conventions

> **TEMPLATE:** Fill in the team's agreed conventions.

- **Branching:** `main` is protected; feature branches off `main`
- **Commit format:** [Conventional Commits](https://www.conventionalcommits.org/) — `feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`
- **PR rules:** One approval required; CI must pass before merge
- **File naming:** *(e.g. kebab-case, PascalCase for components)*

---

## Available Agents

These agents are pre-configured in `.claude/agents/`. Invoke them by mentioning their role to Claude Code
or by using the **Conductor** for full orchestration.

| Agent | File | Purpose |
|---|---|---|
| Conductor | `.claude/agents/conductor.md` | Orchestrates Planning → Implementation → Review → Commit for EPIC-level features |
| Planning Subagent | `.claude/agents/planning-subagent.md` | Researches codebase context; called by Conductor during planning |
| Implement Subagent | `.claude/agents/implement-subagent.md` | Executes TDD implementation tasks; called by Conductor per EPIC |
| Code Review Subagent | `.claude/agents/code-review-subagent.md` | Reviews code changes for correctness and quality |
| Security Subagent | `.claude/agents/security-subagent.md` | OWASP Top 10 security review of changed files |
| Test Subagent | `.claude/agents/test-subagent.md` | Writes and runs tests; validates coverage |
| Documentation Subagent | `.claude/agents/documentation-subagent.md` | Updates README, API docs, and CHANGELOG after code changes |

## Available Commands (Slash Commands)

These commands are pre-configured in `.claude/commands/`. Type `/command-name` in Claude Code to invoke.

| Command | Purpose |
|---|---|
| `/brainstorming` | Turn rough ideas into designs through collaborative dialogue |
| `/spec-writer` | Convert a rough idea into a structured feature spec (PRD) |
| `/writing-plans` | Write a detailed TDD implementation plan from a spec |
| `/executing-plans` | Execute a written plan in batches with checkpoints |
| `/verification-before-completion` | Enforce evidence-based verification before claiming work is done |
| `/bug-logger` | Log a bug to `docs/bugs/` without interrupting current work |
| `/frontend-design` | Create distinctive, production-grade UI with bold aesthetic direction |
| `/update-docs` | Enforce README.md update after any code logic change |
| `/webapp-testing` | Test a local web app using Playwright automation |
| `/create-agents-md` | Generate or refresh this AGENTS.md from the live codebase |
| `/excalidraw-diagram` | Create a `.excalidraw` diagram that argues visually |
| `/using-superpowers` | Reference guide for all available agents and commands |

## Workflow Overview

```
New Feature Request
       │
       ├─ Small change / bugfix ──→ Fix directly → /verification-before-completion → commit
       │
       └─ EPIC-level feature ─────→ Conductor agent orchestrates:
                                      1. /spec-writer (if idea is rough)
                                      2. planning-subagent (research)
                                      3. implement-subagent (TDD per EPIC)
                                      4. code-review-subagent
                                      5. test-subagent
                                      6. security-subagent
                                      7. documentation-subagent
                                      8. Commit checkpoint with user
```

## Docs Folder Conventions

Plans, EPICs, bugs, and session state are stored under `docs/`:

```
docs/
  plans/          # Feature specs (*-spec.md) and implementation plans (*-plan.md)
  epics/          # Per-EPIC progress files created by implement-subagent
  epics-status.md # Single source of truth for plan progress
  bugs/           # Bug reports logged by bug-logger skill (YYYY-MM-DD-slug.md)
  session/        # Conductor session state for context recovery
```
