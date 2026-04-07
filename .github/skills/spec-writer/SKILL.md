---
name: spec-writer
description: "Turns raw inputs (bullet points, one-liners, rough notes, or longer descriptions) into a structured feature spec (PRD) with goals, requirements, and acceptance criteria. Use when: you have a raw idea and need a spec before planning or coding. Saves to docs/plans/. Asks only when critically ambiguous, otherwise infers and writes."
argument-hint: "Paste or describe your raw idea, notes, or requirements here"
---

# Spec Writer

Converts raw inputs — any shape, any level of detail — into a clean, structured feature spec that humans can review and agents can follow.

**Announce at start:** "I'm using the spec-writer skill to turn your input into a spec."

## When to Use

- You have a rough idea, bullet dump, or vague one-liner
- You need a PRD or feature spec before writing an implementation plan
- You want to capture requirements before handing off to a planning or dev agent

## Procedure

### Step 1 — Read project context

Check these files for background before writing anything:
- `AGENTS.md` — tech stack, conventions, team structure
- `docs/README.md` — project structure and existing artifacts
- Recent files in `docs/plans/` — for style and naming reference

### Step 2 — Parse the raw input

Identify:
- **Core intent**: what does the user want to build or change?
- **Scope signals**: any hints about what's included or excluded?
- **Implied constraints**: tech stack, users, timeline, integrations?

### Step 3 — Ask only if critically ambiguous

Ask **at most one question** if any of these remain unclear after reading context:
- Who is the end user?
- What is the primary success metric?
- Is there a hard technical or business constraint?

Do **not** ask about things that can be reasonably inferred. Make an explicit assumption instead and document it in the spec.

### Step 4 — Write the spec

Use the [spec template](./assets/spec-template.md). Fill in every section — never leave one empty. If uncertain about a section, state the assumption explicitly rather than skipping it.

### Step 5 — Present for review

Show the spec inline first. Ask: "Does this capture what you had in mind?"

Iterate based on feedback before saving to disk.

### Step 6 — Save

Save to: `docs/plans/YYYY-MM-DD-<feature-slug>-spec.md`

After saving, suggest the next step based on the user's goal:

| If the user wants to... | Suggest... |
|-------------------------|------------|
| Build immediately with full orchestration | "Hand this to the **Conductor** agent — it will pick up the spec automatically from `docs/plans/` and skip straight to planning." |
| Write a detailed plan first | "Use the **`writing-plans`** skill to break this spec into tasks." |
| Just keep the spec for now | "Spec saved. Come back with the **Conductor** or **`writing-plans`** when ready." |

---

## Spec Quality Rules

- **Goal**: One paragraph, no jargon. A non-technical reader must understand it.
- **Requirements**: Each req starts with a verb. Must be testable. Avoid "should maybe."
- **Acceptance Criteria**: Binary pass/fail. No subjective language like "should feel fast."
- **Out of Scope**: At least one item. Forces explicit scope decisions.
- **Assumptions**: All inferences documented here. Agents must not guess what you assumed.
- **Open Questions**: Not optional — if anything is genuinely unresolved, list it.

## Anti-Patterns

- Do NOT write the spec without reading project context first
- Do NOT combine multiple unrelated features into one spec
- Do NOT ask more than one clarifying question before writing — infer the rest
- Do NOT leave sections empty — use the Assumptions section to cover uncertainty
