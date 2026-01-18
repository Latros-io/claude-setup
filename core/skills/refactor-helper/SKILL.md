---
name: refactor-helper
description: Safe refactoring assistance with automated validation
version: 1.0.0
author: Latros.io
category: refactoring
tags: [refactoring, code-quality, automation]
---

# Refactor Helper Skill

Provides safe refactoring assistance with operations like renaming symbols, extracting functions, moving files with automatic import updates, and validation through tests.

## When to Use This Skill

Invoke this skill when:
- User asks to rename variables, functions, or classes
- User wants to extract functions or methods
- User requests moving files or modules
- User mentions refactoring code
- User wants to inline functions or variables
- User asks to extract interfaces or types
- Code needs restructuring

## Invocation

Claude should automatically use this skill when refactoring operations are requested. The skill provides:
- Symbol renaming with reference updates
- Function and variable extraction
- File moving with import updates
- Inline operations
- Interface/type extraction
- Safety validation through tests
- Automatic rollback on failures

## Dependencies

### Required
- **Agent**: `Bash` - For file operations
- **Agent**: `Explore` - For code analysis
- **Skill**: `test-runner` - For validation after refactoring

### Optional
- **MCP Server**: `github` - For PR creation with refactoring changes
- **Skill**: `git-workflow` - For committing refactoring changes
- **Rule**: `code-style` - For style validation

## Configuration

Default settings (customizable in `.claude/skills/refactor-helper.config.json`):

- `auto_run_tests`: true - Run tests after refactoring
- `create_backup`: true - Create backup before changes
- `validate_before_commit`: true - Validate changes before commit
- `auto_rollback_on_failure`: true - Rollback if tests fail
- `update_imports`: true - Update import statements
- `preserve_git_history`: true - Use git mv for moves

## Supported Refactoring Operations

### Rename Symbol
Renames variables, functions, classes, or modules throughout codebase
- Updates all references
- Updates imports/exports
- Preserves comments
- Case-sensitive matching

### Extract Function
Extracts code block into a new function
- Automatically determines parameters
- Infers return type
- Preserves variable scope
- Adds documentation

### Extract Variable
Extracts expression into a named variable
- Suggests meaningful names
- Uses const by default
- Maintains type information
- Preserves scope

### Move File
Moves files/modules to new location
- Updates all imports
- Updates re-exports
- Preserves git history with git mv
- Updates module paths

### Inline Function
Replaces function calls with function body
- Removes unused function
- Preserves behavior
- Optimizes simple cases
- Validates correctness

### Extract Interface/Type
Extracts interface or type definition
- Analyzes usage patterns
- Creates comprehensive type
- Updates references
- Exports appropriately

## Usage Examples

### Example 1: Rename Function

**User**: "Rename the `getUserData` function to `fetchUserProfile`"

**Claude**:
1. Searches for all occurrences of `getUserData`
2. Shows impact analysis (files affected, references count)
3. Creates backup
4. Renames function definition
5. Updates all function calls
6. Updates imports/exports
7. Runs tests to validate
8. Reports success with summary

### Example 2: Extract Function

**User**: "Extract this validation logic into a separate function"

**Claude**:
1. Analyzes selected code block
2. Identifies variables used (parameters)
3. Determines return type
4. Suggests function name (e.g., `validateUserInput`)
5. Creates new function with documentation
6. Replaces original code with function call
7. Runs tests
8. Shows before/after comparison

### Example 3: Move File

**User**: "Move `auth.ts` to the `services/` directory"

**Claude**:
1. Analyzes `auth.ts` dependencies
2. Shows affected files (imports, re-exports)
3. Creates backup
4. Executes `git mv` to preserve history
5. Updates all import statements
6. Updates index files
7. Runs tests
8. Reports files updated

### Example 4: Refactor with Rollback

**User**: "Rename `processData` to `transformData`"

**Claude**:
1. Creates backup
2. Performs rename operation
3. Updates all references
4. Runs tests
5. Tests fail due to conflict
6. Automatically rolls back changes
7. Reports failure reason
8. Suggests investigation steps

## Refactoring Workflow

1. **Analysis Phase**
   - Parse code structure
   - Identify all references
   - Analyze dependencies
   - Estimate complexity
   - Show impact preview

2. **Planning Phase**
   - Determine operations needed
   - Plan execution order
   - Identify potential issues
   - Calculate risk level

3. **Backup Phase**
   - Create backup copy
   - Store current state
   - Enable rollback capability

4. **Execution Phase**
   - Apply refactoring changes
   - Update all references
   - Fix imports/exports
   - Maintain formatting
   - Preserve comments

5. **Validation Phase**
   - Check for syntax errors
   - Run linters
   - Execute tests
   - Verify functionality
   - Check type errors

6. **Completion Phase**
   - Report changes made
   - Show affected files
   - Display test results
   - Clean up backups (on success)
   - Commit changes (if requested)

## Safety Features

### Pre-Refactoring Checks
- Syntax validation
- Type checking
- Lint checking
- Dependency analysis

### During Refactoring
- Atomic operations
- Backup creation
- Progress tracking
- Error detection

### Post-Refactoring
- Test execution
- Coverage validation
- Import verification
- Reference checking

### Rollback Mechanism
- Automatic on test failures
- Manual rollback option
- Keeps multiple backups
- Preserves original state

## Integration with Other Components

### With test-runner Skill
- Runs tests after each refactoring
- Validates changes don't break functionality
- Provides confidence in refactoring
- Enables safe large-scale changes

### With git-workflow Skill
- Creates commits for refactorings
- Uses conventional commit messages
- Creates PRs for review
- Tags refactoring commits

### With code-style Rule
- Maintains code style consistency
- Auto-formats after refactoring
- Fixes import organization
- Ensures quality standards

### With Explore Agent
- Analyzes code structure
- Identifies dependencies
- Maps references
- Suggests refactoring opportunities

## Best Practices

1. **Test First**: Ensure tests exist before refactoring
2. **Small Steps**: Make incremental changes, not massive rewrites
3. **Validate Often**: Run tests after each operation
4. **Preserve Behavior**: Don't change functionality while refactoring
5. **Update Documentation**: Keep docs in sync with code
6. **Review Changes**: Check diffs before committing
7. **Use Version Control**: Always have a clean git state

## Error Handling

Common errors and resolutions:

**Tests Failed After Refactoring**:
- Automatically rolls back changes
- Shows failing test output
- Suggests investigating failures
- Offers manual retry

**Import Resolution Failed**:
- Reports unresolved imports
- Suggests manual fixes
- Shows affected files
- Preserves original if uncertain

**Circular Dependency Detected**:
- Warns about circular dependency
- Suggests restructuring
- Aborts operation
- Maintains original structure

**Symbol Not Found**:
- Reports missing symbol
- Suggests similar names
- Checks for typos
- Verifies scope

**Merge Conflicts**:
- Detects conflicts with other changes
- Suggests stashing or committing first
- Aborts refactoring
- Preserves working state

## Advanced Features

### Batch Refactoring
- Apply same refactoring to multiple symbols
- Rename patterns (e.g., all getters)
- Bulk file moves
- Consistent transformations

### Smart Suggestions
- Suggests refactoring opportunities
- Identifies code smells
- Recommends improvements
- Provides complexity metrics

### Impact Analysis
- Shows affected files count
- Estimates time required
- Calculates risk level
- Lists dependencies

### Preview Mode
- Dry-run refactoring
- Show changes without applying
- Review impact before execution
- Cancel if unexpected

## Version History

- **1.0.0**: Initial release with symbol renaming, function extraction, file moving, and automated validation
