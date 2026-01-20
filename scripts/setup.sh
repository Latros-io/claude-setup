#!/usr/bin/env bash
#
# setup.sh - Simple setup for Claude Code best practices
#
# This script helps you quickly set up Claude Code with the best practices library
# by copying the appropriate settings file to your project.
#
# Usage:
#   ./setup.sh                    # Interactive mode
#   ./setup.sh --profile=standard # Direct mode
#   ./setup.sh --help             # Show help

set -eo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(pwd)"

# Usage function
usage() {
    cat << EOF
${BLUE}Claude Code Best Practices - Simple Setup${NC}

This script copies the appropriate settings file to your project.

${BLUE}Usage:${NC}
    $0                       Interactive mode (recommended)
    $0 --profile=PROFILE     Direct mode with specified profile
    $0 --help                Show this help message

${BLUE}Available Profiles:${NC}
    minimal         - Barebones (1 agent, 1 skill, 1 rule)
    standard        - Recommended for most projects (3 agents, 3 skills, 3 rules)
    comprehensive   - Full power (4 agents, 5 skills, 5 rules)
    react           - React development (core + web domain)

${BLUE}Examples:${NC}
    # Interactive setup (choose profile from menu)
    $0

    # Direct setup with standard profile
    $0 --profile=standard

    # Setup for React project
    $0 --profile=react

${BLUE}What This Does:${NC}
    1. Copies the selected settings profile to .claude/settings.json
    2. Claude Code will read components from the submodule automatically
    3. No symlinks or extraction needed!

EOF
    exit 0
}

# Parse arguments
PROFILE=""
for arg in "$@"; do
    case $arg in
        --help|-h)
            usage
            ;;
        --profile=*)
            PROFILE="${arg#*=}"
            shift
            ;;
        *)
            echo -e "${RED}Error: Unknown option: $arg${NC}"
            usage
            ;;
    esac
done

# Function to prompt for selection from options
prompt_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local PS3="Select (1-${#options[@]}): "

    echo "$prompt" >&2
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            echo "$opt"
            return 0
        fi
    done
}

# Print header
clear
cat << "EOF"
===============================================================

        Claude Code Best Practices - Setup

===============================================================
EOF
echo
echo "Welcome! This script will set up Claude Code for your project."
echo
echo "The submodule contains all components. We just need to tell"
echo "Claude Code where to find them."
echo

# Interactive mode if no profile specified
if [[ -z "$PROFILE" ]]; then
    echo "Step 1: Choose Your Profile"
    echo "============================================================"
    echo

    cat << 'EOF'
Available Profiles:

1. minimal
   Barebones setup (1 agent, 1 skill, 1 rule)
   For: Simple scripts, small projects

2. standard (recommended)
   Balanced setup (3 agents, 3 skills, 3 rules)
   For: Most development work

3. comprehensive
   Full power (4 agents, 5 skills, 5 rules)
   For: Large codebases, enterprise projects

4. react
   React development (core + web domain components)
   For: React/frontend projects

EOF

    PROFILE=$(prompt_select "Which profile do you want to use?" \
        "minimal" \
        "standard (recommended)" \
        "comprehensive" \
        "react")

    # Remove "(recommended)" suffix if present
    PROFILE="${PROFILE%% (*}"

    echo
    echo "Selected profile: $PROFILE"
    echo
fi

# Validate profile
case "$PROFILE" in
    minimal|standard|comprehensive)
        SOURCE_FILE="$SUBMODULE_ROOT/core/settings/${PROFILE}.json"
        ;;
    react)
        SOURCE_FILE="$SUBMODULE_ROOT/domains/web/settings/react.json"
        ;;
    *)
        echo -e "${RED}Error: Unknown profile: $PROFILE${NC}"
        echo "Available profiles: minimal, standard, comprehensive, react"
        exit 1
        ;;
esac

# Check if source file exists
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo -e "${RED}Error: Settings file not found: $SOURCE_FILE${NC}"
    exit 1
fi

# Create .claude directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/.claude"

# Copy settings file
TARGET_FILE="$PROJECT_ROOT/.claude/settings.json"

if [[ -f "$TARGET_FILE" ]]; then
    echo -e "${YELLOW}Warning: $TARGET_FILE already exists${NC}"
    read -p "Overwrite? [y/N]: " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

echo "Copying settings file..."
cp "$SOURCE_FILE" "$TARGET_FILE"
echo -e "${GREEN}* Settings file created: .claude/settings.json${NC}"
echo

# Done
echo
echo "============================================================"
echo "  Setup Complete!"
echo "============================================================"
echo

cat << EOF
What's Next:

1. Verify the setup:
   cat .claude/settings.json

2. Commit the settings:
   git add .claude/settings.json
   git commit -m "Setup Claude Code with $PROFILE profile"

3. Try Claude Code:
   Ask Claude: "Where is the authentication logic?"
   Ask Claude: "Run the test suite"
   Ask Claude: "Create a commit for these changes"

4. Customize if needed:
   Edit .claude/settings.json to adjust paths or components

5. Update the library:
   cd .claude/best-practices && git pull

Documentation:
  - README: $SUBMODULE_ROOT/README.md
  - Settings: $SUBMODULE_ROOT/core/settings/README.md

Need Help?
  - Issues: https://github.com/Latros-io/claude-setup/issues
  - Discussions: https://github.com/Latros-io/claude-setup/discussions

EOF

echo "Happy coding with Claude!"
echo
