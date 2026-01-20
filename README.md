# Claude Code Best Practices

> A comprehensive library of agents, skills, and rules for Claude Code projects, distributed as a git submodule.

**Build better software with battle-tested components** that integrate seamlessly into your development workflow.

[![Version](https://img.shields.io/badge/version-3.0.0-blue.svg)](https://github.com/Latros-io/claude-code-best-practices)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/claude--code-v3.0-purple.svg)](https://claude.ai/code)

---

## 🎯 What is This?

A **git submodule-based library** of reusable components for Claude Code:

- **🤖 Agents** (4 core + domains): Specialized AI assistants for different tasks
- **🎯 Skills** (5 core + domains): Automated workflows and capabilities
- **📋 Rules** (5 core + domains): Best practices and coding standards
- **⚙️ Settings Profiles**: Pre-configured setups for different project types
- **🔌 MCP Servers**: Integration configurations for external services

---

## ✨ Why Use This Library?

### The Problem
Setting up Claude Code for each project is repetitive:
- Re-creating the same agents, skills, and rules
- Copy-pasting configurations between projects
- Maintaining consistency across team members
- Keeping components up-to-date

### The Solution
One library, reusable everywhere:
- **10+ hours saved** per project setup
- **Consistent best practices** across your team
- **One update** propagates to all projects
- **Battle-tested components** from the community

### How It Works
Instead of copying files, your project references a shared library:
- **Add once**: Install as git submodule
- **Link selectively**: Choose only what you need
- **Customize freely**: Override without affecting upstream
- **Update easily**: `git pull` to get latest improvements

---

## ✨ Features

### ✅ Standard Git Workflow
No special plugin system - just git:
```bash
git submodule add <url>    # Install
git pull                    # Update
git checkout v3.0.0         # Pin version
```

### ✅ Rich Component Library
- **Core**: Universal components for all projects
- **Web**: Frontend (React, Vue) & Backend (Node, Express)
- **Data Science**: Python, Jupyter, ML workflows
- **DevOps**: Docker, Kubernetes, Terraform

### ✅ Clean Customization
- Override system keeps your changes separate
- Updates never conflict with customizations
- Clear distinction: upstream vs local

### ✅ Settings Profiles
- **Minimal**: Barebones (perfect for scripts)
- **Standard**: Recommended for most projects
- **Comprehensive**: Full power for large codebases
- **Domain-Specific**: React, Python, Docker, etc.

### ✅ MCP Server Configurations
MCP (Model Context Protocol) servers extend Claude's capabilities with external integrations:
- **filesystem**: Secure file system access
- **github**: GitHub API integration for issues, PRs
- **browser**: Playwright for web automation and testing
- **postgres**: Database queries and schema inspection
- **docker**: Container management and debugging

Pre-configured for security and best practices.

### ✅ Integrated Tools
- **link.sh**: Set up symlinks from submodule to project
- **sync.sh**: Pull updates safely
- **customize.sh**: Manage overrides
- **validate.sh**: Check configurations
- **merge-settings.sh**: Compose profiles

---

## 📋 Before Getting Started

### System Requirements
- **Git**: 2.13 or higher (for submodule support)
- **Bash**: 4.0 or higher (for integration scripts)
- **Python**: 3.6 or higher (for settings merging)
- **OS**: macOS, Linux, or WSL on Windows

### Knowledge Requirements
- Basic git familiarity (clone, commit, push)
- Understanding of your project type (web, data science, devops, etc.)
- 5 minutes of setup time

### Choose Your Profile

Not sure which profile to use? Here's a quick guide:

| Your Project | Profile | Example |
|-------------|---------|---------|
| Web frontend (React, Vue) | `web-frontend` | Single-page apps, dashboards |
| Web backend (Node, Express) | `web-backend` | REST APIs, microservices |
| Python + ML/Data | `data-science` | Jupyter notebooks, model training |
| Infrastructure | `devops` | Docker, K8s, Terraform |
| Other / Unsure | `core` | General-purpose development |

### What You'll Get

After installation, Claude Code will have access to:
- **Agents** that assist with specific tasks (code exploration, planning, etc.)
- **Skills** that automate workflows (git commits, test running, etc.)
- **Rules** that enforce best practices (code style, security, etc.)

---

## 🚀 Quick Start

**Prerequisites:** Git 2.13+, Bash 4.0+, Python 3.6+
**Time:** ~5 minutes
**Skill Level:** Intermediate (familiarity with git required)

### Installation (4 steps)

**1. Add Submodule**
```bash
cd your-project
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
git submodule update --init --recursive
```
*This adds the best practices library to your project.*

**2. Link Components**

Choose ONE profile based on your project:
- `core` - General development (recommended for most)
- `web-frontend` - React, Vue, or other frontend
- `web-backend` - Node, Express, or other backend
- `data-science` - Python, Jupyter, ML projects
- `devops` - Docker, Kubernetes, infrastructure

```bash
.claude/best-practices/scripts/link.sh --profile=core
```
*This creates symlinks from the library to your .github/ directory.*

**3. Apply Settings**

**Option A - Simple (most users):**
```bash
cp .claude/best-practices/core/settings/standard.json .claude/settings.json
```

**Option B - Advanced (if you need domain-specific settings):**
```bash
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

**4. Commit**
```bash
git add .claude .github
git commit -m "Integrate Claude Code best practices v3.0.0"
```

**Verify Installation:**
```bash
ls -la .github/agents/  # Should show symlinks to agents
cat .claude/settings.json  # Should show your settings
```

✅ **Done!** Claude Code now has access to your selected components.

---

## 🎯 What Happens Next?

After installation, you can immediately use the components:

### Try These Commands

**Ask Claude to explore your codebase:**
```
"Where is the authentication logic implemented?"
```
*Uses the Explore agent to search your codebase.*

**Ask Claude to run tests:**
```
"Run the test suite and show me any failures"
```
*Uses the test-runner skill to execute tests.*

**Ask Claude to create a commit:**
```
"Create a commit for these changes with a conventional commit message"
```
*Uses the git-workflow skill to automate git operations.*

### Next Steps
1. **Customize components** - See [Customization](#-customization)
2. **Explore other components** - Check [What's Included](#-whats-included)
3. **Read the integration guide** - [INTEGRATION.md](INTEGRATION.md)

---

## 📦 What's Included

### Core Components (Universal)

#### Agents (4)
| Agent | Purpose |
|-------|---------|
| **Bash** | Command execution specialist for git, npm, docker, etc. |
| **Explore** | Fast codebase exploration and keyword search |
| **Plan** | Software architect for designing implementations |
| **GeneralPurpose** | Multi-step research and complex tasks |

#### Skills (5)
| Skill | Purpose |
|-------|---------|
| **git-workflow** | Git automation with conventional commits |
| **test-runner** | Auto-detect and run tests (Jest, Vitest, pytest, etc.) |
| **doc-generator** | Generate documentation from code |
| **project-setup** | Initialize Claude Code configuration |
| **refactor-helper** | Safe refactoring with validation |

#### Rules (5)
| Rule | Purpose |
|------|---------|
| **code-style** | Formatting and style standards |
| **testing** | Test coverage and requirements |
| **documentation** | Documentation standards |
| **security** | Security best practices (OWASP Top 10) |
| **git-hygiene** | Commit message and PR standards |

### Domain Components

#### Web (`domains/web/`)
- **Agents**: Frontend (React/Vue expert), Backend (Node/Express)
- **Skills**: API testing, UI component generation, bundle optimization
- **Rules**: Web security, performance, accessibility
- **Settings**: react.json, vue.json, node-express.json, next.json

#### Data Science (`domains/data-science/`)
- **Agents**: DataAnalyst, MLEngineer
- **Skills**: Jupyter workflow, data visualization, model training
- **Rules**: Reproducibility, data validation, notebook quality
- **Settings**: pandas-numpy.json, pytorch.json, tensorflow.json

#### DevOps (`domains/devops/`)
- **Agents**: Infrastructure, CICD
- **Skills**: Container management, K8s helper, Terraform generation
- **Rules**: Infrastructure-as-code, deployment safety, secrets management
- **Settings**: docker.json, kubernetes.json, aws.json

### Settings Profiles

| Profile | Components | Use Case |
|---------|-----------|----------|
| **minimal.json** | 1 agent, 1 skill, 1 rule | Scripts, small projects |
| **standard.json** | 3 agents, 3 skills, 3 rules | Most projects (recommended) |
| **comprehensive.json** | 4 agents, 5 skills, 5 rules | Large codebases, enterprise |

### MCP Servers (5 configs)
- **filesystem**: Secure filesystem access
- **github**: GitHub API integration
- **browser**: Playwright automation
- **postgres**: PostgreSQL access
- **docker**: Container management

---

## 📖 Usage

### Basic Workflow

**Check for updates:**
```bash
.claude/best-practices/scripts/sync.sh
```

**Apply updates:**
```bash
.claude/best-practices/scripts/sync.sh --apply
git add .claude/best-practices
git commit -m "Update best-practices to v3.1.0"
```

### Customization

#### Why Customize?
The library provides defaults, but every project is unique. Customize to:
- Adjust settings for your tech stack
- Add project-specific templates
- Modify agent behavior
- Create team standards

#### How to Customize

**1. Create an override:**
```bash
.claude/best-practices/scripts/customize.sh create-override \
    --component=core/skills/git-workflow \
    --file=config.json
```

**2. Edit the override:**
```bash
vim .github/overrides/skills/git-workflow/config.json
```

**3. Validate your changes:**
```bash
.claude/best-practices/scripts/customize.sh validate
```

#### Example: Custom Commit Message Template

Override the git-workflow commit template:
```bash
.claude/best-practices/scripts/customize.sh create-override \
    --component=core/skills/git-workflow \
    --file=templates/commit-message.md

# Edit to match your team's style
vim .github/overrides/skills/git-workflow/templates/commit-message.md
```

#### Override vs. Settings
- **Overrides** modify component behavior (agents, skills, rules)
- **Settings** configure which components are active
- Both are preserved when updating the library

### Project Structure

After installation:
```
your-project/
├── .claude/
│   ├── best-practices/          # Submodule (upstream)
│   │   ├── core/                # Universal components
│   │   ├── domains/             # Domain-specific
│   │   ├── scripts/             # Integration tools
│   │   └── ...
│   └── settings.json            # Your settings
│
├── .github/
│   ├── agents/                  # Symlinks to submodule
│   │   ├── Bash -> ../.claude/best-practices/core/agents/Bash
│   │   ├── Explore -> ...
│   │   └── ...
│   ├── skills/                  # Symlinks to submodule
│   │   ├── git-workflow -> ...
│   │   └── ...
│   ├── rules/                   # Symlinks to submodule
│   │   ├── code-style -> ...
│   │   └── ...
│   └── overrides/               # Your customizations
│       ├── agents/
│       ├── skills/
│       └── rules/
│
└── CLAUDE.md                    # Project context (optional)
```

---

## 🔄 Migrating from v2.x?

If you're using the old plugin-based system:

```bash
# Automated migration (recommended)
.claude/best-practices/scripts/migrate-from-plugin.sh

# Or see detailed guide
.claude/best-practices/meta/migration-guide.md
```

The migration script:
- ✅ Backs up your current configuration
- ✅ Extracts customizations
- ✅ Removes old plugin components
- ✅ Adds v3.x submodule
- ✅ Links components with profile selection
- ✅ Restores customizations to overrides/
- ✅ Generates detailed migration report

**v2.x Support:** Security fixes only until 2026-07-19. Please migrate soon.

---

## 📚 Documentation

- **[INTEGRATION.md](INTEGRATION.md)** - Complete integration guide
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[meta/migration-guide.md](meta/migration-guide.md)** - Detailed v2.x → v3.x migration
- **[core/settings/README.md](core/settings/README.md)** - Settings profile documentation
- **[STATUS.md](STATUS.md)** - Implementation status and roadmap

### Component Documentation

Each component includes:
- **AGENT.md** / **SKILL.md** / **RULE.md** - Purpose and usage
- **config.json** - Configuration and dependencies
- **prompts/** or **templates/** - Customizable content
- **examples/** - Real-world usage examples

---

## 💡 Common Setups

### Frontend (React)
```bash
.claude/best-practices/scripts/link.sh --profile=web-frontend
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

**Includes**: Bash, Explore, Plan, Frontend agents + git-workflow, test-runner, ui-component-gen + code-style, testing, web-security, performance

### Backend (Node + PostgreSQL)
```bash
.claude/best-practices/scripts/link.sh --profile=web-backend
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/node-express.json \
    .claude/settings.json
```

**Includes**: Core agents + Backend agent + API testing + security rules

### Data Science (Python)
```bash
.claude/best-practices/scripts/link.sh --profile=data-science
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/data-science/settings/pandas-numpy.json \
    .claude/settings.json
```

**Includes**: Core components + DataAnalyst agent + Jupyter workflow + reproducibility rules

### DevOps (Docker + K8s)
```bash
.claude/best-practices/scripts/link.sh --profile=devops
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/devops/settings/kubernetes.json \
    .claude/settings.json
```

**Includes**: Core components + Infrastructure, CICD agents + K8s helper + deployment safety

---

## 🛠️ Integration Scripts

All scripts in `scripts/` directory:

| Script | Purpose |
|--------|---------|
| **link.sh** | Create symlinks from submodule to project |
| **sync.sh** | Pull updates and validate against overrides |
| **customize.sh** | Create, list, validate overrides |
| **validate.sh** | Validate all configurations and dependencies |
| **merge-settings.sh** | Compose multiple settings profiles |
| **migrate-from-plugin.sh** | Migrate from v2.x plugin |

All scripts include `--help` for detailed usage.

---

## 🤝 Contributing

We welcome contributions!

**Ways to contribute:**
- Add new components (agents, skills, rules)
- Improve existing components
- Add domain-specific configurations
- Fix bugs
- Improve documentation

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Component Development:**
1. Follow existing structure (AGENT.md, config.json, etc.)
2. Include examples and documentation
3. Declare dependencies clearly
4. Add to registry.json
5. Submit PR

---

## 🔒 Security

- Never commit secrets to version control
- Use environment variables for sensitive data
- Security rules check for common vulnerabilities
- Regular dependency audits
- Report vulnerabilities: security@latros.io

---

## 📊 Project Stats

- **61 files** in v3.0.0
- **15 stable components** (4 agents, 5 skills, 5 rules, 1 settings group)
- **42 planned components** across 3 domains
- **6 integration scripts**
- **5 MCP server configurations**
- **3 core settings profiles**
- **Comprehensive documentation** (4 major docs + component docs)

---

## 🗺️ Roadmap

### v3.0.0 (Current)
- ✅ Core components (agents, skills, rules)
- ✅ Settings profiles
- ✅ Integration scripts
- ✅ MCP server configs
- ✅ Web domain (examples)
- ✅ Migration tooling

### v3.1.0 (Q2 2026)
- Complete web domain components
- Additional settings profiles
- Enhanced documentation

### v3.2.0 (Q3 2026)
- Data science domain components
- DevOps domain components
- Performance optimizations

### v3.3.0 (Q4 2026)
- Advanced agent capabilities
- Plugin ecosystem
- Community components

---

## ❗ Troubleshooting

### Submodule won't initialize
**Problem:** `git submodule update` hangs or fails

**Solution:**
```bash
# Check network connection
git submodule update --init --recursive --verbose

# If it still fails, try cloning directly:
git clone https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
```

---

### Symlinks don't work (Windows)
**Problem:** Symlinks appear as files, components not found

**Solution:** Use copy mode instead
```bash
.claude/best-practices/scripts/link.sh --profile=core --copy
```
*Note: Re-run after each submodule update*

---

### Components not detected by Claude Code
**Problem:** Claude doesn't see agents/skills/rules

**Solution:** Verify symlinks were created
```bash
ls -la .github/agents/  # Should show symlinks like: Bash -> ../../.claude/...
```

If missing, re-run link script:
```bash
.claude/best-practices/scripts/link.sh --profile=core
```

---

### Settings not applying
**Problem:** Changes to settings.json don't take effect

**Solution:**
1. Verify file location: `ls -la .claude/settings.json`
2. Validate JSON syntax: `python3 -m json.tool .claude/settings.json`
3. Restart Claude Code

---

### How do I uninstall?
**Solution:**
```bash
# Remove symlinks
rm -rf .github/agents .github/skills .github/rules

# Remove submodule
git submodule deinit .claude/best-practices
git rm .claude/best-practices
rm -rf .git/modules/.claude/best-practices

# Remove settings
rm .claude/settings.json

# Commit removal
git commit -m "Remove Claude Code best practices"
```

---

## ❓ Support

- **Documentation**: Start with [INTEGRATION.md](INTEGRATION.md)
- **Issues**: [GitHub Issues](https://github.com/Latros-io/claude-code-best-practices/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Latros-io/claude-code-best-practices/discussions)
- **Email**: support@latros.io

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file

---

## 🙏 Acknowledgments

Built for the Claude Code community. Inspired by best practices from leading software teams.

Special thanks to all contributors and early adopters.

---

**Version**: 3.0.0 | **Status**: Active Development | **Last Updated**: 2026-01-19
