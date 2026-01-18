#!/usr/bin/env bash
#
# customize.sh - Manage component customization overrides
#
# Usage:
#   ./customize.sh create-override --component=<path> --file=<filename>
#   ./customize.sh list-overrides
#   ./customize.sh validate
#   ./customize.sh document
#   ./customize.sh --help

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
COMMAND=""
COMPONENT=""
FILE=""
OVERRIDES_DIR="$PROJECT_ROOT/.github/overrides"
README_PATH="$OVERRIDES_DIR/README.md"

# Usage function
usage() {
    cat << EOF
Usage: $0 <command> [OPTIONS]

Manage component customization overrides.

COMMANDS:
    create-override     Create a new override file from base template
    list-overrides      List all current overrides
    validate            Validate override files
    document            Update README with current overrides

OPTIONS:
    --component=PATH    Component path (e.g., agents/code-reviewer)
    --file=NAME         File name (e.g., config.json, rules.md)
    --help              Show this help message

EXAMPLES:
    # Create override for code-reviewer config
    $0 create-override --component=agents/code-reviewer --file=config.json

    # List all current overrides
    $0 list-overrides

    # Validate all override files
    $0 validate

    # Update override documentation
    $0 document

EOF
    exit 0
}

# Parse arguments
if [ $# -eq 0 ]; then
    usage
fi

COMMAND="$1"
shift

for arg in "$@"; do
    case $arg in
        --component=*)
            COMPONENT="${arg#*=}"
            shift
            ;;
        --file=*)
            FILE="${arg#*=}"
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
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Claude Code Best Practices - Customization${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
}

# Validate JSON file
validate_json() {
    local file="$1"
    if command -v python3 &> /dev/null; then
        python3 -c "import json; json.load(open('$file'))" 2>/dev/null
        return $?
    elif command -v jq &> /dev/null; then
        jq empty "$file" 2>/dev/null
        return $?
    else
        echo -e "${YELLOW}Warning: Neither python3 nor jq found, skipping JSON validation${NC}"
        return 0
    fi
}

# Create override file
create_override() {
    if [ -z "$COMPONENT" ] || [ -z "$FILE" ]; then
        echo -e "${RED}Error: Both --component and --file are required${NC}"
        usage
    fi

    print_header

    # Resolve source path
    local source_path="$SUBMODULE_ROOT/core/$COMPONENT/$FILE"

    # Check if it's a domain component
    if [ ! -f "$source_path" ]; then
        source_path="$SUBMODULE_ROOT/domains/*/$COMPONENT/$FILE"
        source_path=$(eval echo "$source_path" | head -n 1)
    fi

    if [ ! -f "$source_path" ]; then
        echo -e "${RED}Error: Source file not found${NC}"
        echo -e "Searched: $SUBMODULE_ROOT/core/$COMPONENT/$FILE"
        echo -e "          $SUBMODULE_ROOT/domains/*/$COMPONENT/$FILE"
        exit 1
    fi

    # Create override directory structure
    local override_dir="$OVERRIDES_DIR/$COMPONENT"
    local override_path="$override_dir/$FILE"

    if [ -f "$override_path" ]; then
        echo -e "${YELLOW}Warning: Override file already exists${NC}"
        echo -e "Path: $override_path"
        echo
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Cancelled${NC}"
            exit 0
        fi
    fi

    mkdir -p "$override_dir"

    # Copy base file as template
    cp "$source_path" "$override_path"

    echo -e "${GREEN}✓ Created override file${NC}"
    echo -e "Source:   $source_path"
    echo -e "Override: $override_path"
    echo

    # Add comment to JSON files
    if [[ "$FILE" == *.json ]]; then
        echo -e "${BLUE}→ Validating JSON...${NC}"
        if validate_json "$override_path"; then
            echo -e "${GREEN}✓ Valid JSON${NC}"
        else
            echo -e "${RED}✗ Invalid JSON${NC}"
            rm "$override_path"
            exit 1
        fi
    fi

    echo
    echo -e "${YELLOW}Note: Edit the override file to customize:${NC}"
    echo -e "  ${BLUE}$override_path${NC}"
    echo
}

# List all overrides
list_overrides() {
    print_header

    if [ ! -d "$OVERRIDES_DIR" ]; then
        echo -e "${YELLOW}No overrides directory found${NC}"
        echo -e "Create one with: $0 create-override --component=<path> --file=<name>"
        exit 0
    fi

    echo -e "${BLUE}Current overrides:${NC}"
    echo

    local count=0
    while IFS= read -r -d '' override_file; do
        local rel_path="${override_file#$OVERRIDES_DIR/}"

        # Skip README
        if [[ "$rel_path" == "README.md" ]]; then
            continue
        fi

        # Extract component and file
        local component=$(dirname "$rel_path")
        local filename=$(basename "$rel_path")

        # Get file size
        local size=$(du -h "$override_file" | cut -f1)

        # Validate JSON files
        local status="${GREEN}✓${NC}"
        if [[ "$filename" == *.json ]]; then
            if ! validate_json "$override_file"; then
                status="${RED}✗${NC}"
            fi
        fi

        echo -e "  $status $component/${BLUE}$filename${NC} ($size)"
        ((count++))
    done < <(find "$OVERRIDES_DIR" -type f -print0)

    echo
    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}No override files found${NC}"
    else
        echo -e "Total overrides: ${GREEN}$count${NC}"
    fi
    echo
}

# Validate override files
validate_overrides() {
    print_header

    if [ ! -d "$OVERRIDES_DIR" ]; then
        echo -e "${GREEN}✓ No overrides to validate${NC}"
        exit 0
    fi

    echo -e "${BLUE}Validating override files...${NC}"
    echo

    local valid_count=0
    local invalid_count=0
    local total_count=0

    while IFS= read -r -d '' override_file; do
        local rel_path="${override_file#$OVERRIDES_DIR/}"

        # Skip README
        if [[ "$rel_path" == "README.md" ]]; then
            continue
        fi

        ((total_count++))

        # Check if base file exists
        local component=$(dirname "$rel_path")
        local filename=$(basename "$rel_path")
        local base_path="$SUBMODULE_ROOT/core/$component/$filename"

        if [ ! -f "$base_path" ]; then
            base_path="$SUBMODULE_ROOT/domains/*/$component/$filename"
            base_path=$(eval echo "$base_path" | head -n 1)
        fi

        if [ ! -f "$base_path" ]; then
            echo -e "${YELLOW}⚠ Warning: Base file not found for $rel_path${NC}"
        fi

        # Validate JSON files
        if [[ "$filename" == *.json ]]; then
            if validate_json "$override_file"; then
                echo -e "${GREEN}✓ Valid JSON: $rel_path${NC}"
                ((valid_count++))
            else
                echo -e "${RED}✗ Invalid JSON: $rel_path${NC}"
                ((invalid_count++))
            fi
        else
            # Check if file is readable
            if [ -r "$override_file" ]; then
                echo -e "${GREEN}✓ Readable: $rel_path${NC}"
                ((valid_count++))
            else
                echo -e "${RED}✗ Not readable: $rel_path${NC}"
                ((invalid_count++))
            fi
        fi
    done < <(find "$OVERRIDES_DIR" -type f -print0)

    echo
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Validation Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo -e "Total files:   ${BLUE}$total_count${NC}"
    echo -e "Valid:         ${GREEN}$valid_count${NC}"
    echo -e "Invalid:       ${RED}$invalid_count${NC}"
    echo

    if [ $invalid_count -gt 0 ]; then
        echo -e "${RED}✗ Validation failed${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ All overrides valid${NC}"
    fi
    echo
}

# Document overrides
document_overrides() {
    print_header

    if [ ! -d "$OVERRIDES_DIR" ]; then
        echo -e "${YELLOW}No overrides directory found${NC}"
        exit 0
    fi

    echo -e "${BLUE}→ Generating documentation...${NC}"

    # Create README header
    cat > "$README_PATH" << 'EOF'
# Component Overrides

This directory contains customized versions of best-practices components.

## Overview

Overrides allow you to customize default components while maintaining the ability to sync updates from the upstream repository. When the base components are updated, your overrides are preserved.

## Current Overrides

EOF

    # List all overrides
    local count=0
    while IFS= read -r -d '' override_file; do
        local rel_path="${override_file#$OVERRIDES_DIR/}"

        # Skip README
        if [[ "$rel_path" == "README.md" ]]; then
            continue
        fi

        local component=$(dirname "$rel_path")
        local filename=$(basename "$rel_path")

        # Add to README
        echo "### $component/$filename" >> "$README_PATH"
        echo >> "$README_PATH"
        echo "**Location:** \`.github/overrides/$rel_path\`" >> "$README_PATH"
        echo >> "$README_PATH"

        # Get modification time
        if [[ "$OSTYPE" == "darwin"* ]]; then
            local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$override_file")
        else
            local mod_time=$(stat -c "%y" "$override_file" | cut -d'.' -f1)
        fi
        echo "**Last modified:** $mod_time" >> "$README_PATH"
        echo >> "$README_PATH"

        # Add description based on file type
        case "$filename" in
            config.json)
                echo "Configuration override for $component component." >> "$README_PATH"
                ;;
            rules.md)
                echo "Custom rules for $component component." >> "$README_PATH"
                ;;
            *)
                echo "Custom $filename for $component component." >> "$README_PATH"
                ;;
        esac
        echo >> "$README_PATH"
        echo "---" >> "$README_PATH"
        echo >> "$README_PATH"

        ((count++))
    done < <(find "$OVERRIDES_DIR" -type f -not -name "README.md" -print0 | sort -z)

    # Add footer
    cat >> "$README_PATH" << 'EOF'

## Managing Overrides

### Create Override

```bash
./scripts/customize.sh create-override --component=<path> --file=<filename>
```

### List Overrides

```bash
./scripts/customize.sh list-overrides
```

### Validate Overrides

```bash
./scripts/customize.sh validate
```

### Update Documentation

```bash
./scripts/customize.sh document
```

## Best Practices

1. **Keep overrides minimal** - Only override what you need to change
2. **Document changes** - Add comments explaining why changes were made
3. **Review updates** - Check for conflicts when syncing upstream changes
4. **Test thoroughly** - Validate overrides work as expected
5. **Version control** - Commit overrides to your repository

## Merge Behavior

Override files are deep-merged with base components:

- **Objects**: Properties are merged recursively
- **Arrays**: Arrays are concatenated and deduplicated
- **Primitives**: Override value replaces base value

For more details, see `scripts/merge-settings.sh`.

EOF

    echo -e "${GREEN}✓ Documentation updated${NC}"
    echo -e "Path: $README_PATH"
    echo -e "Documented: ${GREEN}$count${NC} override(s)"
    echo
}

# Execute command
case "$COMMAND" in
    create-override)
        create_override
        ;;
    list-overrides)
        list_overrides
        ;;
    validate)
        validate_overrides
        ;;
    document)
        document_overrides
        ;;
    --help|-h)
        usage
        ;;
    *)
        echo -e "${RED}Error: Unknown command: $COMMAND${NC}"
        usage
        ;;
esac
