# Claude Setup - Usage Guide

## Overview

The Claude Setup skill provides an interactive 4-step wizard to configure Claude Code for your project.

## Installation

### Step 1: Clone the repository

```bash
git clone https://github.com/Latros-io/.claude
```

### Step 2: Copy skill to your project

```bash
cp -r .claude/.github/skills/claude-setup /your/project/.github/skills/
```

### Step 3: Run setup

Navigate to your project and run:

```bash
./.github/skills/claude-setup/scripts/setup.sh
```

Or ask Claude Code to run it for you:

```
Please run the Claude setup wizard
```

## The 4 Steps

### Step 1: MCP Servers

Select which Model Context Protocol servers you want to enable:

- **filesystem**: File system operations (read, write, search)
- **github**: GitHub integration (issues, PRs, repos)
- **postgres**: PostgreSQL database access
- **docker**: Docker container management

**Example input**: `1,2` (enables filesystem and github)

### Step 2: Agents

Choose which specialized AI agents to enable:

- **Bash**: Command execution specialist
- **Explore**: Codebase exploration and analysis
- **Plan**: Software architecture and planning
- **general-purpose**: Multi-purpose agent

**Example input**: `1,2,3` (enables Bash, Explore, and Plan)

### Step 3: Skills

Pick which automation skills to enable:

- **git-workflow**: Git operations, commits, PRs
- **test-runner**: Testing automation
- **cicd-helper**: CI/CD operations
- **doc-generator**: Documentation generation

**Example input**: `1,2` (enables git-workflow and test-runner)

### Step 4: Rules

Configure project guidelines:

- **code-style**: Code formatting and style standards
- **testing**: Testing requirements and coverage
- **documentation**: Documentation standards
- **security**: Security policies and best practices

**Example input**: `1,2,3` (enables code-style, testing, and documentation)

## What Gets Created

After completing the setup:

1. **`.claude/settings.local.json`** - Configuration file with your selections
2. **`CLAUDE.md`** - Project guidance file for Claude Code

## Example Session

```bash
$ ./.github/skills/claude-setup/scripts/setup.sh

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

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Step 3/4: Skills
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which skills would you like to enable?
1) git-workflow
2) test-runner
3) cicd-helper
4) doc-generator

Enter numbers (comma-separated): 1,2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Step 4/4: Rules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which rules would you like to configure?
1) code-style
2) testing
3) documentation
4) security

Enter numbers (comma-separated): 1,2,3

Generating configuration...

✓ Configuration created at .claude/settings.local.json
✓ Project guidance created at CLAUDE.md
✓ Setup complete!
```

## Tips

- Press Enter to skip any step
- You can select multiple options by separating numbers with commas
- Configuration applies immediately (no restart needed)
- Re-run the script anytime to update configuration

## Troubleshooting

### Script not executable
```bash
chmod +x ./.github/skills/claude-setup/scripts/setup.sh
```

### Invalid JSON in config
Check your configuration:
```bash
cat .claude/settings.local.json | jq .
```

## Next Steps

After setup:
1. Review `.claude/settings.local.json`
2. Customize `CLAUDE.md` with project details
3. Start using Claude Code with your configuration!
