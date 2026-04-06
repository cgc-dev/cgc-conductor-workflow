---
name: create-agents-md
description: Creates or refreshes AGENTS.md with full project context for AI agents — tech stack, build commands, project structure, coding standards, testing strategy, available agents, and key conventions. Use on new projects, when AGENTS.md is stale, or after meaningful project changes.
---

# Create or Refresh AGENTS.md

## Overview

Generate or refresh `AGENTS.md` at the project root. This file gives every AI agent working in the codebase the context it needs to operate without guessing.

**Announce at start:** "I'm using the create-agents-md skill to generate your AGENTS.md."

---

## Step 0: Determine Mode

Check for `AGENTS.md` in the project root before doing anything else.

| Mode | Condition |
|---|---|
| **Create** | `AGENTS.md` does not exist |
| **Refresh** | `AGENTS.md` exists but is stale — agents, stack, or instructions have changed since it was last written |
| **Update** | Explicitly invoked by the user after a meaningful project change |

In **Refresh** and **Update** modes, read the current `AGENTS.md` in full as the baseline. Identify which sections are out of date. Always rewrite the file in full — do not patch individual sections.

---

## Step 1: Deep Scan

Run all of these reads before asking the user anything. The goal is to auto-populate as many sections as possible.

**Project manifest & stack detection:**
- `package.json`, `*.csproj`, `*.sln`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml` — infer tech stack, dependencies, build/run commands
- `Dockerfile`, `docker-compose.yml` — infer container setup and run commands

**Existing context files:**
- `README.md` — extract project description, setup instructions, documented conventions
- `AGENTS.md` (if present) — read in full as the refresh baseline
- `copilot-instructions.md` — extract global agent rules or preferences

**Agent & instruction inventory:**
- `.github/agents/*.agent.md` — list all agents; read `name` and `description` frontmatter
- `.github/instructions/*.instructions.md` — list all instruction files; read `description` and `applyTo` frontmatter
- `.github/skills/*/SKILL.md` — list available skills; read `name` and `description` frontmatter

**Structure & testing:**
- Top-level folder tree (2 levels deep)
- `tests/` folder structure — infer test framework and layout
- Up to 10 files sampled from `src/` — cross-check inferred stack

After scanning, build a **confidence map** — mark each section as high or low confidence based on what was found. Only low-confidence or missing sections trigger follow-up questions.

---

## Step 2: Targeted Interview

Ask follow-up questions **one at a time**. Always show the scan's best-guess as the default so the user can confirm or correct rather than type from scratch.

Only ask when the trigger condition is met:

| Section | Ask when… |
|---|---|
| Tech Stack | No manifest found, or multiple frameworks detected ambiguously |
| Build & Run Commands | No `scripts` in manifest, no `Makefile`, nothing in `README.md` |
| Project Structure | `src/` is absent or empty |
| Coding Standards | No `*.instructions.md` files and no linting config (`.eslintrc`, `.editorconfig`, etc.) found |
| Testing Strategy | No `tests/` folder and no test runner in manifest scripts |
| Available Agents | No `.github/agents/` folder found |
| Key Conventions | **Always ask** — present what was inferred and ask: *"Are there any conventions I missed — e.g. branching strategy, commit message format, or PR requirements?"* |

---

## Step 3: Write AGENTS.md

Once all gaps are resolved, write `AGENTS.md` to the project root using the template below. Every section must always be present. If a section cannot be fully populated, include a clear placeholder explaining what to fill in — never omit a section.

```markdown
# AGENTS.md

> Project context for AI agents. Keep this file up to date when the stack, structure, agents, or conventions change.

## Tech Stack
- **Language/Runtime:** [e.g. TypeScript / Node 20]
- **Framework:** [e.g. Angular 18]
- **Key Libraries:** [e.g. RxJS, Prisma, Zod]
- **Package Manager:** [e.g. npm]

## Build & Run Commands

| Command | Purpose |
|---|---|
| `[install command]` | Install dependencies |
| `[build command]` | Compile / build |
| `[dev command]` | Start dev server |
| `[test command]` | Run all tests |
| `[lint command]` | Lint the codebase |

## Project Structure

```
[generated annotated folder tree]
```

## Coding Standards
- **Instruction files:** `.github/instructions/*.instructions.md`
- **Key rules:** [e.g. no `any` in TypeScript, functional components only]
- **Linting:** [e.g. ESLint + Prettier — config at `.eslintrc.json`]

## Testing Strategy
- **Framework:** [e.g. Jest + Testing Library]
- **Unit tests:** `tests/unit/` — [what they cover]
- **Integration tests:** `tests/integration/` — [what they cover]
- **When to run:** [e.g. before every commit, in CI on every PR]

## Available Agents

| Agent | File | Purpose |
|---|---|---|
| [name] | `.github/agents/[file].agent.md` | [description] |

## Key Conventions
- **Branching:** [e.g. `main` is protected; feature branches off `main`]
- **Commit format:** [e.g. Conventional Commits — `feat:`, `fix:`, `chore:`]
- **PR rules:** [e.g. one approval required, CI must pass]
- **File naming:** [e.g. kebab-case]
```

---

## Step 4: Confirm & Complete

After writing the file, print:

> ✅ AGENTS.md [created / refreshed / updated]. Review it at `AGENTS.md`.

State which sections were auto-populated from the scan and which were filled in from user answers. If operating in Refresh mode, list the sections that changed.
