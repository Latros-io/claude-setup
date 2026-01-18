#!/usr/bin/env bash
#
# sync.sh - Pull latest updates from best-practices submodule
#
# Usage:
#   ./sync.sh              # Check for updates
#   ./sync.sh --apply      # Apply updates
#   ./sync.sh --help       # Show help

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$SUBMODULE_ROOT")"

# Default values
APPLY=false
CREATE_BACKUP=true
BACKUP_DIR="$PROJECT_ROOT/.claude/backups"

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Pull latest updates from best-practices submodule and validate against local overrides.

OPTIONS:
    --apply         Apply updates (default: check only)
    --no-backup     Don't create backup before applying updates
    --help          Show this help message

EXAMPLES:
    # Check for updates
    $0

    # Apply updates with backup
    $0 --apply

    # Apply updates without backup
    $0 --apply --no-backup

EOF
    exit 0
}

# Parse arguments
for arg in "$@"; do
    case $arg in
        --apply)
            APPLY=true
            shift
            ;;
        --no-backup)
            CREATE_BACKUP=false
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
echo -e "${BLUE}  Claude Code Best Practices - Sync${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if we're in a git repository
if ! git -C "$PROJECT_ROOT" rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check if submodule exists
if [ ! -d "$SUBMODULE_ROOT/.git" ]; then
    echo -e "${RED}Error: Best practices submodule not found${NC}"
    echo "Run: git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices"
    exit 1
fi

# Get current version
cd "$SUBMODULE_ROOT"
CURRENT_VERSION=$(git describe --tags --always 2>/dev/null || echo "unknown")
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

echo -e "Current version: ${BLUE}$CURRENT_VERSION${NC} (branch: $CURRENT_BRANCH)"
echo

# Fetch latest
echo -e "${BLUE}→ Fetching latest updates...${NC}"
git fetch origin --quiet

# Check for updates
LATEST_VERSION=$(git describe --tags --always origin/main 2>/dev/null || echo "unknown")
COMMITS_BEHIND=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo "0")

if [ "$COMMITS_BEHIND" -eq 0 ]; then
    echo -e "${GREEN}✓ Already up to date!${NC}"
    exit 0
fi

echo -e "${YELLOW}⚠ Updates available: $COMMITS_BEHIND commit(s) behind${NC}"
echo -e "Latest version: ${BLUE}$LATEST_VERSION${NC}"
echo

# Show changelog if available
if [ -f "$SUBMODULE_ROOT/CHANGELOG.md" ]; then
    echo -e "${BLUE}Recent changes:${NC}"
    echo
    # Show changes since current version
    git log --oneline HEAD..origin/main | head -n 10
    echo
fi

# Check for breaking changes
echo -e "${BLUE}→ Checking for breaking changes...${NC}"
BREAKING_CHANGES=$(git log HEAD..origin/main --grep="BREAKING CHANGE" --oneline | wc -l)
if [ "$BREAKING_CHANGES" -gt 0 ]; then
    echo -e "${RED}⚠ WARNING: $BREAKING_CHANGES breaking change(s) detected!${NC}"
    git log HEAD..origin/main --grep="BREAKING CHANGE" --oneline
    echo
fi

# Check for conflicts with local overrides
echo -e "${BLUE}→ Checking for conflicts with local overrides...${NC}"
OVERRIDES_DIR="$PROJECT_ROOT/.github/overrides"
if [ -d "$OVERRIDES_DIR" ]; then
    # Get list of modified files
    MODIFIED_FILES=$(git diff --name-only HEAD origin/main)

    CONFLICTS=0
    while IFS= read -r file; do
        # Extract component path
        component=$(echo "$file" | cut -d'/' -f1-3)
        override_path="$OVERRIDES_DIR/${file#*/}"

        if [ -f "$override_path" ]; then
            echo -e "${YELLOW}  ⚠ Potential conflict: $file${NC}"
            echo -e "    Override exists: $override_path"
            ((CONFLICTS++))
        fi
    done <<< "$MODIFIED_FILES"

    if [ "$CONFLICTS" -eq 0 ]; then
        echo -e "${GREEN}✓ No conflicts detected${NC}"
    else
        echo -e "${YELLOW}  Found $CONFLICTS potential conflict(s)${NC}"
        echo -e "  Review overrides before applying updates"
    fi
else
    echo -e "${GREEN}✓ No local overrides${NC}"
fi
echo

# If not applying, exit
if [ "$APPLY" = false ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "To apply updates, run: ${GREEN}$0 --apply${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
fi

# Create backup if requested
if [ "$CREATE_BACKUP" = true ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_PATH="$BACKUP_DIR/pre-sync-$TIMESTAMP"

    echo -e "${BLUE}→ Creating backup...${NC}"
    mkdir -p "$BACKUP_PATH"

    # Backup .github directory
    if [ -d "$PROJECT_ROOT/.github" ]; then
        cp -r "$PROJECT_ROOT/.github" "$BACKUP_PATH/"
        echo -e "${GREEN}✓ Backed up to: $BACKUP_PATH${NC}"
    fi
    echo
fi

# Apply updates
echo -e "${BLUE}→ Applying updates...${NC}"
git merge origin/main --ff-only

if [ $? -eq 0 ]; then
    NEW_VERSION=$(git describe --tags --always)
    echo -e "${GREEN}✓ Successfully updated to $NEW_VERSION${NC}"

    # Update submodule reference in parent repo
    cd "$PROJECT_ROOT"
    git add "$SUBMODULE_ROOT"
    echo
    echo -e "${YELLOW}Note: Submodule updated. Commit the change:${NC}"
    echo -e "  ${BLUE}git commit -m 'Update best-practices submodule to $NEW_VERSION'${NC}"
else
    echo -e "${RED}✗ Update failed${NC}"
    echo "You may have local changes. Commit or stash them first."
    exit 1
fi

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Sync complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
