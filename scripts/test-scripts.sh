#!/usr/bin/env bash
#
# test-scripts.sh - Test suite for Claude Code best practices scripts
#
# This script tests all the integration scripts to ensure they work correctly.
#
# Usage:
#   ./test-scripts.sh              # Run all tests
#   ./test-scripts.sh --verbose    # Run with verbose output

set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Verbose mode
VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

# Test temp directory
TEST_DIR=$(mktemp -d -t claude-test-XXXXXX)
trap 'rm -rf "$TEST_DIR"' EXIT

# Logging functions
log_test() {
    ((TOTAL_TESTS++))
    echo -e "${BLUE}TEST $TOTAL_TESTS:${NC} $1"
}

log_pass() {
    ((PASSED_TESTS++))
    echo -e "${GREEN}  ✓ PASS${NC}"
}

log_fail() {
    ((FAILED_TESTS++))
    echo -e "${RED}  ✗ FAIL: $1${NC}"
}

log_info() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${YELLOW}  → $1${NC}"
    fi
}

# Test helper functions
assert_file_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        return 0
    else
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        return 0
    else
        return 1
    fi
}

assert_symlink_exists() {
    local link="$1"
    if [[ -L "$link" ]]; then
        return 0
    else
        return 1
    fi
}

assert_command_succeeds() {
    if eval "$@" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

assert_string_contains() {
    local string="$1"
    local substring="$2"
    if [[ "$string" == *"$substring"* ]]; then
        return 0
    else
        return 1
    fi
}

# Print header
echo "============================================================"
echo "  Claude Code Best Practices - Test Suite"
echo "============================================================"
echo
echo "Running tests in: $TEST_DIR"
echo

# Test 1: link.sh basic functionality
log_test "link.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/link.sh --help"; then
    log_pass
else
    log_fail "link.sh --help failed"
fi

# Test 2: link.sh dry-run with core profile
log_test "link.sh --profile=core --dry-run works"
cd "$TEST_DIR"
git init -q
mkdir -p .claude
ln -s "$SUBMODULE_ROOT" .claude/best-practices

if output=$("$SCRIPT_DIR/link.sh" --profile=core --dry-run 2>&1); then
    if assert_string_contains "$output" "Would link"; then
        log_pass
    else
        log_fail "Dry run didn't show 'Would link' message"
    fi
else
    log_fail "link.sh dry-run failed"
fi

# Test 3: link.sh creates symlinks
log_test "link.sh --profile=core creates symlinks"
if "$SCRIPT_DIR/link.sh" --profile=core &>/dev/null; then
    if assert_dir_exists ".github/agents" && \
       assert_symlink_exists ".github/agents/Bash" && \
       assert_symlink_exists ".github/skills/git-workflow"; then
        log_pass
    else
        log_fail "Expected symlinks were not created"
    fi
else
    log_fail "link.sh failed to create symlinks"
fi

# Test 4: link.sh copy mode
log_test "link.sh --profile=core --copy creates copies"
rm -rf .github
if "$SCRIPT_DIR/link.sh" --profile=core --copy &>/dev/null; then
    if assert_dir_exists ".github/agents/Bash" && \
       ! assert_symlink_exists ".github/agents/Bash"; then
        log_pass
    else
        log_fail "Copy mode didn't create actual directories"
    fi
else
    log_fail "link.sh copy mode failed"
fi

# Test 5: link.sh with invalid profile
log_test "link.sh rejects invalid profile"
if ! "$SCRIPT_DIR/link.sh" --profile=invalid-profile &>/dev/null; then
    log_pass
else
    log_fail "Should reject invalid profile"
fi

# Test 6: merge-settings.sh basic functionality
log_test "merge-settings.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/merge-settings.sh --help"; then
    log_pass
else
    log_fail "merge-settings.sh --help failed"
fi

# Test 7: merge-settings.sh merges settings
log_test "merge-settings.sh merges JSON files"
cat > "$TEST_DIR/settings1.json" << 'EOF'
{
  "agents": ["Bash"],
  "settings": {
    "timeout": 30
  }
}
EOF

cat > "$TEST_DIR/settings2.json" << 'EOF'
{
  "agents": ["Explore"],
  "settings": {
    "retries": 3
  }
}
EOF

if "$SCRIPT_DIR/merge-settings.sh" "$TEST_DIR/settings1.json" "$TEST_DIR/settings2.json" "$TEST_DIR/merged.json" &>/dev/null; then
    if assert_file_exists "$TEST_DIR/merged.json"; then
        merged=$(cat "$TEST_DIR/merged.json")
        if assert_string_contains "$merged" "Bash" && \
           assert_string_contains "$merged" "Explore" && \
           assert_string_contains "$merged" "timeout" && \
           assert_string_contains "$merged" "retries"; then
            log_pass
        else
            log_fail "Merged settings missing expected content"
        fi
    else
        log_fail "Merged settings file not created"
    fi
else
    log_fail "merge-settings.sh failed"
fi

# Test 8: validate.sh basic functionality
log_test "validate.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/validate.sh --help"; then
    log_pass
else
    log_fail "validate.sh --help failed"
fi

# Test 9: customize.sh basic functionality
log_test "customize.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/customize.sh --help"; then
    log_pass
else
    log_fail "customize.sh --help failed"
fi

# Test 10: sync.sh basic functionality
log_test "sync.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/sync.sh --help"; then
    log_pass
else
    log_fail "sync.sh --help failed"
fi

# Test 11: setup-auto-update.sh basic functionality
log_test "setup-auto-update.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/setup-auto-update.sh --help"; then
    log_pass
else
    log_fail "setup-auto-update.sh --help failed"
fi

# Test 12: setup-auto-update.sh --status works
log_test "setup-auto-update.sh --status works"
if output=$("$SCRIPT_DIR/setup-auto-update.sh" --status 2>&1); then
    if assert_string_contains "$output" "Auto-Update Status"; then
        log_pass
    else
        log_fail "Status output missing expected content"
    fi
else
    log_fail "setup-auto-update.sh --status failed"
fi

# Test 13: Core settings files exist
log_test "Core settings files exist"
if assert_file_exists "$SUBMODULE_ROOT/core/settings/minimal.json" && \
   assert_file_exists "$SUBMODULE_ROOT/core/settings/standard.json" && \
   assert_file_exists "$SUBMODULE_ROOT/core/settings/comprehensive.json"; then
    log_pass
else
    log_fail "Missing core settings files"
fi

# Test 14: Core agents exist
log_test "Core agents exist"
if assert_dir_exists "$SUBMODULE_ROOT/core/agents/Bash" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/Explore" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/Plan" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/GeneralPurpose"; then
    log_pass
else
    log_fail "Missing core agents"
fi

# Test 15: Core skills exist
log_test "Core skills exist"
if assert_dir_exists "$SUBMODULE_ROOT/core/skills/git-workflow" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/test-runner" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/doc-generator"; then
    log_pass
else
    log_fail "Missing core skills"
fi

# Test 16: Core rules exist
log_test "Core rules exist"
if assert_dir_exists "$SUBMODULE_ROOT/core/rules/code-style" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/testing" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/documentation"; then
    log_pass
else
    log_fail "Missing core rules"
fi

# Test 17: All scripts are executable
log_test "All scripts are executable"
all_executable=true
for script in "$SCRIPT_DIR"/*.sh; do
    if [[ ! -x "$script" ]]; then
        log_info "Not executable: $script"
        all_executable=false
    fi
done

if [[ "$all_executable" == "true" ]]; then
    log_pass
else
    log_fail "Some scripts are not executable"
fi

# Test 18: Settings files are valid JSON
log_test "Settings files are valid JSON"
all_valid=true
for settings_file in "$SUBMODULE_ROOT/core/settings"/*.json; do
    if [[ -f "$settings_file" ]]; then
        if ! python3 -m json.tool "$settings_file" &>/dev/null; then
            log_info "Invalid JSON: $settings_file"
            all_valid=false
        fi
    fi
done

if [[ "$all_valid" == "true" ]]; then
    log_pass
else
    log_fail "Some settings files have invalid JSON"
fi

# Test 19: link.sh handles web-frontend profile
log_test "link.sh --profile=web-frontend works"
cd "$TEST_DIR"
rm -rf .github
if "$SCRIPT_DIR/link.sh" --profile=web-frontend &>/dev/null; then
    if assert_dir_exists ".github/agents" && \
       assert_symlink_exists ".github/agents/Bash"; then
        log_pass
    else
        log_fail "web-frontend profile didn't create expected links"
    fi
else
    log_fail "link.sh with web-frontend profile failed"
fi

# Test 20: Documentation files exist
log_test "Documentation files exist"
if assert_file_exists "$SUBMODULE_ROOT/README.md" && \
   assert_file_exists "$SUBMODULE_ROOT/INTEGRATION.md" && \
   assert_file_exists "$SUBMODULE_ROOT/CHANGELOG.md" && \
   assert_file_exists "$SUBMODULE_ROOT/STATUS.md"; then
    log_pass
else
    log_fail "Missing documentation files"
fi

# Print summary
echo
echo "============================================================"
echo "  Test Summary"
echo "============================================================"
echo
echo "Total tests:  $TOTAL_TESTS"
echo -e "Passed:       ${GREEN}$PASSED_TESTS${NC}"
if [[ $FAILED_TESTS -gt 0 ]]; then
    echo -e "Failed:       ${RED}$FAILED_TESTS${NC}"
else
    echo -e "Failed:       $FAILED_TESTS"
fi
echo

# Exit with appropriate code
if [[ $FAILED_TESTS -gt 0 ]]; then
    echo -e "${RED}TESTS FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}ALL TESTS PASSED${NC}"
    exit 0
fi
