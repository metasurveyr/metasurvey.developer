---
description: Commit changes grouped by feature, update NEWS.md and bump version when needed
---

You are a release engineer for the `metasurvey` R package. Your job is to analyze all pending changes, group them into logical feature-based commits, and when the changes are significant enough, update `NEWS.md` and bump the version in `DESCRIPTION`.

## Step 1: Analyze all pending changes

Run these commands to understand the full scope of changes:

```bash
git status
git diff --stat
git diff          # unstaged changes
git diff --cached # staged changes
git log --oneline -10  # recent commit history for style reference
```

## Step 2: Classify changes into feature groups

Read every modified file and classify changes into **feature groups**. Each group becomes ONE commit. Classification rules:

| Priority | Group Type | Prefix | Example |
|----------|-----------|--------|---------|
| 1 | Critical bug fix | `fix:` | `fix: remove record=FALSE from bake_step causing recode crash` |
| 2 | Security fix | `security:` | `security: sanitize API error messages, validate IDs` |
| 3 | New feature | `feat:` | `feat: add debounce on search input` |
| 4 | Performance | `perf:` | `perf: remove double copy in compute/recode` |
| 5 | Refactor | `refactor:` | `refactor: use new.env() in bake_recipes` |
| 6 | Test updates | `test:` | `test: update api_client tests for new behavior` |
| 7 | Documentation | `docs:` | `docs: add examples to exported functions` |
| 8 | Chore/config | `chore:` | `chore: bump version to 0.0.7` |

### Grouping rules

- **Group by logical feature**, not by file. If fixing `bake_step` requires changes in `R/Step.R` AND `R/steps.R`, that's ONE commit.
- **Tests go with their feature** when the test was written/modified to support a specific code change. Only separate test commits if they're independent additions (coverage, new test scenarios).
- **Documentation goes with its feature** when the doc change is part of the same logical unit (e.g., updating roxygen for a renamed param). Only separate docs commits if they're standalone doc improvements.
- **Never mix unrelated features** in one commit, even if they're in the same file.
- **Order commits** so dependencies come first (e.g., a core fix before the tests that verify it).

## Step 3: Decide if NEWS.md and version bump are needed

Update NEWS.md and bump version when ANY of these are true:

- Bug fixes that affect user-visible behavior
- New features or API changes
- Security fixes
- Breaking changes
- Performance improvements users would notice

Do NOT update NEWS/version for:

- Internal-only refactors with no behavior change
- Typo fixes
- Test-only changes
- CI/config changes

### NEWS.md format

Follow the existing structure in `NEWS.md`:

```markdown
# metasurvey X.Y.Z

## Breaking changes
* Description of breaking change.

## New features
* Description of new feature.

## Bug fixes
* Description of bug fix.

## Security
* Description of security improvement.

## Performance
* Description of performance improvement.

## Documentation
* Description of documentation change.

## Internal
* Description of internal change.
```

Only include sections that have entries. Use past tense or imperative mood consistently. Each bullet should be a single concise sentence.

### Version bump rules (semver)

- **Patch** (0.0.X → 0.0.X+1): bug fixes, security patches, performance improvements
- **Minor** (0.X.0 → 0.X+1.0): new features, non-breaking API additions
- **Major** (X.0.0 → X+1.0.0): breaking changes (rare pre-1.0)

For pre-1.0 packages (like metasurvey), use **patch** for most changes and **minor** only for significant new features.

## Step 4: Execute the commits

For each feature group, in dependency order:

1. Stage ONLY the files belonging to that group: `git add file1.R file2.R`
2. Commit with a clear message following the format:
   ```
   type: concise description of the change

   - Detail 1
   - Detail 2

   Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
   ```
3. The first line must be under 72 characters
4. Body bullets explain WHAT changed, not HOW (code speaks for itself)

If NEWS.md/DESCRIPTION need updating:
- Make the version bump + NEWS.md update the **LAST commit**: `chore: bump version to X.Y.Z`
- This commit contains ONLY `DESCRIPTION` and `NEWS.md`

## Step 5: Summary report

After all commits, show:

```
## Commits created

1. `abc1234` fix: description
2. `def5678` perf: description
3. `ghi9012` chore: bump version to 0.0.7

## Files touched
- R/Step.R (fix)
- R/steps.R (perf)
- NEWS.md (chore)
- DESCRIPTION (chore)

## Version: 0.0.6 → 0.0.7
```

## Important rules

- **NEVER commit files that contain secrets** (.env, credentials, tokens). Warn if found.
- **NEVER use `git add -A` or `git add .`** — always stage specific files.
- **NEVER amend previous commits** unless explicitly asked.
- **NEVER push** unless explicitly asked.
- **Run `Rscript -e 'devtools::document()'`** before committing if any roxygen comments changed.
- **Run `Rscript -e 'devtools::test()'`** before the first commit to verify nothing is broken. If tests fail, STOP and report.
- Use HEREDOC syntax for commit messages to preserve formatting.
