# Conventional Commit Message Template

## Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

## Type

Choose one:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process or tool changes

## Scope

The section of the codebase affected (e.g., `auth`, `api`, `ui`, `db`)

## Subject

- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize first letter
- No period at the end
- Maximum 50 characters

## Body

- Explain what and why, not how
- Wrap at 72 characters
- Separate from subject with blank line
- Use bullet points for multiple changes

## Footer

- Reference issues: `Closes #123`, `Fixes #456`
- Note breaking changes: `BREAKING CHANGE: description`

## Examples

### Simple Feature
```
feat(auth): add password reset functionality
```

### Bug Fix with Details
```
fix(api): prevent race condition in user creation

- Add transaction locking to user creation endpoint
- Validate email uniqueness before insert
- Add integration test for concurrent requests

Fixes #789
```

### Breaking Change
```
refactor(api): change authentication response format

Update API response to use camelCase instead of snake_case
for consistency with frontend conventions.

BREAKING CHANGE: Authentication endpoint now returns
`accessToken` instead of `access_token`
```

### Documentation Update
```
docs(readme): update installation instructions

- Add prerequisites section
- Include troubleshooting steps
- Update Node.js version requirement
```
