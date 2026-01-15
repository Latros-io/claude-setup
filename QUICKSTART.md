# Quick Start Guide

## What This Does

Creates **2 configuration files** in your project:
- `.claude/settings.local.json`
- `CLAUDE.md`

**No files are removed or modified** - only these 2 are created!

---

## Installation (5 Steps)

### Step 1: Clone (anywhere)

```bash
cd ~
git clone https://github.com/Latros-io/.claude
```

### Step 2: Go to YOUR project

```bash
cd /path/to/YOUR-PROJECT
```

Example:
```bash
cd ~/projects/my-app
```

### Step 3: Copy the skill

```bash
cp -r ~/.claude/.github/skills/claude-setup .github/skills/
```

### Step 4: Run setup (from YOUR project)

```bash
# Make sure you're in YOUR project directory!
pwd

# Run the setup
./.github/skills/claude-setup/scripts/setup.sh
```

### Step 5: Answer 4 questions

```
Question 1: MCP Servers? → Type: 1,2
Question 2: Agents? → Type: 1,2,3
Question 3: Skills? → Type: 1,2
Question 4: Rules? → Type: 1,2,3
```

**Done!** ✓ Files created:
- `.claude/settings.local.json`
- `CLAUDE.md`

---

## Full Example

Let's say your project is `/Users/sarah/code/my-app`:

```bash
# Step 1: Clone .claude repo
cd ~
git clone https://github.com/Latros-io/.claude

# Step 2: Go to YOUR project
cd /Users/sarah/code/my-app

# Step 3: Copy skill
cp -r ~/.claude/.github/skills/claude-setup .github/skills/

# Step 4: Check you're in the right place
pwd
# Should show: /Users/sarah/code/my-app

# Step 5: Run setup
./.github/skills/claude-setup/scripts/setup.sh

# Step 6: Answer prompts
# Type: 1,2 (then Enter)
# Type: 1,2,3 (then Enter)
# Type: 1,2 (then Enter)
# Type: 1,2,3 (then Enter)

# Step 7: Verify
ls -la .claude/settings.local.json
ls -la CLAUDE.md
```

---

## What Each Question Does

### Q1: MCP Servers → Adds to JSON
```
1) filesystem → "filesystem": {}
2) github → "github": {}
3) postgres → "postgres": {}
4) docker → "docker": {}
```

### Q2: Agents → Adds to JSON
```
1) Bash → "Bash"
2) Explore → "Explore"
3) Plan → "Plan"
4) general-purpose → "general-purpose"
```

### Q3: Skills → Adds to JSON
```
1) git-workflow → "git-workflow"
2) test-runner → "test-runner"
3) cicd-helper → "cicd-helper"
4) doc-generator → "doc-generator"
```

### Q4: Rules → Adds to JSON
```
1) code-style → "code-style"
2) testing → "testing"
3) documentation → "documentation"
4) security → "security"
```

---

## Quick Configs

**Minimal**
```
Q1: 1
Q2: 1,2
Q3: 1
Q4: (press Enter to skip)
```

**Full Stack**
```
Q1: 1,2,3
Q2: 1,2,3,4
Q3: 1,2,3,4
Q4: 1,2,3,4
```

**Data Science**
```
Q1: 1,3
Q2: 1,2,4
Q3: 2,4
Q4: 2,3
```

---

## Troubleshooting

**Error: "No such file or directory"**
→ You're not in YOUR project directory
```bash
cd /path/to/YOUR-PROJECT
pwd  # Check you're in the right place
```

**Error: "Permission denied"**
→ Make script executable
```bash
chmod +x .github/skills/claude-setup/scripts/setup.sh
```

**Wrong directory?**
```bash
# ❌ Wrong (in .claude repo)
pwd → /Users/you/.claude

# ✅ Right (in your project)
pwd → /Users/you/projects/my-app
```

---

## What's Created

```
YOUR-PROJECT/
├── .github/skills/claude-setup/  # Skill (copied)
├── .claude/
│   └── settings.local.json       # ← NEW (created by setup)
└── CLAUDE.md                     # ← NEW (created by setup)
```

---

## Need More Help?

See [README.md](README.md) for detailed documentation.
