---
name: documentation
description: Documentation standards for code and project maintainability
version: 1.0.0
author: Latros.io
category: quality
enforcement: warning
tags: [documentation, comments, readme, api-docs, maintainability]
---

# Documentation Rule

Ensure code and projects are properly documented for maintainability, onboarding, and collaboration.

## Purpose

Comprehensive documentation provides:
- **Maintainability**: Understand code months or years later
- **Onboarding**: New team members get up to speed quickly
- **Collaboration**: Clear interfaces and expectations
- **API Usability**: Users understand how to use your code
- **Decision Context**: Preserve reasoning behind non-obvious choices

## Rules

### 1. Public API Documentation

**Severity**: Error

**Rule**: All public APIs must be documented

**Required elements**:
- Description of what it does
- Parameter types and descriptions
- Return value and type
- Exceptions/errors thrown
- Usage examples

**Example (JavaScript/TypeScript)**:
```javascript
/**
 * Fetches user data from the database by user ID
 *
 * @param {string} userId - The unique identifier for the user
 * @param {Object} options - Optional configuration
 * @param {boolean} options.includeDeleted - Include soft-deleted users
 * @returns {Promise<User>} The user object
 * @throws {NotFoundError} When user does not exist
 * @throws {DatabaseError} When database connection fails
 *
 * @example
 * const user = await getUser('user-123');
 * console.log(user.name);
 *
 * @example
 * const user = await getUser('user-123', { includeDeleted: true });
 */
async function getUser(userId, options = {}) {
  // Implementation
}

// Bad - no documentation
async function getUser(userId, options = {}) {
  // Implementation
}
```

**Example (Python)**:
```python
def get_user(user_id: str, include_deleted: bool = False) -> User:
    """
    Fetches user data from the database by user ID.

    Args:
        user_id: The unique identifier for the user
        include_deleted: Include soft-deleted users (default: False)

    Returns:
        User object containing user data

    Raises:
        NotFoundError: When user does not exist
        DatabaseError: When database connection fails

    Examples:
        >>> user = get_user('user-123')
        >>> print(user.name)

        >>> user = get_user('user-123', include_deleted=True)
    """
    # Implementation
```

### 2. README Requirements

**Severity**: Warning

**Rule**: Every project must have a comprehensive README

**Required sections**:
- Project overview and purpose
- Installation/setup instructions
- Usage examples
- API documentation or link to docs
- Contributing guidelines
- License information

**Minimum viable README**:
```markdown
# Project Name

Brief description of what this project does and why it exists.

## Installation

\`\`\`bash
npm install project-name
\`\`\`

## Usage

\`\`\`javascript
import { feature } from 'project-name';

const result = feature();
\`\`\`

## API

See [API Documentation](docs/API.md) for detailed information.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT - see [LICENSE](LICENSE)
```

**Bad**:
```markdown
# Project

Code for the thing.
```

### 3. Inline Comments for Complex Logic

**Severity**: Info

**Rule**: Comment complex algorithms, business logic, and non-obvious decisions

**Comment the WHY, not the WHAT**:
```javascript
// Good - explains why
// Use exponential backoff to avoid overwhelming the API during outages
const delay = Math.pow(2, retryCount) * 1000;

// Using binary search because dataset is pre-sorted and can be very large (10M+ items)
const index = binarySearch(sortedData, target);

// Bad - explains what (code already says this)
// Set delay to 2 to the power of retryCount times 1000
const delay = Math.pow(2, retryCount) * 1000;

// Call binary search
const index = binarySearch(sortedData, target);
```

**When to comment**:
- Complex algorithms
- Business rules and constraints
- Performance optimizations
- Workarounds for bugs or limitations
- Security considerations
- Non-obvious edge cases

**When NOT to comment**:
- Obvious code
- Redundant explanations
- Commented-out code (use version control instead)

### 4. Changelog Updates

**Severity**: Warning

**Rule**: Update CHANGELOG for user-facing changes

**Format**: Follow [Keep a Changelog](https://keepachangelog.com)

**Example**:
```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- New user authentication system
- Support for OAuth providers

### Changed
- Updated API response format (BREAKING)

### Fixed
- Fixed memory leak in connection pool

### Security
- Patched SQL injection vulnerability in search

## [1.2.0] - 2026-01-15

### Added
- Dark mode support
- Export to PDF feature
```

**Update for**:
- New features
- Bug fixes
- Breaking changes
- Security updates
- Deprecations

### 5. Code Examples in Documentation

**Rule**: Include practical examples for public APIs

**Good examples**:
```javascript
/**
 * Validates and normalizes email addresses
 *
 * @example Basic usage
 * normalizeEmail('User@Example.COM')
 * // Returns: 'user@example.com'
 *
 * @example Handling invalid emails
 * try {
 *   normalizeEmail('invalid-email')
 * } catch (error) {
 *   console.error('Invalid email:', error.message)
 * }
 *
 * @example With options
 * normalizeEmail('user+tag@example.com', { removeTags: true })
 * // Returns: 'user@example.com'
 */
```

## Configuration

Customize in `.claude/rules/documentation.config.json`:

```json
{
  "public_api_documentation": {
    "enabled": true,
    "require_for": ["functions", "classes", "methods"]
  },
  "readme_requirements": {
    "minimum_sections": ["overview", "installation", "usage"]
  },
  "inline_comments": {
    "required_for": "complex_logic",
    "explain_why": true
  }
}
```

## Language-Specific Formats

### JSDoc/TSDoc (JavaScript/TypeScript)
```typescript
/**
 * Calculates the total price including tax
 *
 * @param amount - The base amount
 * @param taxRate - Tax rate as decimal (e.g., 0.08 for 8%)
 * @returns The total amount including tax
 */
function calculateTotal(amount: number, taxRate: number): number {
  return amount * (1 + taxRate);
}
```

### Python Docstrings
```python
def calculate_total(amount: float, tax_rate: float) -> float:
    """
    Calculates the total price including tax.

    Args:
        amount: The base amount
        tax_rate: Tax rate as decimal (e.g., 0.08 for 8%)

    Returns:
        The total amount including tax
    """
    return amount * (1 + tax_rate)
```

### Javadoc (Java)
```java
/**
 * Calculates the total price including tax
 *
 * @param amount The base amount
 * @param taxRate Tax rate as decimal (e.g., 0.08 for 8%)
 * @return The total amount including tax
 */
public double calculateTotal(double amount, double taxRate) {
    return amount * (1 + taxRate);
}
```

### Rustdoc (Rust)
```rust
/// Calculates the total price including tax
///
/// # Arguments
///
/// * `amount` - The base amount
/// * `tax_rate` - Tax rate as decimal (e.g., 0.08 for 8%)
///
/// # Examples
///
/// ```
/// let total = calculate_total(100.0, 0.08);
/// assert_eq!(total, 108.0);
/// ```
pub fn calculate_total(amount: f64, tax_rate: f64) -> f64 {
    amount * (1.0 + tax_rate)
}
```

### GoDoc (Go)
```go
// CalculateTotal calculates the total price including tax.
//
// Parameters:
//   - amount: The base amount
//   - taxRate: Tax rate as decimal (e.g., 0.08 for 8%)
//
// Returns the total amount including tax.
//
// Example:
//   total := CalculateTotal(100.0, 0.08)
//   // total is 108.0
func CalculateTotal(amount float64, taxRate float64) float64 {
    return amount * (1 + taxRate)
}
```

## Integration

**Works with**:
- Documentation generators (JSDoc, Sphinx, Rustdoc)
- API documentation tools (Swagger, API Blueprint)
- Static site generators for docs
- IDE intellisense and autocompletion

**Enforcement points**:
- Code review checklist
- Documentation linters
- CI/CD documentation checks
- Pull request templates

## Enforcement

Claude should:
1. **Require documentation** for public APIs
2. **Check README** exists and has minimum sections
3. **Suggest comments** for complex logic
4. **Remind about changelog** for user-facing changes
5. **Generate documentation** in the correct format for the language
6. **Validate examples** are accurate and runnable

## Best Practices

### Write for Your Audience
- Public API: Assume no internal knowledge
- Internal code: Assume project familiarity
- Complex logic: Explain for future maintainers

### Keep Documentation Updated
- Update docs when code changes
- Review docs during code review
- Remove outdated documentation

### Be Concise but Complete
- Don't write novels
- Include all essential information
- Use examples for clarity

### Make Documentation Discoverable
- Consistent location (docs/ folder)
- Clear file names
- Link from README

## Common Mistakes to Avoid

1. **Outdated documentation** - Worse than no documentation
2. **Redundant comments** - Repeating what code already says
3. **Missing examples** - Hard to understand without context
4. **Incomplete API docs** - Missing parameters or return values
5. **No changelog** - Users don't know what changed

## Version History

**1.0.0** (2026-01-18)
- Initial release
- Core documentation standards
- Multi-language format support
- README and changelog guidelines
