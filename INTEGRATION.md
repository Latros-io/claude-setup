# Integration Guide

**Claude Code Best Practices - Git Submodule Integration**

Version: 3.0.0

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Component Linking](#component-linking)
- [Settings Profiles](#settings-profiles)
- [Customization](#customization)
- [Updates](#updates)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)

## Quick Start

### 1. Add Submodule

```bash
# Navigate to your project
cd your-project

# Add best-practices as submodule
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices

# Initialize and update
git submodule update --init --recursive
```

### 2. Link Components

```bash
# Link standard components (recommended for most projects)
.claude/best-practices/scripts/link.sh --profile=core

# Or choose a domain-specific profile
.claude/best-practices/scripts/link.sh --profile=web-frontend
.claude/best-practices/scripts/link.sh --profile=data-science
.claude/best-practices/scripts/link.sh --profile=devops
```

### 3. Apply Settings

```bash
# Copy standard settings (recommended)
cp .claude/best-practices/core/settings/standard.json .claude/settings.json

# Or compose with domain settings
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

### 4. Commit Integration

```bash
git add .claude .github
git commit -m "Integrate Claude Code best practices"
```

## Installation

### Prerequisites

- Git 2.13+ (for submodule support)
- Bash 4.0+ (for scripts)
- Python 3.6+ (for merge-settings.sh)

### Step-by-Step

#### 1. Add as Git Submodule

```bash
cd your-project
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
git submodule update --init --recursive
```

This creates:
```
your-project/
├── .claude/
│   └── best-practices/     # Submodule (tracks upstream repo)
└── .gitmodules             # Submodule configuration
```

#### 2. Verify Installation

```bash
# Check submodule status
git submodule status

# Expected output:
# [commit-hash] .claude/best-practices (v3.0.0)
```

## Component Linking

Components are linked (or copied) from the submodule to your project structure.

### Link Strategies

#### Symlinks (Recommended)

**Pros:**
- Changes in submodule immediately reflected
- No duplication
- Easy updates

**Cons:**
- Not supported on Windows (use `--copy` instead)

```bash
.claude/best-practices/scripts/link.sh --profile=core
```

#### Copy Mode (Windows)

**Pros:**
- Works on all platforms
- Local modifications possible

**Cons:**
- Need to re-run after submodule updates
- File duplication

```bash
.claude/best-practices/scripts/link.sh --profile=core --copy
```

### Available Profiles

| Profile | Components | Use Case |
|---------|-----------|----------|
| `core` | All core components | General development |
| `web-frontend` | Core + Web frontend | React, Vue, HTML/CSS |
| `web-backend` | Core + Web backend | Node, Express, APIs |
| `data-science` | Core + Data science | Python, Jupyter, ML |
| `devops` | Core + DevOps | Docker, K8s, Terraform |

### Link Options

```bash
# Dry run (see what would happen)
.claude/best-practices/scripts/link.sh --profile=web-frontend --dry-run

# Specify custom target directory
.claude/best-practices/scripts/link.sh --profile=core --target-dir=.github

# Only core components
.claude/best-practices/scripts/link.sh --core-only
```

### Result Structure

After linking with `--profile=core`:

```
your-project/
├── .github/
│   ├── agents/
│   │   ├── Bash -> ../.claude/best-practices/core/agents/Bash
│   │   ├── Explore -> ../.claude/best-practices/core/agents/Explore
│   │   ├── Plan -> ../.claude/best-practices/core/agents/Plan
│   │   └── GeneralPurpose -> ../.claude/best-practices/core/agents/GeneralPurpose
│   ├── skills/
│   │   ├── git-workflow -> ../.claude/best-practices/core/skills/git-workflow
│   │   ├── test-runner -> ../.claude/best-practices/core/skills/test-runner
│   │   └── ...
│   └── rules/
│       ├── code-style -> ../.claude/best-practices/core/rules/code-style
│       └── ...
└── .claude/
    └── best-practices/     # Submodule
```

## Settings Profiles

Settings profiles configure Claude Code's behavior for your project.

### Core Profiles

#### Minimal
**File:** `core/settings/minimal.json`
**For:** Simple scripts, small projects
**Includes:**
- 1 agent (Bash)
- 1 skill (git-workflow)
- 1 rule (code-style)
- Filesystem MCP only

```bash
cp .claude/best-practices/core/settings/minimal.json .claude/settings.json
```

#### Standard (Recommended)
**File:** `core/settings/standard.json`
**For:** Most projects
**Includes:**
- 3 agents (Bash, Explore, Plan)
- 3 skills (git-workflow, test-runner, doc-generator)
- 3 rules (code-style, testing, documentation)
- Filesystem + GitHub MCP

```bash
cp .claude/best-practices/core/settings/standard.json .claude/settings.json
```

#### Comprehensive
**File:** `core/settings/comprehensive.json`
**For:** Large projects, enterprise
**Includes:**
- All 4 core agents
- All 5 core skills
- All 5 core rules
- Multiple MCP servers

```bash
cp .claude/best-practices/core/settings/comprehensive.json .claude/settings.json
```

### Domain Profiles

Domain profiles extend core profiles with specialized components.

#### Web (React)
```bash
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

#### Data Science (Python)
```bash
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/data-science/settings/pandas-numpy.json \
    .claude/settings.json
```

#### DevOps (Docker)
```bash
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/devops/settings/docker.json \
    .claude/settings.json
```

### Profile Composition

Combine multiple profiles:

```bash
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.local.json \
    .claude/settings.json
```

Merge behavior:
- **Objects**: Deep merge (properties combined)
- **Arrays**: Concatenate and deduplicate
- **Primitives**: Last value wins
- **null**: Removes property

## Customization

Customize components without modifying the submodule.

### Override System

Create overrides in `.github/overrides/`:

```
your-project/
├── .github/
│   ├── agents/
│   │   └── Bash -> ../.claude/best-practices/core/agents/Bash  # Symlink
│   └── overrides/                                               # Local customizations
│       ├── agents/
│       │   └── Bash/
│       │       └── config.json                                  # Overrides submodule
│       └── skills/
│           └── git-workflow/
│               └── templates/
│                   └── commit-message.md                        # Custom template
```

### Create Override

```bash
# Create override from base
.claude/best-practices/scripts/customize.sh create-override \
    --component=core/skills/git-workflow \
    --file=config.json

# This creates .github/overrides/skills/git-workflow/config.json
```

### List Overrides

```bash
.claude/best-practices/scripts/customize.sh list-overrides
```

### Validate Overrides

```bash
.claude/best-practices/scripts/customize.sh validate
```

### Document Overrides

```bash
# Auto-generate documentation
.claude/best-practices/scripts/customize.sh document

# Creates/updates .github/overrides/README.md
```

### Override Merge Behavior

**config.json** - Deep merged:
```json
// Base (submodule)
{
  "timeout": 30,
  "retries": 3,
  "features": {"a": true}
}

// Override
{
  "timeout": 60,
  "features": {"b": true}
}

// Effective
{
  "timeout": 60,        // Overridden
  "retries": 3,         // From base
  "features": {
    "a": true,          // From base
    "b": true           // From override
  }
}
```

**Templates (*.md)** - Completely replaced:
```markdown
<!-- Override completely replaces base template -->
```

## Updates

Pull latest best practices from upstream.

### Check for Updates

```bash
.claude/best-practices/scripts/sync.sh
```

Output:
```
Current version: v3.0.0 (branch: main)
→ Fetching latest updates...
⚠ Updates available: 5 commit(s) behind
Latest version: v3.1.0

Recent changes:
  a1b2c3d Add new security rules
  d4e5f6g Improve test-runner
  ...

→ Checking for breaking changes...
✓ No breaking changes detected

→ Checking for conflicts with local overrides...
✓ No conflicts detected

To apply updates, run: ./sync.sh --apply
```

### Apply Updates

```bash
.claude/best-practices/scripts/sync.sh --apply
```

This:
1. Creates backup (`.claude/backups/pre-sync-TIMESTAMP/`)
2. Pulls latest from submodule
3. Validates against overrides
4. Updates submodule reference
5. Prompts to commit

### Update Workflow

```bash
# 1. Check for updates
.claude/best-practices/scripts/sync.sh

# 2. Review changes
cd .claude/best-practices
git log HEAD..origin/main
git diff HEAD..origin/main

# 3. Apply updates
cd ../..
.claude/best-practices/scripts/sync.sh --apply

# 4. Commit submodule update
git add .claude/best-practices
git commit -m "Update best-practices submodule to v3.1.0"
```

### Pin to Specific Version

```bash
cd .claude/best-practices
git checkout v3.0.0     # Pin to release
cd ../..
git add .claude/best-practices
git commit -m "Pin best-practices to v3.0.0"
```

## Advanced Usage

### Version Pinning

**Stay on stable release:**
```bash
cd .claude/best-practices
git checkout v3.1.0
```

**Track latest (automatic updates):**
```bash
cd .claude/best-practices
git checkout main
git pull
```

**Test unreleased features:**
```bash
cd .claude/best-practices
git checkout develop
```

### Selective Component Linking

Link specific components manually:

```bash
# Create target directory
mkdir -p .github/agents

# Link specific agent
ln -s ../..claude/best-practices/core/agents/Bash .github/agents/Bash
```

### Custom Profiles

Create project-specific profiles:

```json
// .claude/profiles/my-project.json
{
  "extends": ".claude/best-practices/core/settings/standard.json",
  "name": "My Project",
  "agents": ["Bash", "Explore", "CustomAgent"],
  "settings": {
    "customSetting": true
  }
}
```

### Team Standardization

Commit your configuration:

```bash
# These should be committed for team consistency
git add .claude/settings.json
git add .github/agents
git add .github/skills
git add .github/rules

# These might be gitignored (personal preferences)
.claude/settings.local.json
.github/overrides/
```

## Troubleshooting

### Submodule Not Initialized

**Problem:** `.claude/best-practices` is empty

**Solution:**
```bash
git submodule update --init --recursive
```

### Symlinks Not Working (Windows)

**Problem:** Symlinks not supported

**Solution:** Use copy mode
```bash
.claude/best-practices/scripts/link.sh --profile=core --copy
```

### Components Not Found

**Problem:** Claude doesn't see linked components

**Solution:** Validate links
```bash
ls -la .github/agents/
# Check symlinks are correct
```

### Override Not Applied

**Problem:** Customizations not taking effect

**Solution:** Validate overrides
```bash
.claude/best-practices/scripts/customize.sh validate
```

### Merge Conflicts on Update

**Problem:** Conflicts when pulling updates

**Solution:** Review and resolve
```bash
cd .claude/best-practices
git status
git diff
# Resolve conflicts
git add .
git commit
```

### Script Permission Denied

**Problem:** Scripts won't execute

**Solution:** Make executable
```bash
chmod +x .claude/best-practices/scripts/*.sh
```

## Next Steps

- Read [README.md](./README.md) for project overview
- See [CHANGELOG.md](./CHANGELOG.md) for version history
- Check [meta/migration-guide.md](./meta/migration-guide.md) for v2.x → v3.x migration
- Explore [core/settings/README.md](./core/settings/README.md) for profile details

## Support

- Issues: https://github.com/Latros-io/claude-code-best-practices/issues
- Discussions: https://github.com/Latros-io/claude-code-best-practices/discussions
- Discord: https://discord.gg/claude-code
