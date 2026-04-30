# docs/

This folder holds all planning and tracking artifacts generated at runtime by the Conductor agent workflow.
It starts empty — files are created here as the team works through features and EPICs.

> **TEMPLATE NOTE:** Nothing in this folder needs to be filled in manually at project setup.
> The Conductor agent and its subagents create and maintain everything here automatically.

---

## Full Repository Structure

```
<project>/
│
├── .claude/                                     ← Claude Code agent and command definitions
│   ├── agents/
│   │   ├── conductor.md                         ← orchestrates full Planning → Commit lifecycle
│   │   ├── planning-subagent.md                 ← researches codebase context for the Conductor
│   │   ├── implement-subagent.md                ← executes TDD implementation per EPIC
│   │   ├── code-review-subagent.md              ← reviews code changes
│   │   ├── security-subagent.md                 ← OWASP security review
│   │   ├── test-subagent.md                     ← writes and runs tests
│   │   └── documentation-subagent.md            ← updates README, API docs, CHANGELOG
│   │
│   └── commands/                                ← slash commands (type /command-name in Claude Code)
│       ├── brainstorming.md
│       ├── spec-writer.md
│       ├── writing-plans.md
│       ├── executing-plans.md
│       ├── verification-before-completion.md
│       ├── bug-logger.md
│       ├── frontend-design.md
│       ├── update-docs.md
│       ├── webapp-testing.md
│       ├── create-agents-md.md
│       ├── excalidraw-diagram.md
│       └── using-superpowers.md
│
├── .github/                                     ← GitHub Copilot definitions (kept for Copilot users)
│   ├── agents/                                  ← Copilot agent definitions (.agent.md)
│   ├── instructions/                            ← Copilot instruction files (.instructions.md)
│   └── skills/                                  ← Copilot skill definitions (SKILL.md per skill)
│
├── docs/
│   ├── README.md                                ← this file
│   ├── epics-status.md                          ← single source of truth for all EPIC progress
│   │
│   ├── plans/
│   │   ├── <task>-spec.md                       ← feature spec written by /spec-writer
│   │   ├── <task>-plan.md                       ← written after user approves the Conductor's plan
│   │   └── <task>-complete.md                   ← written at Phase 3 when all EPICs are done
│   │
│   ├── epics/
│   │   ├── epic-<N>-<task>.md                   ← created by implement-subagent at EPIC start
│   │   └── <task>-epic-<N>-complete.md          ← written at each EPIC commit checkpoint
│   │
│   ├── bugs/
│   │   └── YYYY-MM-DD-<slug>.md                 ← logged by /bug-logger at any point
│   │
│   └── session/
│       └── conductor-state.md                   ← Conductor session state for context recovery
│
├── src/                                         ← application source code
├── tests/                                       ← test files managed by test-subagent
│
├── AGENTS.md                                    ← project context for AI agents
├── CHANGELOG.md                                 ← maintained by documentation-subagent
├── CLAUDE.md                                    ← coding standards loaded automatically by Claude Code
└── README.md                                    ← project README maintained by documentation-subagent
```

---

## File Reference

### `epics-status.md`

**Created by:** Conductor — Phase 1, step 7
**Updated by:** Conductor — after every EPIC commit checkpoint

The single source of truth for progress across all plans and EPICs. Contains one status table covering every EPIC from every plan. Never duplicated or split into per-task files.

```markdown
| EPIC | Completion Rate | Status | Notes/Remarks |
|------|-----------------|--------|---------------|
| auth-system - EPIC 1: Setup | 100% | Completed | — |
| auth-system - EPIC 2: Login flow | 50% | In Progress | Blocked on token refresh |
```

---

### `plans/<task>-spec.md`

**Created by:** `/spec-writer` command — before planning begins
**Picked up by:** Conductor — automatically loaded as the authoritative requirements source

Structured feature spec with goal, requirements, acceptance criteria, out-of-scope items, assumptions, and open questions. Written before any implementation plan or code.

---

### `plans/<task>-plan.md`

**Created by:** Conductor — after user approves the plan (Phase 1, step 6)

Full EPIC-based implementation plan including objectives, files to change, tests to write, and tasks per EPIC. Written once; not modified after approval.

---

### `plans/<task>-complete.md`

**Created by:** Conductor — Phase 3 (after all EPICs are done)

Final report for the plan. Summarises all EPICs completed, all files created or modified, test coverage, and recommendations for next steps.

---

### `epics/epic-<N>-<task>.md`

**Created by:** implement-subagent — at the start of each EPIC

Tracks the detailed state of a single EPIC. Contains the objective, files to modify, tests to write, task list, and a mandatory `### Task Status` table that is kept in sync with `epics-status.md`.

**Required sections (in order):**
1. `### Objective`
2. `### Files/Functions to Modify/Create`
3. `### Tests to Write`
4. `### Tasks`
5. `### Task Status` — table with columns `Task | Completion Rate | Status | Notes/Remarks`

Allowed `Status` values: `Not Started` · `In Progress` · `Completed` · `Blocked`

---

### `epics/<task>-epic-<N>-complete.md`

**Created by:** Conductor — at each EPIC commit checkpoint (Phase 2E)

Snapshot of what was accomplished in the EPIC. Lists files/functions/tests created or changed, the review status, and the git commit message used.

---

### `bugs/YYYY-MM-DD-<slug>.md`

**Created by:** `/bug-logger` command or any agent that detects a bug trigger keyword

Logged automatically without interrupting current workflow. Contains: title, date, severity, description, steps to reproduce, affected files, suggested fix direction, and related plan/EPIC.

**Severity levels:** `Critical` · `High` · `Medium` · `Low`

---

### `session/conductor-state.md`

**Created/Updated by:** Conductor — before every subagent invocation and at every mandatory stop

Recovery point for the Conductor if the context window resets mid-task. Contains current phase, active plan, EPIC progress, last completed step, pending blockers, and retry counts.

---

## Workflow Overview

```
Phase 1 · Planning
  └─ /spec-writer  →  docs/plans/<task>-spec.md
  └─ Conductor     →  docs/plans/<task>-plan.md       (after user approval)
  └─ Conductor     →  docs/epics-status.md             (initialised)

Phase 2 · Per-EPIC Implementation Cycle (repeats per EPIC)
  └─ implement-subagent  →  docs/epics/epic-<N>-<task>.md
  └─ [code review → tests → security review]
  └─ Conductor           →  docs/epics-status.md        (updated at commit checkpoint)
  └─ Conductor           →  docs/epics/<task>-epic-<N>-complete.md

Phase 3 · Completion
  └─ Conductor     →  docs/plans/<task>-complete.md
```

---

## Naming Conventions

All file names use **kebab-case**.

| Token | Example |
|---|---|
| `<task>` | `auth-system`, `payment-refactor` |
| `<N>` | `1`, `2`, `3` |
| `<slug>` | `null-return-on-login`, `missing-validation` |

**Examples:**
- `docs/plans/auth-system-spec.md`
- `docs/plans/auth-system-plan.md`
- `docs/plans/auth-system-complete.md`
- `docs/epics/epic-1-auth-system.md`
- `docs/epics/auth-system-epic-1-complete.md`
- `docs/bugs/2026-04-30-null-return-on-login.md`
- `docs/epics-status.md`
