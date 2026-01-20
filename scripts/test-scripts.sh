#!/usr/bin/env bash
#
# test-scripts.sh - Test suite for Claude Code best practices scripts (v4.0)
#
# This script tests the v4.0 simplified architecture
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
    echo -e "${GREEN}  * PASS${NC}"
}

log_fail() {
    ((FAILED_TESTS++))
    echo -e "${RED}  * FAIL: $1${NC}"
}

log_info() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${YELLOW}  > $1${NC}"
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
echo "  Claude Code Best Practices - Test Suite v4.0"
echo "============================================================"
echo
echo "Running tests in: $TEST_DIR"
echo

# Test 1: setup.sh --help shows usage
log_test "setup.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/setup.sh --help"; then
    log_pass
else
    log_fail "setup.sh --help failed"
fi

# Test 2: validate.sh --help shows usage
log_test "validate.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/validate.sh --help"; then
    log_pass
else
    log_fail "validate.sh --help failed"
fi

# Test 3: merge-settings.sh --help shows usage
log_test "merge-settings.sh --help shows usage"
if assert_command_succeeds "$SCRIPT_DIR/merge-settings.sh --help"; then
    log_pass
else
    log_fail "merge-settings.sh --help failed"
fi

# Test 4: Core agents exist
log_test "Core agents directory exists with 4 agents"
if assert_dir_exists "$SUBMODULE_ROOT/core/agents" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/Bash" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/Explore" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/Plan" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/agents/GeneralPurpose"; then
    log_pass
else
    log_fail "Expected core agents not found"
fi

# Test 5: Core skills exist
log_test "Core skills directory exists with 5 skills"
if assert_dir_exists "$SUBMODULE_ROOT/core/skills" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/git-workflow" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/test-runner" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/doc-generator" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/project-setup" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/skills/refactor-helper"; then
    log_pass
else
    log_fail "Expected core skills not found"
fi

# Test 6: Core rules exist
log_test "Core rules directory exists with 5 rules"
if assert_dir_exists "$SUBMODULE_ROOT/core/rules" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/code-style" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/testing" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/documentation" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/security" && \
   assert_dir_exists "$SUBMODULE_ROOT/core/rules/git-hygiene"; then
    log_pass
else
    log_fail "Expected core rules not found"
fi

# Test 7: Settings profiles exist and are valid JSON
log_test "Settings profiles exist and contain valid JSON"
if assert_file_exists "$SUBMODULE_ROOT/core/settings/minimal.json" && \
   assert_file_exists "$SUBMODULE_ROOT/core/settings/standard.json" && \
   assert_file_exists "$SUBMODULE_ROOT/core/settings/comprehensive.json" && \
   python3 -m json.tool "$SUBMODULE_ROOT/core/settings/minimal.json" >/dev/null 2>&1 && \
   python3 -m json.tool "$SUBMODULE_ROOT/core/settings/standard.json" >/dev/null 2>&1 && \
   python3 -m json.tool "$SUBMODULE_ROOT/core/settings/comprehensive.json" >/dev/null 2>&1; then
    log_pass
else
    log_fail "Settings profiles missing or invalid JSON"
fi

# Test 8: Settings profiles have v4.0.0 version and paths
log_test "Settings profiles have version 4.0.0 and paths section"
if grep -q '"version": "4.0.0"' "$SUBMODULE_ROOT/core/settings/standard.json" && \
   grep -q '"paths":' "$SUBMODULE_ROOT/core/settings/standard.json"; then
    log_pass
else
    log_fail "Settings profiles don't have v4.0.0 version or paths section"
fi

# Test 9: All scripts are executable
log_test "All scripts in scripts/ are executable"
non_executable=$(find "$SCRIPT_DIR" -name "*.sh" ! -perm -u+x 2>/dev/null || true)
if [[ -z "$non_executable" ]]; then
    log_pass
else
    log_fail "Some scripts are not executable: $non_executable"
fi

# Test 10: Documentation files exist
log_test "Core documentation files exist"
if assert_file_exists "$SUBMODULE_ROOT/README.md" && \
   assert_file_exists "$SUBMODULE_ROOT/CHANGELOG.md" && \
   assert_file_exists "$SUBMODULE_ROOT/INTEGRATION.md" && \
   assert_file_exists "$SUBMODULE_ROOT/STATUS.md"; then
    log_pass
else
    log_fail "Some documentation files missing"
fi

# Test 11: setup.sh with --profile=standard creates settings file
log_test "setup.sh --profile=standard creates .claude/settings.json"
cd "$TEST_DIR"
git init -q
mkdir -p .claude
ln -s "$SUBMODULE_ROOT" .claude/best-practices

if "$SCRIPT_DIR/setup.sh" --profile=standard <<< "y" &>/dev/null; then
    if assert_file_exists ".claude/settings.json" && \
       grep -q '"version": "4.0.0"' ".claude/settings.json" && \
       grep -q '"paths":' ".claude/settings.json"; then
        log_pass
    else
        log_fail "Settings file not created or doesn't have correct format"
    fi
else
    log_fail "setup.sh failed to run"
fi

# Test 12: merge-settings.sh merges JSON files
log_test "merge-settings.sh merges JSON files correctly"
cd "$TEST_DIR"
cat > settings1.json << 'EOF'
{
  "agents": ["Bash"],
  "skills": ["git-workflow"]
}
EOF

cat > settings2.json << 'EOF'
{
  "agents": ["Explore"],
  "rules": ["code-style"]
}
EOF

if "$SCRIPT_DIR/merge-settings.sh" settings1.json settings2.json merged.json &>/dev/null; then
    if assert_file_exists "merged.json" && \
       grep -q '"Bash"' "merged.json" && \
       grep -q '"Explore"' "merged.json" && \
       grep -q '"code-style"' "merged.json"; then
        log_pass
    else
        log_fail "Merged file doesn't contain expected content"
    fi
else
    log_fail "merge-settings.sh failed"
fi

# Test 13: No .github directory should be generated
log_test "setup.sh doesn't create .github directory (v4.0 behavior)"
cd "$TEST_DIR"
rm -rf .github .claude/settings.json
"$SCRIPT_DIR/setup.sh" --profile=minimal <<< "y" &>/dev/null || true

if [[ ! -d ".github/agents" ]] && [[ ! -d ".github/skills" ]] && [[ ! -d ".github/rules" ]]; then
    log_pass
else
    log_fail ".github directories were created (should not happen in v4.0)"
fi

# Test 14: Domain settings file exists (react)
log_test "Domain settings file (react.json) exists and is valid"
if assert_file_exists "$SUBMODULE_ROOT/domains/web/settings/react.json" && \
   python3 -m json.tool "$SUBMODULE_ROOT/domains/web/settings/react.json" >/dev/null 2>&1 && \
   grep -q '"version": "4.0.0"' "$SUBMODULE_ROOT/domains/web/settings/react.json"; then
    log_pass
else
    log_fail "React settings file missing, invalid, or wrong version"
fi

# Test 15: setup.sh with --profile=react works
log_test "setup.sh --profile=react creates settings with array paths"
cd "$TEST_DIR"
rm -rf .claude/settings.json
"$SCRIPT_DIR/setup.sh" --profile=react <<< "y" &>/dev/null || true

if assert_file_exists ".claude/settings.json" && \
   grep -q '"version": "4.0.0"' ".claude/settings.json"; then
    log_pass
else
    log_fail "React profile setup failed"
fi

# Print summary
echo
echo "============================================================"
echo "  Test Summary"
echo "============================================================"
echo
echo "Total tests:  $TOTAL_TESTS"
echo "Passed:       $PASSED_TESTS"
echo "Failed:       $FAILED_TESTS"
echo

if [[ $FAILED_TESTS -eq 0 ]]; then
    echo -e "${GREEN}ALL TESTS PASSED${NC}"
    exit 0
else
    echo -e "${RED}SOME TESTS FAILED${NC}"
    exit 1
fi
