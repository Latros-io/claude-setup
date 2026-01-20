# Test Suite for Claude Code Best Practices Scripts (v4.0)

This test suite validates the v4.0 simplified architecture to ensure direct submodule usage works correctly.

## Running Tests

### Run All Tests

```bash
./scripts/test-scripts.sh
```

### Run with Verbose Output

```bash
./scripts/test-scripts.sh --verbose
```

## Test Coverage

The test suite includes 15 tests covering:

### Script Functionality (Tests 1-3)
- `setup.sh` - Simple setup with profile selection
- `validate.sh` - Configuration validation
- `merge-settings.sh` - JSON file merging

### Component Existence (Tests 4-6)
- Core agents (Bash, Explore, Plan, GeneralPurpose)
- Core skills (git-workflow, test-runner, doc-generator, project-setup, refactor-helper)
- Core rules (code-style, testing, documentation, security, git-hygiene)

### Settings Validation (Tests 7-8)
- Settings profiles exist and contain valid JSON
- Settings profiles have v4.0.0 version and paths configuration

### Quality Checks (Tests 9-10)
- All scripts are executable
- Core documentation files exist

### Integration Tests (Tests 11-15)
- `setup.sh --profile=standard` creates correct settings file
- `merge-settings.sh` merges JSON files properly
- No `.github/` directories created (v4.0 behavior)
- Domain settings (react.json) exists and is valid
- `setup.sh --profile=react` works correctly

## Test Output

### Success
```
============================================================
  Test Summary
============================================================

Total tests:  15
Passed:       15
Failed:       0

ALL TESTS PASSED
```

### Failure
When tests fail, you'll see specific error messages:
```
TEST 11: setup.sh --profile=standard creates .claude/settings.json
  * FAIL: Settings file not created or doesn't have correct format
```

## What's Different in v4.0 Tests?

### Removed Tests (from v3.x)
- ❌ `link.sh` tests (script removed)
- ❌ `setup-interactive.sh` tests (replaced with simpler setup.sh)
- ❌ `setup-auto-update.sh` tests (feature removed)
- ❌ `customize.sh` tests (override system removed)
- ❌ `sync.sh` tests (script removed)
- ❌ Symlink creation tests (no symlinks in v4.0)
- ❌ `.github/` directory tests (not generated in v4.0)

### New Tests (for v4.0)
- ✅ Settings files have v4.0.0 version
- ✅ Settings files have paths configuration
- ✅ No `.github/` directories created
- ✅ Direct submodule usage works
- ✅ Array paths for multi-domain profiles

## Compatibility

The test suite is designed to work with:
- **Bash 3.2+** (macOS default)
- **Bash 4.0+** (Linux default)
- **Python 3.6+** (required for JSON validation)

## Test Environment

Tests run in isolated temporary directories that are automatically cleaned up after completion. This ensures tests don't interfere with your actual project or each other.

## Adding New Tests

To add a new test:

1. Add a new test function using the helpers:
   ```bash
   log_test "Description of test"
   if assert_file_exists "/path/to/file"; then
       log_pass
   else
       log_fail "Specific failure message"
   fi
   ```

2. Available assertion helpers:
   - `assert_file_exists <file>` - Check if file exists
   - `assert_dir_exists <dir>` - Check if directory exists
   - `assert_command_succeeds <command>` - Check if command exits with 0
   - `assert_string_contains <string> <substring>` - Check string contains substring

3. Logging functions:
   - `log_test <message>` - Start a new test
   - `log_pass` - Mark test as passed
   - `log_fail <message>` - Mark test as failed with reason
   - `log_info <message>` - Output info (only in verbose mode)

## Continuous Integration

The test suite is designed to be run in CI environments. Example GitHub Actions workflow:

```yaml
name: Test Scripts

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]

    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Run tests
        run: ./scripts/test-scripts.sh
```

## Troubleshooting

### Python not found
Install Python 3.6 or higher:
```bash
# macOS
brew install python3

# Ubuntu/Debian
sudo apt-get install python3
```

### Permission denied
Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### Tests fail on macOS
The scripts are fully compatible with macOS's Bash 3.2. If tests fail:
1. Check Python 3 is installed: `python3 --version`
2. Check Bash version: `bash --version`
3. Run with verbose output: `./scripts/test-scripts.sh --verbose`

## Support

If tests fail or you encounter issues:
1. Run with `--verbose` flag for detailed output
2. Check the error messages for specific failures
3. Report issues at: https://github.com/Latros-io/claude-setup/issues
