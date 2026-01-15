---
name: code-style
description: Code formatting and style guidelines
version: 1.0.0
author: Latros.io
category: quality
enforcement: advisory
tags: [style, formatting, standards, quality]
---

# Code Style Rule

Maintain consistent code style across the project for improved readability, maintainability, and collaboration.

## Purpose

Consistent code style provides:
- **Readability**: Code is easier to read and understand
- **Maintainability**: Consistent patterns reduce cognitive load
- **Collaboration**: Team members can work on any part of the codebase
- **Code Review Efficiency**: Focus on logic, not formatting
- **Reduced Conflicts**: Fewer merge conflicts from formatting differences

## Guidelines

### 1. Indentation

**Rule**: Use spaces, not tabs (configurable)

**Default**: 2 spaces per indentation level

**Rationale**: Spaces display consistently across all editors and platforms

**Example**:
```javascript
// Good
function example() {
  if (condition) {
    doSomething();
  }
}

// Bad (tabs or inconsistent spaces)
function example() {
    if (condition) {
        doSomething();
    }
}
```

### 2. Line Length

**Rule**: Maximum line length (configurable)

**Default**: 100 characters

**Exceptions**:
- URLs
- Long string literals that shouldn't be split
- Import/require statements

**Rationale**: Improves readability, especially in side-by-side diffs

**Example**:
```javascript
// Good
const message =
  "This is a long message that has been split " +
  "across multiple lines for readability";

// Bad
const message = "This is a very long message that extends far beyond the recommended line length and becomes difficult to read";
```

### 3. Naming Conventions

**Variables and Functions**: camelCase
```javascript
let userName = "John";
function getUserData() { }
```

**Classes and Types**: PascalCase
```javascript
class UserAccount { }
type UserProfile = { };
```

**Constants**: UPPER_SNAKE_CASE
```javascript
const API_BASE_URL = "https://api.example.com";
const MAX_RETRY_COUNT = 3;
```

**Files**: kebab-case
```
user-profile.ts
api-client.js
test-utils.spec.js
```

**Private Members**: Leading underscore (optional)
```javascript
class Example {
  _privateMethod() { }
  publicMethod() { }
}
```

### 4. File Organization

**Standard order**:
1. Imports/requires (external first, then internal)
2. Type definitions/interfaces
3. Constants
4. Helper functions
5. Main functions/classes
6. Exports

**Example**:
```javascript
// 1. External imports
import React from 'react';
import axios from 'axios';

// 2. Internal imports
import { formatDate } from './utils';
import { UserType } from './types';

// 3. Constants
const API_URL = '/api/users';

// 4. Helper functions
function validateUser(user) { }

// 5. Main component
export function UserProfile() { }
```

### 5. Comments and Documentation

**When to comment**:
- Complex algorithms or business logic
- Non-obvious decisions (why, not what)
- Public API functions
- TODO items with context

**When NOT to comment**:
- Obvious code (let good names speak)
- Redundant explanations
- Commented-out code (use version control)

**Format**:
```javascript
// Single-line comment for brief notes

/**
 * Multi-line comment for function documentation
 * @param {string} userId - The user ID
 * @returns {Promise<User>} The user object
 */
function getUser(userId) { }

// TODO: Add error handling for network failures
```

### 6. Spacing and Braces

**Spaces around operators**:
```javascript
// Good
const sum = a + b;
if (x === y) { }

// Bad
const sum=a+b;
if(x===y){}
```

**Braces style** (K&R style):
```javascript
// Good
if (condition) {
  doSomething();
} else {
  doSomethingElse();
}

// Bad
if (condition)
{
  doSomething();
}
else
{
  doSomethingElse();
}
```

**Always use braces** (even for single statements):
```javascript
// Good
if (condition) {
  return true;
}

// Bad
if (condition) return true;
```

### 7. Imports and Exports

**Group and sort imports**:
```javascript
// External dependencies first
import React from 'react';
import axios from 'axios';

// Internal dependencies second
import { Component } from './components';
import { utils } from './utils';

// CSS/assets last
import './styles.css';
```

**Prefer named exports**:
```javascript
// Good
export function myFunction() { }
export const MY_CONSTANT = 42;

// Acceptable for main module export
export default class MainComponent { }
```

### 8. Error Handling

**Use explicit error handling**:
```javascript
// Good
try {
  const data = await fetchData();
  return processData(data);
} catch (error) {
  logger.error('Failed to fetch data:', error);
  throw new DataFetchError('Unable to retrieve data');
}

// Bad
const data = await fetchData(); // No error handling
```

### 9. Modern Syntax

**Prefer modern JavaScript/TypeScript**:
```javascript
// Good
const { name, email } = user;
const items = [...oldItems, newItem];
const result = await fetchData();

// Avoid
var name = user.name;
var email = user.email;
items = oldItems.concat([newItem]);
fetchData().then(result => { });
```

## Configuration

Customize in `.claude/rules/code-style.config.json`:

```json
{
  "indent": "2spaces",
  "max_line_length": 100,
  "naming_convention": "camelCase",
  "quote_style": "single",
  "trailing_commas": true,
  "semicolons": true,
  "brace_style": "1tbs"
}
```

### Available Options

**indent**:
- `"2spaces"` (default)
- `"4spaces"`
- `"tabs"`

**max_line_length**:
- `80`, `100` (default), `120`, `140`

**naming_convention**:
- `"camelCase"` (default)
- `"snake_case"`
- `"PascalCase"`

**quote_style**:
- `"single"` (default)
- `"double"`

## Enforcement

Claude should:
1. **Follow these guidelines** when writing code
2. **Suggest fixes** for style violations during code review
3. **Respect existing project style** if different from defaults
4. **Note style issues** in pull request reviews
5. **Not block functionality** - style is advisory, not blocking

## Integration with Tools

**Recommended formatters**:
- **JavaScript/TypeScript**: Prettier, ESLint
- **Python**: Black, flake8
- **Go**: gofmt, golint
- **Rust**: rustfmt
- **Other**: EditorConfig for consistency

**Pre-commit hooks**:
```bash
# Run formatter before commit
npx prettier --write .
git add .
```

## Exceptions

Style rules can be relaxed for:
- **Generated code**: Note in comments that code is auto-generated
- **Third-party code**: Keep original style, note source
- **Migration periods**: Document transition plan
- **Performance-critical code**: Document why style differs
- **External API constraints**: Match external conventions

## Language-Specific Notes

### JavaScript/TypeScript
- Use semicolons (unless project explicitly avoids them)
- Prefer `const` over `let`, avoid `var`
- Use arrow functions for callbacks
- Prefer template literals over concatenation

### Python
- Follow PEP 8
- 4 spaces for indentation
- Maximum line length: 79 characters (code), 72 (docstrings)
- Use type hints

### Other Languages
- Follow community standards (Go: gofmt, Rust: rustfmt)
- When in doubt, match existing project style

## Examples

See `examples/good-vs-bad.md` for comprehensive before/after examples.

## Notes

- Style guidelines are **advisory**, not mandatory
- **Consistency within a file** is more important than perfect adherence
- **Team consensus** takes precedence over these defaults
- **Existing project conventions** should be respected
- Use automated formatters when available to enforce consistency
