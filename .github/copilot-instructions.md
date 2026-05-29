# Copilot Instructions — eessi-pensjon

## Repository Overview

This is a **meta-repo** (using [meta](https://github.com/mateodelnorte/meta)) that contains all EESSI Pensjon applications, libraries, and tools as included builds. Each subdirectory is its own Git repository with its own CI/CD pipeline.

**Architecture documentation:** See `architecture.md` in the root — it's the single source of truth for how the system fits together.

When you need to check implementation details for EESSI Pensjon, look first at the local cloned repos directly under eessi-pensjon (i.e. this project).
Assume that the repos are pulled with latest main/master code. 
If you need to check the state of a repo that is not cloned here, check the relevant repo on GitHub. 
If you need to check the state of a repo that is not part of EESSI Pensjon, check the relevant repo on GitHub.
The architecture document provides an overview and points to the relevant repos for each component.

## Writing guidelines

- Be concise. This document is read by both humans and AI assistants.
- Be precise about which services a statement applies to. Never say "all services do X" unless it is actually true for every single one.
- When describing patterns, always list the specific applications that use that pattern.
- Verify EU/EESSI terminology against official European Commission sources before introducing new terms.
- Keep the architecture diagram in sync with the application tables.
- Do not include specific version numbers for dependencies (e.g. "Spring Boot 4.0.3") — these change frequently. Use "Spring Boot" or link to eux-parent-pom instead. The exception is the eux-parent-pom entry itself, where the current version is useful context.
- Do not add information you cannot verify from the actual source repositories. When in doubt, check the repo.
- 
## Tech Stack

### Backend (Kotlin/Java)

- **Language:** Kotlin (primary) / Java — JDK 21
- **Framework:** Spring Boot 4.x with Spring Kafka
- **Build:** Gradle (Groovy DSL, `build.gradle`)
- **Testing:** JUnit 5, MockK, SpringMockK, ArchUnit (architecture tests)
- **Deployment:** NAIS (Kubernetes on GCP), configured via `nais.yaml` / `.nais/`

### Frontend (TypeScript/React)

- **App:** `eessi-pensjon-saksbehandling-ui`
- **Language:** TypeScript
- **Framework:** React 19, Redux Toolkit, React Router 7
- **Design system:** NAV Aksel 8 (`@navikt/ds-react`, `@navikt/aksel-icons`)
- **Build:** Vite
- **Testing:** Jest (migration to Vitest in progress)

### Internal Libraries (ep-*)

- `ep-logging`, `ep-metrics`, `ep-eux`, `ep-kodeverk`, `ep-personoppslag`, `ep-routing`
- Published to GitHub Packages, consumed by applications via Gradle

## Coding Conventions

### Kotlin / Backend

- Follow existing patterns in each project — they are consistent within a project
- Use Spring's constructor injection (Kotlin primary constructors)
- Prefer immutable data: `data class` and `val`
- Package structure: `no.nav.eessi.pensjon.<app>.<feature>`
- REST controllers return `ResponseEntity` or domain objects
- Kafka listeners in dedicated `listener/` packages
- Configuration in `application.yml` with NAIS env var substitution

### TypeScript / Frontend

- Functional components with hooks
- Redux Toolkit for state management (`createSlice`, `createAsyncThunk`)
- NAV Aksel components for all UI — do not use raw HTML elements where Aksel has an equivalent
- File naming: PascalCase for components, camelCase for utils/hooks
- Translations via `react-i18next`
- Tests co-located with source files (`Component.test.tsx`)

## Git Commit Messages — Arlo's Commit Notation (Modified)

All commits in this repository **must** use our modified version of [Arlo's Commit Notation](https://github.com/RefactoringCombos/ArlosCommitNotation). Each commit message starts with an intention prefix, a risk separator, and a short summary.

### Format

```
<intention><risk separator> <Short summary>
```

### Risk separators

| Separator | Meaning | Example |
|-----------|---------|---------|
| ` - ` | Proven safe | `r - Extract method calculatePension` |
| `! - ` | Risky | `R! - Refactor auth flow` |
| `!! ` | Very risky | `F!! Add untested SED editor` |

### Intention prefixes

Use **lowercase** for safe, non-behaviour-changing work. Use **UPPERCASE** for behaviour-impacting or higher-risk work.

| Prefix | Meaning | Description |
|--------|---------|-------------|
| `f/F` | Feature | Changes or extends one aspect of program behaviour |
| `b/B` | Bugfix | Repairs undesirable behaviour without altering others |
| `r/R` | Refactoring | Changes implementation without changing behaviour |
| `d/D` | Documentation | Changes documentation or comments only |
| `e/E` | Environment | **Manual** changes to build, CI, dependencies, or tooling |
| `u/U` | Update | **Automatic** bumps and environment updates (auto-merge, dependency bots) |
| `t/T` | Test | Adds or modifies tests only |

### Examples

```
r - Extract method calculatePension
R! - Refactor EUX controller endpoints to use FrontendResponse
F!! Add untested SED editor
b - Fix null check in country filter
d - Update README with build instructions
e - Upgrade React to v19
u - Auto-bump @navikt/ds-react to 7.2.0
t - Add missing unit tests for buc reducer
```

### Rules

- The prefix and risk separator are **mandatory** on every commit.
- When multiple intentions apply, use the **riskiest** one.

## Key Considerations

- **Adressebeskyttelse:** EP handles sensitive persons (kode 6/7). All code touching person data must respect access restrictions. See `eessi-pensjon-begrens-innsyn`.
- **EESSI/RINA:** Documents are SEDs (Structured Electronic Documents) exchanged in BUCs (Business Use Cases). Understand the domain model before making changes.
- **Kafka:** Most inter-service communication uses Kafka topics. Events are processed asynchronously.
- **Testing pyramid:** Unit tests are mandatory. Integration tests use `@SpringBootTest` with MockK. ArchUnit enforces architectural rules.
- **Norwegian context:** UI text and domain terminology is in Norwegian. Code and comments are in English (except domain terms like "journalføring", "oppgave", "saksbehandler").