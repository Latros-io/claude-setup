#!/usr/bin/env bash
#
# migrate-from-plugin.sh - Migrate from v2.x plugin to v3.x submodule
#
# Usage:
#   ./migrate-from-plugin.sh              # Interactive migration
#   ./migrate-from-plugin.sh --auto       # Automatic migration
#   ./migrate-from-plugin.sh --help       # Show help

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$SUBMODULE_ROOT")"

# Default values
AUTO_MODE=false
BACKUP_DIR="$HOME/.claude/migration-backups/$(date +%Y%m%d_%H%M%S)"
PLUGIN_PATH="$HOME/.claude/plugins/claude-skills-registry"

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Migrate from v2.x plugin-based installation to v3.x git submodule.

OPTIONS:
    --auto          Run migration automatically without prompts
    --help          Show this help message

WHAT THIS SCRIPT DOES:
    1. Backs up current .github/ and .claude/ directories
    2. Extracts user customizations from existing components
    3. Removes v2.x plugin
    4. Adds v3.x submodule
    5. Links components using appropriate profile
    6. Restores customizations to overrides/
    7. Generates migration report

EXAMPLES:
    # Interactive migration (recommended)
    $0

    # Automatic migration
    $0 --auto

EOF
    exit 0
}

# Parse arguments
for arg in "$@"; do
    case $arg in
        --auto)
            AUTO_MODE=true
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
clear
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Claude Code Best Practices - Migration Tool${NC}"
echo -e "${BLUE}  v2.x Plugin → v3.x Git Submodule${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if we're in a git repository
if ! git -C "$PROJECT_ROOT" rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    echo "This script must be run from within a git repository."
    exit 1
fi

# Check if plugin is installed
echo -e "${CYAN}→ Checking for v2.x plugin installation...${NC}"
if [ ! -d "$PROJECT_ROOT/.github/agents" ] && [ ! -d "$PROJECT_ROOT/.github/skills" ]; then
    echo -e "${YELLOW}No v2.x components found in .github/${NC}"
    echo
    read -p "Continue with fresh v3.x installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Migration cancelled."
        exit 0
    fi
    FRESH_INSTALL=true
else
    FRESH_INSTALL=false
    echo -e "${GREEN}✓ Found v2.x components${NC}"
fi
echo

# Detect installed components
INSTALLED_AGENTS=()
INSTALLED_SKILLS=()
INSTALLED_RULES=()

if [ "$FRESH_INSTALL" = false ]; then
    echo -e "${CYAN}→ Detecting installed components...${NC}"

    if [ -d "$PROJECT_ROOT/.github/agents" ]; then
        while IFS= read -r -d '' agent; do
            agent_name=$(basename "$agent")
            INSTALLED_AGENTS+=("$agent_name")
        done < <(find "$PROJECT_ROOT/.github/agents" -mindepth 1 -maxdepth 1 -type d -print0)
    fi

    if [ -d "$PROJECT_ROOT/.github/skills" ]; then
        while IFS= read -r -d '' skill; do
            skill_name=$(basename "$skill")
            INSTALLED_SKILLS+=("$skill_name")
        done < <(find "$PROJECT_ROOT/.github/skills" -mindepth 1 -maxdepth 1 -type d -print0)
    fi

    if [ -d "$PROJECT_ROOT/.github/rules" ]; then
        while IFS= read -r -d '' rule; do
            rule_name=$(basename "$rule")
            INSTALLED_RULES+=("$rule_name")
        done < <(find "$PROJECT_ROOT/.github/rules" -mindepth 1 -maxdepth 1 -type d -print0)
    fi

    echo -e "  Agents: ${BLUE}${INSTALLED_AGENTS[*]:-none}${NC}"
    echo -e "  Skills: ${BLUE}${INSTALLED_SKILLS[*]:-none}${NC}"
    echo -e "  Rules:  ${BLUE}${INSTALLED_RULES[*]:-none}${NC}"
    echo
fi

# Suggest profile based on installed components
SUGGESTED_PROFILE="core"
if [ "$FRESH_INSTALL" = false ]; then
    # Check for domain indicators
    if [ -f "$PROJECT_ROOT/package.json" ]; then
        if grep -q "react" "$PROJECT_ROOT/package.json" 2>/dev/null; then
            SUGGESTED_PROFILE="web-frontend"
        elif grep -q "express" "$PROJECT_ROOT/package.json" 2>/dev/null; then
            SUGGESTED_PROFILE="web-backend"
        fi
    elif [ -f "$PROJECT_ROOT/requirements.txt" ]; then
        if grep -q "pandas\|numpy\|jupyter" "$PROJECT_ROOT/requirements.txt" 2>/dev/null; then
            SUGGESTED_PROFILE="data-science"
        fi
    elif [ -f "$PROJECT_ROOT/Dockerfile" ] || [ -f "$PROJECT_ROOT/docker-compose.yml" ]; then
        SUGGESTED_PROFILE="devops"
    fi
fi

# Show migration plan
echo -e "${CYAN}Migration Plan:${NC}"
echo -e "  1. Backup current configuration"
echo -e "  2. Extract customizations"
echo -e "  3. Remove v2.x components"
echo -e "  4. Add v3.x submodule"
echo -e "  5. Link components (profile: ${BLUE}$SUGGESTED_PROFILE${NC})"
echo -e "  6. Restore customizations"
echo -e "  7. Generate report"
echo
echo -e "  Backup location: ${BLUE}$BACKUP_DIR${NC}"
echo

# Confirm migration
if [ "$AUTO_MODE" = false ]; then
    read -p "Proceed with migration? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Migration cancelled."
        exit 0
    fi
    echo
fi

# Step 1: Create backup
echo -e "${CYAN}[1/7] Creating backup...${NC}"
mkdir -p "$BACKUP_DIR"

if [ -d "$PROJECT_ROOT/.github" ]; then
    cp -r "$PROJECT_ROOT/.github" "$BACKUP_DIR/.github"
    echo -e "${GREEN}✓ Backed up .github/${NC}"
fi

if [ -d "$PROJECT_ROOT/.claude" ]; then
    cp -r "$PROJECT_ROOT/.claude" "$BACKUP_DIR/.claude"
    echo -e "${GREEN}✓ Backed up .claude/${NC}"
fi

echo -e "${GREEN}✓ Backup complete: $BACKUP_DIR${NC}"
echo

# Step 2: Extract customizations
echo -e "${CYAN}[2/7] Extracting customizations...${NC}"
CUSTOMIZATIONS_DIR="$BACKUP_DIR/customizations"
mkdir -p "$CUSTOMIZATIONS_DIR"

CUSTOMIZATION_COUNT=0

# Check for modified config files
if [ "$FRESH_INSTALL" = false ]; then
    for component_type in agents skills rules; do
        if [ -d "$PROJECT_ROOT/.github/$component_type" ]; then
            for component in "$PROJECT_ROOT/.github/$component_type"/*; do
                if [ -d "$component" ]; then
                    component_name=$(basename "$component")

                    # Check for modified config.json
                    if [ -f "$component/config.json" ]; then
                        mkdir -p "$CUSTOMIZATIONS_DIR/$component_type/$component_name"
                        cp "$component/config.json" "$CUSTOMIZATIONS_DIR/$component_type/$component_name/"
                        ((CUSTOMIZATION_COUNT++))
                    fi

                    # Check for custom templates
                    if [ -d "$component/templates" ]; then
                        mkdir -p "$CUSTOMIZATIONS_DIR/$component_type/$component_name"
                        cp -r "$component/templates" "$CUSTOMIZATIONS_DIR/$component_type/$component_name/"
                        ((CUSTOMIZATION_COUNT++))
                    fi
                fi
            done
        fi
    done
fi

echo -e "${GREEN}✓ Extracted $CUSTOMIZATION_COUNT customization(s)${NC}"
echo

# Step 3: Remove v2.x components
echo -e "${CYAN}[3/7] Removing v2.x components...${NC}"

if [ -d "$PROJECT_ROOT/.github/agents" ]; then
    rm -rf "$PROJECT_ROOT/.github/agents"
    echo -e "${GREEN}✓ Removed .github/agents${NC}"
fi

if [ -d "$PROJECT_ROOT/.github/skills" ]; then
    rm -rf "$PROJECT_ROOT/.github/skills"
    echo -e "${GREEN}✓ Removed .github/skills${NC}"
fi

if [ -d "$PROJECT_ROOT/.github/rules" ]; then
    rm -rf "$PROJECT_ROOT/.github/rules"
    echo -e "${GREEN}✓ Removed .github/rules${NC}"
fi

echo

# Step 4: Add v3.x submodule
echo -e "${CYAN}[4/7] Adding v3.x submodule...${NC}"

cd "$PROJECT_ROOT"

# Check if submodule already exists
if [ -d ".claude/best-practices/.git" ]; then
    echo -e "${YELLOW}⊘ Submodule already exists, skipping${NC}"
else
    git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices 2>&1 || {
        echo -e "${YELLOW}⊘ Submodule may already exist, trying update...${NC}"
        git submodule update --init --recursive
    }
    echo -e "${GREEN}✓ Added submodule${NC}"
fi

echo

# Step 5: Link components
echo -e "${CYAN}[5/7] Linking components with profile: ${BLUE}$SUGGESTED_PROFILE${NC}"

if [ "$AUTO_MODE" = false ]; then
    echo
    echo "Available profiles:"
    echo "  1) core - Core components only"
    echo "  2) web-frontend - React, Vue, etc."
    echo "  3) web-backend - Node, Express, etc."
    echo "  4) data-science - Python, Jupyter, ML"
    echo "  5) devops - Docker, K8s, Terraform"
    echo
    read -p "Select profile [default: $SUGGESTED_PROFILE]: " profile_choice

    case $profile_choice in
        1) SELECTED_PROFILE="core" ;;
        2) SELECTED_PROFILE="web-frontend" ;;
        3) SELECTED_PROFILE="web-backend" ;;
        4) SELECTED_PROFILE="data-science" ;;
        5) SELECTED_PROFILE="devops" ;;
        "") SELECTED_PROFILE="$SUGGESTED_PROFILE" ;;
        *) SELECTED_PROFILE="$profile_choice" ;;
    esac
else
    SELECTED_PROFILE="$SUGGESTED_PROFILE"
fi

echo
.claude/best-practices/scripts/link.sh --profile="$SELECTED_PROFILE"
echo

# Step 6: Restore customizations
echo -e "${CYAN}[6/7] Restoring customizations...${NC}"

if [ "$CUSTOMIZATION_COUNT" -gt 0 ]; then
    mkdir -p "$PROJECT_ROOT/.github/overrides"

    if [ -d "$CUSTOMIZATIONS_DIR" ]; then
        cp -r "$CUSTOMIZATIONS_DIR"/* "$PROJECT_ROOT/.github/overrides/" 2>/dev/null || true
        echo -e "${GREEN}✓ Restored $CUSTOMIZATION_COUNT customization(s) to .github/overrides/${NC}"
    fi
else
    echo -e "${GREEN}✓ No customizations to restore${NC}"
fi

echo

# Step 7: Generate report
echo -e "${CYAN}[7/7] Generating migration report...${NC}"

REPORT_FILE="$BACKUP_DIR/migration-report.txt"

cat > "$REPORT_FILE" << EOF
Claude Code Best Practices Migration Report
============================================

Date: $(date)
Project: $(basename "$PROJECT_ROOT")

Migration Summary
-----------------
From: v2.x Plugin
To:   v3.x Git Submodule

Components Migrated
-------------------
Agents: ${INSTALLED_AGENTS[*]:-none}
Skills: ${INSTALLED_SKILLS[*]:-none}
Rules:  ${INSTALLED_RULES[*]:-none}

Selected Profile: $SELECTED_PROFILE

Customizations
--------------
Extracted: $CUSTOMIZATION_COUNT
Location: .github/overrides/

Backup Location
---------------
$BACKUP_DIR

Next Steps
----------
1. Review customizations in .github/overrides/
2. Test that components work correctly
3. Apply settings profile:

   # Option 1: Standard profile
   cp .claude/best-practices/core/settings/standard.json .claude/settings.json

   # Option 2: Compose with domain profile
   .claude/best-practices/scripts/merge-settings.sh \\
       .claude/best-practices/core/settings/standard.json \\
       .claude/best-practices/domains/web/settings/react.json \\
       .claude/settings.json

4. Commit the migration:
   git add .claude .github
   git commit -m "Migrate to Claude Code best practices v3.0.0"

5. Read the integration guide:
   .claude/best-practices/INTEGRATION.md

Support
-------
Issues: https://github.com/Latros-io/claude-code-best-practices/issues
Docs: .claude/best-practices/INTEGRATION.md

EOF

echo -e "${GREEN}✓ Report generated: $REPORT_FILE${NC}"
echo

# Show completion summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Migration Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "Migration report: ${BLUE}$REPORT_FILE${NC}"
echo -e "Backup location:  ${BLUE}$BACKUP_DIR${NC}"
echo
echo -e "${CYAN}Next Steps:${NC}"
echo -e "1. Review migration report: ${BLUE}cat $REPORT_FILE${NC}"
echo -e "2. Apply settings profile (see report for commands)"
echo -e "3. Test components"
echo -e "4. Commit: ${BLUE}git add .claude .github && git commit -m 'Migrate to v3.0.0'${NC}"
echo
echo -e "For help, see: ${BLUE}.claude/best-practices/INTEGRATION.md${NC}"
echo

# Ask to view report
if [ "$AUTO_MODE" = false ]; then
    read -p "View migration report now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat "$REPORT_FILE"
    fi
fi
