# Project Repository

This repository contains GitHub Copilot agent definitions, coding instructions, reusable skills, and workflow automation. The `docs/` folder holds all planning and tracking artifacts generated at runtime by the Conductor agent workflow.

## Full Folder Structure

```
 my-project/
│
├── .github/
│   ├── agents/
│   │   ├── Conductor.agent.md
│   │   ├── planning-subagent.agent.md
│   │   ├── implement-subagent.agent.md
│   │   ├── test-subagent.agent.md
│   │   ├── security-subagent.agent.md
│   │   ├── code-review-subagent.agent.md
│   │   ├── documentation-subagent.agent.md
│   │   └── implementation-plan.agent.md
│   │
│   └── instructions/
│       ├── angular.instructions.md
│       ├── reactjs.instructions.md
│       └── ...
│
├── docs/
│   │
│   ├── epics-status.md                          ← single source of truth for all EPIC progress
│   │
│   ├── plans/
│   │   ├── auth-system-plan.md                  ← written after user approves plan
│   │   ├── auth-system-complete.md              ← written at Phase 3
│   │   ├── payment-refactor-plan.md
│   │   └── payment-refactor-complete.md
│   │
│   └── epics/
│       ├── epic-1-auth-system.md                ← created by implement-subagent per EPIC
│       ├── epic-2-auth-system.md
│       ├── epic-3-auth-system.md
│       ├── auth-system-epic-1-complete.md       ← written at commit checkpoint
│       ├── auth-system-epic-2-complete.md
│       ├── auth-system-epic-3-complete.md
│       ├── epic-1-payment-refactor.md
│       └── payment-refactor-epic-1-complete.md
│
├── src/                                         ← your actual application code
│   ├── ...
│   └── ...
│
├── tests/                                       ← test files managed by test-subagent
│   ├── unit/
│   ├── integration/
│   └── ...
│
├── AGENTS.md                                    ← describes available agents and how to invoke them
├── CHANGELOG.md                                 ← maintained by documentation-subagent
├── README.md                                    ← maintained by documentation-subagent
└── copilot-instructions.md                      ← global agent instructions (optional)
```

---

## File Reference

### `epics-status.md`

**Created by:** Conductor — Phase 1, step 7  
**Updated by:** Conductor — after every EPIC commit checkpoint

The single source of truth for progress across all plans and EPICs. Contains one status table covering every EPIC from every plan. Never duplicated or split into per-task files.

---

### `plans/<task-name>-plan.md`

**Created by:** Conductor — after user approves the plan  
**Template:** `<plan_style_guide>` in `Conductor.agent.md`

Contains the full EPIC-based implementation plan including objectives, files to change, tests to write, and tasks per EPIC. Written once and not modified after approval.

---

### `plans/<task-name>-complete.md`

**Created by:** Conductor — Phase 3 (after all EPICs are done)  
**Template:** `<plan_complete_style_guide>` in `Conductor.agent.md`

Final report for the plan. Summarises all EPICs completed, all files created or modified, test coverage, and recommendations for next steps.

---

### `epics/epic-<N>-<plan-name>.md`

**Created by:** implement-subagent — at the start of each EPIC  
**Template:** `<epic_style_guide>` in `Conductor.agent.md`

Tracks the detailed state of a single EPIC. Contains the objective, files to modify, tests to write, task list, and a mandatory `### Task Status` table that is kept in sync with `epics-status.md`.

**Required sections (in order):**
1. `### Objective`
2. `### Files/Functions to Modify/Create`
3. `### Tests to Write`
4. `### Tasks`
5. `### Task Status` — table with columns `Task | Completion Rate | Status | Notes/Remarks`

Allowed `Status` values: `Not Started` · `In Progress` · `Completed` · `Blocked`

---

### `epics/<plan-name>-epic-<N>-complete.md`

**Created by:** Conductor — at each EPIC commit checkpoint (Phase 2F)  
**Template:** `<epic_complete_style_guide>` in `Conductor.agent.md`

Snapshot of what was accomplished in the EPIC. Lists files/functions/tests created or changed, the review status, and the git commit message used.

---

## Workflow Overview

```
Phase 1 · Planning
  └─ docs/plans/<task>-plan.md         (written after user approval)
  └─ docs/epics-status.md              (initialised)

Phase 2 · Per-EPIC Implementation Cycle
  └─ docs/epics/epic-<N>-<task>.md     (created by implement-subagent)
  └─ docs/epics-status.md              (updated at every commit checkpoint)
  └─ docs/epics/<task>-epic-<N>-complete.md  (written at commit checkpoint)

Phase 3 · Completion
  └─ docs/plans/<task>-complete.md     (written when all EPICs are done)
```

---

## Naming Conventions

All file names use **kebab-case**.

| Token | Example |
|---|---|
| `<task-name>` | `auth-system`, `payment-refactor` |
| `<N>` | `1`, `2`, `3` |
| `<plan-name>` | same value as `<task-name>` |

**Examples:**
- `docs/plans/auth-system-plan.md`
- `docs/plans/auth-system-complete.md`
- `docs/epics/epic-1-auth-system.md`
- `docs/epics/auth-system-epic-1-complete.md`
- `docs/epics-status.md`
