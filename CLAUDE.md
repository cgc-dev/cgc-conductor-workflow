# CLAUDE.md

> This file is automatically loaded by Claude Code in every conversation for this project.
> It defines coding standards, conventions, and behavioral rules that Claude must follow.
>
> **TEMPLATE INSTRUCTIONS** — Two steps to customize this for your project:
>
> 1. Fill in the **"Project-Specific Standards"** section below with your tech stack and coding rules.
> 2. Delete any technology sections from the **"Technology Guidelines"** section that don't apply,
>    and keep (or expand) the ones that do.
>
> The **"Universal Rules"** section applies to every project and should not be removed.

---

## Project-Specific Standards

> **TEMPLATE:** Fill this in once the project tech stack and conventions are decided.
> This is what Claude reads first to understand your project's specific context.

### Tech Stack

> Replace with your actual stack:
- **Language/Runtime:**
- **Framework:**
- **Key Libraries:**
- **Test Framework:**

### Coding Conventions

> Add project-specific rules here. Examples:
> - "Use the Result pattern for all error handling — never throw exceptions in service methods"
> - "All database queries must go through the repository layer — no raw SQL in controllers"
> - "Component filenames are PascalCase; all other files are kebab-case"

### Architecture Decisions

> Document significant decisions that Claude should be aware of. Examples:
> - "We use CQRS — reads and writes go through separate handlers"
> - "All API responses follow the envelope format: `{ data, error, meta }`"
> - "Authentication is handled by Azure AD — never implement custom auth"

---

## Technology Guidelines

> **TEMPLATE:** Keep only the sections relevant to your project. Delete the rest.
> These sections are examples drawn from common CGC project patterns.
> Add new sections for technologies not listed here.

### Angular
> *Keep this section if the project uses Angular.*

- Use standalone components (Angular 17+) unless modules are explicitly required
- Use Angular Signals (`signal()`, `computed()`, `effect()`) for reactive state — prefer over RxJS Subject for UI state
- Use `input()`, `output()`, `viewChild()` functions (Angular 19+) instead of decorators
- Use `HttpClient` with proper typing for API calls; handle errors with global interceptors
- Use `OnPush` change detection for performance-critical components
- Follow the [Angular Style Guide](https://angular.dev/style-guide) for file naming and structure

### React
> *Keep this section if the project uses React.*

- Functional components with hooks only — no class components
- Use `useState` / `useReducer` for local state; React Query or SWR for server state
- Use `useEffect` with proper dependency arrays; always return cleanup functions
- Use `React.memo`, `useMemo`, `useCallback` judiciously — profile before optimizing
- Implement code splitting with `React.lazy` and `Suspense` for route-level components

### .NET (SDK-style / modern)
> *Keep this section if the project uses .NET 6+.*

- Use `async`/`await` throughout — never `.Result`, `.Wait()`, or `.GetAwaiter().GetResult()`
- Always `ConfigureAwait(false)` in library/infrastructure code
- Use the built-in DI container; constructor injection only
- Use records for immutable data transfer objects
- Follow DDD layering: Domain → Application → Infrastructure; never skip layers

### .NET Framework (legacy)
> *Keep this section only if the project uses .NET Framework (not .NET 6+).*

- Build with `msbuild /t:rebuild` — not `dotnet build`
- All new `.cs` files MUST be added to the `.csproj` with an explicit `<Compile Include="..." />` entry
- C# language version is **7.3** — avoid all C# 8.0+ features (records, nullable reference types, switch expressions, `??=`, range operators, etc.)
- Do NOT install or update NuGet packages — ask the developer to do so via Visual Studio Package Manager
- Always `ConfigureAwait(false)` in library code; never use `.Result` or `.Wait()`

### DDD / Domain-Driven Design
> *Keep this section if the project uses DDD patterns.*

**Before any implementation, explicitly state:**
1. Which DDD patterns apply and which layer(s) are affected
2. The aggregate boundaries and ubiquitous language terms involved
3. Which domain events will be raised and how consistency is maintained

**Layer rules:**
- Business logic belongs in the **Domain layer** — not in controllers, services, or handlers
- **Application layer** orchestrates domain operations and handles validation of incoming DTOs
- **Infrastructure layer** holds repositories, event bus, ORM mappings, external adapters
- Never let infrastructure concerns leak into the domain layer

**Testing:** Use `MethodName_Condition_ExpectedResult()` naming for all test methods. Minimum 85% coverage for domain and application layers.

**Financial calculations:** Use `decimal` for all monetary values. Implement saga patterns for distributed transactions. All financial operations must emit domain events for audit trail.

### Azure DevOps Pipelines
> *Keep this section if the project uses Azure DevOps CI/CD.*

- Use 2-space indentation throughout YAML files
- Always include `displayName` for every stage, job, and step
- Use variable groups and Azure Key Vault for secrets — never hardcode sensitive values
- Separate build and deployment into distinct stages
- Implement environment promotion: dev → staging → production with approval gates
- Use path filters on triggers to avoid unnecessary builds

---

## Universal Rules

> These rules apply to every project. Do not remove them.

### Code Comments

**Write code that speaks for itself. Comment only to explain WHY, not WHAT.**

Avoid:
- Obvious comments that restate the code
- Redundant comments repeating what the identifier already says
- Changelog or attribution comments (use git blame)
- Commented-out dead code (delete it; git history preserves it)
- Decorative divider comments

Write comments only when:
- A non-obvious business rule or constraint must be explained
- An algorithm choice needs justification
- A regex pattern needs human-readable explanation
- An external API quirk or workaround is being applied
- Using annotation keywords: `TODO`, `FIXME`, `HACK`, `NOTE`, `WARNING`, `PERF`, `SECURITY`, `DEPRECATED`

### Documentation Updates

**Trigger:** Whenever source code changes modify business logic, API endpoints, configuration parameters, or public interfaces.

1. Check that `README.md` exists at the project root. If missing, create it immediately using the four-question structure: *What is this? / Why does this exist? / How do I use/run it? / When should I use this?*
2. Update the relevant README section to reflect the change — no "TODO" placeholders.
3. Append an entry to `CHANGELOG.md` under `[Unreleased]` using the appropriate change type (`Added`, `Changed`, `Fixed`, etc.).

Every response or commit message where docs were updated must state:
> "✅ Enforced Documentation Policy: [Created/Updated] README.md."

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: short description (max 50 chars)

- bullet describing what changed
- bullet describing what changed
```

Types: `feat`, `fix`, `chore`, `test`, `refactor`, `docs`, `perf`, `security`

Do not reference internal plan or EPIC numbers in commit messages.

### Security

- Never hardcode credentials, API keys, or secrets in source files
- Validate all input at system boundaries (user input, external API responses)
- Apply the principle of least privilege to all roles and service accounts
- Run the `security-subagent` automatically whenever changes touch: auth/authorization, tokens/sessions, user input written to storage, file upload/download endpoints, CORS/CSP config, or environment variable handling
