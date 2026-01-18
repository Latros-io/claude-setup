# Settings Profiles

Settings profiles provide pre-configured combinations of MCP servers, agents, skills, and rules tailored for different project types and complexity levels.

## What are Profiles?

Profiles are JSON configuration files that bundle together:

- **MCP Servers**: External tools and integrations (filesystem, GitHub, databases, etc.)
- **Agents**: Specialized AI assistants for different tasks (Bash, Explore, Plan, etc.)
- **Skills**: Reusable workflows and commands (git-workflow, test-runner, etc.)
- **Rules**: Guardrails and best practices (code-style, testing, security, etc.)
- **Settings**: Claude Code behavior customization

Think of profiles as configuration presets that adapt Claude Code to your project's needs.

## Available Core Profiles

### minimal.json

**Use for**: Simple scripts, small projects, learning

**Includes**:
- MCP Servers: `filesystem`
- Agents: `Bash`
- Skills: `git-workflow`
- Rules: `code-style`

**Best for**:
- Quick scripts and utilities
- Personal projects
- Learning and experimentation
- Minimal overhead and fast startup

### standard.json (Recommended)

**Use for**: Most development projects

**Includes**:
- MCP Servers: `filesystem`, `github`
- Agents: `Bash`, `Explore`, `Plan`
- Skills: `git-workflow`, `test-runner`, `doc-generator`
- Rules: `code-style`, `testing`, `documentation`

**Best for**:
- Web applications
- Libraries and packages
- Team projects
- Balanced performance and features

### comprehensive.json

**Use for**: Large projects, enterprise applications

**Includes**:
- MCP Servers: `filesystem`, `github`, `postgres`, `docker`
- Agents: `Bash`, `Explore`, `Plan`, `GeneralPurpose`
- Skills: All core skills
- Rules: All core rules

**Best for**:
- Enterprise applications
- Complex microservices
- Projects requiring database integration
- Maximum assistance and guardrails

## How to Use Profiles

### Basic Usage

```bash
# Use a specific profile
claude --profile minimal

# Use the standard profile (recommended default)
claude --profile standard

# Use comprehensive profile
claude --profile comprehensive
```

### Setting a Default Profile

Edit your `~/.claude/config.json`:

```json
{
  "defaultProfile": "standard"
}
```

### Project-Specific Profiles

Create a `.claude/profile.json` in your project root:

```json
{
  "extends": "standard",
  "name": "my-project"
}
```

## Composing Profiles

Profiles can be composed together, with later profiles overriding earlier ones.

### Combining Core and Domain Profiles

```bash
# Use standard core profile + React domain profile
claude --profile standard,domains/react

# Use minimal core + Python domain profile
claude --profile minimal,domains/python

# Multiple domain profiles
claude --profile standard,domains/react,domains/typescript
```

### Profile Composition in Configuration

```json
{
  "extends": ["standard", "domains/react"],
  "name": "my-react-app",
  "skills": ["custom-skill"],
  "settings": {
    "verbosity": "detailed"
  }
}
```

**Merge behavior**:
- Arrays (mcpServers, agents, skills, rules) are **merged** (combined, deduplicated)
- Objects (settings) are **deep merged** (later values override earlier ones)
- Primitives (name, description) are **replaced** (last one wins)

### Example Compositions

```json
// .claude/profile.json
{
  "extends": ["standard", "domains/nextjs"],
  "name": "my-nextjs-blog",

  // Add project-specific skills
  "skills": ["./scripts/deploy-skill"],

  // Override settings
  "settings": {
    "testOnSave": true,
    "customCommand": "npm run build"
  }
}
```

This results in:
- All `standard` profile features
- All `domains/nextjs` profile features
- Additional custom deploy skill
- Modified settings (testOnSave enabled)

## Creating Custom Profiles

### Profile Structure

```json
{
  "name": "profile-name",
  "description": "What this profile is for",
  "version": "3.0.0",

  "mcpServers": [
    "server-name"
  ],

  "agents": [
    "AgentName"
  ],

  "skills": [
    "skill-name",
    "./path/to/custom-skill"
  ],

  "rules": [
    "rule-name",
    "./path/to/custom-rule"
  ],

  "settings": {
    "autoSave": true,
    "suggestionMode": "auto",
    "verbosity": "normal"
  }
}
```

### Custom Profile Example

```json
{
  "name": "data-science",
  "description": "Profile for data science and ML projects",
  "version": "3.0.0",

  "extends": ["standard"],

  "mcpServers": [
    "postgres",
    "jupyter"
  ],

  "skills": [
    "notebook-helper",
    "data-viz"
  ],

  "rules": [
    "data-quality",
    "reproducibility"
  ],

  "settings": {
    "verbosity": "detailed",
    "showPlots": true
  }
}
```

### Profile Locations

Profiles are loaded from these locations (in order):

1. **Core profiles**: `/Users/silviomollov/Documents/Projects/claude/core/settings/`
2. **Domain profiles**: `/Users/silviomollov/Documents/Projects/claude/domains/*/profile.json`
3. **User profiles**: `~/.claude/profiles/`
4. **Project profiles**: `.claude/profile.json` (in project root)

### Best Practices

1. **Start with a core profile**: Always extend `minimal`, `standard`, or `comprehensive`
2. **Layer domain expertise**: Add domain profiles for your tech stack
3. **Customize minimally**: Only override what you need
4. **Document your profiles**: Add clear descriptions
5. **Version your profiles**: Track profile versions with your project
6. **Share team profiles**: Commit `.claude/profile.json` to ensure consistency

## Profile Selection Logic

When you run Claude Code:

1. Uses `defaultProfile` from `~/.claude/config.json` (if set)
2. Overridden by project's `.claude/profile.json` (if exists)
3. Overridden by `--profile` CLI flag (if provided)
4. Falls back to `standard` if nothing specified

## Common Scenarios

### Starting a New Project

```bash
# Start with standard, adjust as needed
claude --profile standard

# For a React project
claude --profile standard,domains/react

# For a Python data project
claude --profile comprehensive,domains/python
```

### Switching Contexts

```bash
# Quick script work
claude --profile minimal

# Back to your main project (uses .claude/profile.json)
claude

# Enterprise debugging session
claude --profile comprehensive
```

### Team Standardization

Create `.claude/profile.json` in your repo:

```json
{
  "extends": ["standard", "domains/nextjs"],
  "name": "team-project",
  "rules": ["./team-rules/pr-checklist"],
  "settings": {
    "testOnSave": true
  }
}
```

All team members get the same configuration automatically.

## Advanced Features

### Conditional Profiles

Use environment-specific profiles:

```json
{
  "extends": ["standard"],
  "name": "my-app",
  "profiles": {
    "development": {
      "settings": {
        "verbosity": "detailed"
      }
    },
    "production": {
      "settings": {
        "verbosity": "minimal",
        "securityScanning": true
      }
    }
  }
}
```

```bash
claude --env production
```

### Profile Inheritance Chain

```
comprehensive.json
  ↓ extends
standard.json
  ↓ extends
minimal.json
  ↓ extends (default base)
{} (empty config)
```

## Troubleshooting

### Profile Not Found

```
Error: Profile 'myprofile' not found
```

**Solution**: Check profile exists in one of the profile locations

### Conflicting Settings

If settings conflict, the last profile in the chain wins:

```bash
# 'domains/react' settings override 'standard'
claude --profile standard,domains/react
```

### Debugging Profile Loading

```bash
# See which profile is active
claude --show-profile

# See full merged configuration
claude --show-config

# Validate a profile without loading it
claude --validate-profile comprehensive
```

## Related Documentation

- [MCP Servers](../README.md#mcp-servers) - Available MCP server integrations
- [Agents](../agents/README.md) - Specialized AI agents
- [Skills](../skills/README.md) - Reusable workflows
- [Rules](../rules/README.md) - Best practice guardrails
- [Domain Profiles](../../domains/README.md) - Technology-specific configurations
