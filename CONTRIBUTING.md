# Contributing to .claude

Thank you for your interest in contributing! This guide will help you add new skills, agents, rules, or improve existing components.

## Table of Contents

- [Types of Contributions](#types-of-contributions)
- [Adding a New Skill](#adding-a-new-skill)
- [Adding a New Agent](#adding-a-new-agent)
- [Adding a New Rule](#adding-a-new-rule)
- [Updating the Registry](#updating-the-registry)
- [Testing Your Component](#testing-your-component)
- [Submission Guidelines](#submission-guidelines)

## Types of Contributions

### 1. New Components
- **Skills**: Task-specific capabilities (e.g., API testing, database migrations)
- **Agents**: Specialized AI assistants (e.g., security auditor, performance optimizer)
- **Rules**: Guidelines and standards (e.g., accessibility, API design)

### 2. Improvements
- Enhance existing components with new features
- Fix bugs in component implementations
- Improve documentation and examples
- Add templates or additional resources

### 3. Bug Fixes
- Fix issues in setup script
- Correct registry schema errors
- Fix dependency resolution problems

## Adding a New Skill

### 1. Create Directory Structure

```bash
mkdir -p .github/skills/your-skill-name/{templates,prompts,assets}
```

### 2. Create SKILL.md

```bash
cat > .github/skills/your-skill-name/SKILL.md << 'EOF'
---
name: your-skill-name
description: Brief description of what this skill does
version: 1.0.0
author: Your Name
category: category-name
tags: [tag1, tag2, tag3]
---

# Your Skill Name

Detailed description of the skill.

## When to Use This Skill

- Use case 1
- Use case 2

## Invocation

How Claude should invoke this skill.

## Dependencies

### Required
- MCP Server: server-name (why needed)
- Agent: agent-name (why needed)

### Optional
- Skill: other-skill (why helpful)

## Configuration

Settings and their defaults.

## Usage Examples

### Example 1: Common Use Case
[Detailed example]

## Integration

How this skill works with other components.

## Error Handling

Common errors and solutions.

## Notes

Additional important information.
EOF
```

### 3. Add Templates (Optional)

```bash
# Add any templates your skill needs
cat > .github/skills/your-skill-name/templates/template-file.ext << 'EOF'
[Template content]
EOF
```

### 4. Create config.json

```bash
cat > .github/skills/your-skill-name/config.json << 'EOF'
{
  "setting1": "default_value1",
  "setting2": "default_value2",
  "enabled": true
}
EOF
```

### 5. Update Registry

Add your skill to `registry.json`:

```json
{
  "skills": {
    "your-skill-name": {
      "id": "your-skill-name",
      "type": "skill",
      "name": "Your Skill Name",
      "description": "Brief description",
      "version": "1.0.0",
      "author": "Your Name",
      "category": "category-name",
      "tags": ["tag1", "tag2"],
      "dependencies": {
        "mcpServers": ["required-server"],
        "agents": ["required-agent"],
        "skills": [],
        "rules": []
      },
      "optionalDependencies": {
        "mcpServers": [],
        "agents": [],
        "skills": [],
        "rules": []
      },
      "conflicts": [],
      "files": [
        {
          "source": ".github/skills/your-skill-name/SKILL.md",
          "destination": ".github/skills/your-skill-name/SKILL.md",
          "type": "static",
          "overwrite": "prompt"
        },
        {
          "source": ".github/skills/your-skill-name/config.json",
          "destination": ".claude/skills/your-skill-name.config.json",
          "type": "config",
          "overwrite": "merge"
        }
      ],
      "settings": {
        "setting1": "default_value1",
        "setting2": "default_value2"
      }
    }
  }
}
```

## Adding a New Agent

### 1. Create Directory Structure

```bash
mkdir -p .github/agents/YourAgent/prompts
```

### 2. Create AGENT.md

```bash
cat > .github/agents/YourAgent/AGENT.md << 'EOF'
---
name: YourAgent
description: Specialized AI assistant for specific tasks
version: 1.0.0
author: Your Name
specialization: area-of-expertise
tags: [tag1, tag2]
---

# Your Agent

## Specialization

What this agent is specialized for.

## Capabilities

- Capability 1
- Capability 2

## When to Delegate to This Agent

- Scenario 1
- Scenario 2

## Dependencies

Required components.

## Configuration

Agent-specific settings.

## Limitations

What this agent should NOT do.

## Integration

How this agent works with other components.
EOF
```

### 3. Create System Prompt

```bash
cat > .github/agents/YourAgent/prompts/system.md << 'EOF'
# Your Agent System Prompt

Detailed instructions for how this agent should behave.

## Core Responsibilities

1. Responsibility 1
2. Responsibility 2

## Safety Rules

Critical rules the agent must follow.

## Best Practices

Recommended patterns and approaches.
EOF
```

### 4. Add Examples

```bash
cat > .github/agents/YourAgent/prompts/examples.md << 'EOF'
# Your Agent Usage Examples

## Example 1: Common Task

**User**: "User request"

**Agent**: [Agent response and actions]
EOF
```

### 5. Create config.json

```bash
cat > .github/agents/YourAgent/config.json << 'EOF'
{
  "timeout": 300,
  "max_iterations": 10,
  "custom_setting": "value"
}
EOF
```

### 6. Update Registry

Add your agent to `registry.json` (similar to skills).

## Adding a New Rule

### 1. Create Directory Structure

```bash
mkdir -p .github/rules/your-rule/{templates,examples}
```

### 2. Create RULE.md

```bash
cat > .github/rules/your-rule/RULE.md << 'EOF'
---
name: your-rule
description: Guidelines for specific aspect of code
version: 1.0.0
author: Your Name
category: quality|security|standards
enforcement: strict|advisory
tags: [tag1, tag2]
---

# Your Rule

## Purpose

Why this rule exists.

## Guidelines

### Guideline 1
[Detailed description with examples]

### Guideline 2
[Detailed description with examples]

## Configuration

Settings that customize rule behavior.

## Enforcement

How Claude should enforce this rule.

## Exceptions

When it's OK to break this rule.
EOF
```

### 3. Add Templates

```bash
cat > .github/rules/your-rule/templates/template.md << 'EOF'
# Template for project-specific customization
EOF
```

### 4. Add Examples

```bash
cat > .github/rules/your-rule/examples/good-vs-bad.md << 'EOF'
# Good vs Bad Examples

## Example 1

### Bad
[Bad code example]

### Good
[Good code example]

**Why**: Explanation
EOF
```

### 5. Create config.json

```bash
cat > .github/rules/your-rule/config.json << 'EOF'
{
  "enforcement_level": "advisory",
  "auto_fix": false,
  "custom_setting": "value"
}
EOF
```

### 6. Update Registry

Add your rule to `registry.json` (similar to skills).

## Updating the Registry

### Registry Schema

Each component entry in `registry.json` must include:

**Required Fields**:
- `id`: Unique identifier (matches directory name)
- `type`: "skill" | "agent" | "rule" | "mcpServer"
- `name`: Display name
- `description`: Brief description (1-2 sentences)
- `version`: Semantic version (e.g., "1.0.0")
- `author`: Your name or organization
- `category`: Category for grouping
- `tags`: Array of searchable tags

**Dependency Fields**:
- `dependencies`: Required components (by type)
- `optionalDependencies`: Optional components
- `conflicts`: Components that conflict with this one

**File Specifications**:
- `files`: Array of file objects with:
  - `source`: Path in central repo
  - `destination`: Path in user project
  - `type`: "static" | "template" | "config"
  - `overwrite`: "prompt" | "preserve" | "merge" | "always"

**Settings**:
- `settings`: Default configuration values

### Overwrite Behaviors

- **prompt**: Ask user before overwriting customized files
- **preserve**: Never overwrite user modifications
- **merge**: Merge JSON files (for configs)
- **always**: Always overwrite (for static templates)

### Validate Registry

```bash
# Validate JSON syntax
jq empty registry.json

# Run validation script (if available)
./scripts/validate-registry.sh
```

## Testing Your Component

### 1. Test Installation

```bash
# Create test project
mkdir ~/test-project
cd ~/test-project

# Run setup
~/.claude/.github/skills/claude-setup/scripts/setup.sh

# Select your component
# Verify files are copied correctly
ls -la .github/skills/your-component/
cat .claude/installation.state.json
```

### 2. Test Dependencies

```bash
# If your component has dependencies:
# 1. Select only your component
# 2. Verify dependencies are auto-installed
cat .claude/settings.local.json | jq '.mcpServers, .agents, .skills, .rules'
```

### 3. Test Update Mode

```bash
# Run setup again
~/.claude/.github/skills/claude-setup/scripts/setup.sh

# Choose "Update"
# Verify component can be added/removed
# Verify customizations are preserved
```

### 4. Test Customization Detection

```bash
# Modify an installed file
echo "# Custom note" >> .github/skills/your-component/SKILL.md

# Run setup again, select same component
# Should detect customization and prompt
```

### 5. Test with Claude Code

```bash
# Start Claude Code in test project
# Try using your component
# Verify it provides the expected functionality
```

## Submission Guidelines

### Before Submitting

- [ ] Component follows directory structure standards
- [ ] All required files are present (SKILL.md/AGENT.md/RULE.md, config.json)
- [ ] Registry entry is complete and valid JSON
- [ ] Dependencies are correctly declared
- [ ] Files specifications include correct overwrite behaviors
- [ ] Documentation is clear and includes examples
- [ ] Component has been tested in fresh installation
- [ ] Update mode tested (add/remove component)
- [ ] Customization detection tested

### Pull Request Checklist

1. **Title**: Clear description of what's added/changed
   - Example: "Add API testing skill"
   - Example: "Improve Bash agent error handling"

2. **Description**: Include:
   - What this component does
   - Why it's useful
   - Dependencies and why they're needed
   - Testing performed

3. **Files**: Include:
   - All component files
   - Registry.json update
   - Documentation updates (if needed)

4. **Tests**: Describe:
   - Fresh installation test results
   - Update mode test results
   - Integration with existing components

### Review Process

1. Maintainers will review for:
   - Code quality and organization
   - Documentation completeness
   - Registry schema compliance
   - No conflicts with existing components
   - Proper dependency declarations

2. Feedback will be provided via PR comments

3. Once approved, your component will be merged and available in the next release

## Component Guidelines

### Naming Conventions

- **Skills**: `kebab-case` (e.g., `git-workflow`, `api-testing`)
- **Agents**: `PascalCase` (e.g., `Bash`, `SecurityAuditor`)
- **Rules**: `kebab-case` (e.g., `code-style`, `accessibility`)

### Documentation Standards

- Clear, concise language
- Include practical examples
- Explain the "why" behind decisions
- Link to external resources when appropriate
- Keep line length under 100 characters

### File Organization

- Keep files focused and single-purpose
- Use templates for user-customizable content
- Separate examples from main documentation
- Include config.json for all configurable components

### Version Management

Follow semantic versioning:
- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features, backward compatible
- **Patch** (1.0.0 → 1.0.1): Bug fixes

## Questions?

- **Issues**: [GitHub Issues](https://github.com/Latros-io/.claude/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Latros-io/.claude/discussions)
- **Email**: [support@latros.io](mailto:support@latros.io)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to .claude! 🎉
