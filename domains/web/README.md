# Web Domain

**Version:** 1.0.0
**Status:** Early Development (2 of 14 components implemented)
**Category:** Frontend & Backend Web Development

## Overview

The Web domain provides specialized components for modern web development, covering both frontend (React, Vue, Next.js) and backend (Node.js, Express, FastAPI) technologies. It extends the core Claude Code components with web-specific agents, skills, rules, and settings optimized for building performant, accessible, and secure web applications.

This domain is designed for teams building:
- Single-page applications (SPAs)
- Server-side rendered applications (SSR)
- Progressive web apps (PWAs)
- REST and GraphQL APIs
- Full-stack web applications

## Components

### Agents (1 of 2 implemented)

| Agent | Status | Purpose |
|-------|--------|---------|
| **Frontend** | ✅ Implemented | React/Vue specialist with accessibility and performance expertise |
| **Backend** | Planned | Node.js/Express API development and server-side logic |

**Frontend Agent** (`agents/Frontend/`)
- Expert in React 18+ (hooks, context) and Vue 3 (composition API)
- WCAG 2.1 AA accessibility compliance
- Build optimization with Vite/Webpack
- Responsive design and modern CSS
- Core Web Vitals optimization

### Skills (0 of 4 planned)

| Skill | Status | Purpose |
|-------|--------|---------|
| **ui-component-gen** | Planned | Generate accessible React/Vue components from specs |
| **api-testing** | Planned | Test REST/GraphQL APIs with automated validation |
| **bundle-optimizer** | Planned | Analyze and optimize webpack/vite bundles |
| **e2e-test-gen** | Planned | Generate Playwright/Cypress E2E tests |

### Rules (0 of 6 planned)

| Rule | Status | Purpose |
|------|--------|---------|
| **web-security** | Planned | XSS, CSRF, CSP, secure cookies, OWASP Top 10 |
| **performance** | Planned | Bundle size limits, Core Web Vitals, lazy loading |
| **accessibility** | Planned | WCAG 2.1 AA, semantic HTML, keyboard navigation |
| **api-design** | Planned | REST best practices, versioning, error handling |
| **seo** | Planned | Meta tags, structured data, SSR optimization |
| **state-management** | Planned | Redux/Context patterns, immutability, data flow |

### Settings Profiles (1 of 4 implemented)

| Profile | Status | Purpose |
|---------|--------|---------|
| **react.json** | ✅ Implemented | React + Vite + Testing Library + Playwright |
| **vue.json** | Planned | Vue 3 + Vite + Vitest + Cypress |
| **node-express.json** | Planned | Express + TypeScript + Jest + Supertest |
| **next.json** | Planned | Next.js SSR + API routes + React Testing Library |

## Use Cases

### Frontend Development

**React Component with Accessibility**
```bash
# Use Frontend agent to build accessible components
.claude/best-practices/scripts/link.sh --profile=web-frontend
```

Example tasks:
- "Create a modal component with keyboard navigation and focus trapping"
- "Build a responsive dashboard layout with CSS Grid"
- "Optimize bundle size by implementing code splitting"
- "Add ARIA labels to form components for screen reader support"

**Performance Optimization**
```bash
# Frontend agent helps with Core Web Vitals
```

Example tasks:
- "Analyze bundle and reduce size by lazy loading components"
- "Implement image optimization with WebP and lazy loading"
- "Add preloading for critical resources to improve LCP"

### Backend Development (Planned)

**API Development**
```bash
# Backend agent (coming soon) for server-side work
.claude/best-practices/scripts/link.sh --profile=web-backend
```

Example tasks:
- "Create Express REST API with input validation"
- "Add JWT authentication middleware"
- "Implement rate limiting and CORS configuration"

### Full-Stack Projects

**Combined Frontend + Backend**
```bash
# Use both profiles together
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/best-practices/domains/web/settings/node-express.json \
    .claude/settings.json
```

## Integration Instructions

### Quick Start (Frontend)

**1. Add submodule** (if not already added)
```bash
cd your-react-project
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
git submodule update --init --recursive
```

**2. Link web frontend components**
```bash
.claude/best-practices/scripts/link.sh --profile=web-frontend
```

This creates symlinks for:
- Core agents (Bash, Explore, Plan)
- Frontend agent
- Core skills (git-workflow, test-runner, doc-generator)
- Web skills (when implemented)
- Core + web rules

**3. Apply React settings**
```bash
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

**4. Commit changes**
```bash
git add .claude .github
git commit -m "Add Claude Code best practices (web/frontend)"
```

### Customization

**Override Frontend agent behavior**
```bash
# Create override for Frontend agent
.claude/best-practices/scripts/customize.sh create-override \
    --component=domains/web/agents/Frontend \
    --file=config.json

# Edit the override
vim .github/overrides/agents/Frontend/config.json
```

**Customize React settings**
```bash
# Edit your local settings.json
vim .claude/settings.json
```

Example customizations:
- Change bundler from Vite to Webpack
- Switch testing framework from Vitest to Jest
- Modify accessibility standards or bundle size budgets
- Add custom ESLint rules

## Configuration Options

### React Profile (`settings/react.json`)

Key configuration areas:

**Testing**
- Framework: Vitest (unit/component tests)
- Component testing: @testing-library/react
- E2E: Playwright
- Coverage threshold: 80%

**Bundler**
- Tool: Vite
- HMR enabled
- Code splitting and tree-shaking
- Minification for production

**Styling**
- Default: CSS Modules
- Alternatives: styled-components, Tailwind CSS
- No CSS preprocessor by default

**Accessibility**
- Standard: WCAG 2.1 AA
- ESLint plugin: jsx-a11y
- Axe-core integration for testing

**Performance**
- Bundle budget: 250kb max
- Chunk budget: 100kb max
- Metrics: LCP, FID, CLS monitoring

**State Management**
- Preferred: React Context
- Alternatives: Redux, Zustand, Jotai
- Server state: React Query

### Frontend Agent Configuration

```json
{
  "frameworkPreference": "auto-detect",
  "optimizeBundle": true,
  "checkAccessibility": true,
  "accessibilityStandards": ["WCAG 2.1 AA"],
  "browserTargets": ["modern", "es2020+"]
}
```

## Examples

### Example 1: Build Accessible Modal

**Task:** "Create a reusable modal component with keyboard support"

**Frontend agent will:**
1. Create modal with proper ARIA attributes (`role="dialog"`, `aria-modal="true"`)
2. Implement focus trapping (focus stays within modal)
3. Add escape key handler to close
4. Prevent body scroll when modal is open
5. Include visible focus indicators
6. Write component tests with Testing Library

### Example 2: Optimize Bundle Size

**Task:** "Reduce bundle size by implementing lazy loading"

**Frontend agent will:**
1. Analyze current bundle with Vite/Webpack
2. Identify large dependencies and routes
3. Implement React.lazy for route components
4. Add Suspense boundaries with loading states
5. Configure code splitting in bundler
6. Verify bundle size reduction

### Example 3: Implement Responsive Layout

**Task:** "Build a dashboard layout with sidebar and responsive grid"

**Frontend agent will:**
1. Create mobile-first CSS Grid layout
2. Add responsive breakpoints for tablet/desktop
3. Implement collapsible sidebar for mobile
4. Ensure keyboard navigation works
5. Test across different viewport sizes
6. Add appropriate ARIA landmarks

## Dependencies

### Required Core Components

The web domain extends these core components:
- **Agents**: Bash, Explore, Plan (all required)
- **Skills**: git-workflow, test-runner (recommended)
- **Rules**: code-style, testing, documentation (recommended)

### MCP Servers

Recommended MCP servers for web development:
- **filesystem**: File operations and project navigation
- **github**: GitHub integration for PRs and issues
- **browser**: Playwright automation for E2E testing

### External Dependencies

**Frontend (React)**
- Node.js 18+
- React 18+
- Vite 5+ or Webpack 5+
- ESLint, Prettier
- Testing Library, Playwright

## Roadmap

### v1.0.0 - Early Development (Current)
- ✅ Frontend agent (React/Vue)
- ✅ React settings profile
- Remaining: 12 components

### v1.1.0 - Frontend Complete (Q2 2026)
- Backend agent (Node.js/Express)
- All frontend skills (ui-component-gen, bundle-optimizer, e2e-test-gen)
- Frontend rules (web-security, performance, accessibility)
- Vue and Next.js settings profiles

### v1.2.0 - Full-Stack Ready (Q3 2026)
- API testing skill
- API design rules
- Node-Express settings profile
- Backend-specific skills

### v1.3.0 - Advanced Features (Q4 2026)
- SEO optimization rules
- State management patterns
- GraphQL support
- Advanced caching strategies

## Troubleshooting

### Issue: Frontend agent not available

**Solution:**
```bash
# Ensure symlink was created correctly
ls -la .github/agents/Frontend

# Re-run link script with web profile
.claude/best-practices/scripts/link.sh --profile=web-frontend
```

### Issue: React settings not applied

**Solution:**
```bash
# Check settings.json extends correctly
cat .claude/settings.json | grep extends

# Re-merge settings
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/web/settings/react.json \
    .claude/settings.json
```

### Issue: Bundle optimization suggestions not working

**Solution:**
Ensure you have bundler tools installed:
```bash
npm install -D vite-bundle-visualizer
# or for webpack
npm install -D webpack-bundle-analyzer
```

## Contributing

We welcome contributions to the web domain:

**Needed components:**
- Backend agent for Node.js/Express/FastAPI
- Skills: ui-component-gen, api-testing, bundle-optimizer
- Rules: web-security, performance, accessibility
- Settings: vue.json, node-express.json, next.json

**How to contribute:**
1. Check [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines
2. Follow existing component structure (AGENT.md, config.json, etc.)
3. Include examples and comprehensive documentation
4. Add tests for skills
5. Update this README with new components

## Support

- **Documentation**: See [INTEGRATION.md](../../INTEGRATION.md) for general integration
- **Issues**: [GitHub Issues](https://github.com/Latros-io/claude-code-best-practices/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Latros-io/claude-code-best-practices/discussions)

## License

MIT License - see [LICENSE](../../LICENSE)

---

**Last Updated:** 2026-01-19
**Maintainer:** Claude Code Best Practices Team
