# CGC COPILOT

> Project template + multi-tool AI agent installer. One repo. Claude Code, GitHub Copilot, and Cursor.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Two Ways to Use This

### 1. Quick install — agents only (any project)

Install the Conductor workflow into an existing project for your AI coding tool:

```bash
git clone https://github.com/CGC-ORG/COPILOT.git ~/.cgc-copilot
cd ~/my-project
~/.cgc-copilot/installer/install.sh --tool claude    # or copilot / cursor / all
```

One-liner (no clone):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/CGC-ORG/COPILOT/main/installer/install.sh)
```

### 2. Full template — start a new project

Use the root install script to scaffold a complete project with agents, instructions, skills, and CI/CD:

```bash
cd ~/my-new-project
~/.cgc-copilot/install.sh
```

See the [Getting Started](#getting-started) section below for full details.

---

## What's included

| Category | What you get |
|---|---|
| **Agents** | Conductor, Planning, Implement, Code Review, Security, Test, and Documentation — for Claude Code, GitHub Copilot, and Cursor |
| **Slash commands** | `/spec-writer`, `/writing-plans`, `/executing-plans`, `/brainstorming`, `/frontend-design`, `/bug-logger`, `/update-docs`, `/webapp-testing`, `/excalidraw-diagram`, and more (Claude Code) |
| **Tech-stack instructions** | Copilot instructions for Angular, React, .NET (modern + Framework), DDD, and Azure DevOps Pipelines in `.github/instructions/` |
| **Coding standards** | `CLAUDE.md` loaded automatically in every Claude Code session — pre-filled with universal rules, ready for your project specifics |
| **Agent context** | `AGENTS.md` — single source of truth for AI agents: tech stack, commands, structure, conventions |
| **CI/CD** | GitHub Actions workflows for build, test, and Azure deployment in `.github/workflows/` |
| **Changelog** | Keep-a-Changelog format with AI-maintained `[Unreleased]` section |

---

## Getting started

### Option A — New project (use as template)

Click **"Use this template"** on GitHub, or clone directly:

```bash
git clone git@github.com:YOUR-ORG/YOUR-REPO.git my-project
cd my-project
```

### Option B — Add to an existing project (recommended for teams)

Clone the config repo once to a permanent location, then run the install script from any project root.

**Mac / Linux**
```bash
# One-time clone (do this once per machine)
git clone git@github.com:YOUR-ORG/YOUR-REPO.git ~/.copilot-config

# From your project root — install configuration
cd ~/my-project
~/.copilot-config/install.sh

# Later: pull the latest config updates
~/.copilot-config/install.sh --update
```

**Windows (PowerShell)**
```powershell
# One-time clone (do this once per machine)
git clone git@github.com:YOUR-ORG/YOUR-REPO.git $HOME\.copilot-config

# From your project root — install configuration
cd C:\my-project
& $HOME\.copilot-config\install.ps1

# Later: pull the latest config updates
& $HOME\.copilot-config\install.ps1 -Update
```

> The install script merges `.github/`, `.claude/`, `AGENTS.md`, and `CLAUDE.md` into your project. It skips existing files so it never overwrites your project-specific customisations.

### 2. Open in Claude Code

```bash
claude  # or open the folder in the Claude Code desktop/VS Code extension
```

### 3. Fill in the four template files

Every `> TEMPLATE:` callout marks a section you need to fill in. Start here:

| File | What to fill in |
|---|---|
| `CLAUDE.md` | Tech stack, coding conventions, architecture decisions — delete tech sections that don't apply |
| `AGENTS.md` | Build commands, project structure, testing strategy, key conventions |
| `README.md` | Replace this file with your project's README (see structure below) |
| `CHANGELOG.md` | Remove the "how to maintain" header; keep the `[Unreleased]` section |

### 4. Delete or keep tech-stack instructions

Remove any `.github/instructions/` files for tech stacks you're not using. The ones you keep are picked up automatically by GitHub Copilot and Claude Code in VS Code/JetBrains.

---

## Agent workflow

```
New task or feature
       │
       ├─ Small change / bugfix ──→ Fix directly → /verification-before-completion → commit
       │
       └─ EPIC-level feature ─────→ Conductor orchestrates:
                                      1. /spec-writer      — structured spec from rough idea
                                      2. planning-subagent — codebase research + plan
                                      3. implement-subagent — TDD execution per EPIC
                                      4. code-review-subagent
                                      5. test-subagent
                                      6. security-subagent  — OWASP Top 10 review
                                      7. documentation-subagent — README + CHANGELOG
                                      8. Commit checkpoint with developer
```

---

## Slash commands reference

Type any of these in a Claude Code session:

| Command | Purpose |
|---|---|
| `/brainstorming` | Turn rough ideas into designs through dialogue |
| `/spec-writer` | Convert a rough idea into a structured feature spec (PRD) |
| `/writing-plans` | Write a detailed TDD implementation plan from a spec |
| `/executing-plans` | Execute a written plan in batches with checkpoints |
| `/verification-before-completion` | Evidence-based verification before claiming work done |
| `/bug-logger` | Log a bug to `docs/bugs/` without interrupting current work |
| `/frontend-design` | Create distinctive, production-grade UI |
| `/update-docs` | Enforce README update after any code logic change |
| `/webapp-testing` | Test a local web app using Playwright |
| `/create-agents-md` | Regenerate `AGENTS.md` from the live codebase |
| `/excalidraw-diagram` | Create a visual `.excalidraw` diagram |
| `/using-superpowers` | Reference guide for all agents and commands |

---

## Project structure (template layout)

```
.
├── agents/                 # Multi-tool agent definitions (source for installer)
│   ├── claude/
│   │   ├── agents/         # 7 Claude Code agents
│   │   └── commands/       # 12 slash commands
│   ├── copilot/
│   │   ├── agents/         # 7 GitHub Copilot agents
│   │   └── prompts/        # 4 workflow prompt templates
│   ├── cursor/
│   │   ├── rules/          # 7 Cursor .mdc rules
│   │   └── instructions/   # Agent mode instructions
│   └── generic/
│       ├── workflow.md     # Canonical workflow reference
│       └── agents/README.md
├── installer/              # Multi-tool installer scripts
│   ├── install.sh
│   ├── install.ps1
│   └── lib/                # Per-tool install helpers
├── .claude/
│   ├── agents/             # Claude Code agents (for this repo)
│   └── commands/           # Slash commands (for this repo)
├── .github/
│   ├── agents/             # GitHub Copilot agents (for this repo)
│   ├── instructions/       # Copilot / Claude coding instructions per tech stack
│   ├── skills/             # Skill implementations for slash commands
│   └── workflows/          # GitHub Actions CI/CD (build, test, Azure deploy)
├── docs/                   # Plans, EPICs, bugs, session state
├── AGENTS.md               # AI agent context file
├── CHANGELOG.md            # Keep-a-Changelog format
├── CLAUDE.md               # Claude Code coding standards
├── install.sh              # Full template installer (bash)
└── install.ps1             # Full template installer (PowerShell)
```

---

## Customizing CI/CD

Two workflow files ship in `.github/workflows/`:

- **`deploy.yml`** — general build + test pipeline; update the `build` step for your stack
- **`deploy-azure.yml`** — Azure App Service deployment; requires these repository secrets:

| Secret | Description |
|---|---|
| `AZURE_WEBAPP_NAME` | Target Azure Web App name |
| `AZURE_WEBAPP_PUBLISH_PROFILE` | Publish profile XML from Azure Portal |

Remove whichever workflow you don't need.

---

## Contributing

1. Fork and create a branch: `feature/your-improvement`
2. Commit using [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, etc.
3. Open a PR — one approval required; CI must pass

Issues and suggestions are welcome via GitHub Issues.

---

## License

MIT — see [LICENSE](LICENSE).
