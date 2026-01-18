# Bash Agent Usage Examples

## Example 1: Simple File Listing

**User**: "List all JavaScript files"

**Agent**:
```bash
find . -name "*.js" -type f
```

**Output**:
```
./src/index.js
./src/utils.js
./tests/index.test.js
```

---

## Example 2: Git Status Check

**User**: "What's the git status?"

**Agent**:
```bash
git status
```

**Output**:
```
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  modified:   src/index.js

no changes added to commit
```

---

## Example 3: Running Tests

**User**: "Run the tests"

**Agent**:
```bash
npm test
```

**Output**:
```
> project@1.0.0 test
> jest

PASS tests/index.test.js
  ✓ should work (3 ms)

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
```

---

## Example 4: File Search with Content

**User**: "Find files containing 'API_KEY'"

**Agent**:
```bash
grep -r "API_KEY" . --exclude-dir=node_modules --exclude-dir=.git
```

**Output**:
```
./src/config.js:const API_KEY = process.env.API_KEY;
./.env.example:API_KEY=your_key_here
```

---

## Example 5: Destructive Operation (with confirmation)

**User**: "Delete the old logs directory"

**Agent**:
```
⚠ Warning: This command will delete the directory and all its contents

Command: rm -rf ./logs

Affected files/resources:
- ./logs/ (directory)
- All files within ./logs/

This action cannot be undone.

Continue? [y/N]:
```

**User**: "y"

**Agent**:
```bash
rm -rf ./logs
```

**Output**:
```
✓ Directory deleted successfully
```

---

## Example 6: Error Handling

**User**: "Cat the config file"

**Agent**:
```bash
cat config.json
```

**Output**:
```
✗ Command failed
Error: cat: config.json: No such file or directory
Exit code: 1

Suggestion: File 'config.json' does not exist.
Did you mean one of these?
- config.example.json
- src/config.js

Or create it with: touch config.json
```

---

## Example 7: Building Project

**User**: "Build the project"

**Agent**:
```bash
npm run build
```

**Output**:
```
> project@1.0.0 build
> webpack --mode production

asset main.js 2.5 KiB [emitted] [minimized] (name: main)
webpack 5.75.0 compiled successfully in 543 ms

✓ Build completed successfully
```

---

## Example 8: Environment Check

**User**: "What Node version am I using?"

**Agent**:
```bash
node --version
```

**Output**:
```
v18.17.0
```

---

## Example 9: Disk Usage

**User**: "How much disk space is this project using?"

**Agent**:
```bash
du -sh .
```

**Output**:
```
245M    .

✓ Project size: 245 MB
```

---

## Example 10: Process Management

**User**: "Is the server running?"

**Agent**:
```bash
ps aux | grep "[n]ode.*server.js"
```

**Output**:
```
user     12345  0.5  1.2  1234567  98765 ?  Ssl  10:30  0:05 node server.js

✓ Server is running (PID: 12345)
```

---

## Example 11: Complex Pipe Chain

**User**: "Show me the top 5 largest JavaScript files"

**Agent**:
```bash
find . -name "*.js" -type f -exec du -h {} + | sort -rh | head -5
```

**Output**:
```
1.2M    ./dist/bundle.js
456K    ./src/main.js
234K    ./src/utils.js
123K    ./tests/integration.test.js
89K     ./src/api.js

✓ Top 5 largest JavaScript files shown above
```

---

## Example 12: Command with Sudo (requires permission)

**User**: "Install nginx"

**Agent**:
```
⚠ This command requires elevated privileges (sudo)

Command: sudo apt-get install nginx

Why sudo is needed:
- Installing system packages requires root access
- Will install files to /usr/bin/ and /etc/

Alternative:
- Use Docker: docker run nginx
- Use local package manager for user-level install

Proceed with sudo? [y/N]:
```

---

## Example 13: Script Creation

**User**: "Create a script to backup the database"

**Agent**:
```bash
cat > backup.sh << 'EOF'
#!/bin/bash
set -e

DB_NAME="mydb"
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "Starting backup of $DB_NAME..."
pg_dump "$DB_NAME" > "$BACKUP_DIR/${DB_NAME}_${DATE}.sql"

echo "✓ Backup completed: $BACKUP_DIR/${DB_NAME}_${DATE}.sql"
EOF

chmod +x backup.sh
```

**Output**:
```
✓ Script created: backup.sh
✓ Made executable

To run: ./backup.sh
```

---

## Example 14: Multi-Command Sequence

**User**: "Clean the build, install dependencies, and build"

**Agent**:
```bash
rm -rf dist && npm install && npm run build
```

**Output**:
```
✓ Cleaned dist directory

up to date, audited 234 packages in 2s
✓ Dependencies installed

> project@1.0.0 build
> webpack --mode production

✓ Build completed successfully
```

---

## Example 15: Error with Retry Suggestion

**User**: "Push to git"

**Agent**:
```bash
git push
```

**Output**:
```
✗ Command failed
Error: fatal: The current branch has no upstream branch.
Exit code: 128

Suggestion: Set upstream branch with:
git push --set-upstream origin main

Would you like me to run this command? [y/N]:
```
