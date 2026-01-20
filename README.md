# Claude Code Best Practices

> A comprehensive library of agents, skills, and rules for Claude Code projects, distributed as a git submodule.

**Build better software with battle-tested components** that integrate seamlessly into your development workflow.

[![Version](https://img.shields.io/badge/version-4.0.0-blue.svg)](https://github.com/Latros-io/claude-setup)
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
Claude Code reads components directly from the submodule:
- **Add once**: Install as git submodule
- **Copy settings**: One JSON file tells Claude where to find components
- **Update easily**: `git pull` in submodule to get latest improvements
- **No extraction**: No symlinks, no copying, no complexity

---

## 🚀 Quick Start

**Prerequisites:** Git 2.13+
**Time:** ~2 minutes
**Skill Level:** Beginner (basic git knowledge)

### Installation (3 steps)

**1. Add Submodule**
```bash
cd your-project
git submodule add https://github.com/Latros-io/claude-setup.git .claude/best-practices
git submodule update --init --recursive
```

**2. Run Setup Script**
```bash
.claude/best-practices/scripts/setup.sh
```

The setup script will:
- Let you choose a profile (minimal, standard, comprehensive, or react)
- Copy the appropriate settings file to `.claude/settings.json`
- That's it!

**3. Commit**
```bash
git add .claude
git commit -m "Setup Claude Code best practices v4.0.0"
```

✅ **Done!** Claude Code now reads components directly from the submodule.

---

## 📖 What's Different in v4.0?

**Before (v3.x):** Complex extraction with symlinks
```
.claude/best-practices/          # Submodule
.github/agents/                  # Symlinks extracted here
.github/skills/                  # Symlinks extracted here
.github/rules/                   # Symlinks extracted here
```
Required: link.sh, customize.sh, sync.sh scripts

**Now (v4.0):** Direct submodule usage
```
.claude/best-practices/          # Submodule (components stay here)
.claude/settings.json            # Just tell Claude where they are
```
Required: One settings file. That's it!

**Benefits:**
- ✅ No symlinks (Windows-friendly!)
- ✅ No extraction scripts needed
- ✅ No `.github/` directory clutter
- ✅ Simpler mental model
- ✅ Faster setup (2 min vs 5 min)
- ✅ Easier updates (just `git pull`)

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
| **react.json** | Core + Web domain | React/frontend development |

---

## 📚 Usage

### Updating the Library

```bash
# Check for updates
cd .claude/best-practices
git fetch origin

# View available updates
git log HEAD..origin/main --oneline

# Apply updates
git pull

# Commit the update in your project
cd ../..
git add .claude/best-practices
git commit -m "Update best-practices to latest version"
```

### Switching Profiles

```bash
# Run setup again to choose a different profile
.claude/best-practices/scripts/setup.sh
```

Or manually copy a different settings file:
```bash
cp .claude/best-practices/core/settings/comprehensive.json .claude/settings.json
```

### Customizing Settings

Edit `.claude/settings.json` directly:

```json
{
  "name": "my-custom-profile",
  "version": "4.0.0",
  "paths": {
    "agents": ".claude/best-practices/core/agents",
    "skills": ".claude/best-practices/core/skills",
    "rules": ".claude/best-practices/core/rules"
  },
  "agents": ["Bash", "Explore"],
  "skills": ["git-workflow"],
  "rules": ["code-style", "security"]
}
```

### Project Structure

After installation:
```
your-project/
├── .claude/
│   ├── best-practices/          # Submodule (components live here)
│   │   ├── core/
│   │   │   ├── agents/
│   │   │   ├── skills/
│   │   │   ├── rules/
│   │   │   └── settings/
│   │   └── domains/
│   │       ├── web/
│   │       ├── data-science/
│   │       └── devops/
│   └── settings.json            # Points to submodule paths
│
└── CLAUDE.md                    # Project context (optional)
```

---

## 💡 Common Setups

### General Development
```bash
.claude/best-practices/scripts/setup.sh --profile=standard
```

### React Frontend
```bash
.claude/best-practices/scripts/setup.sh --profile=react
```

### Custom Mix (Core + Web Domain)
Edit `.claude/settings.json`:
```json
{
  "name": "my-fullstack-setup",
  "version": "4.0.0",
  "paths": {
    "agents": [
      ".claude/best-practices/core/agents",
      ".claude/best-practices/domains/web/agents"
    ],
    "skills": [
      ".claude/best-practices/core/skills",
      ".claude/best-practices/domains/web/skills"
    ],
    "rules": [
      ".claude/best-practices/core/rules",
      ".claude/best-practices/domains/web/rules"
    ]
  }
}
```

---

## 🔄 Migrating from v3.x?

v3.x used symlinks and extraction scripts. v4.0 is much simpler!

**Quick Migration:**

1. Remove old symlinks:
```bash
rm -rf .github/agents .github/skills .github/rules .github/overrides
```

2. Run the new setup:
```bash
.claude/best-practices/scripts/setup.sh
```

3. Commit:
```bash
git add .claude .github
git commit -m "Migrate to v4.0 (direct submodule usage)"
```

See [meta/migration-guide.md](meta/migration-guide.md) for detailed migration instructions.

**v3.x Support:** Security fixes only until 2026-07-19. Please migrate soon.

---

## 🛠️ Available Scripts

| Script | Purpose |
|--------|---------|
| **setup.sh** | Copy settings file to your project (one-time setup) |
| **validate.sh** | Validate configurations and check for issues |
| **merge-settings.sh** | Merge multiple settings files (advanced) |
| **test-scripts.sh** | Run test suite to verify everything works |

All scripts include `--help` for detailed usage.

---

## 📚 Documentation

- **[INTEGRATION.md](INTEGRATION.md)** - Complete integration guide
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[meta/migration-guide.md](meta/migration-guide.md)** - Detailed v3.x → v4.x migration
- **[core/settings/README.md](core/settings/README.md)** - Settings profile documentation
- **[STATUS.md](STATUS.md)** - Implementation status and roadmap

### Component Documentation

Each component includes:
- **AGENT.md** / **SKILL.md** / **RULE.md** - Purpose and usage
- **config.json** - Configuration and dependencies
- **prompts/** or **templates/** - Customizable content
- **examples/** - Real-world usage examples

---

## ❗ Troubleshooting

### Submodule won't initialize
**Problem:** `git submodule update` hangs or fails

**Solution:**
```bash
# Check network connection
git submodule update --init --recursive --verbose

# If it still fails, try cloning directly:
git clone https://github.com/Latros-io/claude-setup.git .claude/best-practices
```

---

### Components not detected by Claude Code
**Problem:** Claude doesn't see agents/skills/rules

**Solution:** Verify settings file paths
```bash
cat .claude/settings.json
# Ensure "paths" section points to .claude/best-practices/...
```

If paths are wrong, re-run setup:
```bash
.claude/best-practices/scripts/setup.sh
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
# Remove settings
rm .claude/settings.json

# Remove submodule
git submodule deinit .claude/best-practices
git rm .claude/best-practices
rm -rf .git/modules/.claude/best-practices

# Commit removal
git commit -m "Remove Claude Code best practices"
```

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

---

## 🔒 Security

- Never commit secrets to version control
- Use environment variables for sensitive data
- Security rules check for common vulnerabilities
- Regular dependency audits
- Report vulnerabilities: security@latros.io

---

## 📊 Project Stats

- **58 files** in v4.0.0
- **15 stable components** (4 agents, 5 skills, 5 rules, 1 settings group)
- **42 planned components** across 3 domains
- **4 utility scripts** (down from 9!)
- **5 MCP server configurations**
- **3 core settings profiles + 1 domain profile**
- **Comprehensive documentation** (4 major docs + component docs)

---

## 🗺️ Roadmap

### v4.0.0 (Current) - Simplification Release
- ✅ Direct submodule usage (no extraction)
- ✅ Removed complex linking scripts
- ✅ Simplified setup (2 minutes)
- ✅ Windows-friendly (no symlinks)
- ✅ Updated all documentation

### v4.1.0 (Q2 2026)
- Complete web domain components
- Additional domain settings profiles
- Enhanced component discovery

### v4.2.0 (Q3 2026)
- Data science domain components
- DevOps domain components
- Performance optimizations

### v4.3.0 (Q4 2026)
- Advanced agent capabilities
- Plugin ecosystem
- Community components

---

## ❓ Support

- **Documentation**: Start with [INTEGRATION.md](INTEGRATION.md)
- **Issues**: [GitHub Issues](https://github.com/Latros-io/claude-setup/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Latros-io/claude-setup/discussions)
- **Email**: support@latros.io

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file

---

## 🙏 Acknowledgments

Built for the Claude Code community. Inspired by best practices from leading software teams.

Special thanks to all contributors and early adopters who provided feedback on the v3.x → v4.0 simplification.

---

**Version**: 4.0.0 | **Status**: Active Development | **Last Updated**: 2026-01-20
