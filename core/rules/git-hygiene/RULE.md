---
name: git-hygiene
description: Git workflow and repository hygiene best practices
version: 1.0.0
author: Latros.io
category: workflow
enforcement: warning
tags: [git, version-control, commits, branches, workflow]
---

# Git Hygiene Rule

Maintain clean git history and follow best practices for version control collaboration.

## Purpose

Clean git hygiene provides:
- **Clarity**: Understand what changed and why
- **Collaboration**: Easy for team members to review and understand
- **Debugging**: Git bisect and blame become powerful tools
- **Rollback**: Easier to revert specific changes
- **Professional**: Shows attention to detail and care

## Rules

### 1. Meaningful Commit Messages

**Severity**: Warning

**Rule**: Write clear, descriptive commit messages

**Format**: Conventional Commits (recommended)
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, no logic change)
- `refactor`: Code restructuring (no feature/fix)
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Example (Good)**:
```
feat(auth): add OAuth2 login support

Implement OAuth2 authentication flow with Google and GitHub providers.
Includes token refresh logic and session management.

Closes #123
```

```
fix(api): prevent race condition in user creation

Add transaction lock to prevent duplicate user records when
multiple requests arrive simultaneously.

The issue occurred when high traffic caused database timing issues.
Now using SELECT FOR UPDATE to ensure atomicity.
```

**Example (Bad)**:
```
fix stuff
```

```
Update
```

```
WIP
```

```
Fixed the thing that was broken
```

**Commit message guidelines**:
- Subject line: 50 characters or less
- Body: Wrap at 72 characters
- Use imperative mood ("Add feature" not "Added feature")
- Explain WHY, not just WHAT
- Reference issue/ticket numbers

### 2. No Large Files

**Severity**: Error

**Rule**: Don't commit large binary files or build artifacts

**Maximum size**: 50MB (configurable)

**What to avoid**:
- Build artifacts (node_modules, dist/, target/)
- Large media files without Git LFS
- Database dumps
- Log files
- OS-specific files (.DS_Store)

**Example (.gitignore)**:
```gitignore
# Dependencies
node_modules/
vendor/
.pnp/

# Build outputs
dist/
build/
target/
*.pyc
__pycache__/

# Environment and secrets
.env
.env.local
*.key
*.pem

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Testing
coverage/
.nyc_output/
```

**For large assets, use Git LFS**:
```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.psd"
git lfs track "*.mp4"

# Commit .gitattributes
git add .gitattributes
git commit -m "chore: add Git LFS tracking for large assets"
```

### 3. Proper .gitignore Configuration

**Severity**: Info

**Rule**: Configure .gitignore before committing code

**Check before first commit**:
```bash
# Generate .gitignore using gitignore.io
curl -L -s https://www.gitignore.io/api/node,python,go,java,rust > .gitignore

# Or use templates
npx gitignore node
```

**Common patterns by language**:

**Node.js/JavaScript**:
```gitignore
node_modules/
npm-debug.log
yarn-error.log
.env
dist/
build/
```

**Python**:
```gitignore
__pycache__/
*.py[cod]
.venv/
venv/
.pytest_cache/
.coverage
```

**Go**:
```gitignore
*.exe
*.test
*.out
vendor/
```

**Rust**:
```gitignore
target/
Cargo.lock
```

**Java**:
```gitignore
*.class
*.jar
target/
.gradle/
build/
```

### 4. Branch Naming Conventions

**Severity**: Info

**Rule**: Use descriptive branch names with consistent patterns

**Recommended patterns**:
```
feature/<description>    - New features
fix/<description>        - Bug fixes
hotfix/<description>     - Urgent production fixes
release/<version>        - Release preparation
chore/<description>      - Maintenance tasks
docs/<description>       - Documentation updates
```

**Examples (Good)**:
```
feature/user-authentication
fix/memory-leak-in-upload
hotfix/critical-security-patch
release/v2.1.0
chore/update-dependencies
```

**Examples (Bad)**:
```
new-feature
johns-branch
temp
fix
branch-2
```

**Branch naming rules**:
- Use lowercase and hyphens
- Be descriptive
- Include issue number if applicable: `feature/123-add-oauth`
- Keep reasonably short (< 50 characters)

### 5. No Force Push to Protected Branches

**Severity**: Critical

**Rule**: Never force push to main, master, or production branches

**Example**:
```bash
# CRITICAL - Never do this on main/master
git push --force origin main

# Good - force push only to feature branches
git push --force origin feature/my-work

# Good - use lease for safety on feature branches
git push --force-with-lease origin feature/my-work
```

**Set up branch protection**:
```bash
# Prevent force push to main
git config branch.main.pushRemote origin
git config receive.denyNonFastForwards true
```

**GitHub branch protection rules**:
- Require pull request reviews
- Require status checks
- Prevent force pushes
- Prevent deletions

### 6. Atomic Commits

**Severity**: Info

**Rule**: Each commit should represent one logical change

**Good - atomic commits**:
```bash
# Commit 1: Add new feature
git add src/feature.js src/feature.test.js
git commit -m "feat: add user profile feature"

# Commit 2: Update related documentation
git add docs/api.md
git commit -m "docs: add user profile API documentation"

# Commit 3: Update dependencies
git add package.json package-lock.json
git commit -m "chore: update lodash to v4.17.21"
```

**Bad - mixed changes**:
```bash
# Mixing multiple unrelated changes
git add src/feature.js src/unrelated-fix.js docs/api.md
git commit -m "updates"
```

**Benefits of atomic commits**:
- Easy to review
- Easy to revert specific changes
- Better for git bisect
- Clear history

### 7. Clean History Before Merging

**Severity**: Info

**Rule**: Clean up commits before merging to main

**Interactive rebase for cleanup**:
```bash
# Review last 3 commits
git rebase -i HEAD~3

# Options:
# pick - keep commit
# reword - change commit message
# squash - combine with previous
# fixup - combine and discard message
# drop - remove commit
```

**Example workflow**:
```bash
# Before merge - messy history
fix typo
WIP
add feature
fix bug
more fixes

# After squash/rebase - clean history
feat: add user authentication feature
```

**When to squash**:
- Multiple "WIP" or "fix typo" commits
- Cleaning up development process
- Before merging to main

**When NOT to squash**:
- Logically separate changes
- Already pushed to shared branch with collaborators
- History provides value for debugging

## Configuration

Customize in `.claude/rules/git-hygiene.config.json`:

```json
{
  "meaningful_commit_messages": {
    "min_length": 10,
    "format": "conventional_commits"
  },
  "no_large_files": {
    "max_size_mb": 50
  },
  "branch_naming_conventions": {
    "patterns": [
      "feature/<description>",
      "fix/<description>"
    ]
  },
  "no_force_push_protected": {
    "protected_branches": ["main", "master"]
  }
}
```

## Git Workflow Best Practices

### Daily Workflow

1. **Start with updated main**:
```bash
git checkout main
git pull origin main
```

2. **Create feature branch**:
```bash
git checkout -b feature/new-feature
```

3. **Make changes and commit**:
```bash
git add <files>
git commit -m "feat: descriptive message"
```

4. **Keep branch updated**:
```bash
git fetch origin
git rebase origin/main
```

5. **Push and create PR**:
```bash
git push -u origin feature/new-feature
# Create pull request via GitHub/GitLab
```

### Commit Often, Push Once

- Commit frequently during development
- Clean up commits before pushing
- Push clean, reviewed code

### Review Before Committing

```bash
# Check what's changed
git status
git diff

# Stage specific changes
git add -p  # Interactive staging

# Review staged changes
git diff --staged

# Commit with good message
git commit
```

## Integration with Git Workflow Skill

This rule works with the git-workflow skill:
- Automates branch creation with proper naming
- Enforces commit message format
- Checks for large files before commit
- Validates .gitignore completeness
- Prevents force push to protected branches

## Enforcement

Claude should:
1. **Check commit messages** for quality and format
2. **Warn about large files** before committing
3. **Verify .gitignore** is properly configured
4. **Validate branch names** follow conventions
5. **Prevent force push** to protected branches
6. **Suggest commit cleanup** before merging
7. **Recommend atomic commits** during development

## Tools and Hooks

### Pre-commit Hooks

```bash
# .git/hooks/pre-commit
#!/bin/bash

# Check commit message length
msg=$(cat "$1")
if [ ${#msg} -lt 10 ]; then
  echo "Commit message too short (min 10 chars)"
  exit 1
fi

# Check for large files
git diff --cached --name-only | while read file; do
  if [ -f "$file" ]; then
    size=$(du -m "$file" | cut -f1)
    if [ $size -gt 50 ]; then
      echo "File $file is too large ($size MB)"
      exit 1
    fi
  fi
done

# Check for secrets
if git diff --cached | grep -i "password\|api_key\|secret"; then
  echo "Possible secret detected in commit"
  exit 1
fi
```

### Commit Message Template

```bash
# ~/.gitmessage
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>

# Set as default template
git config --global commit.template ~/.gitmessage
```

## Common Mistakes to Avoid

1. **Commit messages**:
   - ❌ "fix", "update", "changes"
   - ✅ "fix(auth): prevent token expiry race condition"

2. **Branch names**:
   - ❌ "temp", "test", "johns-work"
   - ✅ "feature/oauth-integration"

3. **Commit size**:
   - ❌ 100 files changed in one commit
   - ✅ Logical groups of related changes

4. **Force pushing**:
   - ❌ `git push --force origin main`
   - ✅ `git push --force-with-lease origin feature/my-work`

5. **Ignored files**:
   - ❌ Committing node_modules, .env
   - ✅ Proper .gitignore before first commit

## Version History

**1.0.0** (2026-01-18)
- Initial release
- Commit message guidelines
- Branch naming conventions
- Large file prevention
- Force push protection
