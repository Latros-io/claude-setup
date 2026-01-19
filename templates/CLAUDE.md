# Project Context for Claude Code

This file provides context about your project to help Claude Code assist you more effectively.

## Project Overview

**Name:** [Your Project Name]
**Type:** [Web App / CLI Tool / Library / API / Data Science / DevOps / Other]
**Description:** [Brief description of what this project does]

## Tech Stack

### Language(s)
- [e.g., TypeScript, Python, Go, Rust]

### Frameworks/Libraries
- [e.g., React 18, Express 4, FastAPI, Django]

### Build Tools
- [e.g., Vite, Webpack, npm, Poetry, Cargo]

### Testing
- [e.g., Jest, Vitest, pytest, Go test]

### Database
- [e.g., PostgreSQL, MongoDB, Redis]

### Infrastructure
- [e.g., Docker, Kubernetes, AWS, Vercel]

## Project Structure

```
project-root/
├── src/              # [Description]
├── tests/            # [Description]
├── docs/             # [Description]
└── [other key directories]
```

### Key Directories
- `src/` - [What's here and how it's organized]
- `tests/` - [Testing strategy and organization]
- `docs/` - [Documentation files]
- [Add more as needed]

### Important Files
- `src/index.ts` - [Main entry point]
- `package.json` - [Dependencies and scripts]
- [Add more as needed]

## Development Workflow

### Setup
```bash
# Clone and install
git clone [repo-url]
cd [project-name]
npm install  # or appropriate command

# Environment setup
cp .env.example .env
# Edit .env with your values
```

### Common Tasks

**Development:**
```bash
npm run dev         # Start dev server
npm run build       # Build for production
npm run test        # Run tests
npm run lint        # Lint code
```

**Database:**
```bash
npm run db:migrate  # Run migrations
npm run db:seed     # Seed database
```

**Docker:**
```bash
docker-compose up   # Start services
```

## Coding Standards

### Style Guide
- **Language:** [e.g., TypeScript with strict mode]
- **Formatting:** [e.g., Prettier with 2-space indentation]
- **Linting:** [e.g., ESLint with Airbnb config]
- **Naming:** [e.g., camelCase for variables, PascalCase for components]

### Best Practices
- [e.g., Always use async/await over .then()]
- [e.g., Prefer functional components with hooks]
- [e.g., Write tests for all public APIs]
- [e.g., Document complex logic with comments]

### Code Organization
- [e.g., One component per file]
- [e.g., Co-locate tests with source files]
- [e.g., Use barrel exports (index.ts) for modules]

## Architecture

### Design Patterns
- [e.g., MVC, Repository pattern, Dependency injection]

### Key Concepts
- [e.g., How authentication works]
- [e.g., How state management is organized]
- [e.g., How API routes are structured]

### Data Flow
```
[User] → [Component] → [API] → [Service] → [Database]
```

## Testing Strategy

### Unit Tests
- **Location:** [e.g., Co-located with source files (*.test.ts)]
- **Framework:** [e.g., Jest with React Testing Library]
- **Coverage:** [e.g., Aim for 80% coverage on critical paths]

### Integration Tests
- **Location:** [e.g., tests/integration/]
- **Framework:** [e.g., Supertest for API tests]

### E2E Tests
- **Location:** [e.g., tests/e2e/]
- **Framework:** [e.g., Playwright]

## Dependencies

### Critical Dependencies
- `[package-name]` - [Why it's used, any gotchas]
- `[package-name]` - [Why it's used, any gotchas]

### Development Dependencies
- `[package-name]` - [Purpose]
- `[package-name]` - [Purpose]

## Environment Variables

Required variables (see `.env.example`):
- `DATABASE_URL` - [PostgreSQL connection string]
- `API_KEY` - [Third-party API key]
- `NODE_ENV` - [development/production]

## Common Issues & Solutions

### Issue: [Common problem]
**Solution:** [How to fix it]

### Issue: [Another problem]
**Solution:** [How to fix it]

## Deployment

### Build Process
```bash
npm run build
```

### Deployment Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Environments
- **Development:** [URL and details]
- **Staging:** [URL and details]
- **Production:** [URL and details]

## Git Workflow

### Branch Strategy
- `main` - [Production-ready code]
- `develop` - [Integration branch]
- `feature/*` - [New features]
- `fix/*` - [Bug fixes]
- `hotfix/*` - [Production hotfixes]

### Commit Convention
We use [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: Add user authentication
fix: Resolve memory leak in API
docs: Update README with new endpoints
refactor: Simplify database queries
test: Add tests for user service
```

### Pull Request Process
1. Create feature branch from `develop`
2. Make changes with meaningful commits
3. Write/update tests
4. Open PR with description
5. Address review feedback
6. Merge after approval

## Claude Code Configuration

### Active Components

**Agents:**
- Bash
- Explore
- Plan
- [Add domain-specific agents]

**Skills:**
- git-workflow
- test-runner
- doc-generator
- [Add domain-specific skills]

**Rules:**
- code-style
- testing
- documentation
- security
- git-hygiene
- [Add domain-specific rules]

### MCP Servers
- filesystem
- github
- [Add others you're using]

## Additional Resources

### Documentation
- [Link to API docs]
- [Link to architecture docs]
- [Link to runbook]

### External Resources
- [Design system / component library]
- [Third-party API docs]
- [Team wiki]

## Team

### Contacts
- **Tech Lead:** [Name]
- **DevOps:** [Name]
- **Design:** [Name]

### Communication
- **Slack:** [#channel-name]
- **Email:** [team@example.com]
- **Meetings:** [Schedule]

---

**Last Updated:** [Date]
**Maintained By:** [Team/Person]
