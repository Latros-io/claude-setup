# GeneralPurpose Agent

**Version:** 1.0.0
**Category:** Core
**Type:** Agent

## Overview

The GeneralPurpose agent is a flexible, multi-purpose agent for tasks that require iteration, multiple tool types, or don't fit specialized agents. It can read, write, execute commands, and handle complex multi-step workflows.

## Purpose

Some tasks don't fit neatly into specialized categories. The GeneralPurpose agent handles:
- Complex research requiring multiple approaches
- Tasks combining reading, writing, and execution
- Open-ended problems needing iteration
- Cross-cutting concerns spanning multiple areas

## Key Capabilities

- **Multi-Tool Access**: Can use Glob, Grep, Read, Write, Edit, Bash
- **Iterative Problem Solving**: Can adjust approach based on findings
- **File Manipulation**: Read, write, and edit files
- **Command Execution**: Run shell commands
- **Complex Analysis**: Combine multiple data sources

## When to Use

Use GeneralPurpose when:
- Task requires multiple tool types (read + write + execute)
- Problem is open-ended and requires exploration
- You need to iterate based on intermediate results
- Task doesn't match any specialized agent
- Combining research with implementation

## When NOT to Use

Don't use GeneralPurpose when:
- Simple file read (use Read tool directly)
- Pure codebase exploration (use Explore agent)
- Implementation planning (use Plan agent)
- Simple command (use Bash tool directly)
- Task matches a specialized agent

## Example Tasks

### 1. TODO Report Generation
**Task**: Find all TODO comments and create summary report

**Approach**:
1. Grep for TODO/FIXME across codebase
2. Parse and categorize by file/priority
3. Generate markdown report with statistics
4. Write report to docs/todos.md

### 2. Import Path Update
**Task**: Update import paths after directory restructure

**Approach**:
1. Find all files with imports
2. Identify old path patterns
3. Update each file with new paths
4. Verify no broken imports remain

### 3. Test Coverage Analysis
**Task**: Analyze test coverage and suggest missing tests

**Approach**:
1. Find all source files
2. Find corresponding test files
3. Identify modules without tests
4. Generate coverage report with suggestions

### 4. Dependency Audit
**Task**: Find unused dependencies

**Approach**:
1. Read package.json dependencies
2. Search codebase for import statements
3. Identify dependencies never imported
4. Generate report of unused packages

## Best Practices

1. **Start Broad**: Initial exploration, then narrow down
2. **Iterate**: Adjust based on findings
3. **Validate**: Check results after each step
4. **Document**: Explain what you're doing
5. **Handle Errors**: Gracefully handle unexpected situations

## Integration with Other Agents

- **Explore**: Use Explore for initial discovery, GP for action
- **Plan**: Plan designs, GP implements
- **Bash**: GP can execute commands, but Bash agent is specialized

## Limitations

- Not optimized for pure exploration (use Explore)
- Not optimized for planning (use Plan)
- Should be last resort, not first choice
- Prefer specialized tools/agents when available

## Version History

- **1.0.0** (2026-01-18): Initial implementation
  - Multi-tool access
  - Iterative workflows
  - Complex task handling
