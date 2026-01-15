# Claude Skills Registry

> A Claude Code plugin for selective installation of skills, agents, and rules

**Keep your Claude Code context slim and focused** by installing only the components your project needs.

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/Latros-io/claude-setup)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/claude--code-plugin-purple.svg)](https://claude.ai/code)

---

## What is This?

A **centralized registry** of reusable components for Claude Code projects:

- 🎯 **Skills**: Specialized capabilities (git workflows, test running, documentation)
- 🤖 **Agents**: Focused AI assistants (Bash execution, code exploration, planning)
- 📋 **Rules**: Guidelines and best practices (code style, security, testing)
- 🔌 **MCP Servers**: External integrations (GitHub, filesystem, databases)

**Selective installation** means your project only contains what you actually use.

## Installation

You can install using either the Claude Code CLI or within a Claude Code session:

### Option 1: Using Claude Code CLI (Recommended)

```bash
# Add the marketplace
claude plugin marketplace add Latros-io/claude-setup

# Install the plugin
claude plugin install claude-skills

# Verify installation
claude plugin marketplace list
```

Then in your Claude Code session, run:
```
/claude-skills:setup
```

### Option 2: Within Claude Code Session

Inside a Claude Code instance, run:

```
/plugin marketplace add Latros-io/claude-setup
/plugin install claude-skills
/claude-skills:setup
```

Done! The setup wizard starts immediately — no restart needed.

### Verification

To verify the plugin was installed successfully:

```bash
# List installed plugins
claude plugin list

# Update the marketplace to get latest changes
claude plugin marketplace update claude-skills-registry

# The /claude-skills:setup command should now be available
```

**Note**: If you don't see the command, try restarting your Claude Code session.

## Quick Start

### 1. Run Setup

In your Claude Code instance:

```
/claude-skills:setup
```

### 2. Select Components

Answer 4 interactive questions:

**Step 1/4: MCP Servers**
```
Which MCP servers would you like to enable?
1) filesystem
2) github
3) postgres
4) docker

Enter numbers (comma-separated): 1,2
```

**Step 2/4: Agents**
```
Which agents would you like to enable?
1) Bash
2) Explore
3) Plan
4) general-purpose

Enter numbers (comma-separated): 1,2
```

**Step 3/4: Skills**
```
Which skills would you like to enable?
1) git-workflow
2) test-runner
3) cicd-helper
4) doc-generator

Enter numbers (comma-separated): 1,2
```

**Step 4/4: Rules**
```
Which rules would you like to enable?
1) code-style
2) testing
3) security
4) documentation

Enter numbers (comma-separated): 1,2
```

### 3. Installation Complete! 🎉

Your project now contains:
```
your-project/
├── .claude/
│   ├── settings.local.json       # Configuration
│   ├── installation.state.json   # Tracking
│   └── [component configs]
├── CLAUDE.md                      # Project guidance
└── .github/
    ├── skills/[selected]         # Only what you chose
    ├── agents/[selected]         # Only what you chose
    └── rules/[selected]          # Only what you chose
```

## Features

### ✅ Selective Installation
Install only the components you need - no clutter, no bloat.

### ✅ Automatic Dependencies
Dependencies are resolved automatically:
```
You select: git-workflow
System adds: github MCP + Bash agent
```

### ✅ Update Mode
Re-run setup to add or remove components:
```
/claude-skills:setup
# Choose "Update (add/remove)" when prompted
```

### ✅ Customization Tracking
Modify installed components freely. Updates preserve your changes:
```bash
# Edit any installed component
vim .github/skills/git-workflow/SKILL.md
# Your customizations are tracked and preserved on update
```

### ✅ Local Extensions
Add project-specific components via local registry:
```bash
# Create .claude/registry.local.json
# Add your custom skills, agents, or rules
# They appear in setup alongside central components
```

### ✅ Self-Contained Projects
After installation, projects work offline. All components are copied locally.

## Available Components

### MCP Servers
| Name | Description |
|------|-------------|
| **filesystem** | Local file operations |
| **github** | GitHub API integration |
| **postgres** | PostgreSQL database |
| **docker** | Container management |

### Agents
| Name | Description | View |
|------|-------------|------|
| **Bash** | Command execution specialist | [📄](/.github/agents/Bash/AGENT.md) |
| **Explore** | Codebase analysis | |
| **Plan** | Implementation planning | |
| **general-purpose** | Multi-purpose research | |

### Skills
| Name | Description | View |
|------|-------------|------|
| **git-workflow** | Git automation with conventional commits | [📄](/.github/skills/git-workflow/SKILL.md) |
| **test-runner** | Test execution and coverage | |
| **cicd-helper** | CI/CD automation | |
| **doc-generator** | Documentation generation | |

### Rules
| Name | Description | View |
|------|-------------|------|
| **code-style** | Formatting and style guidelines | [📄](/.github/rules/code-style/RULE.md) |
| **testing** | Test requirements and coverage | |
| **security** | Security best practices | |
| **documentation** | Documentation standards | |

## Common Setups

### Frontend Developer
```
MCP: filesystem, github
Agents: Bash, Explore
Skills: git-workflow, test-runner
Rules: code-style, testing
```

### Backend Developer
```
MCP: filesystem, github, postgres
Agents: Bash, Explore, Plan
Skills: git-workflow, test-runner, cicd-helper
Rules: code-style, testing, security
```

### Full Stack Team
```
MCP: filesystem, github, postgres, docker
Agents: Bash, Explore, Plan, general-purpose
Skills: git-workflow, test-runner, cicd-helper, doc-generator
Rules: code-style, testing, security, documentation
```

### Minimal Setup
```
MCP: filesystem
Agents: Bash
Skills: git-workflow
Rules: code-style
```

## How It Works

### Registry-Driven Architecture

```
┌─────────────────────────────────────┐
│  Claude Plugin                      │
│  (Installed via /plugin install)    │
│                                     │
│  ├── registry.json   ← Catalog     │
│  ├── .github/                       │
│  │   ├── skills/    ← All skills   │
│  │   ├── agents/    ← All agents   │
│  │   └── rules/     ← All rules    │
│  └── setup command                  │
└─────────────────────────────────────┘
              ↓
    User runs /claude-skills:setup
              ↓
┌─────────────────────────────────────┐
│  Your Project                       │
│                                     │
│  ├── .claude/                       │
│  │   ├── settings.local.json       │
│  │   ├── installation.state.json   │
│  │   └── registry.local.json       │
│  ├── CLAUDE.md                      │
│  └── .github/                       │
│      ├── skills/    ← Only selected│
│      ├── agents/    ← Only selected│
│      └── rules/     ← Only selected│
└─────────────────────────────────────┘
```

### Three-Registry System

1. **Central Registry** (`registry.json`)
   - Maintained in plugin repository
   - Defines all available components
   - Single source of truth

2. **Local Registry** (`.claude/registry.local.json`)
   - Optional, project-specific
   - Custom components
   - Merged with central (local overrides)

3. **Installation State** (`.claude/installation.state.json`)
   - Tracks installed components
   - Records versions and timestamps
   - Lists customizations

## Usage Examples

### Example 1: Fresh Setup

```
/claude-skills:setup

# Select components
# Installation completes
# Start using Claude Code with selected components
```

### Example 2: Add Components Later

```
/claude-skills:setup

# Choose "Update (add/remove)"
# Select additional components
# Existing components preserved
```

### Example 3: Customize and Update

```bash
# Customize installed skill
vim .github/skills/git-workflow/SKILL.md

# Run update
/claude-skills:setup

# Your customizations are detected and preserved
# "File has been customized: .github/skills/git-workflow/SKILL.md"
# "Overwrite? [y/N]:" → Choose 'N' to keep changes
```

### Example 4: Custom Project-Specific Skill

```bash
# Create local registry
cat > .claude/registry.local.json << 'EOF'
{
  "version": "1.0.0",
  "components": {
    "skills": {
      "custom-deploy": {
        "id": "custom-deploy",
        "type": "skill",
        "name": "Custom Deploy",
        "description": "Project-specific deployment automation",
        "version": "1.0.0",
        "dependencies": {},
        "files": [...]
      }
    }
  }
}
EOF

# Create skill files
mkdir -p .github/skills/custom-deploy
vim .github/skills/custom-deploy/SKILL.md

# Run setup - custom skill appears in list
/claude-skills:setup
```

## Requirements

- **Bash**: 4.0 or higher
- **jq**: 1.5 or higher (JSON processor)
- **OS**: macOS, Linux, or WSL on Windows

### Install jq

If setup fails with "jq: command not found":

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Fedora
sudo dnf install jq
```

## Documentation

- **Quick Start**: [QUICKSTART.md](QUICKSTART.md) - 5-minute setup
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md) - Add components
- **Registry Schema**: [registry.json](registry.json) - Technical reference

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Adding new skills, agents, or rules
- Improving existing components
- Documentation improvements
- Bug fixes

## Philosophy

**Why selective installation?**

1. **Slim Context**: Claude Code reads project files. Fewer files = faster, more focused responses
2. **No Clutter**: Only see components you use
3. **Clear Intent**: Installed components document project patterns
4. **Easy Customization**: Modify without affecting unused components
5. **Version Control Friendly**: Commit only what's needed

**Design Principles**:
- Self-contained projects (work offline)
- Explicit dependencies (no surprises)
- Customization-aware (preserve modifications)
- Update-friendly (safe to re-run)
- Registry-driven (single source of truth)

## Troubleshooting

### Plugin not found

```
# Make sure marketplace is added
/plugin marketplace add Latros-io/claude-setup

# Then install
/plugin install claude-skills
```

### jq not installed

```bash
# Install jq (see Requirements section)
brew install jq  # macOS
sudo apt-get install jq  # Ubuntu/Debian
```

### Components not working

```bash
# Verify installation
cat .claude/installation.state.json

# Check configuration
cat .claude/settings.local.json

# Re-run setup if needed
/claude-skills:setup
```

### Setup command not found

```bash
# Verify plugin is installed - check both CLI and within Claude Code
claude plugin install claude-skills  # Use CLI command format

# Verify marketplace is added
claude plugin marketplace list

# Update marketplace cache to get latest version
claude plugin marketplace update claude-skills-registry

# If command still not available, restart Claude Code session
```

### Installation validation error

If you see "Invalid schema" or "commands: Invalid input" errors:

```bash
# This usually means you're trying to add an older version
# Update the marketplace to get the latest fixes:
claude plugin marketplace update claude-skills-registry

# Then try installing again:
claude plugin install claude-skills
```

## Support

- **Issues**: [GitHub Issues](https://github.com/Latros-io/claude-setup/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Latros-io/claude-setup/discussions)

## License

MIT License - see [LICENSE](LICENSE) file

---

**Version**: 2.0.0 (Registry-based selective installation)
**Status**: Active Development
**Last Updated**: 2026-01-15
