#!/usr/bin/env bash
#
# setup-auto-update.sh - Configure automatic update checks for Claude Code best practices
#
# This script sets up git hooks to automatically check for updates to the best-practices
# submodule and notify the user when updates are available.
#
# Usage:
#   ./setup-auto-update.sh --enable     # Enable auto-update checks
#   ./setup-auto-update.sh --disable    # Disable auto-update checks
#   ./setup-auto-update.sh --status     # Check if enabled
#   ./setup-auto-update.sh --help       # Show help

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$SUBMODULE_ROOT/..")"

# Git hooks directory
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
POST_MERGE_HOOK="$HOOKS_DIR/post-merge"
POST_CHECKOUT_HOOK="$HOOKS_DIR/post-checkout"

# Marker to identify our hook code
HOOK_MARKER="# CLAUDE_SETUP_AUTO_UPDATE"

# Usage function
usage() {
    cat << EOF
${BOLD}${BLUE}Claude Code Best Practices - Auto-Update Setup${NC}

Configure automatic update checks for the best-practices submodule.

${BOLD}Usage:${NC}
    $0 --enable       Enable auto-update checks
    $0 --disable      Disable auto-update checks
    $0 --status       Check if auto-update is enabled
    $0 --help         Show this help message

${BOLD}What This Does:${NC}
When enabled, this creates git hooks that:
  • Check for updates when you pull changes (post-merge hook)
  • Check for updates when you switch branches (post-checkout hook)
  • Display a notification if updates are available
  • Never automatically applies updates (you stay in control)

${BOLD}Examples:${NC}
    # Enable auto-update checks
    $0 --enable

    # Disable auto-update checks
    $0 --disable

    # Check status
    $0 --status

${BOLD}Safety:${NC}
This only checks for updates and notifies you. It never automatically
applies updates. You always control when to update using:
    $SCRIPT_DIR/sync.sh --apply

EOF
    exit 0
}

# Hook code that will be injected
get_hook_code() {
    cat << 'HOOKEOF'
$HOOK_MARKER - START
# Auto-check for Claude Code best-practices updates
if [ -d ".claude/best-practices" ]; then
    (
        cd .claude/best-practices 2>/dev/null || exit 0

        # Fetch latest from remote (quietly)
        git fetch origin --quiet 2>/dev/null || exit 0

        # Check if behind
        LOCAL=$(git rev-parse HEAD 2>/dev/null)
        REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "$LOCAL")

        if [ "$LOCAL" != "$REMOTE" ]; then
            COMMITS_BEHIND=$(git rev-list HEAD..@{u} --count 2>/dev/null || echo "0")

            if [ "$COMMITS_BEHIND" -gt 0 ]; then
                echo ""
                echo "╔═══════════════════════════════════════════════════════════════╗"
                echo "║  Claude Code Best Practices - Updates Available              ║"
                echo "╚═══════════════════════════════════════════════════════════════╝"
                echo ""
                echo "  📦 $COMMITS_BEHIND new update(s) available for best-practices"
                echo ""
                echo "  To review and apply updates, run:"
                echo "    .claude/best-practices/scripts/sync.sh"
                echo ""
                echo "  To disable these notifications, run:"
                echo "    .claude/best-practices/scripts/setup-auto-update.sh --disable"
                echo ""
            fi
        fi
    ) &
fi
$HOOK_MARKER - END
HOOKEOF
}

# Function to check if hook is installed
is_hook_installed() {
    local hook_file="$1"

    if [[ ! -f "$hook_file" ]]; then
        return 1
    fi

    if grep -q "$HOOK_MARKER" "$hook_file" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to install hook
install_hook() {
    local hook_file="$1"
    local hook_code="$2"

    # Create hooks directory if it doesn't exist
    mkdir -p "$HOOKS_DIR"

    # If hook file doesn't exist, create it with shebang
    if [[ ! -f "$hook_file" ]]; then
        cat > "$hook_file" << 'EOF'
#!/usr/bin/env bash
EOF
        chmod +x "$hook_file"
    fi

    # Check if already installed
    if is_hook_installed "$hook_file"; then
        echo -e "${YELLOW}⊘ Hook already installed in $(basename "$hook_file")${NC}"
        return 0
    fi

    # Append hook code
    echo "" >> "$hook_file"
    echo "$hook_code" >> "$hook_file"

    # Make executable
    chmod +x "$hook_file"

    echo -e "${GREEN}✓ Installed hook in $(basename "$hook_file")${NC}"
}

# Function to remove hook
remove_hook() {
    local hook_file="$1"

    if [[ ! -f "$hook_file" ]]; then
        return 0
    fi

    if ! is_hook_installed "$hook_file"; then
        return 0
    fi

    # Remove lines between markers (inclusive)
    sed -i.bak "/$HOOK_MARKER - START/,/$HOOK_MARKER - END/d" "$hook_file"
    rm -f "${hook_file}.bak"

    # If file is now empty or only has shebang, remove it
    if [[ ! -s "$hook_file" ]] || [[ "$(wc -l < "$hook_file")" -le 2 ]]; then
        rm -f "$hook_file"
    fi

    echo -e "${GREEN}✓ Removed hook from $(basename "$hook_file")${NC}"
}

# Function to enable auto-update
enable_auto_update() {
    echo -e "${BOLD}${BLUE}Enabling Auto-Update Checks${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo

    # Check if we're in a git repository
    if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
        echo -e "${RED}✗ Error: Not in a git repository${NC}"
        echo "  Auto-update requires git hooks which need a git repository."
        exit 1
    fi

    local hook_code
    hook_code=$(get_hook_code)

    # Install hooks
    install_hook "$POST_MERGE_HOOK" "$hook_code"
    install_hook "$POST_CHECKOUT_HOOK" "$hook_code"

    echo
    echo -e "${GREEN}✓ Auto-update checks enabled!${NC}"
    echo
    echo "The system will now check for updates when you:"
    echo "  • Pull changes (git pull)"
    echo "  • Switch branches (git checkout)"
    echo
    echo "To manually check for updates anytime, run:"
    echo -e "  ${CYAN}.claude/best-practices/scripts/sync.sh${NC}"
    echo
}

# Function to disable auto-update
disable_auto_update() {
    echo -e "${BOLD}${BLUE}Disabling Auto-Update Checks${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo

    # Remove hooks
    remove_hook "$POST_MERGE_HOOK"
    remove_hook "$POST_CHECKOUT_HOOK"

    echo
    echo -e "${GREEN}✓ Auto-update checks disabled${NC}"
    echo
    echo "You can still manually check for updates anytime:"
    echo -e "  ${CYAN}.claude/best-practices/scripts/sync.sh${NC}"
    echo
}

# Function to show status
show_status() {
    echo -e "${BOLD}${BLUE}Auto-Update Status${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo

    local post_merge_installed
    local post_checkout_installed

    post_merge_installed=$(is_hook_installed "$POST_MERGE_HOOK" && echo "true" || echo "false")
    post_checkout_installed=$(is_hook_installed "$POST_CHECKOUT_HOOK" && echo "true" || echo "false")

    echo "Git Repository:  $([ -d "$PROJECT_ROOT/.git" ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
    echo "Post-merge hook: $([ "$post_merge_installed" = "true" ] && echo -e "${GREEN}Installed${NC}" || echo -e "${YELLOW}Not installed${NC}")"
    echo "Post-checkout hook: $([ "$post_checkout_installed" = "true" ] && echo -e "${GREEN}Installed${NC}" || echo -e "${YELLOW}Not installed${NC}")"
    echo

    if [[ "$post_merge_installed" = "true" ]] && [[ "$post_checkout_installed" = "true" ]]; then
        echo -e "Status: ${GREEN}${BOLD}ENABLED${NC}"
        echo
        echo "Auto-update checks are active. You'll be notified when updates are available."
    elif [[ "$post_merge_installed" = "true" ]] || [[ "$post_checkout_installed" = "true" ]]; then
        echo -e "Status: ${YELLOW}${BOLD}PARTIALLY ENABLED${NC}"
        echo
        echo "Some hooks are installed but not all. Run --enable to fix."
    else
        echo -e "Status: ${YELLOW}${BOLD}DISABLED${NC}"
        echo
        echo "Auto-update checks are not active."
        echo -e "Run ${CYAN}$0 --enable${NC} to enable them."
    fi
    echo
}

# Parse arguments
if [[ $# -eq 0 ]]; then
    usage
fi

case "${1:-}" in
    --enable)
        enable_auto_update
        ;;
    --disable)
        disable_auto_update
        ;;
    --status)
        show_status
        ;;
    --help|-h)
        usage
        ;;
    *)
        echo -e "${RED}Error: Unknown option: $1${NC}"
        echo
        usage
        ;;
esac
