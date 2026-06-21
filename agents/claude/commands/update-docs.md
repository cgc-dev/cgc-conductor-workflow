---
description: Enforce README.md update after any code logic change
---

# Documentation Enforcement

> **CRITICAL INSTRUCTION:** This skill is **NON-NEGOTIABLE**. You are prohibited from completing a logic change without ensuring the `README.md` is accurate and present.

## 1. Trigger
Activate this skill **immediately** upon detecting any edit to source code that modifies:
- Business logic or algorithms
- API endpoints (requests/responses)
- Configuration parameters
- Public interfaces (class/method signatures)

## 2. Mandatory Pre-Check (Creation Protocol)
Before analyzing changes, check the root directory for a file named `README.md`.

- **IF `README.md` EXISTS:** Proceed to Section 3.
- **IF `README.md` IS MISSING:** You **MUST** create it immediately using this exact structure:

```markdown
# [Project Name]

## 1. What is this?
[Briefly describe what the application or module does. List core features.]

## 2. Why does this exist?
[Explain the problem it solves. Why was this specific technical approach chosen?]

## 3. How do I use/run it?
### Installation
[Steps to install dependencies]
### Configuration
[Environment variables or config settings]
### Usage
[Code examples or run commands]

## 4. When should I use this? (Status & Roadmap)
[Current state (Alpha/Beta/Prod). Known limitations. When to pick this tool over alternatives.]
```

## 3. Analysis & Update
Compare your code changes against the `README.md`.

1. **Identify Discrepancy:** Pinpoint exactly what new behavior is missing from the docs.
2. **Update Text:**
   - If you created a new README in Step 2, fill in the details now.
   - If the README existed, append or modify the relevant section.
   - Do not leave placeholder text like "TODO" regarding the new feature. Write the actual documentation.

## 4. Verification & Commit
You are not authorized to finish the turn until:
1. `README.md` exists.
2. The content of `README.md` reflects the latest logic change.

**Final Output Requirement:**
Your final response or commit message **must** explicitly state:
> "✅ Enforced Documentation Policy: [Created/Updated] README.md."
