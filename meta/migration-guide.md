# Migration Guide: v2.x Plugin → v3.x Git Submodule

**Last Updated:** 2026-01-19

This guide helps you migrate from the v2.x plugin-based installation to the v3.x git submodule architecture.

---

## Table of Contents

- [Why Migrate?](#why-migrate)
- [What's Changed](#whats-changed)
- [Migration Methods](#migration-methods)
  - [Automated Migration (Recommended)](#automated-migration-recommended)
  - [Manual Migration](#manual-migration)
- [Post-Migration Steps](#post-migration-steps)
- [Troubleshooting](#troubleshooting)
- [Rollback Instructions](#rollback-instructions)

---

## Why Migrate?

### v3.0 Benefits

1. **Standard Git Workflow**
   - Familiar git commands (clone, pull, branch)
   - Version pinning with git tags
   - Easy updates with `git pull`

2. **Better Customization**
   - Clean override system (no submodule modifications)
   - Updates don't conflict with customizations
   - Clear separation: upstream vs local

3. **More Components**
   - 4 agents (vs 1 in v2.x)
   - 5 skills (vs 1 in v2.x)
   - 5 rules (vs 1 in v2.x)
   - Domain-specific components (web, data-science, devops)

4. **Enhanced Features**
   - Settings profiles (minimal, standard, comprehensive)
   - MCP server configurations
   - Integration scripts (link, sync, customize)
   - Comprehensive metadata and dependency tracking

5. **Long-Term Support**
   - v2.x receives security fixes only (until 2026-07-19)
   - All new features will be v3.x only

---

## What's Changed

### Architecture

| Aspect | v2.x Plugin | v3.x Submodule |
|--------|-------------|----------------|
| **Distribution** | Plugin system | Git submodule |
| **Location** | `~/.claude/plugins/` | `.claude/best-practices/` |
| **Installation** | `claude plugin install` | `git submodule add` |
| **Updates** | Plugin update command | `git pull` or `scripts/sync.sh` |
| **Components** | `.github/agents/`, `.github/skills/` | `core/`, `domains/` |
| **Customization** | Direct file edits | `.github/overrides/` |

### Component Organization

**v2.x Structure:**
```
.github/
├── agents/
│   └── Bash/
├── skills/
│   └── git-workflow/
└── rules/
    └── code-style/
```

**v3.x Structure:**
```
.claude/best-practices/          # Submodule
├── core/
│   ├── agents/                  # 4 agents
│   ├── skills/                  # 5 skills
│   ├── rules/                   # 5 rules
│   └── settings/                # 3 profiles
├── domains/
│   ├── web/
│   ├── data-science/
│   └── devops/
└── scripts/                     # Integration tools

.github/                         # Your project (symlinks)
├── agents/
│   ├── Bash -> ../.claude/best-practices/core/agents/Bash
│   └── ...
└── overrides/                   # Your customizations
```

### Breaking Changes

1. **Installation Method**
   - Old: `claude plugin install claude-skills`
   - New: `git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices`

2. **Component Paths**
   - Components moved from root to `core/` directory
   - Domain-specific components in `domains/`

3. **Customization Approach**
   - Don't edit submodule files directly
   - Use `.github/overrides/` instead

4. **Settings Format**
   - New profile-based settings system
   - Settings compose with deep merge

---

## Migration Methods

### Automated Migration (Recommended)

The automated script handles everything for you.

#### Prerequisites

- Git repository (your project must be in git)
- Bash 4.0+
- Python 3.6+ (for settings merging)

#### Steps

1. **Navigate to your project:**
   ```bash
   cd your-project
   ```

2. **Download migration script:**
   ```bash
   # If you already have the submodule
   .claude/best-practices/scripts/migrate-from-plugin.sh

   # Or download standalone
   curl -O https://raw.githubusercontent.com/Latros-io/claude-code-best-practices/main/scripts/migrate-from-plugin.sh
   chmod +x migrate-from-plugin.sh
   ./migrate-from-plugin.sh
   ```

3. **Follow interactive prompts:**
   - Script detects installed components
   - Suggests appropriate profile
   - Backs up existing configuration
   - Extracts customizations
   - Links new components

4. **Review migration report:**
   ```bash
   cat ~/.claude/migration-backups/[timestamp]/migration-report.txt
   ```

#### What the Script Does

1. ✅ Backs up `.github/` and `.claude/`
2. ✅ Detects installed v2.x components
3. ✅ Extracts customizations (configs, templates)
4. ✅ Removes old components
5. ✅ Adds v3.x submodule
6. ✅ Links components with selected profile
7. ✅ Restores customizations to `.github/overrides/`
8. ✅ Generates detailed migration report

---

### Manual Migration

For advanced users or special cases.

#### Step 1: Backup

```bash
# Create backup directory
mkdir -p ~/claude-migration-backup-$(date +%Y%m%d)
cd ~/claude-migration-backup-$(date +%Y%m%d)

# Backup current configuration
cp -r /path/to/your-project/.github ./github-backup
cp -r /path/to/your-project/.claude ./claude-backup

# List installed components
ls -la /path/to/your-project/.github/agents/
ls -la /path/to/your-project/.github/skills/
ls -la /path/to/your-project/.github/rules/
```

#### Step 2: Extract Customizations

```bash
cd /path/to/your-project

# Create customizations directory
mkdir -p .github/overrides

# Copy any modified configs
# (If you edited config.json files or templates)
cp .github/agents/Bash/config.json .github/overrides/agents/Bash/ 2>/dev/null || true
cp .github/skills/git-workflow/config.json .github/overrides/skills/git-workflow/ 2>/dev/null || true
# ... repeat for any customized components
```

#### Step 3: Remove v2.x Components

```bash
cd /path/to/your-project

# Remove old components
rm -rf .github/agents
rm -rf .github/skills
rm -rf .github/rules
```

#### Step 4: Add v3.x Submodule

```bash
cd /path/to/your-project

# Add submodule
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices

# Initialize and update
git submodule update --init --recursive
```

#### Step 5: Link Components

Choose appropriate profile:

```bash
# Core only
.claude/best-practices/scripts/link.sh --profile=core

# Or domain-specific
.claude/best-practices/scripts/link.sh --profile=web-frontend
.claude/best-practices/scripts/link.sh --profile=data-science
.claude/best-practices/scripts/link.sh --profile=devops
```

#### Step 6: Apply Settings

```bash
# Copy base profile
cp .claude/best-practices/core/settings/standard.json .claude/settings.json

# Or compose with domain profile
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

#### Step 7: Restore Customizations

```bash
# Move extracted customizations to overrides
# (Already done in Step 2)

# Validate overrides
.claude/best-practices/scripts/customize.sh validate
```

#### Step 8: Commit

```bash
# Add all changes
git add .claude .github

# Commit migration
git commit -m "Migrate to Claude Code best practices v3.0.0"
```

---

## Post-Migration Steps

### 1. Verify Installation

```bash
# Check submodule status
git submodule status

# Expected output:
# [commit-hash] .claude/best-practices (v3.0.0)

# Verify symlinks
ls -la .github/agents/
ls -la .github/skills/
ls -la .github/rules/
```

### 2. Test Components

```bash
# Try a simple command
claude "List all files in src/"

# Test git workflow skill
claude "Create a commit for these changes"

# Test explore agent
claude "Where is the authentication logic?"
```

### 3. Review Customizations

```bash
# List your overrides
.claude/best-practices/scripts/customize.sh list-overrides

# Validate them
.claude/best-practices/scripts/customize.sh validate

# Document them
.claude/best-practices/scripts/customize.sh document
```

### 4. Update Team Documentation

Update your project's README or documentation with:
- New installation instructions for team members
- Link to INTEGRATION.md
- Any project-specific customizations

Example:
```markdown
## Claude Code Setup

This project uses Claude Code best practices v3.0.

**For new team members:**
1. Clone the repository
2. Initialize submodules: `git submodule update --init --recursive`
3. Symlinks are already set up via git

**For existing team members:**
See [migration guide](.claude/best-practices/meta/migration-guide.md)
```

### 5. Configure CI/CD

Update CI/CD to initialize submodules:

**.github/workflows/ci.yml:**
```yaml
- name: Checkout code
  uses: actions/checkout@v3
  with:
    submodules: recursive
```

**GitLab CI:**
```yaml
variables:
  GIT_SUBMODULE_STRATEGY: recursive
```

---

## Troubleshooting

### Issue: Submodule Not Initialized

**Symptom:** `.claude/best-practices` directory is empty

**Solution:**
```bash
git submodule update --init --recursive
```

---

### Issue: Symlinks Not Working (Windows)

**Symptom:** Components not found, symlinks appear as files

**Solution:** Use copy mode instead
```bash
.claude/best-practices/scripts/link.sh --profile=core --copy
```

**Note:** Re-run after submodule updates

---

### Issue: Customizations Lost

**Symptom:** Your configs reverted to defaults

**Solution:** Check backup and restore overrides
```bash
# Check backup
ls ~/claude-migration-backup-*/github-backup/

# Restore specific customization
cp ~/claude-migration-backup-*/github-backup/agents/Bash/config.json \
   .github/overrides/agents/Bash/config.json
```

---

### Issue: Components Not Detected

**Symptom:** Claude Code doesn't see agents/skills/rules

**Solution:** Verify structure
```bash
# Check symlinks
ls -la .github/agents/

# Should show symlinks like:
# Bash -> ../../.claude/best-practices/core/agents/Bash

# If missing, re-run link script
.claude/best-practices/scripts/link.sh --profile=core
```

---

### Issue: Settings Not Applied

**Symptom:** Settings don't take effect

**Solution:** Validate settings file
```bash
# Check settings location
ls -la .claude/settings.json

# Validate JSON
python3 -m json.tool .claude/settings.json

# Restart Claude Code
```

---

### Issue: Merge Conflicts on Update

**Symptom:** Conflicts when pulling submodule updates

**Solution:**
```bash
cd .claude/best-practices

# Check status
git status

# If you accidentally made changes:
git stash  # Save changes
git pull   # Update
git stash pop  # Re-apply (resolve conflicts)

# Or discard local changes:
git reset --hard origin/main
```

---

### Issue: Old Plugin Still Active

**Symptom:** v2.x components still loaded

**Solution:** Remove plugin completely
```bash
# Uninstall plugin
claude plugin uninstall claude-skills-registry

# Verify removal
claude plugin list

# Remove plugin directory
rm -rf ~/.claude/plugins/claude-skills-registry
```

---

## Rollback Instructions

If migration fails or you need to rollback:

### Quick Rollback

```bash
# 1. Remove submodule
git submodule deinit .claude/best-practices
git rm .claude/best-practices
rm -rf .git/modules/.claude/best-practices

# 2. Restore backup
cp -r ~/claude-migration-backup-*/github-backup/* .github/
cp -r ~/claude-migration-backup-*/claude-backup/* .claude/

# 3. Reinstall v2.x plugin
claude plugin install claude-skills-registry

# 4. Revert git commit
git reset --hard HEAD~1
```

### Verify Rollback

```bash
# Check v2.x structure
ls -la .github/agents/Bash
ls -la .github/skills/git-workflow

# Test components
claude "Check git status"
```

---

## Comparison: Before & After

### Installation

**v2.x:**
```bash
claude plugin install claude-skills-registry
claude plugin install component Bash
claude plugin install component git-workflow
```

**v3.x:**
```bash
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
.claude/best-practices/scripts/link.sh --profile=core
```

### Updates

**v2.x:**
```bash
claude plugin update claude-skills-registry
claude plugin update component Bash
```

**v3.x:**
```bash
.claude/best-practices/scripts/sync.sh --apply
```

### Customization

**v2.x:**
```bash
# Edit directly (risky)
vim .github/agents/Bash/config.json
```

**v3.x:**
```bash
# Create override (safe)
.claude/best-practices/scripts/customize.sh create-override \
    --component=core/agents/Bash \
    --file=config.json

vim .github/overrides/agents/Bash/config.json
```

---

## Next Steps

After successful migration:

1. ✅ Read [INTEGRATION.md](../INTEGRATION.md) for advanced usage
2. ✅ Explore [settings profiles](../core/settings/README.md)
3. ✅ Check out [domain components](../domains/)
4. ✅ Join community discussions
5. ✅ Share feedback and report issues

---

## Support

**Issues:** https://github.com/Latros-io/claude-code-best-practices/issues
**Discussions:** https://github.com/Latros-io/claude-code-best-practices/discussions
**Email:** support@latros.io

---

**Migration Checklist**

- [ ] Backup current configuration
- [ ] Run migration script (or manual steps)
- [ ] Verify submodule installation
- [ ] Test components
- [ ] Review and restore customizations
- [ ] Apply settings profile
- [ ] Update team documentation
- [ ] Configure CI/CD
- [ ] Commit migration
- [ ] Celebrate! 🎉
