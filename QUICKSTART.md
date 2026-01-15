# Quick Start

## Install

### Step 1: Clone

```bash
git clone https://github.com/Latros-io/.claude
```

### Step 2: Copy to your project

```bash
cp -r .claude/.github/skills/claude-setup /your/project/.github/skills/
```

### Step 3: Run setup

```bash
cd /your/project
./.github/skills/claude-setup/scripts/setup.sh
```

### Step 4: Answer 4 questions

1. MCP Servers? (e.g., `1,2`)
2. Agents? (e.g., `1,2,3`)
3. Skills? (e.g., `1,2`)
4. Rules? (e.g., `1,2,3`)

**Done!** ✓ Configuration ready immediately.

---

## Example Configurations

**Minimal**
```
MCP: 1
Agents: 1,2
Skills: 1
Rules: (skip)
```

**Full Stack**
```
MCP: 1,2,3
Agents: 1,2,3,4
Skills: 1,2,3,4
Rules: 1,2,3,4
```

**Data Science**
```
MCP: 1,3
Agents: 1,2,4
Skills: 2,4
Rules: 2,3
```

---

## What You Get

- `.claude/settings.local.json` - Configuration
- `CLAUDE.md` - Project guidance

---

## Need Help?

See [README.md](README.md) for full documentation.
