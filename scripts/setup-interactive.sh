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
===============================================================

        Claude Code Best Practices - Interactive Setup

===============================================================
EOF
echo
echo "Welcome! This wizard will help you set up Claude Code for your project."
echo
echo "Press CTRL+C at any time to cancel."
echo

# Function to prompt for yes/no
prompt_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [[ "$default" == "y" ]]; then
        read -p "$prompt [Y/n]: " response
        response="${response:-y}"
    else
        read -p "$prompt [y/N]: " response
        response="${response:-n}"
    fi

    [[ "$response" =~ ^[Yy]$ ]]
}

# Function to prompt for selection from options
prompt_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local PS3="Select (1-${#options[@]}): "

    echo "$prompt"
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
echo "Step 1: Project Type Detection"
echo "============================================================"
echo

detected_type=$(detect_project_type)
if [[ "$detected_type" != "unknown" ]]; then
    echo "* Detected project type: $detected_type"
else
    echo "* Could not auto-detect project type"
fi
echo

# Step 2: Select profile
echo "Step 2: Choose Profile"
echo "============================================================"
echo

cat << 'EOF'
Available Profiles:

1. core
   General development (recommended for most projects)
   Components: 4 agents, 5 skills, 5 rules

2. web-frontend
   React, Vue, or other frontend frameworks
   Components: Core + Web domain (Frontend agent, UI components)

3. web-backend
   Node, Express, or other backend APIs
   Components: Core + Web domain (Backend agent, API tools)

4. data-science
   Python, Jupyter, ML projects
   Components: Core + Data Science domain (Jupyter, visualization)

5. devops
   Docker, Kubernetes, infrastructure
   Components: Core + DevOps domain (Container, K8s helpers)

EOF

# Recommend based on detected type
if [[ "$detected_type" == "web-frontend" ]]; then
    echo "> Recommended: web-frontend"
    default_profile="web-frontend"
elif [[ "$detected_type" == "web-backend" ]]; then
    echo "> Recommended: web-backend"
    default_profile="web-backend"
elif [[ "$detected_type" == "data-science" ]]; then
    echo "> Recommended: data-science"
    default_profile="data-science"
elif [[ "$detected_type" == "devops" ]]; then
    echo "> Recommended: devops"
    default_profile="devops"
else
    echo "> Recommended: core (safe default)"
    default_profile="core"
fi
echo

profile=$(prompt_select "Which profile do you want to use?" \
    "core" \
    "web-frontend" \
    "web-backend" \
    "data-science" \
    "devops")

echo "* Selected profile: $profile"
echo

# Step 3: Settings profile
echo "Step 3: Settings Profile"
echo "============================================================"
echo

cat << 'EOF'
Available Settings Profiles:

1. minimal
   Barebones setup (1 agent, 1 skill, 1 rule)
   For: Simple scripts, small projects

2. standard (recommended)
   Recommended for most projects (3 agents, 3 skills, 3 rules)
   For: Most development work

3. comprehensive
   Full power (4 agents, 5 skills, 5 rules)
   For: Large codebases, enterprise projects

EOF

settings_profile=$(prompt_select "Which settings profile do you want?" \
    "minimal" \
    "standard (recommended)" \
    "comprehensive")

# Remove "(recommended)" suffix if present
settings_profile="${settings_profile%% (*}"

echo "* Selected settings: $settings_profile"
echo

# Step 4: Link mode
echo "Step 4: Link Mode"
echo "============================================================"
echo

cat << 'EOF'
Choose how to integrate components:

1. Symlink (recommended)
   Creates symbolic links to submodule files
   Pros: Updates automatically, no duplication
   Cons: Not supported on older Windows systems

2. Copy
   Copies files from submodule to project
   Pros: Works everywhere, can modify locally
   Cons: Must re-run after updates

EOF

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "> Detected Windows - copy mode recommended"
    default_copy=true
else
    echo "> Recommended: symlink"
    default_copy=false
fi
echo

if prompt_yes_no "Use copy mode instead of symlinks?" "$([ "$default_copy" = true ] && echo 'y' || echo 'n')"; then
    copy_mode="--copy"
    echo "* Will use copy mode"
else
    copy_mode=""
    echo "* Will use symlink mode"
fi
echo

# Step 5: Auto-update
echo "Step 5: Auto-Update (Optional)"
echo "============================================================"
echo

cat << 'EOF'
Would you like to enable automatic updates?

This will create a git hook that checks for updates to the best-practices
submodule when you pull changes. You'll be notified if updates are available.

EOF

if prompt_yes_no "Enable auto-update checks?" "n"; then
    enable_auto_update=true
    echo "* Auto-update will be enabled"
else
    enable_auto_update=false
    echo "* Auto-update disabled (you can enable it later)"
fi
echo

# Step 6: Summary and confirmation
echo "Step 6: Review Configuration"
echo "============================================================"
echo

cat << EOF
Your Configuration:

  Profile:          $profile
  Settings:         $settings_profile
  Link Mode:        $([ -n "$copy_mode" ] && echo "copy" || echo "symlink")
  Auto-Update:      $([ "$enable_auto_update" = true ] && echo "enabled" || echo "disabled")

EOF

if ! prompt_yes_no "Proceed with setup?" "y"; then
    echo
    echo "Setup cancelled."
    exit 0
fi

echo
echo "Installing..."
echo "============================================================"
echo

# Step 7: Run link.sh
echo "> Linking components..."
if "$SCRIPT_DIR/link.sh" --profile="$profile" $copy_mode; then
    echo "* Components linked successfully"
else
    echo "ERROR: Failed to link components"
    exit 1
fi
echo

# Step 8: Apply settings
echo "> Applying settings profile..."

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
            echo "* Settings merged with domain profile"
        else
            # Fallback to just copying core settings
            echo "* Domain settings not found, using core only"
            cp "$settings_source" "$settings_target"
        fi
    else
        cp "$settings_source" "$settings_target"
    fi
else
    # Just copy core settings
    cp "$settings_source" "$settings_target"
    echo "* Settings applied"
fi
echo

# Step 9: Setup auto-update if requested
if [[ "$enable_auto_update" = true ]]; then
    echo "> Setting up auto-update..."
    if "$SCRIPT_DIR/setup-auto-update.sh" --enable; then
        echo "* Auto-update configured"
    else
        echo "* Could not setup auto-update (optional feature)"
    fi
    echo
fi

# Step 10: Save configuration
echo "> Saving configuration..."
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
echo "* Configuration saved to .claude/setup-config.json"
echo

# Final summary
echo
echo "============================================================"
echo "  Setup Complete!"
echo "============================================================"
echo

cat << EOF
What's Next:

1. Commit the changes to version control:
   git add .claude .github
   git commit -m "Setup Claude Code best practices"

2. Try these Claude commands:
   "Where is the authentication logic implemented?"
   "Run the test suite"
   "Create a commit for these changes"

3. Customize components as needed:
   $SCRIPT_DIR/customize.sh create-override --component=core/agents/Bash

4. Keep up to date:
   $SCRIPT_DIR/sync.sh

Documentation:
  - README: $SUBMODULE_ROOT/README.md
  - Integration Guide: $SUBMODULE_ROOT/INTEGRATION.md
  - Component Docs: $SUBMODULE_ROOT/core/

Need Help?
  - Issues: https://github.com/Latros-io/claude-setup/issues
  - Discussions: https://github.com/Latros-io/claude-setup/discussions

EOF

echo "Happy coding with Claude!"
echo
