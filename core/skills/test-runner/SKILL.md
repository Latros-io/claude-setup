---
name: test-runner
description: Automatically detect and run tests after code changes
version: 1.0.0
author: Latros.io
category: testing
tags: [testing, automation, ci-cd]
---

# Test Runner Skill

Automatically detects test frameworks and runs appropriate test commands with support for watch mode, coverage reports, and targeted test execution.

## When to Use This Skill

Invoke this skill when:
- User asks to run tests
- User wants to enable watch mode for tests
- User requests coverage reports
- User mentions running specific test files
- User asks about test results or failures
- After code changes that should be validated

## Invocation

Claude should automatically use this skill when test execution is requested. The skill provides:
- Automatic test framework detection
- Smart test command execution
- Coverage report generation
- Watch mode for continuous testing
- Targeted test execution for specific files

## Dependencies

### Required
- **Agent**: `Bash` - For executing test commands

### Optional
- **MCP Server**: `github` - For CI/CD integration and status updates
- **Skill**: `refactor-helper` - For running tests after refactoring

## Configuration

Default settings (customizable in `.claude/skills/test-runner.config.json`):

- `auto_detect_framework`: true - Automatically detect test framework
- `watch_mode`: false - Enable watch mode by default
- `coverage`: false - Generate coverage reports by default
- `parallel`: true - Run tests in parallel when possible
- `run_after_changes`: false - Auto-run tests after file changes
- `fail_fast`: false - Stop on first failure
- `verbose`: false - Show detailed test output
- `timeout`: 300 - Test execution timeout in seconds
- `coverage_threshold`: 80 - Minimum coverage percentage

## Supported Test Frameworks

### JavaScript/TypeScript
- **Jest**: Full support for watch, coverage, and parallel execution
- **Vitest**: Modern Vite-based test runner
- **Mocha**: Classic test framework with nyc for coverage

### Python
- **pytest**: Full support with pytest-watch and coverage

### Go
- **go test**: Native Go testing with gotestsum for watch mode

### Rust
- **cargo test**: Native Rust testing with cargo-watch and tarpaulin

## Usage Examples

### Example 1: Running All Tests

**User**: "Run the tests"

**Claude**:
1. Detects test framework (e.g., Jest from package.json)
2. Executes `npm test`
3. Reports results with pass/fail statistics
4. Highlights any failures with error details

### Example 2: Running Tests in Watch Mode

**User**: "Run tests in watch mode"

**Claude**:
1. Detects framework
2. Executes watch command (e.g., `npm test -- --watch`)
3. Monitors for file changes
4. Reports when tests re-run

### Example 3: Running Specific Tests

**User**: "Run tests for the auth module"

**Claude**:
1. Searches for auth-related test files
2. Executes targeted test command
3. Shows results for matching tests only

### Example 4: Coverage Report

**User**: "Show me the test coverage"

**Claude**:
1. Runs tests with coverage flag
2. Generates coverage report
3. Displays coverage percentage by file
4. Highlights uncovered lines
5. Warns if below threshold

## Framework Detection

The skill automatically detects frameworks by checking:

1. **package.json** scripts and dependencies (JavaScript/TypeScript)
2. **pytest.ini** or **setup.py** (Python)
3. **go.mod** (Go)
4. **Cargo.toml** (Rust)

Detection priority:
1. Explicit test script in package.json
2. Framework-specific config files
3. Framework dependencies
4. File naming patterns

## Test Execution Modes

### Normal Mode
- Runs all tests once
- Reports results
- Exits on completion

### Watch Mode
- Monitors file changes
- Re-runs affected tests
- Continues until stopped

### Coverage Mode
- Runs tests with coverage instrumentation
- Generates coverage reports
- Shows uncovered lines
- Validates against threshold

### Targeted Mode
- Runs specific test files or patterns
- Faster feedback for focused work
- Useful during development

## Integration with Other Components

### With Bash Agent
- Executes test commands safely
- Captures output and errors
- Handles timeouts and interruptions

### With refactor-helper Skill
- Automatically runs tests after refactoring
- Validates that changes don't break functionality
- Provides confidence in code changes

### With GitHub MCP Server
- Updates PR status with test results
- Posts coverage reports to PRs
- Triggers CI/CD pipelines

## Error Handling

Common errors and resolutions:

**Framework Not Found**:
- Lists available frameworks
- Suggests installation commands
- Provides setup instructions

**Tests Failing**:
- Shows detailed error messages
- Highlights failing assertions
- Suggests potential fixes

**Timeout**:
- Reports timeout condition
- Suggests increasing timeout config
- Identifies slow tests

**Coverage Below Threshold**:
- Shows current vs required coverage
- Lists files below threshold
- Suggests areas needing tests

## Best Practices

1. **Run Tests Frequently**: Use watch mode during development
2. **Maintain Coverage**: Keep coverage above threshold
3. **Fast Tests**: Keep unit tests fast, use integration test suites separately
4. **Isolate Tests**: Ensure tests don't depend on each other
5. **Clear Assertions**: Write descriptive test names and assertions
6. **Test After Refactoring**: Always validate changes with tests

## Version History

- **1.0.0**: Initial release with multi-framework support, watch mode, and coverage reporting
