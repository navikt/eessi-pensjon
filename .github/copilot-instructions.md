# Copilot Instructions — eessi-pensjon

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