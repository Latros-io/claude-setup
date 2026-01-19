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

**Why git submodule?** Standard git workflow, version pinning, clean updates, and clear separation between upstream and your customizations.

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

### ✅ Integrated Tools
- **link.sh**: Set up symlinks from submodule to project
- **sync.sh**: Pull updates safely
- **customize.sh**: Manage overrides
- **validate.sh**: Check configurations
- **merge-settings.sh**: Compose profiles

---

## 🚀 Quick Start

### Installation (3 steps)

**1. Add Submodule**
```bash
cd your-project
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
git submodule update --init --recursive
```

**2. Link Components**
```bash
# Choose a profile based on your project type
.claude/best-practices/scripts/link.sh --profile=core              # General
.claude/best-practices/scripts/link.sh --profile=web-frontend     # React, Vue
.claude/best-practices/scripts/link.sh --profile=web-backend      # Node, Express
.claude/best-practices/scripts/link.sh --profile=data-science     # Python, ML
.claude/best-practices/scripts/link.sh --profile=devops           # Docker, K8s
```

**3. Apply Settings**
```bash
# Standard profile (recommended)
cp .claude/best-practices/core/settings/standard.json .claude/settings.json

# Or compose with domain profile
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

✅ **Done!** Claude Code now has access to your selected components.

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

**Create override:**
```bash
.claude/best-practices/scripts/customize.sh create-override \
    --component=core/skills/git-workflow \
    --file=config.json
```

**Edit override:**
```bash
vim .github/overrides/skills/git-workflow/config.json
```

**Validate:**
```bash
.claude/best-practices/scripts/customize.sh validate
```

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
