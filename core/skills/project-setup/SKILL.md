---
name: project-setup
description: Initialize Claude Code configuration in new or existing projects
version: 1.0.0
author: Latros.io
category: setup
tags: [initialization, configuration, setup]
---

# Project Setup Skill

Initialize Claude Code configuration in projects by creating the `.claude/` directory structure, setting up MCP servers, and providing starter configurations.

## When to Use This Skill

Invoke this skill when:
- User asks to initialize Claude Code in a project
- User wants to setup Claude configuration
- User mentions creating .claude directory
- User asks about project setup or configuration
- Starting work in a new project without Claude config
- User wants to add MCP servers or skills

## Invocation

Claude should automatically use this skill when project initialization is requested. The skill provides:
- Automatic `.claude/` directory creation
- Project type detection and configuration
- MCP server setup and configuration
- Starter templates for common files
- Initial agents, skills, and rules setup

## Dependencies

### Required
- **Agent**: `Bash` - For directory and file operations

### Optional
- **MCP Server**: `github` - For repository integration
- **Skill**: `git-workflow` - For committing setup changes

## Configuration

Default settings (customizable in `.claude/skills/project-setup.config.json`):

- `claude_directory`: ".claude" - Name of configuration directory
- `create_directories`: true - Create full directory structure
- `auto_detect_project_type`: true - Detect project language/framework
- `interactive_setup`: true - Prompt for configuration choices
- `backup_existing`: true - Backup existing .claude directory
- `git_integration`: true - Add .claude to git if repo exists

## Directory Structure Created

```
.claude/
├── agents/              # Custom agent configurations
│   ├── Bash/
│   │   └── config.json
│   └── Explore/
│       └── config.json
├── skills/              # Enabled skills configurations
│   ├── git-workflow/
│   │   └── config.json
│   └── test-runner/
│       └── config.json
├── rules/               # Code style and quality rules
│   └── code-style/
│       └── config.json
├── mcp-servers/         # MCP server configurations
│   ├── github.json
│   └── filesystem.json
└── templates/           # Project templates
    ├── pr-template.md
    └── issue-template.md
```

## Project Type Detection

The skill automatically detects project type by checking for:

### JavaScript/Node.js
- `package.json`
- Configures: ESLint, Prettier, test-runner, doc-generator

### TypeScript
- `tsconfig.json` or `package.json` with TypeScript
- Configures: TSConfig, ESLint, Prettier, test-runner, doc-generator

### Python
- `setup.py`, `pyproject.toml`, `requirements.txt`
- Configures: pytest, black, mypy, test-runner, doc-generator

### Go
- `go.mod`
- Configures: go fmt, go test, test-runner, doc-generator

### Rust
- `Cargo.toml`
- Configures: cargo fmt, cargo test, test-runner, doc-generator

## Usage Examples

### Example 1: Initialize New Project

**User**: "Initialize Claude Code in this project"

**Claude**:
1. Detects project type (e.g., TypeScript from tsconfig.json)
2. Creates `.claude/` directory structure
3. Installs default agents (Bash, Explore, GeneralPurpose)
4. Configures TypeScript-specific skills (test-runner, doc-generator)
5. Sets up code-style rules
6. Creates starter templates
7. Adds `.claude/` to .gitignore if needed
8. Reports setup completion

### Example 2: Add MCP Server

**User**: "Add GitHub MCP server to this project"

**Claude**:
1. Checks if `.claude/` exists (creates if not)
2. Creates `mcp-servers/github.json` configuration
3. Prompts for GitHub token (if needed)
4. Tests connection
5. Activates GitHub-related skills
6. Reports success

### Example 3: Setup with Custom Configuration

**User**: "Setup Claude with test automation and documentation"

**Claude**:
1. Creates `.claude/` structure
2. Enables test-runner skill with watch mode
3. Enables doc-generator skill
4. Configures auto-run tests after changes
5. Sets up documentation generation on commit
6. Creates configuration files
7. Provides usage instructions

### Example 4: Migrate Existing Configuration

**User**: "Update my Claude configuration to latest structure"

**Claude**:
1. Backs up existing `.claude/` directory
2. Analyzes current configuration
3. Creates new structure
4. Migrates settings to new format
5. Updates deprecated configurations
6. Tests new setup
7. Reports changes made

## Setup Workflow

1. **Detection Phase**
   - Scan project for indicators
   - Identify language and framework
   - Detect existing tools (linters, formatters)

2. **Planning Phase**
   - Determine recommended agents
   - Select appropriate skills
   - Choose compatible rules
   - Identify needed MCP servers

3. **Creation Phase**
   - Create directory structure
   - Generate configuration files
   - Copy template files
   - Set appropriate permissions

4. **Configuration Phase**
   - Configure MCP servers
   - Set skill parameters
   - Customize rules
   - Set agent preferences

5. **Validation Phase**
   - Test configurations
   - Verify MCP connections
   - Check permissions
   - Report any issues

6. **Completion Phase**
   - Summary of setup
   - Next steps guide
   - Usage examples
   - Documentation links

## Configuration Templates

### Minimal Setup
- Basic .claude directory
- Bash agent only
- No skills or rules
- For simple projects

### Standard Setup
- Full directory structure
- Common agents (Bash, Explore, GeneralPurpose)
- git-workflow skill
- code-style rule
- For typical development projects

### Full Setup
- Complete directory structure
- All standard agents
- Multiple skills (git-workflow, test-runner, doc-generator)
- Comprehensive rules
- MCP server configurations
- For large team projects

## Integration with Other Components

### With git-workflow Skill
- Commits setup changes
- Creates initial .gitignore entries
- Sets up git hooks if requested

### With MCP Servers
- Configures GitHub integration
- Sets up filesystem access
- Enables database connections
- Activates cloud service integrations

### With Bash Agent
- Creates directories and files
- Sets permissions
- Tests configurations
- Validates setup

## Best Practices

1. **Version Control**: Always commit .claude configuration
2. **Documentation**: Document custom configurations
3. **Team Sharing**: Share .claude directory with team
4. **Regular Updates**: Keep configurations up to date
5. **Backup**: Backup before major changes
6. **Test Setup**: Validate configuration after setup

## Error Handling

Common errors and resolutions:

**Directory Already Exists**:
- Offers to backup existing directory
- Prompts for merge or replace
- Preserves custom configurations

**Permission Denied**:
- Reports permission issues
- Suggests using appropriate permissions
- Offers alternative locations

**MCP Server Connection Failed**:
- Tests connectivity
- Validates credentials
- Suggests configuration fixes
- Provides troubleshooting steps

**Incompatible Configuration**:
- Detects conflicts
- Suggests resolutions
- Offers compatible alternatives
- Updates deprecated settings

## Version History

- **1.0.0**: Initial release with project type detection, directory structure creation, and MCP server setup
