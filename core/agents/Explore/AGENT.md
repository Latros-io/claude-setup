# Explore Agent

**Version:** 1.0.0
**Category:** Core
**Type:** Agent

## Overview

The Explore agent is a fast, specialized agent for exploring codebases efficiently. It excels at finding files by patterns, searching for keywords across the codebase, and answering structural questions about code organization.

## Purpose

When working with unfamiliar codebases or trying to understand how systems are organized, the Explore agent provides quick, targeted analysis without the overhead of full codebase indexing. It's optimized for discovery and understanding rather than modification.

## Key Capabilities

- **Pattern-Based File Discovery**: Find files using glob patterns
- **Keyword Search**: Search across the codebase for specific terms, functions, or patterns
- **Structural Analysis**: Understand directory organization and architectural patterns
- **Contextual Understanding**: Answer questions about code organization and relationships
- **Thoroughness Control**: Adjust depth of exploration based on needs

## When to Use

Use the Explore agent when you need to:

- Find files by pattern (e.g., `src/components/**/*.tsx`)
- Search for keywords or patterns across the codebase
- Understand how a feature is implemented across multiple files
- Locate specific functions, classes, or modules
- Answer questions about codebase structure
- Discover related files or components

## When NOT to Use

Don't use the Explore agent when:

- You know the exact file path (use Read tool directly)
- Searching within 2-3 specific files (use Read tool)
- Looking for a specific class definition (use Glob tool directly)
- You need to modify code (use general-purpose agent or plan mode)
- Performing deep architectural analysis (use Plan agent)

## Configuration

### Thoroughness Levels

**Quick** (`--thoroughness=quick`)
- Max 10 files read
- Max depth: 3 levels
- Good for: Finding specific files or obvious patterns

**Medium** (`--thoroughness=medium`) - Default
- Max 30 files read
- Max depth: 5 levels
- Good for: Understanding component structure, moderate exploration

**Thorough** (`--thoroughness=thorough`)
- Max 100 files read
- No depth limit
- Good for: Comprehensive analysis, multiple naming conventions

### Ignored Patterns

By default, the Explore agent ignores:
- `node_modules/`
- `dist/`, `build/`
- `.git/`
- `coverage/`
- Minified files (`*.min.js`)
- Source maps (`*.map`)

## Usage Examples

### Example 1: Find Error Handling

**Query:** "Where are errors from the client handled?"

**Approach:**
```
1. Search for "error" and "handle" keywords
2. Look for try-catch blocks in client-related files
3. Examine error handling middleware
4. Report findings with file locations
```

### Example 2: Locate React Components

**Query:** "Find all React components that use the useState hook"

**Approach:**
```
1. Glob for *.tsx and *.jsx files
2. Grep for "useState" in those files
3. Read relevant files to confirm usage
4. List components with line numbers
```

### Example 3: Understand Structure

**Query:** "What is the codebase structure?"

**Approach:**
```
1. Examine top-level directories
2. Read package.json, tsconfig.json
3. Identify main entry points
4. Map out key modules and their purposes
```

## Integration with Other Agents

- **Plan Agent**: Explore provides context for planning implementations
- **General Purpose**: Explore handles focused searches, GP handles complex multi-step tasks
- **Bash Agent**: Explore finds files, Bash executes commands on them

## Best Practices

1. **Start Broad**: Begin with quick thoroughness, increase if needed
2. **Be Specific**: Provide clear search terms or patterns
3. **Iterate**: Refine searches based on initial results
4. **Combine Tools**: Use multiple search strategies (glob + grep)
5. **Read Selectively**: Only read files that match your criteria

## Performance Considerations

- **Quick Mode**: ~2-5 seconds for simple searches
- **Medium Mode**: ~5-15 seconds for typical exploration
- **Thorough Mode**: ~15-30 seconds for comprehensive analysis

Times vary based on codebase size and complexity.

## Output Format

The Explore agent provides:
- **File paths** with line numbers for matches
- **Context snippets** showing relevant code
- **Summaries** of findings
- **Recommendations** for next steps

## Limitations

- Cannot modify files (read-only)
- Not suitable for deep architectural analysis
- Limited to text-based file analysis
- May miss dynamically generated or runtime code

## Version History

- **1.0.0** (2026-01-18): Initial implementation
  - Basic file pattern matching
  - Keyword search capability
  - Thoroughness levels
  - Ignore pattern support
