# .claude

Interactive 4-step configuration wizard for Claude Code projects.

## Quick Start

### Installation

**Step 1: Clone the repository**

```bash
git clone https://github.com/Latros-io/.claude
```

**Step 2: Copy skill to your project**

```bash
cp -r .claude/.github/skills/claude-setup /your/project/.github/skills/
```

**Step 3: Run setup**

Navigate to your project:
```bash
cd /your/project
```

Run the setup script:
```bash
./.github/skills/claude-setup/scripts/setup.sh
```

Or ask Claude Code to run it:
```
Please run the Claude setup wizard
```

**Step 4: Follow the 4 prompts**

Answer the configuration questions for:
1. MCP Servers (filesystem, github, postgres, docker)
2. Agents (Bash, Explore, Plan, general-purpose)
3. Skills (git-workflow, test-runner, cicd-helper, doc-generator)
4. Rules (code-style, testing, documentation, security)

**Done!** Configuration is ready immediately — no restart needed. 🎉

## What Is This?

Claude Setup is an interactive wizard that configures Claude Code for your project in 4 simple steps.

After setup, you'll have:
- `.claude/settings.local.json` - Claude Code configuration
- `CLAUDE.md` - Project guidance for Claude

## The 4 Steps

### Step 1: MCP Servers
Select Model Context Protocol servers:
- **filesystem** - File system operations
- **github** - GitHub integration
- **postgres** - PostgreSQL database
- **docker** - Docker container management

### Step 2: Agents
Choose specialized AI assistants:
- **Bash** - Command execution specialist
- **Explore** - Codebase exploration
- **Plan** - Software architecture and planning
- **general-purpose** - Multi-purpose agent

### Step 3: Skills
Pick automation capabilities:
- **git-workflow** - Git operations, commits, PRs
- **test-runner** - Testing automation
- **cicd-helper** - CI/CD operations
- **doc-generator** - Documentation generation

### Step 4: Rules
Configure project guidelines:
- **code-style** - Code formatting standards
- **testing** - Testing requirements
- **documentation** - Documentation standards
- **security** - Security best practices

## Example Usage

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

[... continues through 4 steps ...]

✓ Configuration created at .claude/settings.local.json
✓ Project guidance created at CLAUDE.md
✓ Setup complete!
```

## Use Cases

### Full-Stack Web App
```
MCP: 1,2,3 (filesystem, github, postgres)
Agents: 1,2,3,4 (all)
Skills: 1,2,3,4 (all)
Rules: 1,2,3,4 (all)
```

### Quick Prototype
```
MCP: 1 (filesystem)
Agents: 1,2 (Bash, Explore)
Skills: 1 (git-workflow)
Rules: (skip or minimal)
```

### Data Science Project
```
MCP: 1,3 (filesystem, postgres)
Agents: 1,2,4 (Bash, Explore, general-purpose)
Skills: 2,4 (test-runner, doc-generator)
Rules: 2,3 (testing, documentation)
```

## Documentation

- [Usage Guide](.github/skills/claude-setup/references/usage.md)
- [SKILL Definition](.github/skills/claude-setup/SKILL.md)

## Requirements

- Bash 4.0 or higher
- Unix-like OS (macOS, Linux, WSL)

## Version

1.0.0 - POC Release

## License

MIT

## Support

- [GitHub Issues](https://github.com/Latros-io/.claude/issues)
- [Documentation](.github/skills/claude-setup/)
