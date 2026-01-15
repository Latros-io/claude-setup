---
name: git-workflow
description: Automated git operations including commits, branching, and PR creation
version: 1.0.0
author: Latros.io
category: version-control
tags: [git, workflow, automation]
---

# Git Workflow Skill

Automated git operations following best practices and conventional commit standards.

## When to Use This Skill

Invoke this skill when:
- User asks to commit changes
- User wants to create a new branch
- User requests a pull request
- User mentions git operations (merge, rebase, tag, etc.)
- User asks for commit message suggestions

## Invocation

Claude should automatically use this skill when git operations are requested. The skill provides:
- Structured commit message templates
- Pull request templates and automation
- Branch naming conventions
- Git best practices guidance

## Dependencies

### Required
- **MCP Server**: `github` - For PR creation and repository operations
- **Agent**: `Bash` - For executing git commands

### Optional
- **Rule**: `code-style` - For pre-commit style validation

## Configuration

Default settings (customizable in `.claude/skills/git-workflow.config.json`):

- `commit_style`: "conventional" - Use conventional commit format
- `auto_pr_template`: true - Automatically populate PR descriptions
- `branch_naming`: "feature/{description}" - Branch naming pattern

## Conventional Commit Format

Follow the conventional commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, missing semi colons, etc)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvements
- `test`: Adding or correcting tests
- `chore`: Changes to build process or auxiliary tools

### Scope
Optional, indicates the section of the codebase affected (e.g., auth, api, ui)

### Subject
Brief description of the change (imperative mood, no capitalization, no period)

### Body
Optional, detailed explanation of the change

### Footer
Optional, references to issues, breaking changes, etc.

## Usage Examples

### Example 1: Creating a Commit

**User**: "Commit these authentication changes"

**Claude**:
1. Runs `git status` to see changes
2. Reviews the diff to understand modifications
3. Generates conventional commit message:
   ```
   feat(auth): add OAuth2 authentication

   - Implement OAuth2 authorization flow
   - Add token refresh mechanism
   - Update user model with OAuth fields
   - Add integration tests for auth flow

   Closes #123
   ```
4. Executes commit with proper formatting

### Example 2: Creating a Pull Request

**User**: "Create a PR for this feature"

**Claude**:
1. Checks current branch and commits
2. Reviews changes since branching from main
3. Generates PR description using template
4. Creates PR via GitHub MCP server

## Pull Request Template

Default PR template (from `templates/pr-template.md`):

```markdown
## Summary
Brief description of changes

## Changes
- List of key changes
- Bullet points for each major modification

## Testing
- How these changes were tested
- Test cases added/modified

## Screenshots (if applicable)
Visual changes

## Checklist
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Code reviewed
```

## Branch Naming Conventions

Default pattern: `{type}/{description}`

Types:
- `feature/` - New features
- `fix/` - Bug fixes
- `hotfix/` - Urgent production fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation updates
- `test/` - Test additions/modifications

Examples:
- `feature/oauth-authentication`
- `fix/user-login-error`
- `docs/api-endpoints`

## Integration with Other Components

### With code-style Rule
- Validates code style before committing
- Suggests fixes if style violations detected
- Can auto-format code before commit (if configured)

### With GitHub MCP Server
- Creates pull requests programmatically
- Links commits to issues
- Manages branch protection rules
- Fetches PR templates from repository

### With Bash Agent
- Executes all git commands safely
- Handles errors and provides clear feedback
- Manages authentication and credentials

## Error Handling

Common errors and resolutions:

**Merge Conflicts**:
- Detect conflicts during merge/rebase
- Guide user through resolution
- Provide conflict markers explanation

**Uncommitted Changes**:
- Detect unstaged changes
- Prompt user to stage or stash
- Suggest appropriate action

**Authentication Failures**:
- Check GitHub token validity
- Guide through token configuration
- Suggest SSH key setup

## Best Practices

1. **Commit Frequency**: Small, focused commits over large monolithic ones
2. **Commit Messages**: Clear, descriptive, following conventions
3. **Branch Strategy**: Feature branches off main, regular rebasing
4. **Code Review**: Always create PRs for review before merging
5. **Clean History**: Squash or rebase before merging to maintain clean history

## Notes

- This skill respects existing repository conventions
- Can be customized per-project via configuration
- Integrates with CI/CD pipelines through commit hooks
- Supports both HTTPS and SSH authentication
