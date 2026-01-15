# Project Code Style Guide

This document defines the code style standards for this project.

## Quick Reference

- **Indentation**: 2 spaces
- **Line Length**: 100 characters
- **Quotes**: Single quotes
- **Semicolons**: Required
- **Naming**: camelCase for variables/functions, PascalCase for classes

## Indentation

```
Spaces per level: 2
Use tabs: No
```

## Line Length

```
Maximum: 100 characters
Exceptions: URLs, long strings, imports
```

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Variables | camelCase | `userName` |
| Functions | camelCase | `getUserData()` |
| Classes | PascalCase | `UserAccount` |
| Constants | UPPER_SNAKE_CASE | `API_BASE_URL` |
| Files | kebab-case | `user-profile.js` |

## File Organization

Standard order for file contents:

1. Imports (external, then internal)
2. Type definitions
3. Constants
4. Helper functions
5. Main functions/classes
6. Exports

## Comments

- Use `//` for single-line comments
- Use `/** */` for function documentation
- Explain **why**, not **what**
- No commented-out code (use git)

## Braces and Spacing

- K&R brace style (opening brace on same line)
- Always use braces, even for single statements
- Space around operators: `a + b`, not `a+b`
- Space after keywords: `if (`, not `if(`

## Imports

- Group by: external, internal, assets
- Sort alphabetically within groups
- Use named exports when possible

## Error Handling

- Always handle errors explicitly
- Use try/catch for async operations
- Provide meaningful error messages
- Log errors appropriately

## Modern Syntax

- Use `const`/`let`, not `var`
- Prefer arrow functions for callbacks
- Use template literals for string interpolation
- Destructure objects and arrays
- Use `async`/`await` over `.then()`

## Tools

Recommended formatters and linters:
- Prettier (formatting)
- ESLint (linting)
- EditorConfig (consistency)

## Customization

Project-specific deviations from standard style:

```
(Document any project-specific style decisions here)
```

## Resources

- Full style guide: `.github/rules/code-style/RULE.md`
- Examples: `.github/rules/code-style/examples/good-vs-bad.md`
- Configuration: `.claude/rules/code-style.config.json`

---

*This style guide is generated from the code-style rule. Customize it for your project's needs.*
