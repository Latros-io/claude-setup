#!/usr/bin/env bash
#
# merge-settings.sh - Deep merge JSON configuration files
#
# Usage:
#   ./merge-settings.sh base.json override.json [output.json]
#   ./merge-settings.sh profile1.json profile2.json local.json [output.json]
#   ./merge-settings.sh --help

set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
OUTPUT_FILE=""
VALIDATE=true
VERBOSE=false

# Usage function
usage() {
    cat << EOF
Usage: $0 <file1.json> <file2.json> [<file3.json> ...] [output.json]

Deep merge JSON configuration files with extends directive support.

FEATURES:
    - Resolves "extends" directives recursively
    - Deep merge objects
    - Concatenate arrays (deduplicated)
    - Validates final output
    - Writes to output file or stdout

OPTIONS:
    --no-validate       Skip validation of output
    --verbose           Show detailed merge operations
    --help              Show this help message

MERGE BEHAVIOR:
    - Objects:      Properties merged recursively
    - Arrays:       Concatenated and deduplicated
    - Primitives:   Last value wins
    - null:         Removes property

EXTENDS DIRECTIVE:
    Files can include an "extends" field to inherit from base files:

    {
      "extends": "./base-config.json",
      "customProperty": "value"
    }

EXAMPLES:
    # Merge two files to stdout
    $0 base.json override.json

    # Merge multiple files to output file
    $0 profile1.json profile2.json local.json output.json

    # Merge with extends resolution
    $0 config.json merged-config.json

    # Verbose merge
    $0 --verbose base.json override.json output.json

EOF
    exit 0
}

# Check for required tools
check_requirements() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Error: python3 is required but not found${NC}"
        exit 1
    fi
}

# Parse arguments
declare -a INPUT_FILES=()

for arg in "$@"; do
    case $arg in
        --no-validate)
            VALIDATE=false
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        -*)
            echo -e "${RED}Error: Unknown option: $arg${NC}"
            usage
            ;;
        *)
            INPUT_FILES+=("$arg")
            shift
            ;;
    esac
done

# Check if we have at least 2 files
if [ ${#INPUT_FILES[@]} -lt 2 ]; then
    echo -e "${RED}Error: At least 2 JSON files are required${NC}"
    usage
fi

# Determine if last argument is output file
# Bash 3.2 compatible way to get last element
if [ ${#INPUT_FILES[@]} -gt 2 ]; then
    last_index=$((${#INPUT_FILES[@]} - 1))
    OUTPUT_FILE="${INPUT_FILES[$last_index]}"
    # Remove last element (Bash 3.2 compatible)
    INPUT_FILES=("${INPUT_FILES[@]:0:$last_index}")
fi

# Print header
if [ "$VERBOSE" = true ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Claude Code Best Practices - Settings Merge${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
fi

# Verify all input files exist
for file in "${INPUT_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}"
        exit 1
    fi
    [ "$VERBOSE" = true ] && echo -e "${BLUE}→ Input: $file${NC}"
done

[ "$VERBOSE" = true ] && [ -n "$OUTPUT_FILE" ] && echo -e "${BLUE}→ Output: $OUTPUT_FILE${NC}"
[ "$VERBOSE" = true ] && echo

# Python script for deep merge
MERGE_SCRIPT=$(cat << 'PYTHON_EOF'
import json
import sys
import os
from copy import deepcopy
from collections import OrderedDict

def resolve_extends(data, base_dir, visited=None):
    """Recursively resolve extends directives"""
    if visited is None:
        visited = set()

    if not isinstance(data, dict):
        return data

    if 'extends' not in data:
        return data

    extends_path = data['extends']

    # Resolve relative path
    if not os.path.isabs(extends_path):
        extends_path = os.path.normpath(os.path.join(base_dir, extends_path))

    # Check for circular extends
    if extends_path in visited:
        print(f"Error: Circular extends detected: {extends_path}", file=sys.stderr)
        sys.exit(1)

    visited.add(extends_path)

    # Load base file
    try:
        with open(extends_path) as f:
            base_data = json.load(f)
    except FileNotFoundError:
        print(f"Error: Extended file not found: {extends_path}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in {extends_path}: {e}", file=sys.stderr)
        sys.exit(1)

    # Recursively resolve extends in base
    base_dir_new = os.path.dirname(extends_path)
    base_data = resolve_extends(base_data, base_dir_new, visited.copy())

    # Remove extends from current data
    current_data = {k: v for k, v in data.items() if k != 'extends'}

    # Merge base with current
    return deep_merge(base_data, current_data)

def deep_merge(base, override):
    """Deep merge two dictionaries"""
    if not isinstance(base, dict) or not isinstance(override, dict):
        return override if override is not None else base

    result = deepcopy(base)

    for key, value in override.items():
        if value is None:
            # null removes property
            result.pop(key, None)
        elif key in result:
            if isinstance(result[key], dict) and isinstance(value, dict):
                # Merge objects recursively
                result[key] = deep_merge(result[key], value)
            elif isinstance(result[key], list) and isinstance(value, list):
                # Concatenate arrays and deduplicate
                merged = result[key] + value
                # Deduplicate while preserving order
                seen = set()
                deduped = []
                for item in merged:
                    # Handle both hashable and unhashable items
                    try:
                        item_key = json.dumps(item, sort_keys=True) if isinstance(item, (dict, list)) else item
                        if item_key not in seen:
                            seen.add(item_key)
                            deduped.append(item)
                    except TypeError:
                        # If item is not JSON serializable, just append
                        deduped.append(item)
                result[key] = deduped
            else:
                # Override value
                result[key] = value
        else:
            result[key] = value

    return result

def merge_files(file_paths, verbose=False):
    """Merge multiple JSON files"""
    result = {}

    for file_path in file_paths:
        if verbose:
            print(f"Merging: {file_path}", file=sys.stderr)

        try:
            with open(file_path) as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"Error: Invalid JSON in {file_path}: {e}", file=sys.stderr)
            sys.exit(1)

        # Resolve extends
        base_dir = os.path.dirname(os.path.abspath(file_path))
        data = resolve_extends(data, base_dir)

        # Merge with result
        result = deep_merge(result, data)

    return result

def validate_json(data):
    """Validate JSON data"""
    try:
        json.dumps(data)
        return True
    except (TypeError, ValueError) as e:
        print(f"Error: Invalid JSON output: {e}", file=sys.stderr)
        return False

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Deep merge JSON files')
    parser.add_argument('files', nargs='+', help='JSON files to merge')
    parser.add_argument('--output', help='Output file (stdout if not specified)')
    parser.add_argument('--no-validate', action='store_true', help='Skip validation')
    parser.add_argument('--verbose', action='store_true', help='Verbose output')

    args = parser.parse_args()

    # Merge files
    try:
        result = merge_files(args.files, args.verbose)
    except Exception as e:
        print(f"Error during merge: {e}", file=sys.stderr)
        sys.exit(1)

    # Validate
    if not args.no_validate:
        if not validate_json(result):
            sys.exit(1)

    # Output
    output_json = json.dumps(result, indent=2, ensure_ascii=False)

    if args.output:
        try:
            with open(args.output, 'w') as f:
                f.write(output_json)
            if args.verbose:
                print(f"✓ Written to: {args.output}", file=sys.stderr)
        except IOError as e:
            print(f"Error writing output: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        print(output_json)
PYTHON_EOF
)

# Build python command arguments
PYTHON_ARGS=("${INPUT_FILES[@]}")

if [ -n "$OUTPUT_FILE" ]; then
    PYTHON_ARGS+=("--output" "$OUTPUT_FILE")
fi

if [ "$VALIDATE" = false ]; then
    PYTHON_ARGS+=("--no-validate")
fi

if [ "$VERBOSE" = true ]; then
    PYTHON_ARGS+=("--verbose")
fi

# Execute merge
if python3 -c "$MERGE_SCRIPT" "${PYTHON_ARGS[@]}"; then
    if [ "$VERBOSE" = true ]; then
        echo
        echo -e "${GREEN}✓ Merge complete${NC}"
        [ -n "$OUTPUT_FILE" ] && echo -e "Output: ${BLUE}$OUTPUT_FILE${NC}"
    fi
    exit 0
else
    if [ "$VERBOSE" = true ]; then
        echo
        echo -e "${RED}✗ Merge failed${NC}"
    fi
    exit 1
fi
