#!/usr/bin/env bash
#
# link.sh - Create symlinks from best-practices submodule to project structure
#
# Usage:
#   ./link.sh --profile=web-frontend          # Link web frontend components
#   ./link.sh --profile=data-science --copy   # Copy data science components
#   ./link.sh --core-only                     # Only core components
#   ./link.sh --help                          # Show help

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

# Default values
PROFILE=""
CORE_ONLY=false
COPY_MODE=false
TARGET_DIR="${TARGET_DIR:-.github}"
DRY_RUN=false

# Function to get profile components
get_profile_components() {
    local profile="$1"

    case "$profile" in
        core)
            echo "core/agents core/skills core/rules"
            ;;
        web-frontend)
            echo "core/agents core/skills core/rules domains/web/agents domains/web/skills domains/web/rules"
            ;;
        web-backend)
            echo "core/agents core/skills core/rules domains/web/agents domains/web/skills domains/web/rules"
            ;;
        data-science)
            echo "core/agents core/skills core/rules domains/data-science/agents domains/data-science/skills domains/data-science/rules"
            ;;
        devops)
            echo "core/agents core/skills core/rules domains/devops/agents domains/devops/skills domains/devops/rules"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Create symlinks (or copies) from best-practices submodule to project structure.

OPTIONS:
    --profile=PROFILE       Use a predefined profile (core, web-frontend, web-backend, data-science, devops)
    --core-only            Link only core components
    --copy                 Copy files instead of symlinking (useful on Windows)
    --target-dir=DIR       Target directory (default: .github)
    --dry-run              Show what would be linked without making changes
    --help                 Show this help message

PROFILES:
    core                   Core components only (agents, skills, rules)
    web-frontend          Core + Web domain (React, Vue, etc.)
    web-backend           Core + Web domain (Node, Express, etc.)
    data-science          Core + Data Science domain (Python, Jupyter, ML)
    devops                Core + DevOps domain (Docker, K8s, Terraform)

EXAMPLES:
    # Link web frontend components
    $0 --profile=web-frontend

    # Copy data science components (Windows-friendly)
    $0 --profile=data-science --copy

    # Only link core components
    $0 --core-only

    # Dry run to see what would happen
    $0 --profile=devops --dry-run

EOF
    exit 0
}

# Parse arguments
for arg in "$@"; do
    case $arg in
        --profile=*)
            PROFILE="${arg#*=}"
            shift
            ;;
        --core-only)
            CORE_ONLY=true
            shift
            ;;
        --copy)
            COPY_MODE=true
            shift
            ;;
        --target-dir=*)
            TARGET_DIR="${arg#*=}"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
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

# Validate arguments
if [ "$CORE_ONLY" = true ] && [ -n "$PROFILE" ]; then
    echo -e "${RED}Error: Cannot use both --core-only and --profile${NC}"
    exit 1
fi

if [ "$CORE_ONLY" = false ] && [ -z "$PROFILE" ]; then
    echo -e "${RED}Error: Must specify either --core-only or --profile=PROFILE${NC}"
    usage
fi

# Get components to link
COMPONENTS=""
if [ "$CORE_ONLY" = true ]; then
    COMPONENTS=$(get_profile_components "core")
elif [ -n "$PROFILE" ]; then
    COMPONENTS=$(get_profile_components "$PROFILE")
    if [ -z "$COMPONENTS" ]; then
        echo -e "${RED}Error: Unknown profile: $PROFILE${NC}"
        echo "Available profiles: core, web-frontend, web-backend, data-science, devops"
        exit 1
    fi
fi

# Print header
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Claude Code Best Practices - Component Linker${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "Mode:        $([ "$COPY_MODE" = true ] && echo "${YELLOW}COPY${NC}" || echo "${GREEN}SYMLINK${NC}")"
echo -e "Target:      ${BLUE}$TARGET_DIR${NC}"
echo -e "Dry run:     $([ "$DRY_RUN" = true ] && echo "${YELLOW}Yes${NC}" || echo "No")"
echo

# Create target directory if it doesn't exist
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$TARGET_DIR"
fi

# Link or copy each component
linked_count=0
skipped_count=0

for component_path in $COMPONENTS; do
    source_path="$SUBMODULE_ROOT/$component_path"

    # Extract component type (agents, skills, rules)
    # component_path is like "core/agents" or "domains/web/agents"
    # We want the last part: "agents"
    component_type=$(basename "$component_path")

    target_path="$TARGET_DIR/$component_type"

    # Check if source exists
    if [ ! -d "$source_path" ]; then
        echo -e "${YELLOW}- Skipping $component_path (not found)${NC}"
        ((skipped_count++))
        continue
    fi

    # Create target directory
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_path"
    fi

    # Link/copy each item in the component directory
    for item in "$source_path"/*; do
        if [ ! -e "$item" ]; then
            continue
        fi

        item_name=$(basename "$item")
        target_item="$target_path/$item_name"

        # Skip if already exists
        if [ -e "$target_item" ] || [ -L "$target_item" ]; then
            echo -e "${YELLOW}- Skipping $component_type/$item_name (already exists)${NC}"
            ((skipped_count++))
            continue
        fi

        # Create relative path for symlink
        rel_path=$(python3 -c "import os.path; print(os.path.relpath('$item', '$target_path'))")

        if [ "$DRY_RUN" = true ]; then
            echo -e "${BLUE}> Would link: $target_item -> $rel_path${NC}"
        else
            if [ "$COPY_MODE" = true ]; then
                cp -r "$item" "$target_item"
                echo -e "${GREEN}✓ Copied: $target_item${NC}"
            else
                ln -s "$rel_path" "$target_item"
                echo -e "${GREEN}✓ Linked: $target_item${NC}"
            fi
            ((linked_count++))
        fi
    done
done

# Print summary
echo
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}Dry run - no changes made${NC}"
else
    echo -e "Linked/Copied: ${GREEN}$linked_count${NC}"
    echo -e "Skipped:       ${YELLOW}$skipped_count${NC}"
    echo
    echo -e "${GREEN}✓ Component linking complete!${NC}"
fi
echo
