# Quick Start Guide

Get up and running with Claude Code in 5 minutes.

## Prerequisites

- Git installed
- Bash shell (macOS, Linux, or WSL on Windows)
- `jq` installed (JSON processor)

### Install jq

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Fedora
sudo dnf install jq
```

## 5-Step Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/Latros-io/.claude ~/.claude
```

This creates `~/.claude/` with all available components.

### Step 2: Navigate to Your Project

```bash
cd /path/to/your-project
```

### Step 3: Run Setup

```bash
~/.claude/.github/skills/claude-setup/scripts/setup.sh
```

### Step 4: Select Components

Answer 4 questions to select what you need:

#### Question 1: MCP Servers
```
Which MCP servers would you like to enable?
1) filesystem
2) github
3) postgres
4) docker

Enter numbers (comma-separated): 1,2
```

#### Question 2: Agents
```
Which agents would you like to enable?
1) Bash
2) Explore
3) Plan
4) general-purpose

Enter numbers (comma-separated): 1,2
```

#### Question 3: Skills
```
Which skills would you like to enable?
1) git-workflow
2) test-runner
3) cicd-helper
4) doc-generator

Enter numbers (comma-separated): 1,2
```

#### Question 4: Rules
```
Which rules would you like to enable?
1) code-style
2) testing
3) security
4) documentation

Enter numbers (comma-separated): 1,2
```

### Step 5: Confirm Installation

```
Components to install:
  - Filesystem MCP (mcpServers)
  - GitHub MCP (mcpServers)
  - Bash Agent (agents)
  - Explore Agent (agents)
  - Git Workflow (skills)
  - Test Runner (skills)
  - Code Style Rules (rules)
  - Testing Rules (rules)

Continue with installation? [Y/n]: y
```

## What Gets Created

After installation, your project has:

```
your-project/
├── .claude/
│   ├── settings.local.json       # Configuration
│   ├── installation.state.json   # Tracking
│   └── agents/                    # Agent configs
│       ├── Bash.config.json
│       └── Explore.config.json
├── CLAUDE.md                      # Project guidance
└── .github/
    ├── skills/
    │   ├── git-workflow/         # Installed skill
    │   └── test-runner/          # Installed skill
    ├── agents/
    │   ├── Bash/                 # Installed agent
    │   └── Explore/              # Installed agent
    └── rules/
        ├── code-style/           # Installed rule
        └── testing/              # Installed rule
```

## Common Setups

### Frontend Developer

```
MCP Servers: filesystem, github
Agents: Bash, Explore
Skills: git-workflow, test-runner
Rules: code-style, testing
```

### Backend Developer

```
MCP Servers: filesystem, github, postgres
Agents: Bash, Explore, Plan
Skills: git-workflow, test-runner, cicd-helper
Rules: code-style, testing, security
```

### Full Stack Team

```
MCP Servers: filesystem, github, postgres, docker
Agents: Bash, Explore, Plan, general-purpose
Skills: git-workflow, test-runner, cicd-helper, doc-generator
Rules: code-style, testing, security, documentation
```

### Minimal Setup

```
MCP Servers: filesystem
Agents: Bash
Skills: git-workflow
Rules: code-style
```

## Next Steps

### Use Claude Code

With components installed, Claude Code can now:
- Execute bash commands (Bash agent)
- Explore your codebase (Explore agent)
- Follow git workflow patterns (git-workflow skill)
- Run tests automatically (test-runner skill)
- Enforce code style (code-style rule)

### Update Installation

Add or remove components later:

```bash
~/.claude/.github/skills/claude-setup/scripts/setup.sh
```

Choose "Update (add/remove)" when prompted.

### Customize Components

Edit installed components:

```bash
# Customize git commit style
vim .github/skills/git-workflow/SKILL.md

# Adjust code style rules
vim .claude/rules/code-style.config.json
```

### Add Custom Components

Create project-specific components:

```bash
# Create local registry
vim .claude/registry.local.json

# Add your custom skill
mkdir -p .github/skills/my-custom-skill
vim .github/skills/my-custom-skill/SKILL.md

# Re-run setup to register it
~/.claude/.github/skills/claude-setup/scripts/setup.sh
```

## Verification

### Check Installation

```bash
# View installed components
cat .claude/installation.state.json | jq '.components | keys'

# View configuration
cat .claude/settings.local.json | jq '.'

# List installed skills
ls -la .github/skills/

# List installed agents
ls -la .github/agents/

# List installed rules
ls -la .github/rules/
```

### Test Components

```bash
# Test Bash agent (should work if installed)
# Ask Claude: "List all JavaScript files"

# Test git-workflow skill (should work if installed)
# Ask Claude: "Commit these changes with a conventional commit message"

# Test Explore agent (should work if installed)
# Ask Claude: "Explore the codebase and explain the architecture"
```

## Troubleshooting

### Setup script not found

```bash
# Ensure you cloned to the right location
ls ~/.claude/.github/skills/claude-setup/scripts/setup.sh

# If not found, clone again
git clone https://github.com/Latros-io/.claude ~/.claude
```

### jq command not found

```bash
# Install jq (see Prerequisites section above)
brew install jq  # macOS
```

### Permission denied

```bash
# Make setup script executable
chmod +x ~/.claude/.github/skills/claude-setup/scripts/setup.sh

# Run again
~/.claude/.github/skills/claude-setup/scripts/setup.sh
```

### Components not working

```bash
# Verify installation state
cat .claude/installation.state.json

# Check configuration
cat .claude/settings.local.json

# Re-run setup if needed
~/.claude/.github/skills/claude-setup/scripts/setup.sh
```

## More Information

- **Detailed Guide**: See [README.md](README.md) for complete documentation
- **Visual Walkthrough**: See [HOWTO.md](HOWTO.md) for step-by-step diagrams
- **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md) to add components

## Quick Reference

| Command | Purpose |
|---------|---------|
| `~/.claude/.github/skills/claude-setup/scripts/setup.sh` | Run setup wizard |
| `cat .claude/installation.state.json` | View installed components |
| `cat .claude/settings.local.json` | View configuration |
| `ls .github/skills/` | List installed skills |
| `ls .github/agents/` | List installed agents |
| `ls .github/rules/` | List installed rules |

---

**Need Help?** Open an issue at [github.com/Latros-io/.claude/issues](https://github.com/Latros-io/.claude/issues)
