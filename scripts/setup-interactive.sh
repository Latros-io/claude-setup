#!/usr/bin/env bash
#
# setup-interactive.sh - Interactive setup wizard for Claude Code best practices
#
# This script guides users through selecting which components and settings they want
# to enable in their project through an interactive CLI interface.
#
# Usage:
#   ./setup-interactive.sh              # Run interactive setup
#   ./setup-interactive.sh --help       # Show help

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$SUBMODULE_ROOT/..")"

# Configuration file to store user selections
CONFIG_FILE="$PROJECT_ROOT/.claude/setup-config.json"

# Usage function
usage() {
    cat << EOF
${BOLD}${BLUE}Claude Code Best Practices - Interactive Setup${NC}

This interactive wizard helps you configure Claude Code for your project by:
  • Selecting which profile fits your project type
  • Choosing individual components to enable/disable
  • Configuring settings and MCP servers
  • Setting up automatic updates

${BOLD}Usage:${NC}
    $0              Run interactive setup
    $0 --help       Show this help message

${BOLD}What This Does:${NC}
    1. Detects your project type
    2. Recommends an appropriate profile
    3. Lets you customize components
    4. Links selected components to your project
    5. Applies settings configuration
    6. Optionally sets up auto-update

${BOLD}Examples:${NC}
    # Run the interactive setup
    $0

EOF
    exit 0
}

# Parse arguments
for arg in "$@"; do
    case $arg in
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
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        Claude Code Best Practices - Interactive Setup        ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo
echo -e "${CYAN}Welcome! This wizard will help you set up Claude Code for your project.${NC}"
echo
echo -e "Press ${YELLOW}CTRL+C${NC} at any time to cancel."
echo

# Function to prompt for yes/no
prompt_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [[ "$default" == "y" ]]; then
        read -p "$(echo -e "${prompt} ${GREEN}[Y/n]${NC}: ")" response
        response="${response:-y}"
    else
        read -p "$(echo -e "${prompt} ${YELLOW}[y/N]${NC}: ")" response
        response="${response:-n}"
    fi

    [[ "$response" =~ ^[Yy]$ ]]
}

# Function to prompt for selection from options
prompt_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local PS3="$(echo -e "${BLUE}Select (1-${#options[@]}): ${NC}")"

    echo -e "${BOLD}${prompt}${NC}"
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            echo "$opt"
            return 0
        fi
    done
}

# Function to detect project type
detect_project_type() {
    local project_type="unknown"

    # Check for common files
    if [[ -f "package.json" ]]; then
        if grep -q "react" "package.json" 2>/dev/null; then
            project_type="web-frontend"
        elif grep -q "express\|fastify\|next" "package.json" 2>/dev/null; then
            project_type="web-backend"
        else
            project_type="web"
        fi
    elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
        if [[ -d "notebooks" ]] || ls *.ipynb &>/dev/null; then
            project_type="data-science"
        else
            project_type="python"
        fi
    elif [[ -f "Dockerfile" ]] || [[ -f "docker-compose.yml" ]]; then
        project_type="devops"
    elif [[ -f "Cargo.toml" ]]; then
        project_type="rust"
    elif [[ -f "go.mod" ]]; then
        project_type="go"
    fi

    echo "$project_type"
}

# Step 1: Detect project type
echo -e "${BOLD}${BLUE}Step 1: Project Type Detection${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

detected_type=$(detect_project_type)
if [[ "$detected_type" != "unknown" ]]; then
    echo -e "${GREEN}✓${NC} Detected project type: ${BOLD}$detected_type${NC}"
else
    echo -e "${YELLOW}⚠${NC} Could not auto-detect project type"
fi
echo

# Step 2: Select profile
echo -e "${BOLD}${BLUE}Step 2: Choose Profile${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

cat << EOF
${BOLD}Available Profiles:${NC}

${GREEN}1. core${NC}
   General development (recommended for most projects)
   Components: 4 agents, 5 skills, 5 rules

${CYAN}2. web-frontend${NC}
   React, Vue, or other frontend frameworks
   Components: Core + Web domain (Frontend agent, UI components)

${CYAN}3. web-backend${NC}
   Node, Express, or other backend APIs
   Components: Core + Web domain (Backend agent, API tools)

${MAGENTA}4. data-science${NC}
   Python, Jupyter, ML projects
   Components: Core + Data Science domain (Jupyter, visualization)

${YELLOW}5. devops${NC}
   Docker, Kubernetes, infrastructure
   Components: Core + DevOps domain (Container, K8s helpers)

EOF

# Recommend based on detected type
if [[ "$detected_type" == "web-frontend" ]]; then
    echo -e "${GREEN}→ Recommended: web-frontend${NC}"
    default_profile="web-frontend"
elif [[ "$detected_type" == "web-backend" ]]; then
    echo -e "${GREEN}→ Recommended: web-backend${NC}"
    default_profile="web-backend"
elif [[ "$detected_type" == "data-science" ]]; then
    echo -e "${GREEN}→ Recommended: data-science${NC}"
    default_profile="data-science"
elif [[ "$detected_type" == "devops" ]]; then
    echo -e "${GREEN}→ Recommended: devops${NC}"
    default_profile="devops"
else
    echo -e "${GREEN}→ Recommended: core (safe default)${NC}"
    default_profile="core"
fi
echo

profile=$(prompt_select "Which profile do you want to use?" \
    "core" \
    "web-frontend" \
    "web-backend" \
    "data-science" \
    "devops")

echo -e "${GREEN}✓${NC} Selected profile: ${BOLD}$profile${NC}"
echo

# Step 3: Settings profile
echo -e "${BOLD}${BLUE}Step 3: Settings Profile${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

cat << EOF
${BOLD}Available Settings Profiles:${NC}

${YELLOW}1. minimal${NC}
   Barebones setup (1 agent, 1 skill, 1 rule)
   For: Simple scripts, small projects

${GREEN}2. standard (recommended)${NC}
   Recommended for most projects (3 agents, 3 skills, 3 rules)
   For: Most development work

${BLUE}3. comprehensive${NC}
   Full power (4 agents, 5 skills, 5 rules)
   For: Large codebases, enterprise projects

EOF

settings_profile=$(prompt_select "Which settings profile do you want?" \
    "minimal" \
    "standard (recommended)" \
    "comprehensive")

# Remove "(recommended)" suffix if present
settings_profile="${settings_profile%% (*}"

echo -e "${GREEN}✓${NC} Selected settings: ${BOLD}$settings_profile${NC}"
echo

# Step 4: Link mode
echo -e "${BOLD}${BLUE}Step 4: Link Mode${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

cat << EOF
${BOLD}Choose how to integrate components:${NC}

${GREEN}1. Symlink (recommended)${NC}
   Creates symbolic links to submodule files
   Pros: Updates automatically, no duplication
   Cons: Not supported on older Windows systems

${YELLOW}2. Copy${NC}
   Copies files from submodule to project
   Pros: Works everywhere, can modify locally
   Cons: Must re-run after updates

EOF

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo -e "${YELLOW}→ Detected Windows - copy mode recommended${NC}"
    default_copy=true
else
    echo -e "${GREEN}→ Recommended: symlink${NC}"
    default_copy=false
fi
echo

if prompt_yes_no "Use copy mode instead of symlinks?" "$([ "$default_copy" = true ] && echo 'y' || echo 'n')"; then
    copy_mode="--copy"
    echo -e "${GREEN}✓${NC} Will use ${YELLOW}copy mode${NC}"
else
    copy_mode=""
    echo -e "${GREEN}✓${NC} Will use ${GREEN}symlink mode${NC}"
fi
echo

# Step 5: Auto-update
echo -e "${BOLD}${BLUE}Step 5: Auto-Update (Optional)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

cat << EOF
${BOLD}Would you like to enable automatic updates?${NC}

This will create a git hook that checks for updates to the best-practices
submodule when you pull changes. You'll be notified if updates are available.

EOF

if prompt_yes_no "Enable auto-update checks?" "n"; then
    enable_auto_update=true
    echo -e "${GREEN}✓${NC} Auto-update will be enabled"
else
    enable_auto_update=false
    echo -e "${YELLOW}⊘${NC} Auto-update disabled (you can enable it later)"
fi
echo

# Step 6: Summary and confirmation
echo -e "${BOLD}${BLUE}Step 6: Review Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

cat << EOF
${BOLD}Your Configuration:${NC}

  Profile:          ${GREEN}$profile${NC}
  Settings:         ${GREEN}$settings_profile${NC}
  Link Mode:        ${GREEN}$([ -n "$copy_mode" ] && echo "copy" || echo "symlink")${NC}
  Auto-Update:      ${GREEN}$([ "$enable_auto_update" = true ] && echo "enabled" || echo "disabled")${NC}

EOF

if ! prompt_yes_no "${BOLD}Proceed with setup?${NC}" "y"; then
    echo
    echo -e "${YELLOW}Setup cancelled.${NC}"
    exit 0
fi

echo
echo -e "${BOLD}${BLUE}Installing...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Step 7: Run link.sh
echo -e "${CYAN}→ Linking components...${NC}"
if "$SCRIPT_DIR/link.sh" --profile="$profile" $copy_mode; then
    echo -e "${GREEN}✓ Components linked successfully${NC}"
else
    echo -e "${RED}✗ Failed to link components${NC}"
    exit 1
fi
echo

# Step 8: Apply settings
echo -e "${CYAN}→ Applying settings profile...${NC}"

settings_source="$SUBMODULE_ROOT/core/settings/${settings_profile}.json"
settings_target="$PROJECT_ROOT/.claude/settings.json"

# Create .claude directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/.claude"

# Check if we need to merge with domain settings
if [[ "$profile" =~ ^(web-frontend|web-backend|data-science|devops)$ ]]; then
    # Determine domain settings file
    domain_settings=""
    case "$profile" in
        web-frontend)
            domain_settings="$SUBMODULE_ROOT/domains/web/settings/react.json"
            ;;
        web-backend)
            domain_settings="$SUBMODULE_ROOT/domains/web/settings/node-express.json"
            ;;
        data-science)
            domain_settings="$SUBMODULE_ROOT/domains/data-science/settings/pandas-numpy.json"
            ;;
        devops)
            domain_settings="$SUBMODULE_ROOT/domains/devops/settings/kubernetes.json"
            ;;
    esac

    # Merge if domain settings exist
    if [[ -f "$domain_settings" ]]; then
        if "$SCRIPT_DIR/merge-settings.sh" "$settings_source" "$domain_settings" "$settings_target"; then
            echo -e "${GREEN}✓ Settings merged with domain profile${NC}"
        else
            # Fallback to just copying core settings
            echo -e "${YELLOW}⚠ Domain settings not found, using core only${NC}"
            cp "$settings_source" "$settings_target"
        fi
    else
        cp "$settings_source" "$settings_target"
    fi
else
    # Just copy core settings
    cp "$settings_source" "$settings_target"
    echo -e "${GREEN}✓ Settings applied${NC}"
fi
echo

# Step 9: Setup auto-update if requested
if [[ "$enable_auto_update" = true ]]; then
    echo -e "${CYAN}→ Setting up auto-update...${NC}"
    if "$SCRIPT_DIR/setup-auto-update.sh" --enable; then
        echo -e "${GREEN}✓ Auto-update configured${NC}"
    else
        echo -e "${YELLOW}⚠ Could not setup auto-update (optional feature)${NC}"
    fi
    echo
fi

# Step 10: Save configuration
echo -e "${CYAN}→ Saving configuration...${NC}"
cat > "$CONFIG_FILE" << EOF
{
  "profile": "$profile",
  "settings_profile": "$settings_profile",
  "link_mode": "$([ -n "$copy_mode" ] && echo "copy" || echo "symlink")",
  "auto_update": $enable_auto_update,
  "setup_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version": "3.0.0"
}
EOF
echo -e "${GREEN}✓ Configuration saved to .claude/setup-config.json${NC}"
echo

# Final summary
echo
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  Setup Complete! 🎉${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

cat << EOF
${BOLD}What's Next:${NC}

${GREEN}1.${NC} Commit the changes to version control:
   ${CYAN}git add .claude .github
   git commit -m "Setup Claude Code best practices"${NC}

${GREEN}2.${NC} Try these Claude commands:
   ${CYAN}"Where is the authentication logic implemented?"
   "Run the test suite"
   "Create a commit for these changes"${NC}

${GREEN}3.${NC} Customize components as needed:
   ${CYAN}$SCRIPT_DIR/customize.sh create-override --component=core/agents/Bash${NC}

${GREEN}4.${NC} Keep up to date:
   ${CYAN}$SCRIPT_DIR/sync.sh${NC}

${BOLD}Documentation:${NC}
  • README: $SUBMODULE_ROOT/README.md
  • Integration Guide: $SUBMODULE_ROOT/INTEGRATION.md
  • Component Docs: $SUBMODULE_ROOT/core/

${BOLD}Need Help?${NC}
  • Issues: https://github.com/Latros-io/claude-setup/issues
  • Discussions: https://github.com/Latros-io/claude-setup/discussions

EOF

echo -e "${GREEN}Happy coding with Claude! ✨${NC}"
echo
