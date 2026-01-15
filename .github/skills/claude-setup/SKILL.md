---
name: claude-setup
description: Interactive 4-step configuration wizard for Claude Code projects
version: 1.0.0
author: Latros.io
---

# Claude Setup Skill

Interactive configuration wizard for Claude Code that sets up MCP servers, agents, skills, and rules in 4 simple steps.

## When to Use This Skill

Invoke this skill when:
- Setting up Claude Code for a new project
- The user asks to "configure Claude" or "setup Claude Code"
- The user wants to select MCP servers, agents, skills, or rules
- The user mentions `/claude-setup` or similar setup commands

## What This Skill Does

This skill guides users through a 4-step configuration process:

1. **MCP Servers** - Select Model Context Protocol servers (filesystem, github, postgres, docker)
2. **Agents** - Choose specialized AI agents (Bash, Explore, Plan, general-purpose)
3. **Skills** - Pick automation skills (git-workflow, test-runner, cicd-helper, doc-generator)
4. **Rules** - Configure project guidelines (code-style, testing, documentation, security)

After completion, the skill creates:
- `.claude/settings.local.json` - Claude Code configuration file
- `CLAUDE.md` - Project-specific guidance for Claude

## How to Invoke

When the user asks to set up Claude Code, run the setup script:

```bash
./.github/skills/claude-setup/scripts/setup.sh
```

The script will interactively prompt the user for their preferences across 4 steps.

## Expected Inputs

The setup script expects user input for each step:

**Step 1 - MCP Servers:**
- Input: Comma-separated numbers (e.g., `1,2` for filesystem and github)
- Options: 1) filesystem, 2) github, 3) postgres, 4) docker

**Step 2 - Agents:**
- Input: Comma-separated numbers (e.g., `1,2,3` for Bash, Explore, Plan)
- Options: 1) Bash, 2) Explore, 3) Plan, 4) general-purpose

**Step 3 - Skills:**
- Input: Comma-separated numbers (e.g., `1,2` for git-workflow and test-runner)
- Options: 1) git-workflow, 2) test-runner, 3) cicd-helper, 4) doc-generator

**Step 4 - Rules:**
- Input: Comma-separated numbers (e.g., `1,2,3` for code-style, testing, documentation)
- Options: 1) code-style, 2) testing, 3) documentation, 4) security

## Expected Outputs

After successful execution:
- `.claude/settings.local.json` created with user's selections
- `CLAUDE.md` created with project guidance template
- Configuration is immediately active (no restart required)

## Usage Example

```
User: "I want to setup Claude Code for my project"

Claude: I'll run the Claude setup wizard for you.

[Runs ./.github/skills/claude-setup/scripts/setup.sh]

Script Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Step 1/4: MCP Servers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which MCP servers would you like to enable?
1) filesystem
2) github
3) postgres
4) docker

Enter numbers (comma-separated): 1,2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Step 2/4: Agents
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which agents would you like to enable?
1) Bash
2) Explore
3) Plan
4) general-purpose

Enter numbers (comma-separated): 1,2,3

[... continues through 4 steps ...]

✓ Configuration created at .claude/settings.local.json
✓ Project guidance created at CLAUDE.md
✓ Setup complete!
```

## Integration with Other Skills

This skill can work alongside:
- **git-workflow** - If selected, enables git automation
- **test-runner** - If selected, enables test automation
- **cicd-helper** - If selected, enables CI/CD operations
- **doc-generator** - If selected, enables documentation generation

## Error Handling

If the script encounters errors:
- Invalid input: Prompts user to re-enter
- Missing directories: Creates them automatically
- Existing config: Backs up and overwrites

## Notes

- This is a POC (Proof of Concept) with minimal error handling
- Configuration applies immediately without restart
- Users can re-run the script to update configuration
- All selections are optional (users can press Enter to skip)