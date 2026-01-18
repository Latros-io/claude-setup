# Plan Agent

**Version:** 1.0.0
**Category:** Core
**Type:** Agent

## Overview

The Plan agent is a software architect agent that designs implementation plans before code is written. It explores the codebase, analyzes existing patterns, identifies trade-offs, and creates step-by-step implementation plans for user approval.

## Purpose

Good planning prevents wasted effort. The Plan agent ensures that:
- Implementation approach is sound before writing code
- Architectural decisions are explicit and justified
- User preferences are captured before work begins
- Critical files and dependencies are identified upfront
- Trade-offs are understood and documented

## Key Capabilities

- **Codebase Exploration**: Understands existing patterns and architecture
- **Approach Design**: Evaluates multiple implementation strategies
- **Trade-off Analysis**: Identifies pros/cons of different approaches
- **File Identification**: Lists all files that need modification
- **Step-by-Step Planning**: Creates detailed implementation roadmap
- **User Collaboration**: Asks clarifying questions when needed

## When to Use

Use the Plan agent when:

- **New Features**: Adding meaningful new functionality
  - Example: "Add a logout button" - where should it go? What happens on click?

- **Multiple Approaches**: Task can be solved several ways
  - Example: "Add caching" - Redis vs in-memory vs file-based?

- **Code Modifications**: Changes affecting existing behavior
  - Example: "Update the login flow" - what exactly should change?

- **Architectural Decisions**: Choosing between patterns/technologies
  - Example: "Add real-time updates" - WebSockets vs SSE vs polling?

- **Multi-File Changes**: Touches 3+ files
  - Example: "Refactor authentication system"

- **Unclear Requirements**: Need exploration first
  - Example: "Make the app faster" - need to profile first

- **User Preferences Matter**: Implementation could go multiple ways
  - If you'd use AskUserQuestion, use Plan mode instead

## When NOT to Use

Skip the Plan agent for:

- Single-line or few-line fixes (typos, obvious bugs)
- Adding a single function with clear requirements
- User gave very specific, detailed instructions
- Pure research/exploration (use Explore agent)
- Trivial changes with obvious implementation

## Planning Process

### Phase 1: Exploration
1. Use Explore agent to understand codebase
2. Find relevant files and patterns
3. Identify existing similar implementations
4. Understand project structure

### Phase 2: Analysis
1. Evaluate current state
2. Identify gaps and requirements
3. Consider constraints (performance, security, etc.)
4. List dependencies and blockers

### Phase 3: Design
1. Propose implementation approach
2. List files to modify/create
3. Break into implementation steps
4. Identify trade-offs
5. Design testing strategy

### Phase 4: Approval
1. Present plan to user
2. Ask clarifying questions if needed
3. Get approval before implementation
4. Exit plan mode with approved plan

## Plan Structure

Every plan includes:

### 1. Overview
- Brief summary of what will be implemented
- Context and motivation

### 2. Current State Analysis
- What exists today
- How the current system works
- Relevant code locations

### 3. Proposed Changes
- What will change
- New components/files
- Modified behavior

### 4. Implementation Steps
- Numbered, sequential steps
- Each step is concrete and testable
- Dependencies between steps noted

### 5. Files to Modify
- Complete list with file paths
- Type of change (create/modify/delete)
- Brief description of changes

### 6. Architectural Considerations
- Design patterns used
- Integration points
- Extension points for future

### 7. Trade-offs
- **Chosen Approach**: Why this way?
- **Alternatives Considered**: What else was evaluated?
- **Pros/Cons**: Honest assessment

### 8. Testing Strategy
- Unit tests needed
- Integration tests
- Manual testing steps

### 9. Rollback Plan
- How to undo if needed
- What to backup
- Rollback steps

## Integration with Other Agents

- **Explore Agent**: Plan uses Explore to understand codebase
- **General Purpose**: Plan designs, GP implements
- **Bash Agent**: Plan may specify commands to run

## Best Practices

1. **Explore First**: Always understand existing code before planning
2. **Be Specific**: "Modify auth.ts" < "Add logout() method to auth.ts:45"
3. **Break Down**: Large tasks → small, testable steps
4. **Identify Files**: List ALL files that will be touched
5. **Consider Alternatives**: Show you evaluated options
6. **Ask Questions**: Use AskUserQuestion for clarifications
7. **Be Honest**: Document trade-offs and limitations

## Example Plans

### Example 1: Add Dark Mode

**Overview**: Implement dark mode toggle with persistent user preference

**Current State**:
- Single theme (light)
- Styles in CSS modules
- No theme management system

**Proposed Changes**:
- Add theme context with React Context API
- Create CSS custom properties for colors
- Add toggle button in settings
- Store preference in localStorage

**Implementation Steps**:
1. Create `src/contexts/ThemeContext.tsx`
2. Define CSS variables in `src/styles/themes.css`
3. Update all color values to use CSS variables
4. Add toggle component in `src/components/ThemeToggle.tsx`
5. Wrap app with ThemeProvider
6. Add localStorage persistence

**Files to Modify**:
- CREATE: `src/contexts/ThemeContext.tsx`
- CREATE: `src/styles/themes.css`
- CREATE: `src/components/ThemeToggle.tsx`
- MODIFY: `src/App.tsx` (wrap with provider)
- MODIFY: `src/components/Header.tsx` (add toggle)
- MODIFY: ~15 component CSS files (use variables)

**Trade-offs**:
- **Chosen**: CSS variables
  - Pros: Native, performant, easy to maintain
  - Cons: No IE11 support
- **Alternative**: Styled-components
  - Pros: More features, TypeScript types
  - Cons: Runtime overhead, larger bundle

**Testing**:
- Unit: ThemeContext state management
- Integration: Toggle changes theme
- Manual: Check all pages in both themes

### Example 2: Optimize API Calls

**Overview**: Reduce unnecessary API calls by implementing request caching

**Current State**:
- Every component fetch triggers API call
- No caching mechanism
- Slow loading on navigation

**Current State Analysis**:
- `src/services/api.ts:45` - API client
- Multiple components fetch same data
- Average 15 API calls per page load

**Proposed Changes**:
- Implement SWR (stale-while-revalidate) pattern
- Add request deduplication
- Set 5-minute cache TTL

**Implementation Steps**:
1. Install `swr` package
2. Create `src/hooks/useApi.ts` wrapper
3. Update components to use wrapper
4. Configure cache settings
5. Add cache invalidation on mutations

**Files to Modify**:
- CREATE: `src/hooks/useApi.ts`
- MODIFY: `src/services/api.ts` (add SWR)
- MODIFY: ~8 components (use useApi hook)
- MODIFY: `package.json` (add swr)

**Trade-offs**:
- **Chosen**: SWR library
  - Pros: Mature, auto-revalidation, React-optimized
  - Cons: Additional dependency
- **Alternative**: Custom cache
  - Pros: No dependency, full control
  - Cons: Complex to implement correctly

**Testing**:
- Unit: Cache hit/miss logic
- Integration: Verify deduplication
- Performance: Measure API call reduction

## Configuration Options

```json
{
  "planningPhases": ["exploration", "analysis", "design", "approval"],
  "includeTradeoffs": true,
  "identifyCriticalFiles": true,
  "estimateComplexity": true
}
```

## Success Criteria

A good plan has:
- ✅ Clear, specific implementation steps
- ✅ Complete list of files to modify
- ✅ Honest trade-off analysis
- ✅ Testable milestones
- ✅ Rollback strategy
- ✅ User approval before implementation

## Version History

- **1.0.0** (2026-01-18): Initial implementation
  - Four-phase planning process
  - Structured plan output
  - Trade-off analysis
  - Integration with Explore agent
