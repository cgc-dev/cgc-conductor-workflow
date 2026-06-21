# Conductor Workflow — Canonical Reference

This document describes the Conductor multi-agent workflow. Use it to understand the process, or copy-paste as context into any AI coding tool.

---

## Overview

The Conductor orchestrates a 7-step pipeline for feature development:

```
New task / feature
       │
       ├─ Small change / bugfix ──→ Fix directly → verify → commit
       │
       └─ EPIC-level feature ─────→ Conductor orchestrates:
                                      1. Spec — structured feature spec
                                      2. Plan — codebase research + plan
                                      3. Implement — TDD execution
                                      4. Code Review — correctness & quality
                                      5. Test — write & run tests
                                      6. Security — OWASP Top 10
                                      7. Docs — README + CHANGELOG
                                      8. Commit checkpoint with developer
```

## When to Use Each Path

| Situation | Path |
|---|---|
| Bugfix (1-3 files) | Fix directly → verify → commit |
| Small feature (2-5 files, well-understood) | Plan → implement → verify → commit |
| EPIC-level feature (new domain, 10+ files) | Full Conductor pipeline |
| Exploration / research spike | Brainstorm → document findings |

## Agent Roles

| Agent | Responsibility |
|---|---|
| **Conductor** | Decides which path to use, delegates to subagents, tracks progress |
| **Spec Writer** | Converts rough ideas into structured specs with goals, requirements, acceptance criteria |
| **Planning** | Reads codebase, produces step-by-step plan with file-level changes |
| **Implement** | TDD per task: RED → GREEN → REFACTOR |
| **Code Review** | Correctness, edge cases, code quality, error handling, performance |
| **Test** | Writes and runs tests, validates 85%+ coverage for new code |
| **Security** | OWASP Top 10 — injection, auth, data exposure, XSS, access control |
| **Docs** | Updates README and CHANGELOG, creates README if missing |

## Conventions

### Project Context File
Every project should have a context file that agents read first:

| Tool | File |
|---|---|
| Claude Code | `CLAUDE.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Cursor | `.cursorrules` |
| Any tool | `AGENTS.md` |

### Docs Folder
Plans, specs, EPICs, and bugs stored under `docs/`:

```
docs/
  plans/          # Feature specs (*-spec.md) and plans (*-plan.md)
  epics/          # Per-EPIC progress files
  epics-status.md # Single source of truth
  bugs/           # Bug reports (YYYY-MM-DD-slug.md)
  session/        # Session state for context recovery
```

### Commit Messages

```
<type>: short description (max 50 chars)

- bullet describing what changed
```

Types: `feat`, `fix`, `chore`, `test`, `refactor`, `docs`, `perf`, `security`
