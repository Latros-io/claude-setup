#!/usr/bin/env bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
FORCE=false
SKIP_EXISTING=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -s|--skip-existing)
            SKIP_EXISTING=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-f|--force] [-s|--skip-existing]"
            exit 1
            ;;
    esac
done

# Get the plugin directory (where this script is located)
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Get the target repository directory (where the plugin is being installed)
TARGET_DIR="${PWD}"

echo -e "${BLUE}Installing claude-skills plugin...${NC}"
echo "Plugin location: ${PLUGIN_DIR}"
echo "Target location: ${TARGET_DIR}"

# Function to merge skills from plugin to target
merge_skills() {
    local source_skills="${PLUGIN_DIR}/.github/skills"
    local target_skills="${TARGET_DIR}/.github/skills"

    # Check if source skills directory exists
    if [ ! -d "${source_skills}" ]; then
        echo -e "${YELLOW}No skills found in plugin to copy.${NC}"
        return
    fi

    # Create target skills directory if it doesn't exist
    mkdir -p "${target_skills}"

    # Iterate through each skill in the plugin
    for skill_path in "${source_skills}"/*; do
        if [ -d "${skill_path}" ]; then
            local skill_name=$(basename "${skill_path}")
            local target_skill_path="${target_skills}/${skill_name}"

            # Check if skill already exists in target
            if [ -d "${target_skill_path}" ]; then
                if [ "${FORCE}" = true ]; then
                    echo -e "${GREEN}Overwriting skill '${skill_name}' (forced)...${NC}"
                    rm -rf "${target_skill_path}"
                    cp -r "${skill_path}" "${target_skill_path}"
                elif [ "${SKIP_EXISTING}" = true ]; then
                    echo -e "${BLUE}Skipping existing skill '${skill_name}'.${NC}"
                else
                    echo -e "${YELLOW}Skill '${skill_name}' already exists in target repository.${NC}"
                    echo -n "Overwrite? [y/N]: "
                    read -r response
                    if [[ "${response}" =~ ^[Yy]$ ]]; then
                        echo -e "${GREEN}Overwriting skill '${skill_name}'...${NC}"
                        rm -rf "${target_skill_path}"
                        cp -r "${skill_path}" "${target_skill_path}"
                    else
                        echo -e "${BLUE}Skipping skill '${skill_name}'.${NC}"
                    fi
                fi
            else
                echo -e "${GREEN}Copying skill '${skill_name}'...${NC}"
                cp -r "${skill_path}" "${target_skill_path}"
            fi
        fi
    done
}

# Function to merge agents from plugin to target
merge_agents() {
    local source_agents="${PLUGIN_DIR}/.github/agents"
    local target_agents="${TARGET_DIR}/.github/agents"

    # Check if source agents directory exists
    if [ ! -d "${source_agents}" ]; then
        echo -e "${YELLOW}No agents found in plugin to copy.${NC}"
        return
    fi

    # Create target agents directory if it doesn't exist
    mkdir -p "${target_agents}"

    # Iterate through each agent in the plugin
    for agent_path in "${source_agents}"/*; do
        if [ -d "${agent_path}" ]; then
            local agent_name=$(basename "${agent_path}")
            local target_agent_path="${target_agents}/${agent_name}"

            # Check if agent already exists in target
            if [ -d "${target_agent_path}" ]; then
                if [ "${FORCE}" = true ]; then
                    echo -e "${GREEN}Overwriting agent '${agent_name}' (forced)...${NC}"
                    rm -rf "${target_agent_path}"
                    cp -r "${agent_path}" "${target_agent_path}"
                elif [ "${SKIP_EXISTING}" = true ]; then
                    echo -e "${BLUE}Skipping existing agent '${agent_name}'.${NC}"
                else
                    echo -e "${YELLOW}Agent '${agent_name}' already exists in target repository.${NC}"
                    echo -n "Overwrite? [y/N]: "
                    read -r response
                    if [[ "${response}" =~ ^[Yy]$ ]]; then
                        echo -e "${GREEN}Overwriting agent '${agent_name}'...${NC}"
                        rm -rf "${target_agent_path}"
                        cp -r "${agent_path}" "${target_agent_path}"
                    else
                        echo -e "${BLUE}Skipping agent '${agent_name}'.${NC}"
                    fi
                fi
            else
                echo -e "${GREEN}Copying agent '${agent_name}'...${NC}"
                cp -r "${agent_path}" "${target_agent_path}"
            fi
        fi
    done
}

# Function to merge rules from plugin to target
merge_rules() {
    local source_rules="${PLUGIN_DIR}/.github/rules"
    local target_rules="${TARGET_DIR}/.github/rules"

    # Check if source rules directory exists
    if [ ! -d "${source_rules}" ]; then
        echo -e "${YELLOW}No rules found in plugin to copy.${NC}"
        return
    fi

    # Create target rules directory if it doesn't exist
    mkdir -p "${target_rules}"

    # Iterate through each rule in the plugin
    for rule_path in "${source_rules}"/*; do
        if [ -d "${rule_path}" ]; then
            local rule_name=$(basename "${rule_path}")
            local target_rule_path="${target_rules}/${rule_name}"

            # Check if rule already exists in target
            if [ -d "${target_rule_path}" ]; then
                if [ "${FORCE}" = true ]; then
                    echo -e "${GREEN}Overwriting rule '${rule_name}' (forced)...${NC}"
                    rm -rf "${target_rule_path}"
                    cp -r "${rule_path}" "${target_rule_path}"
                elif [ "${SKIP_EXISTING}" = true ]; then
                    echo -e "${BLUE}Skipping existing rule '${rule_name}'.${NC}"
                else
                    echo -e "${YELLOW}Rule '${rule_name}' already exists in target repository.${NC}"
                    echo -n "Overwrite? [y/N]: "
                    read -r response
                    if [[ "${response}" =~ ^[Yy]$ ]]; then
                        echo -e "${GREEN}Overwriting rule '${rule_name}'...${NC}"
                        rm -rf "${target_rule_path}"
                        cp -r "${rule_path}" "${target_rule_path}"
                    else
                        echo -e "${BLUE}Skipping rule '${rule_name}'.${NC}"
                    fi
                fi
            else
                echo -e "${GREEN}Copying rule '${rule_name}'...${NC}"
                cp -r "${rule_path}" "${target_rule_path}"
            fi
        fi
    done
}

# Main installation process
echo ""
echo -e "${BLUE}=== Merging Skills ===${NC}"
merge_skills

echo ""
echo -e "${BLUE}=== Merging Agents ===${NC}"
merge_agents

echo ""
echo -e "${BLUE}=== Merging Rules ===${NC}"
merge_rules

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  Run: /claude-skills:setup"
echo "  This will help you configure the installed components."
