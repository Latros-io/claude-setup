# .claude

Interactive 4-step configuration wizard for Claude Code projects.

> 📖 **New to this?** Read the [Visual Guide (HOWTO.md)](HOWTO.md) for a step-by-step walkthrough with diagrams!

## How It Works

This skill asks you 4 questions and then **creates 2 files**:
1. `.claude/settings.local.json` - Your Claude Code configuration
2. `CLAUDE.md` - Project guidance file

**Important**: The skill only creates configuration files. It doesn't copy, modify, or remove any other files in your project.

## Installation

### Step 1: Clone this repository

Open your terminal **anywhere** and run:

```bash
cd ~
git clone https://github.com/Latros-io/.claude
```

This creates a folder at `~/.claude/` with the skill files.

### Step 2: Copy the skill to your project

Navigate to **YOUR PROJECT** directory:

```bash
cd /path/to/YOUR-PROJECT
```

For example:
```bash
cd ~/projects/my-app
```

Then copy the skill folder:

```bash
cp -r ~/.claude/.github/skills/claude-setup .github/skills/
```

This copies only the `claude-setup` skill folder into your project at:
```
YOUR-PROJECT/.github/skills/claude-setup/
```

### Step 3: Run the setup script

**You must be in YOUR PROJECT directory** (not in the .claude repo):

```bash
# Make sure you're in your project directory
cd /path/to/YOUR-PROJECT

# Run the setup script
./.github/skills/claude-setup/scripts/setup.sh
```

### Step 4: Answer 4 questions

The script will prompt you 4 times:

```
Step 1/4: MCP Servers
Which MCP servers would you like to enable?
1) filesystem
2) github
3) postgres
4) docker

Enter numbers (comma-separated): 1,2
```

Just type numbers separated by commas (e.g., `1,2`) and press Enter.

Repeat for Steps 2, 3, and 4.

### Step 5: Done!

The script creates **only 2 files** in your project:
- `YOUR-PROJECT/.claude/settings.local.json`
- `YOUR-PROJECT/CLAUDE.md`

## What Gets Created

After answering the 4 questions, these files are created:

### `.claude/settings.local.json`
Contains your selected configuration:
```json
{
  "permissions": {
    "allow": ["WebSearch"]
  },
  "mcpServers": {
    "filesystem": {},
    "github": {}
  },
  "agents": [
    "Bash",
    "Explore",
    "Plan"
  ],
  "skills": [
    "git-workflow",
    "test-runner"
  ],
  "rules": [
    "code-style",
    "testing"
  ]
}
```

### `CLAUDE.md`
Project guidance file with your selections listed:
```markdown
# CLAUDE.md

## Configuration

### MCP Servers
- filesystem
- github

### Agents
- Bash
- Explore
- Plan

...
```

**That's it!** No other files are created, copied, or removed.

## Full Example with Explicit Paths

Let's say your project is at `/Users/john/projects/my-web-app`

```bash
# Step 1: Clone the .claude repo (do this anywhere)
cd ~
git clone https://github.com/Latros-io/.claude

# Step 2: Go to YOUR project
cd /Users/john/projects/my-web-app

# Step 3: Copy the skill to your project
cp -r ~/.claude/.github/skills/claude-setup .github/skills/

# Step 4: Verify you're in your project directory
pwd
# Output: /Users/john/projects/my-web-app

# Step 5: Run the setup
./.github/skills/claude-setup/scripts/setup.sh

# Step 6: Answer the 4 prompts
# When asked: "Enter numbers (comma-separated):"
# Type something like: 1,2

# Step 7: Check what was created
ls -la .claude/settings.local.json
ls -la CLAUDE.md
```

## The 4 Questions Explained

### Question 1: MCP Servers
```
Which MCP servers would you like to enable?
1) filesystem
2) github
3) postgres
4) docker

Enter numbers (comma-separated):
```
**Type**: `1,2` (or any combination) then press Enter

**What it does**: Adds those servers to your `.claude/settings.local.json` file

---

### Question 2: Agents
```
Which agents would you like to enable?
1) Bash
2) Explore
3) Plan
4) general-purpose

Enter numbers (comma-separated):
```
**Type**: `1,2,3` (or any combination) then press Enter

**What it does**: Adds those agents to your configuration file

---

### Question 3: Skills
```
Which skills would you like to enable?
1) git-workflow
2) test-runner
3) cicd-helper
4) doc-generator

Enter numbers (comma-separated):
```
**Type**: `1,2` (or any combination) then press Enter

**What it does**: Lists those skills in your configuration file

**Note**: This doesn't create skill folders - it just tells Claude which skills you plan to use.

---

### Question 4: Rules
```
Which rules would you like to configure?
1) code-style
2) testing
3) documentation
4) security

Enter numbers (comma-separated):
```
**Type**: `1,2,3` (or any combination) then press Enter

**What it does**: Lists those rules in your configuration file

## Common Confusion Clarified

❌ **WRONG**: "The skill copies all skills/agents/servers and removes what I don't select"

✅ **CORRECT**: "The skill creates a JSON config file with only what I selected"

The skill **only creates 2 text files** with your selections. It doesn't copy, install, or remove anything else.

## Example Configurations

### Minimal Setup
```
MCP: 1 (filesystem)
Agents: 1,2 (Bash, Explore)
Skills: 1 (git-workflow)
Rules: (press Enter to skip)
```

### Full-Stack Web App
```
MCP: 1,2,3 (filesystem, github, postgres)
Agents: 1,2,3,4 (all)
Skills: 1,2,3,4 (all)
Rules: 1,2,3,4 (all)
```

### Data Science Project
```
MCP: 1,3 (filesystem, postgres)
Agents: 1,2,4 (Bash, Explore, general-purpose)
Skills: 2,4 (test-runner, doc-generator)
Rules: 2,3 (testing, documentation)
```

## Using with Claude Code

After setup, when you use Claude Code in your project, it will read:
- `.claude/settings.local.json` - To know your preferences
- `CLAUDE.md` - To understand your project

You can manually edit these files anytime!

## Re-running Setup

To change your configuration, just run the script again:

```bash
# Make sure you're in your project directory
cd /path/to/YOUR-PROJECT

# Run setup again
./.github/skills/claude-setup/scripts/setup.sh
```

It will overwrite the previous configuration files.

## Directory Structure After Setup

```
YOUR-PROJECT/
├── .github/
│   └── skills/
│       └── claude-setup/        # The skill (copied from .claude repo)
│           ├── SKILL.md
│           ├── scripts/
│           │   └── setup.sh
│           └── assets/
├── .claude/
│   └── settings.local.json      # ← Created by setup script
├── CLAUDE.md                    # ← Created by setup script
└── [your other project files]
```

## Troubleshooting

### "No such file or directory"

**Problem**: You're not in your project directory

**Solution**:
```bash
cd /path/to/YOUR-PROJECT
pwd  # Verify you're in the right place
```

### "Permission denied"

**Problem**: Script not executable

**Solution**:
```bash
chmod +x .github/skills/claude-setup/scripts/setup.sh
```

### "Command not found: ./.github/..."

**Problem**: You're in the wrong directory

**Solution**: Make sure you're in YOUR PROJECT directory, not the .claude repo:
```bash
# Wrong (you're in the .claude repo)
pwd
# /Users/john/.claude

# Right (you're in your project)
pwd
# /Users/john/projects/my-web-app
```

## Documentation

- [QUICKSTART.md](QUICKSTART.md) - Quick reference
- [Usage Guide](.github/skills/claude-setup/references/usage.md) - Detailed usage
- [SKILL Definition](.github/skills/claude-setup/SKILL.md) - Skill metadata

## Requirements

- Bash 4.0 or higher
- Unix-like OS (macOS, Linux, WSL)

## Version

1.0.0 - POC Release

## License

MIT

## Support

- [GitHub Issues](https://github.com/Latros-io/.claude/issues)
- [Documentation](.github/skills/claude-setup/)
