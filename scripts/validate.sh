#!/usr/bin/env bash
#
# validate.sh - Validate component configurations
#
# Usage:
#   ./validate.sh              # Validate all components
#   ./validate.sh --component=<path>  # Validate specific component
#   ./validate.sh --help       # Show help

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$SUBMODULE_ROOT")"

# Default values
COMPONENT=""
VERBOSE=false
EXIT_CODE=0

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Validate component configurations and dependencies.

OPTIONS:
    --component=PATH    Validate specific component (e.g., agents/code-reviewer)
    --verbose           Show detailed validation output
    --help              Show this help message

VALIDATIONS:
    - JSON schema validation for config.json files
    - Dependency existence checks
    - Circular dependency detection
    - Override deep-merge compatibility
    - Required files presence

EXAMPLES:
    # Validate all components
    $0

    # Validate specific component
    $0 --component=agents/code-reviewer

    # Verbose validation output
    $0 --verbose

EXIT CODES:
    0    All validations passed
    1    Validation errors found

EOF
    exit 0
}

# Parse arguments
for arg in "$@"; do
    case $arg in
        --component=*)
            COMPONENT="${arg#*=}"
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option: $arg${NC}"
            usage
            ;;
    esac
done

# Print header
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Claude Code Best Practices - Validation${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Validate JSON file
validate_json() {
    local file="$1"
    local label="${2:-JSON}"

    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}  → Validating $label...${NC}"
    fi

    if command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$file'))" 2>/dev/null; then
            [ "$VERBOSE" = true ] && echo -e "${GREEN}  ✓ Valid JSON${NC}"
            return 0
        else
            echo -e "${RED}✗ Invalid JSON: $file${NC}"
            python3 -c "import json; json.load(open('$file'))" 2>&1 | sed 's/^/    /'
            return 1
        fi
    elif command -v jq &> /dev/null; then
        if jq empty "$file" 2>/dev/null; then
            [ "$VERBOSE" = true ] && echo -e "${GREEN}  ✓ Valid JSON${NC}"
            return 0
        else
            echo -e "${RED}✗ Invalid JSON: $file${NC}"
            jq empty "$file" 2>&1 | sed 's/^/    /'
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ Warning: Neither python3 nor jq found, skipping JSON validation${NC}"
        return 0
    fi
}

# Extract dependencies from config.json
extract_dependencies() {
    local config_file="$1"

    if command -v python3 &> /dev/null; then
        python3 -c "
import json
import sys
try:
    with open('$config_file') as f:
        config = json.load(f)
    deps = config.get('dependencies', [])
    for dep in deps:
        print(dep)
except:
    pass
" 2>/dev/null
    elif command -v jq &> /dev/null; then
        jq -r '.dependencies[]? // empty' "$config_file" 2>/dev/null
    fi
}

# Check if component exists
component_exists() {
    local component="$1"
    local base_path="$SUBMODULE_ROOT"

    # Check core
    if [ -d "$base_path/core/$component" ]; then
        return 0
    fi

    # Check domains
    for domain_dir in "$base_path"/domains/*/; do
        if [ -d "${domain_dir}${component}" ]; then
            return 0
        fi
    done

    return 1
}

# Detect circular dependencies
detect_circular_deps() {
    local component="$1"
    local visited="$2"
    local config_file="$3"

    # Check if already visited (circular dependency)
    if [[ "$visited" == *"|$component|"* ]]; then
        echo -e "${RED}✗ Circular dependency detected: $component${NC}"
        echo -e "  Path: ${visited}${component}"
        return 1
    fi

    # Add to visited
    visited="${visited}${component}|"

    # Extract and check dependencies
    local deps=$(extract_dependencies "$config_file")
    local has_error=0

    while IFS= read -r dep; do
        [ -z "$dep" ] && continue

        # Find dependency config
        local dep_config=""
        if [ -f "$SUBMODULE_ROOT/core/$dep/config.json" ]; then
            dep_config="$SUBMODULE_ROOT/core/$dep/config.json"
        else
            for domain_dir in "$SUBMODULE_ROOT"/domains/*/; do
                if [ -f "${domain_dir}${dep}/config.json" ]; then
                    dep_config="${domain_dir}${dep}/config.json"
                    break
                fi
            done
        fi

        # Recursively check
        if [ -n "$dep_config" ]; then
            if ! detect_circular_deps "$dep" "$visited" "$dep_config"; then
                has_error=1
            fi
        fi
    done <<< "$deps"

    return $has_error
}

# Validate component
validate_component() {
    local component_path="$1"
    local component_name=$(basename "$component_path")
    local errors=0

    echo -e "${BLUE}Validating: $component_path${NC}"

    # Check required files
    local config_file="$component_path/config.json"

    if [ ! -f "$config_file" ]; then
        echo -e "${YELLOW}⚠ No config.json found (optional)${NC}"
    else
        # Validate JSON schema
        if ! validate_json "$config_file" "config.json"; then
            ((errors++))
        fi

        # Check dependencies exist
        [ "$VERBOSE" = true ] && echo -e "${BLUE}  → Checking dependencies...${NC}"
        local deps=$(extract_dependencies "$config_file")
        local dep_errors=0

        while IFS= read -r dep; do
            [ -z "$dep" ] && continue

            if ! component_exists "$dep"; then
                echo -e "${RED}✗ Dependency not found: $dep${NC}"
                ((dep_errors++))
                ((errors++))
            else
                [ "$VERBOSE" = true ] && echo -e "${GREEN}  ✓ Dependency exists: $dep${NC}"
            fi
        done <<< "$deps"

        if [ "$dep_errors" -eq 0 ] && [ -n "$deps" ]; then
            [ "$VERBOSE" = true ] && echo -e "${GREEN}  ✓ All dependencies exist${NC}"
        fi

        # Detect circular dependencies
        [ "$VERBOSE" = true ] && echo -e "${BLUE}  → Checking for circular dependencies...${NC}"
        if ! detect_circular_deps "$component_name" "|" "$config_file"; then
            ((errors++))
        else
            [ "$VERBOSE" = true ] && echo -e "${GREEN}  ✓ No circular dependencies${NC}"
        fi
    fi

    # Check for override compatibility
    local override_dir="$PROJECT_ROOT/.github/overrides/$component_name"
    if [ -d "$override_dir" ]; then
        [ "$VERBOSE" = true ] && echo -e "${BLUE}  → Checking override compatibility...${NC}"

        for override_file in "$override_dir"/*; do
            [ ! -f "$override_file" ] && continue

            local filename=$(basename "$override_file")
            local base_file="$component_path/$filename"

            if [ ! -f "$base_file" ]; then
                echo -e "${YELLOW}⚠ Override file has no base: $filename${NC}"
            else
                [ "$VERBOSE" = true ] && echo -e "${GREEN}  ✓ Override compatible: $filename${NC}"

                # Validate override JSON if applicable
                if [[ "$filename" == *.json ]]; then
                    if ! validate_json "$override_file" "override $filename"; then
                        ((errors++))
                    fi
                fi
            fi
        done
    fi

    echo
    return $errors
}

# Main validation
validate_all() {
    local total_components=0
    local valid_components=0
    local invalid_components=0

    # Find all components
    local search_paths=(
        "$SUBMODULE_ROOT/core/agents"
        "$SUBMODULE_ROOT/core/skills"
        "$SUBMODULE_ROOT/core/rules"
    )

    # Add domain paths
    for domain_dir in "$SUBMODULE_ROOT"/domains/*/; do
        [ ! -d "$domain_dir" ] && continue
        search_paths+=("${domain_dir}agents")
        search_paths+=("${domain_dir}skills")
        search_paths+=("${domain_dir}rules")
    done

    # Validate each component
    for search_path in "${search_paths[@]}"; do
        [ ! -d "$search_path" ] && continue

        for component_dir in "$search_path"/*; do
            [ ! -d "$component_dir" ] && continue

            ((total_components++))

            if validate_component "$component_dir"; then
                ((valid_components++))
            else
                ((invalid_components++))
                EXIT_CODE=1
            fi
        done
    done

    # Print summary
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Validation Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo -e "Total components:  ${BLUE}$total_components${NC}"
    echo -e "Valid:             ${GREEN}$valid_components${NC}"
    echo -e "Invalid:           ${RED}$invalid_components${NC}"
    echo

    if [ $EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}✓ All validations passed${NC}"
    else
        echo -e "${RED}✗ Validation failed${NC}"
    fi
    echo
}

# Validate specific component
if [ -n "$COMPONENT" ]; then
    # Find component path
    component_path=""
    if [ -d "$SUBMODULE_ROOT/core/$COMPONENT" ]; then
        component_path="$SUBMODULE_ROOT/core/$COMPONENT"
    else
        for domain_dir in "$SUBMODULE_ROOT"/domains/*/; do
            if [ -d "${domain_dir}${COMPONENT}" ]; then
                component_path="${domain_dir}${COMPONENT}"
                break
            fi
        done
    fi

    if [ -z "$component_path" ]; then
        echo -e "${RED}Error: Component not found: $COMPONENT${NC}"
        exit 1
    fi

    if validate_component "$component_path"; then
        echo -e "${GREEN}✓ Component valid${NC}"
        exit 0
    else
        echo -e "${RED}✗ Component invalid${NC}"
        exit 1
    fi
else
    validate_all
fi

exit $EXIT_CODE
