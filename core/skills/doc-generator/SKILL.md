---
name: doc-generator
description: Generate documentation from code comments and structure
version: 1.0.0
author: Latros.io
category: documentation
tags: [documentation, automation, api-docs]
---

# Doc Generator Skill

Automatically extracts documentation from code comments (JSDoc, TSDoc, docstrings) and generates comprehensive documentation in multiple formats.

## When to Use This Skill

Invoke this skill when:
- User asks to generate documentation
- User wants API documentation created
- User requests README generation
- User mentions JSDoc, TSDoc, or docstrings
- User asks to document code or functions
- After significant code changes requiring documentation updates

## Invocation

Claude should automatically use this skill when documentation generation is requested. The skill provides:
- Automatic comment extraction from source code
- Multi-format documentation generation
- API documentation with examples
- README file generation
- Component/module documentation

## Dependencies

### Required
- **Agent**: `Bash` - For file operations and tool execution
- **Agent**: `Explore` - For analyzing code structure

### Optional
- **MCP Server**: `github` - For publishing documentation
- **Skill**: `git-workflow` - For committing documentation updates

## Configuration

Default settings (customizable in `.claude/skills/doc-generator.config.json`):

- `auto_extract_comments`: true - Automatically parse code comments
- `output_format`: "markdown" - Default output format
- `include_private`: false - Include private/internal APIs
- `include_examples`: true - Extract and include code examples
- `output_directory`: "./docs" - Where to save generated docs
- `generate_index`: true - Create index/TOC file
- `include_source_links`: true - Link to source code

## Supported Documentation Types

### API Documentation
- Endpoint definitions
- Parameters and return types
- Request/response examples
- Authentication requirements
- Error codes and messages

### README Generation
- Project overview
- Installation instructions
- Usage examples
- API reference
- Contributing guidelines
- License information

### Component Documentation
- Props/parameters
- Events/callbacks
- Slots/children
- Usage examples
- TypeScript definitions

## Supported Comment Formats

### JSDoc (JavaScript)
```javascript
/**
 * Calculate the sum of two numbers
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} Sum of a and b
 * @example
 * add(2, 3) // returns 5
 */
function add(a, b) { return a + b; }
```

### TSDoc (TypeScript)
```typescript
/**
 * User authentication service
 * @remarks
 * Handles user login, logout, and token management
 * @public
 */
class AuthService { }
```

### Python Docstrings
```python
def divide(a: float, b: float) -> float:
    """
    Divide two numbers.

    Args:
        a: Numerator
        b: Denominator

    Returns:
        Result of division

    Raises:
        ValueError: If b is zero
    """
    return a / b
```

### Rustdoc
```rust
/// Calculates the factorial of a number
///
/// # Examples
/// ```
/// let result = factorial(5);
/// assert_eq!(result, 120);
/// ```
fn factorial(n: u32) -> u32 { }
```

## Output Formats

### Markdown
- GitHub-flavored markdown
- Table of contents
- Code syntax highlighting
- Badges and shields
- Cross-references

### HTML
- Clean, responsive theme
- Syntax highlighting
- Search functionality
- Navigation sidebar
- Mobile-friendly

### JSON
- Structured data
- Machine-readable
- For custom processing
- API schema export

## Usage Examples

### Example 1: Generate API Documentation

**User**: "Generate API documentation for the user service"

**Claude**:
1. Analyzes user service files
2. Extracts JSDoc/TSDoc comments
3. Identifies endpoints and methods
4. Generates markdown documentation with:
   - Function signatures
   - Parameter descriptions
   - Return types
   - Usage examples
5. Saves to `docs/user-service.md`

### Example 2: Create README

**User**: "Create a README for this project"

**Claude**:
1. Analyzes project structure
2. Reads package.json or similar config
3. Identifies main features
4. Generates README.md with:
   - Project description
   - Installation steps
   - Usage examples
   - Configuration options
   - Contributing guidelines

### Example 3: Document Component

**User**: "Document the Button component"

**Claude**:
1. Finds Button component file
2. Extracts prop definitions
3. Identifies events and callbacks
4. Generates component documentation with:
   - Props table
   - Event handlers
   - Usage examples
   - TypeScript types

### Example 4: Generate Full Documentation Site

**User**: "Generate complete documentation"

**Claude**:
1. Scans entire codebase
2. Extracts all documented functions/classes
3. Generates individual doc files
4. Creates index with navigation
5. Organizes by module/category
6. Generates README and guides

## Documentation Structure

```
docs/
├── index.md              # Main index
├── api/
│   ├── user-service.md
│   ├── auth-service.md
│   └── data-service.md
├── components/
│   ├── Button.md
│   ├── Input.md
│   └── Modal.md
├── guides/
│   ├── getting-started.md
│   └── configuration.md
└── README.md
```

## Integration with Other Components

### With Explore Agent
- Analyzes code structure
- Identifies modules and dependencies
- Maps relationships between components

### With git-workflow Skill
- Commits documentation updates
- Creates documentation PRs
- Tags documentation releases

### With GitHub MCP Server
- Publishes to GitHub Pages
- Updates wiki pages
- Generates release notes

## Best Practices

1. **Keep Comments Updated**: Documentation is only as good as the comments
2. **Include Examples**: Show how to use APIs and components
3. **Document Public APIs**: Focus on user-facing functionality
4. **Use Standard Formats**: Stick to JSDoc, TSDoc, or docstrings
5. **Generate Regularly**: Update docs with code changes
6. **Review Generated Docs**: Ensure accuracy and completeness

## Error Handling

Common errors and resolutions:

**No Comments Found**:
- Reports files without documentation
- Suggests adding comments
- Shows comment format examples

**Invalid Comment Format**:
- Identifies malformed comments
- Suggests corrections
- Continues with valid comments

**Output Directory Permissions**:
- Creates directory if missing
- Reports permission issues
- Suggests alternative locations

**Missing Type Information**:
- Notes missing type annotations
- Suggests adding types
- Infers types when possible

## Version History

- **1.0.0**: Initial release with multi-format support, JSDoc/TSDoc extraction, and README generation
