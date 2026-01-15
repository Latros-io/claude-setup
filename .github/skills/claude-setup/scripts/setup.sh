#!/bin/bash

# Claude Setup - Interactive Configuration Wizard
# POC Version 1.0.0

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# Configuration
CLAUDE_DIR=".claude"
CONFIG_FILE="$CLAUDE_DIR/settings.local.json"

# Storage for selections
MCP_SERVERS=()
AGENTS=()
SKILLS=()
RULES=()

# Print step header
print_step() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}Step $1/4: $2${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

# Create .claude directory
mkdir -p "$CLAUDE_DIR"

# Step 1: MCP Servers
print_step 1 "MCP Servers"
echo "Which MCP servers would you like to enable?"
echo "1) filesystem"
echo "2) github"
echo "3) postgres"
echo "4) docker"
echo ""
read -p "Enter numbers (comma-separated): " mcp_input

if [ ! -z "$mcp_input" ]; then
  IFS=',' read -ra NUMS <<< "$mcp_input"
  for num in "${NUMS[@]}"; do
    num=$(echo "$num" | xargs)
    case $num in
      1) MCP_SERVERS+=("filesystem") ;;
      2) MCP_SERVERS+=("github") ;;
      3) MCP_SERVERS+=("postgres") ;;
      4) MCP_SERVERS+=("docker") ;;
    esac
  done
fi

# Step 2: Agents
print_step 2 "Agents"
echo "Which agents would you like to enable?"
echo "1) Bash"
echo "2) Explore"
echo "3) Plan"
echo "4) general-purpose"
echo ""
read -p "Enter numbers (comma-separated): " agent_input

if [ ! -z "$agent_input" ]; then
  IFS=',' read -ra NUMS <<< "$agent_input"
  for num in "${NUMS[@]}"; do
    num=$(echo "$num" | xargs)
    case $num in
      1) AGENTS+=("Bash") ;;
      2) AGENTS+=("Explore") ;;
      3) AGENTS+=("Plan") ;;
      4) AGENTS+=("general-purpose") ;;
    esac
  done
fi

# Step 3: Skills
print_step 3 "Skills"
echo "Which skills would you like to enable?"
echo "1) git-workflow"
echo "2) test-runner"
echo "3) cicd-helper"
echo "4) doc-generator"
echo ""
read -p "Enter numbers (comma-separated): " skill_input

if [ ! -z "$skill_input" ]; then
  IFS=',' read -ra NUMS <<< "$skill_input"
  for num in "${NUMS[@]}"; do
    num=$(echo "$num" | xargs)
    case $num in
      1) SKILLS+=("git-workflow") ;;
      2) SKILLS+=("test-runner") ;;
      3) SKILLS+=("cicd-helper") ;;
      4) SKILLS+=("doc-generator") ;;
    esac
  done
fi

# Step 4: Rules
print_step 4 "Rules"
echo "Which rules would you like to configure?"
echo "1) code-style"
echo "2) testing"
echo "3) documentation"
echo "4) security"
echo ""
read -p "Enter numbers (comma-separated): " rule_input

if [ ! -z "$rule_input" ]; then
  IFS=',' read -ra NUMS <<< "$rule_input"
  for num in "${NUMS[@]}"; do
    num=$(echo "$num" | xargs)
    case $num in
      1) RULES+=("code-style") ;;
      2) RULES+=("testing") ;;
      3) RULES+=("documentation") ;;
      4) RULES+=("security") ;;
    esac
  done
fi

# Generate configuration file
echo ""
echo "Generating configuration..."

cat > "$CONFIG_FILE" << EOF
{
  "permissions": {
    "allow": ["WebSearch"]
  },
  "mcpServers": {
EOF

# Add MCP servers
if [ ${#MCP_SERVERS[@]} -gt 0 ]; then
  for i in "${!MCP_SERVERS[@]}"; do
    server="${MCP_SERVERS[$i]}"
    if [ $i -eq $((${#MCP_SERVERS[@]} - 1)) ]; then
      echo "    \"$server\": {}" >> "$CONFIG_FILE"
    else
      echo "    \"$server\": {}," >> "$CONFIG_FILE"
    fi
  done
fi

cat >> "$CONFIG_FILE" << EOF
  },
  "agents": [
EOF

# Add agents
if [ ${#AGENTS[@]} -gt 0 ]; then
  for i in "${!AGENTS[@]}"; do
    agent="${AGENTS[$i]}"
    if [ $i -eq $((${#AGENTS[@]} - 1)) ]; then
      echo "    \"$agent\"" >> "$CONFIG_FILE"
    else
      echo "    \"$agent\"," >> "$CONFIG_FILE"
    fi
  done
fi

cat >> "$CONFIG_FILE" << EOF
  ],
  "skills": [
EOF

# Add skills
if [ ${#SKILLS[@]} -gt 0 ]; then
  for i in "${!SKILLS[@]}"; do
    skill="${SKILLS[$i]}"
    if [ $i -eq $((${#SKILLS[@]} - 1)) ]; then
      echo "    \"$skill\"" >> "$CONFIG_FILE"
    else
      echo "    \"$skill\"," >> "$CONFIG_FILE"
    fi
  done
fi

cat >> "$CONFIG_FILE" << EOF
  ],
  "rules": [
EOF

# Add rules
if [ ${#RULES[@]} -gt 0 ]; then
  for i in "${!RULES[@]}"; do
    rule="${RULES[$i]}"
    if [ $i -eq $((${#RULES[@]} - 1)) ]; then
      echo "    \"$rule\"" >> "$CONFIG_FILE"
    else
      echo "    \"$rule\"," >> "$CONFIG_FILE"
    fi
  done
fi

cat >> "$CONFIG_FILE" << EOF
  ]
}
EOF

# Create CLAUDE.md if it doesn't exist
if [ ! -f "CLAUDE.md" ]; then
  cat > CLAUDE.md << 'EOFCLAUDE'
# CLAUDE.md

This file provides guidance to Claude Code when working with this project.

## Project Overview

[Describe your project here]

## Configuration

This project has been configured with the following Claude Code settings:

EOFCLAUDE

  if [ ${#MCP_SERVERS[@]} -gt 0 ]; then
    echo "### MCP Servers" >> CLAUDE.md
    for server in "${MCP_SERVERS[@]}"; do
      echo "- $server" >> CLAUDE.md
    done
    echo "" >> CLAUDE.md
  fi

  if [ ${#AGENTS[@]} -gt 0 ]; then
    echo "### Agents" >> CLAUDE.md
    for agent in "${AGENTS[@]}"; do
      echo "- $agent" >> CLAUDE.md
    done
    echo "" >> CLAUDE.md
  fi

  if [ ${#SKILLS[@]} -gt 0 ]; then
    echo "### Skills" >> CLAUDE.md
    for skill in "${SKILLS[@]}"; do
      echo "- $skill" >> CLAUDE.md
    done
    echo "" >> CLAUDE.md
  fi

  if [ ${#RULES[@]} -gt 0 ]; then
    echo "### Rules" >> CLAUDE.md
    for rule in "${RULES[@]}"; do
      echo "- $rule" >> CLAUDE.md
    done
    echo "" >> CLAUDE.md
  fi

  cat >> CLAUDE.md << 'EOFCLAUDE'
## Development Guidelines

[Add project-specific guidelines here]

## Common Commands

[List common commands here]
EOFCLAUDE
fi

# Success message
echo ""
echo -e "${GREEN}✓${NC} Configuration created at $CONFIG_FILE"
echo -e "${GREEN}✓${NC} Project guidance created at CLAUDE.md"
echo -e "${GREEN}✓${NC} Setup complete!"
echo ""
