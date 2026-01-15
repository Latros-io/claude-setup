# How It Works - Visual Guide

## The Big Picture

```
┌─────────────────────────────────────────────┐
│  1. You clone .claude repo to ~/           │
│     (contains the skill)                    │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  2. You copy the skill to YOUR project     │
│     YOUR-PROJECT/.github/skills/            │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  3. You run the setup script               │
│     (from YOUR project directory)           │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  4. Script asks you 4 questions            │
│     (which things do you want?)             │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  5. Script creates 2 files:                │
│     - .claude/settings.local.json           │
│     - CLAUDE.md                             │
└─────────────────────────────────────────────┘
```

## What Gets Created

### BEFORE running setup:
```
YOUR-PROJECT/
├── src/
├── package.json
└── .github/
    └── skills/
        └── claude-setup/    ← You copied this
            ├── SKILL.md
            ├── scripts/
            │   └── setup.sh
            └── assets/
```

### AFTER running setup:
```
YOUR-PROJECT/
├── src/
├── package.json
├── .github/
│   └── skills/
│       └── claude-setup/
│           ├── SKILL.md
│           ├── scripts/
│           │   └── setup.sh
│           └── assets/
├── .claude/                 ← NEW!
│   └── settings.local.json  ← Created by script
└── CLAUDE.md                ← Created by script
```

**Only 2 new files!** That's it!

## What Each Question Creates

### Question 1: MCP Servers
```
You type: 1,2

Gets added to settings.local.json:
{
  "mcpServers": {
    "filesystem": {},
    "github": {}
  }
}
```

### Question 2: Agents
```
You type: 1,2,3

Gets added to settings.local.json:
{
  "agents": [
    "Bash",
    "Explore",
    "Plan"
  ]
}
```

### Question 3: Skills
```
You type: 1,2

Gets added to settings.local.json:
{
  "skills": [
    "git-workflow",
    "test-runner"
  ]
}
```

### Question 4: Rules
```
You type: 1,2,3

Gets added to settings.local.json:
{
  "rules": [
    "code-style",
    "testing",
    "documentation"
  ]
}
```

## Step-by-Step with Locations

### Terminal Session Example

```bash
# WHERE: Anywhere
# WHAT: Clone the .claude repo
$ cd ~
$ git clone https://github.com/Latros-io/.claude
$ ls ~/.claude
# You see: .github/ README.md QUICKSTART.md etc.

# WHERE: Go to YOUR project
# WHAT: Navigate to your actual project
$ cd ~/projects/my-web-app
$ pwd
/Users/you/projects/my-web-app

# WHERE: Your project directory
# WHAT: Copy the skill folder
$ cp -r ~/.claude/.github/skills/claude-setup .github/skills/
$ ls .github/skills/claude-setup
# You see: SKILL.md scripts/ assets/

# WHERE: Your project directory
# WHAT: Run the setup
$ ./.github/skills/claude-setup/scripts/setup.sh

# The script runs and asks 4 questions:
Step 1/4: MCP Servers
Which MCP servers would you like to enable?
1) filesystem
2) github
3) postgres
4) docker

Enter numbers (comma-separated): 1,2    ← You type this

Step 2/4: Agents
Which agents would you like to enable?
1) Bash
2) Explore
3) Plan
4) general-purpose

Enter numbers (comma-separated): 1,2,3  ← You type this

Step 3/4: Skills
Which skills would you like to enable?
1) git-workflow
2) test-runner
3) cicd-helper
4) doc-generator

Enter numbers (comma-separated): 1,2    ← You type this

Step 4/4: Rules
Which rules would you like to configure?
1) code-style
2) testing
3) documentation
4) security

Enter numbers (comma-separated): 1,2,3  ← You type this

Generating configuration...
✓ Configuration created at .claude/settings.local.json
✓ Project guidance created at CLAUDE.md
✓ Setup complete!

# WHERE: Still in your project
# WHAT: Check what was created
$ ls .claude/
settings.local.json

$ ls CLAUDE.md
CLAUDE.md

$ cat .claude/settings.local.json
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
    "testing",
    "documentation"
  ]
}
```

## Common Mistakes

### ❌ Mistake 1: Running from wrong directory
```bash
# You're in the .claude repo (WRONG!)
$ pwd
/Users/you/.claude

$ ./.github/skills/claude-setup/scripts/setup.sh
# This creates files in ~/.claude/ instead of your project!
```

### ✅ Correct: Run from YOUR project
```bash
# You're in your project (RIGHT!)
$ pwd
/Users/you/projects/my-app

$ ./.github/skills/claude-setup/scripts/setup.sh
# This creates files in your project!
```

### ❌ Mistake 2: Not copying the skill first
```bash
$ cd ~/projects/my-app
$ ./.github/skills/claude-setup/scripts/setup.sh
# Error: No such file or directory
```

### ✅ Correct: Copy first, then run
```bash
$ cd ~/projects/my-app
$ cp -r ~/.claude/.github/skills/claude-setup .github/skills/
$ ./.github/skills/claude-setup/scripts/setup.sh
# Works!
```

## FAQ

**Q: Does this install MCP servers?**
A: No, it only writes their names to a JSON file.

**Q: Does this create skill folders?**
A: No, it only lists skill names in a JSON file.

**Q: What if I select option 3 for skills but don't have that skill?**
A: That's fine! The JSON just lists what you *plan* to use. You can add actual skills later.

**Q: Can I edit the files manually?**
A: Yes! Both `.claude/settings.local.json` and `CLAUDE.md` are just text files.

**Q: Can I run setup again?**
A: Yes! It will overwrite the previous configuration.

## Summary

1. **Clone** the .claude repo (one time, anywhere)
2. **Go to** YOUR project directory
3. **Copy** the skill folder to your project
4. **Run** the setup script (from YOUR project directory)
5. **Answer** 4 questions
6. **Done** - 2 files created in your project

That's it!
