# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-01-19

### 🚀 Major Release: Git Submodule-Based Architecture

This is a complete restructuring from a plugin-based system to a git submodule-based best practices library.

### Added

#### Core Structure
- **New Directory Organization**
  - `core/` - Universal components (agents, skills, rules, settings)
  - `domains/` - Domain-specific components (web, data-science, devops)
  - `mcp-servers/` - MCP server configurations
  - `templates/` - Project templates
  - `scripts/` - Integration and management scripts
  - `meta/` - Registry and metadata

#### Core Components (Universal)
- **Agents** (4 total)
  - ✅ `Bash` - Command execution specialist (migrated from v2.x)
  - ✨ `Explore` - Fast codebase exploration
  - ✨ `Plan` - Software architect for implementation planning
  - ✨ `GeneralPurpose` - Multi-purpose research and tasks

- **Skills** (5 total)
  - ✅ `git-workflow` - Git automation (migrated from v2.x)
  - ✨ `test-runner` - Automated test execution
  - ✨ `doc-generator` - Documentation generation
  - ✨ `project-setup` - Initial scaffolding
  - ✨ `refactor-helper` - Safe refactoring assistance

- **Rules** (5 total)
  - ✅ `code-style` - Formatting standards (migrated from v2.x)
  - ✨ `testing` - Test requirements and coverage
  - ✨ `documentation` - Documentation standards
  - ✨ `security` - Security best practices (OWASP Top 10)
  - ✨ `git-hygiene` - Commit and PR standards

#### Settings Profiles
- **Core Profiles**
  - `minimal.json` - Barebones (1 agent, 1 skill, 1 rule)
  - `standard.json` - Recommended (3 agents, 3 skills, 3 rules)
  - `comprehensive.json` - Full power (4 agents, 5 skills, 5 rules)
- **Profile System** - Composable settings with deep merge

#### Domain Components

**Web Domain** (`domains/web/`)
- Agents: `Frontend`, `Backend`
- Skills: `api-testing`, `ui-component-gen`, `bundle-optimizer`, `accessibility-audit`
- Rules: `web-security`, `performance`, `accessibility`
- Settings: `react.json`, `vue.json`, `node-express.json`, `next.json`

**Data Science Domain** (`domains/data-science/`)
- Agents: `DataAnalyst`, `MLEngineer`
- Skills: `jupyter-workflow`, `data-viz`, `model-training`, `experiment-tracking`
- Rules: `reproducibility`, `data-validation`, `notebook-quality`
- Settings: `pandas-numpy.json`, `pytorch.json`, `tensorflow.json`

**DevOps Domain** (`domains/devops/`)
- Agents: `Infrastructure`, `CICD`
- Skills: `container-mgmt`, `k8s-helper`, `terraform-gen`, `monitoring-setup`
- Rules: `infrastructure-as-code`, `deployment-safety`, `secrets-management`
- Settings: `docker.json`, `kubernetes.json`, `aws.json`

#### Integration Scripts
- `scripts/link.sh` - Create symlinks from submodule to project
- `scripts/sync.sh` - Pull updates and validate against overrides
- `scripts/customize.sh` - Manage local overrides
- `scripts/validate.sh` - Validate configurations and dependencies
- `scripts/merge-settings.sh` - Compose multiple settings profiles
- `scripts/migrate-from-plugin.sh` - Migrate from v2.x plugin

#### Documentation
- `INTEGRATION.md` - Comprehensive integration guide
- `CHANGELOG.md` - Version history (this file)
- `meta/migration-guide.md` - v2.x → v3.x migration guide
- `core/settings/README.md` - Settings profile documentation
- Domain-specific README files

#### Features
- **Override System** - Customize components without modifying submodule
- **Version Pinning** - Pin to stable releases or track latest
- **Profile Composition** - Combine core + domain + local profiles
- **Validation** - Automatic validation of configs and dependencies
- **Backup System** - Automatic backups before updates
- **Conflict Detection** - Detects conflicts between updates and overrides

### Changed

- **BREAKING**: Plugin architecture replaced with git submodule
- **BREAKING**: Component location moved from `.github/` to `core/`
- **BREAKING**: Installation method changed from plugin to submodule
- **BREAKING**: Settings format updated to support profiles
- Repository renamed from `claude-skills-registry` to `claude-code-best-practices`

### Migrating from v2.x

See `meta/migration-guide.md` for detailed migration instructions.

**Quick migration:**
```bash
# Automated migration (recommended)
~/.claude/plugins/claude-skills/.claude-plugin/migrate-to-submodule.sh

# Or manual migration
# 1. Backup .github/ and .claude/
# 2. Note installed components
# 3. Uninstall plugin
# 4. Add submodule
# 5. Run link script
# 6. Restore customizations to overrides/
```

### Deprecated

- v2.x plugin installation method
  - Plugin branch will receive security fixes for 6 months
  - No new features will be added to v2.x
  - Migrate to v3.0.0 as soon as possible

### Security

- Added comprehensive security rules (OWASP Top 10)
- Secrets detection in git-hygiene rule
- Dependency audit checks
- SQL injection prevention
- XSS prevention
- CSRF protection guidelines

## [2.1.0] - 2026-01-16

### Added
- Installation script with merging capabilities
- Enhanced plugin commands

### Changed
- Updated marketplace and plugin configuration

## [2.0.0] - 2026-01-15

### Added
- Initial plugin-based registry
- Bash agent
- git-workflow skill
- code-style rule
- Component installation system

### Features
- Selective component installation
- Plugin-based distribution
- Basic configuration

---

## Versioning Policy

Starting with v3.0.0, we follow Semantic Versioning:

- **MAJOR** version for breaking changes
- **MINOR** version for new features (backward compatible)
- **PATCH** version for bug fixes

### Component Versioning

Individual components are versioned independently in `meta/versions.json`:
- Components follow semantic versioning
- Breaking changes in components trigger major version bump
- New components added in minor versions

### Release Branches

- `main` - Stable releases (v3.x.x tags)
- `develop` - Active development
- `v2.x` - Legacy plugin support (security fixes only)

## Support Policy

- **Current version (v3.x)**: Full support, new features, bug fixes
- **Previous major (v2.x)**: Security fixes only for 6 months (until 2026-07-19)
- **Older versions**: No support

## Upgrade Path

- **v2.x → v3.0.0**: Use `scripts/migrate-from-plugin.sh` or see migration guide
- **v3.0.x → v3.1.x**: Run `scripts/sync.sh --apply` (backward compatible)
- **v3.x → v4.0**: Future major version (breaking changes)

---

[3.0.0]: https://github.com/Latros-io/claude-setup/releases/tag/v3.0.0
[2.1.0]: https://github.com/Latros-io/claude-setup/releases/tag/v2.1.0
[2.0.0]: https://github.com/Latros-io/claude-setup/releases/tag/v2.0.0
