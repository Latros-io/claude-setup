---
name: setup
description: Interactive setup wizard to select and install components
---

# Claude Skills Setup

This command launches an interactive setup wizard that helps you:

1. Select MCP servers to enable
2. Choose agents to install
3. Pick skills for your project
4. Configure rules and guidelines

The wizard will:
- Present available components from the registry
- Allow you to select what you need
- Install only the selected components
- Create necessary configuration files
- Track installation state for future updates

## Usage

```
/claude-skills:setup
```

## What Gets Installed

The setup process will create:
- `.claude/settings.local.json` - Configuration
- `.claude/installation.state.json` - Tracking file
- `.github/skills/[selected]` - Only chosen skills
- `.github/agents/[selected]` - Only chosen agents
- `.github/rules/[selected]` - Only chosen rules
- `CLAUDE.md` - Project guidance document

## Update Mode

Run the command again anytime to add or remove components. Your customizations will be preserved.
