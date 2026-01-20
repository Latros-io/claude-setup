# Test Suite for Claude Code Best Practices Scripts

This test suite validates all integration scripts to ensure they work correctly across different environments, including macOS with Bash 3.2.

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

The test suite includes 20 tests covering:

### Script Functionality (Tests 1-12)
- `link.sh` - Component linking with symlinks and copy mode
- `merge-settings.sh` - JSON file merging
- `validate.sh` - Configuration validation
- `customize.sh` - Override management
- `sync.sh` - Update synchronization
- `setup-auto-update.sh` - Auto-update configuration
- `setup-interactive.sh` - Interactive setup wizard

### Component Existence (Tests 13-16)
- Core settings files (minimal, standard, comprehensive)
- Core agents (Bash, Explore, Plan, GeneralPurpose)
- Core skills (git-workflow, test-runner, doc-generator, etc.)
- Core rules (code-style, testing, documentation, etc.)

### Quality Checks (Tests 17-20)
- All scripts are executable
- All settings files contain valid JSON
- Different profile configurations work correctly
- Documentation files exist

## Test Output

### Success
```
============================================================
  Test Summary
============================================================

Total tests:  20
Passed:       20
Failed:       0

ALL TESTS PASSED
```

### Failure
When tests fail, you'll see specific error messages:
```
TEST 3: link.sh --profile=core creates symlinks
  ✗ FAIL: Expected symlinks were not created
```

## Compatibility

The test suite is designed to work with:
- **Bash 3.2+** (macOS default)
- **Bash 4.0+** (Linux default)
- **Python 3.6+** (required for JSON merging)

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
   - `assert_symlink_exists <link>` - Check if symlink exists
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
