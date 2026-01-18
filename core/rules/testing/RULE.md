---
name: testing
description: Testing best practices and requirements for code quality
version: 1.0.0
author: Latros.io
category: quality
enforcement: warning
tags: [testing, quality, coverage, unit-tests, integration-tests]
---

# Testing Rule

Ensure comprehensive test coverage and maintain testing best practices for reliable, maintainable code.

## Purpose

Comprehensive testing provides:
- **Reliability**: Catch bugs before they reach production
- **Confidence**: Refactor safely with test coverage
- **Documentation**: Tests describe expected behavior
- **Regression Prevention**: Prevent reintroduction of fixed bugs
- **Design Quality**: Testable code is usually better designed

## Rules

### 1. Minimum Test Coverage

**Severity**: Warning

**Rule**: Maintain minimum test coverage threshold

**Default**: 80% overall coverage, 100% for new code

**Applies to**:
- Line coverage
- Branch coverage
- Function coverage

**Example**:
```javascript
// Good - comprehensive coverage
describe('UserService', () => {
  it('should create user with valid data', () => {
    const user = createUser({ name: 'John', email: 'john@example.com' });
    expect(user).toBeDefined();
    expect(user.name).toBe('John');
  });

  it('should throw error for invalid email', () => {
    expect(() => createUser({ name: 'John', email: 'invalid' }))
      .toThrow('Invalid email');
  });

  it('should handle missing name', () => {
    expect(() => createUser({ email: 'john@example.com' }))
      .toThrow('Name is required');
  });
});

// Bad - incomplete coverage
describe('UserService', () => {
  it('should create user', () => {
    const user = createUser({ name: 'John', email: 'john@example.com' });
    expect(user).toBeDefined();
  });
  // Missing error cases
});
```

### 2. Test Naming Conventions

**Severity**: Info

**Rule**: Use descriptive test names that explain behavior

**Patterns**:
- `should [expected behavior] when [condition]`
- `[method/function] [scenario] [expected result]`
- Describe what, not how

**Example**:
```javascript
// Good
it('should return user when ID exists in database', async () => {});
it('should throw NotFoundError when user does not exist', async () => {});
it('should hash password before saving to database', async () => {});

// Bad
it('test1', () => {});
it('getUserById works', () => {});
it('should call database', () => {}); // Too vague
```

### 3. No Skipped Tests in Main

**Severity**: Error

**Rule**: No skipped/disabled tests in main/production branches

**Allowed**: With linked issue/ticket reference in development branches

**Example**:
```javascript
// Good - in feature branch with reference
it.skip('should handle concurrent updates - Issue #1234', async () => {
  // Test implementation
});

// Good - alternative approach
it('should handle concurrent updates', async () => {
  // Test implementation or throw NotImplementedError with issue reference
});

// Bad - in main branch
it.skip('should do something important', async () => {});
test.todo('implement this later');
```

### 4. Test Organization

**Severity**: Info

**Rule**: Organize tests to mirror source code structure

**Structure**:
```
src/
  services/
    user-service.ts
test/
  services/
    user-service.test.ts
```

**Grouping**:
```javascript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', () => {});
    it('should validate email format', () => {});
  });

  describe('updateUser', () => {
    it('should update existing user', () => {});
    it('should throw error for non-existent user', () => {});
  });
});
```

### 5. Test Isolation

**Rule**: Tests should be independent and repeatable

**Best Practices**:
- No shared state between tests
- Clean up after each test
- Use beforeEach/afterEach for setup/teardown
- Mock external dependencies

**Example**:
```javascript
// Good
describe('UserRepository', () => {
  let repository;
  let mockDb;

  beforeEach(() => {
    mockDb = createMockDatabase();
    repository = new UserRepository(mockDb);
  });

  afterEach(() => {
    mockDb.clear();
  });

  it('should save user', async () => {
    await repository.save({ name: 'John' });
    expect(mockDb.users).toHaveLength(1);
  });
});

// Bad - shared state
let globalUser;
it('creates user', () => {
  globalUser = createUser();
});
it('updates user', () => {
  globalUser.name = 'Updated'; // Depends on previous test
});
```

## Configuration

Customize in `.claude/rules/testing.config.json`:

```json
{
  "minimum_coverage": {
    "threshold": 80,
    "enforce_on_new_code": true
  },
  "no_skipped_tests": {
    "enabled": true,
    "branches": ["main", "master"]
  },
  "required_test_types": {
    "unit_tests": true,
    "integration_tests": true,
    "e2e_tests": false
  }
}
```

## Framework-Specific Examples

### Jest/Vitest (JavaScript/TypeScript)
```javascript
import { describe, it, expect, beforeEach, vi } from 'vitest';

describe('PaymentProcessor', () => {
  it('should process payment successfully', async () => {
    const mockGateway = vi.fn().mockResolvedValue({ success: true });
    const processor = new PaymentProcessor(mockGateway);

    const result = await processor.process({ amount: 100 });

    expect(result.success).toBe(true);
    expect(mockGateway).toHaveBeenCalledWith({ amount: 100 });
  });
});
```

### pytest (Python)
```python
import pytest

class TestUserService:
    def test_create_user_with_valid_data(self):
        user = create_user(name="John", email="john@example.com")
        assert user is not None
        assert user.name == "John"

    def test_create_user_with_invalid_email_raises_error(self):
        with pytest.raises(ValueError, match="Invalid email"):
            create_user(name="John", email="invalid")
```

### Go testing
```go
func TestUserService_CreateUser(t *testing.T) {
    t.Run("should create user with valid data", func(t *testing.T) {
        user, err := CreateUser("John", "john@example.com")
        assert.NoError(t, err)
        assert.Equal(t, "John", user.Name)
    })

    t.Run("should return error for invalid email", func(t *testing.T) {
        _, err := CreateUser("John", "invalid")
        assert.Error(t, err)
    })
}
```

### Cargo test (Rust)
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_create_user_with_valid_data() {
        let user = create_user("John", "john@example.com").unwrap();
        assert_eq!(user.name, "John");
    }

    #[test]
    #[should_panic(expected = "Invalid email")]
    fn test_create_user_with_invalid_email() {
        create_user("John", "invalid").unwrap();
    }
}
```

## Integration

**Works with**:
- CI/CD pipelines for automated testing
- Code review workflows
- Coverage reporting tools
- Test frameworks and runners

**Enforcement points**:
- Pre-commit hooks for running tests
- Pull request checks for coverage
- Branch protection rules
- Code review guidelines

## Enforcement

Claude should:
1. **Require tests** for new features and bug fixes
2. **Check coverage** and warn if below threshold
3. **Identify skipped tests** in main branches
4. **Suggest test cases** for edge cases and error scenarios
5. **Review test quality** during code review
6. **Recommend mocking** for external dependencies

## Best Practices

### Test What Matters
- Focus on behavior, not implementation
- Test edge cases and error conditions
- Test public interfaces, not private methods

### Keep Tests Fast
- Use mocks for external services
- Avoid unnecessary setup
- Run unit tests frequently

### Make Tests Readable
- Clear test names
- Arrange-Act-Assert pattern
- One assertion per concept

### Maintain Tests
- Update tests when requirements change
- Remove obsolete tests
- Refactor tests as you refactor code

## Version History

**1.0.0** (2026-01-18)
- Initial release
- Core testing rules and guidelines
- Support for major testing frameworks
- Coverage and naming conventions
