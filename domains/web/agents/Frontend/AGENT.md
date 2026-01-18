# Frontend Agent

**Version:** 1.0.0
**Category:** Web
**Type:** Agent

## Overview

The Frontend agent specializes in modern web development, focusing on React, Vue, HTML/CSS, bundling, and accessibility. It helps build performant, accessible, and maintainable user interfaces following web standards and best practices.

## Purpose

Modern frontend development requires expertise across frameworks, tooling, styling, accessibility, and performance. The Frontend agent ensures:
- Components are accessible and follow WCAG guidelines
- Bundles are optimized for performance
- Code follows framework best practices
- Styling is maintainable and responsive
- User interfaces work across browsers and devices

## Key Capabilities

- **Framework Development**: Expert in React (hooks, context) and Vue (composition API)
- **Responsive Design**: Mobile-first layouts using Flexbox, Grid, and modern CSS
- **Accessibility**: WCAG 2.1 AA compliance, ARIA, keyboard navigation
- **Build Optimization**: Vite, Webpack configuration, code splitting, tree-shaking
- **Component Architecture**: Design systems, reusable components, state management
- **Testing**: Unit, component, and E2E testing strategies

## When to Use

Use the Frontend agent when:

- **Component Development**: Building or modifying React/Vue components
  - Example: "Create a reusable dropdown component with keyboard navigation"

- **Styling & Layout**: Implementing responsive designs
  - Example: "Build a dashboard layout with sidebar and responsive grid"

- **Build Tooling**: Setting up or debugging bundlers
  - Example: "Configure Vite with code splitting for production"

- **Accessibility**: Ensuring WCAG compliance
  - Example: "Add ARIA labels and keyboard support to modal component"

- **Performance**: Optimizing bundle size and load times
  - Example: "Reduce bundle size by implementing lazy loading"

- **State Management**: Setting up Redux, Zustand, or React Context
  - Example: "Implement global theme state with React Context"

## When NOT to Use

Skip the Frontend agent for:

- Backend API development (use Backend agent)
- Database operations (use Database agent)
- Infrastructure/deployment (use DevOps agent)
- Pure design work without code implementation

## Framework Expertise

### React
- Hooks (useState, useEffect, useCallback, useMemo, useRef)
- Custom hooks for reusable logic
- Context API for global state
- Component composition patterns
- Performance optimization (React.memo, lazy loading)
- Error boundaries and Suspense

### Vue
- Composition API (ref, reactive, computed, watch)
- Component lifecycle and reactivity
- Vue Router for navigation
- Pinia/Vuex for state management
- Teleport, Suspense, and async components
- Template syntax and directives

### Next.js / Nuxt.js
- Server-side rendering (SSR)
- Static site generation (SSG)
- API routes and middleware
- Image optimization
- File-based routing

## Styling Expertise

### CSS Fundamentals
- Flexbox and Grid layouts
- CSS custom properties (variables)
- Animations and transitions
- Media queries and responsive design
- Modern selectors (`:has()`, `:is()`, `:where()`)

### CSS Approaches
- **CSS Modules**: Scoped styles, type-safe with TypeScript
- **Styled Components**: CSS-in-JS with dynamic styling
- **Tailwind CSS**: Utility-first, rapid development
- **SASS/SCSS**: Variables, mixins, nesting

### Responsive Design
- Mobile-first approach
- Breakpoint strategies
- Fluid typography and spacing
- Container queries
- Responsive images and media

## Accessibility Standards

Following WCAG 2.1 Level AA:

### Semantic HTML
- Proper heading hierarchy (h1-h6)
- Landmark elements (nav, main, aside, footer)
- Semantic form elements and labels
- Button vs link usage

### ARIA Attributes
- `role`, `aria-label`, `aria-labelledby`
- `aria-describedby`, `aria-live`
- `aria-expanded`, `aria-selected`, `aria-checked`
- Avoiding ARIA when semantic HTML suffices

### Keyboard Navigation
- All interactive elements keyboard accessible
- Focus management (visible focus indicators)
- Tab order and skip links
- Escape key for modals/dropdowns
- Arrow keys for custom widgets

### Screen Reader Support
- Alt text for images
- Descriptive link text
- Form field labels and error messages
- Live regions for dynamic content
- Hidden content management

### Visual Accessibility
- Color contrast ratios (4.5:1 for text)
- Not relying on color alone
- Text resizing support
- Reduced motion preferences

## Build & Tooling

### Bundlers

**Vite** (recommended for new projects)
- Lightning-fast dev server with HMR
- Optimized production builds
- Plugin ecosystem
- Built-in TypeScript support

**Webpack**
- Mature ecosystem
- Extensive configuration options
- Code splitting strategies
- Asset optimization

**Rollup**
- Library bundling
- Tree-shaking optimization
- ES module output

### Optimization Strategies

1. **Code Splitting**
   - Route-based splitting
   - Component lazy loading
   - Dynamic imports

2. **Tree Shaking**
   - ES modules
   - Side-effect-free code
   - Proper package.json configuration

3. **Asset Optimization**
   - Image compression and modern formats (WebP, AVIF)
   - SVG optimization
   - Font subsetting
   - CSS/JS minification

4. **Caching**
   - Content hashing for long-term caching
   - Service workers
   - HTTP caching headers

## Testing Approach

### Unit Tests (Jest/Vitest)
- Test utility functions
- Test custom hooks
- Test Redux reducers/actions
- Fast, isolated tests

### Component Tests (Testing Library)
- Test user interactions
- Test accessibility
- Test component rendering
- Query by accessible roles

### E2E Tests (Playwright/Cypress)
- Test full user flows
- Test across browsers
- Visual regression testing
- Performance testing

## Performance Best Practices

### Core Web Vitals
- **LCP** (Largest Contentful Paint): < 2.5s
- **FID** (First Input Delay): < 100ms
- **CLS** (Cumulative Layout Shift): < 0.1

### Optimization Techniques
- Code splitting and lazy loading
- Image optimization (next/image, lazy loading)
- Preloading critical resources
- Debouncing and throttling
- Virtualization for long lists
- Memoization (React.memo, useMemo)

## Integration with Web Domain

### Works with Skills
- **ui-component-gen**: Generate component boilerplate
- **api-testing**: Test frontend API calls
- **bundle-optimizer**: Analyze and optimize bundles

### Follows Rules
- **web-security**: XSS prevention, CSP, secure cookies
- **performance**: Bundle size, Core Web Vitals
- **accessibility**: WCAG compliance, keyboard navigation

### Uses MCP Servers
- **browser**: Testing in real browsers with Playwright

## Common Patterns

### Accessible Modal Component
```jsx
function Modal({ isOpen, onClose, title, children }) {
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
      // Focus trap implementation
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      onKeyDown={(e) => {
        if (e.key === 'Escape') onClose();
      }}
    >
      <h2 id="modal-title">{title}</h2>
      {children}
      <button onClick={onClose} aria-label="Close modal">
        Close
      </button>
    </div>
  );
}
```

### Code Splitting with React.lazy
```jsx
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HeavyComponent />
    </Suspense>
  );
}
```

### Responsive CSS Grid
```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  padding: 1rem;
}

@media (min-width: 768px) {
  .grid {
    gap: 2rem;
    padding: 2rem;
  }
}
```

## Configuration Options

```json
{
  "frameworkPreference": "auto-detect",
  "optimizeBundle": true,
  "checkAccessibility": true,
  "accessibilityStandards": ["WCAG 2.1 AA"],
  "browserTargets": ["modern", "es2020+"]
}
```

## Best Practices

1. **Mobile-First**: Design for mobile, enhance for desktop
2. **Accessibility First**: Build accessible from the start, not as an afterthought
3. **Progressive Enhancement**: Start with core functionality, add enhancements
4. **Component Composition**: Small, reusable components over large monoliths
5. **Performance Budget**: Monitor bundle size, set limits
6. **Type Safety**: Use TypeScript for better DX and fewer runtime errors
7. **Test Behavior**: Test what users do, not implementation details

## Limitations

- Does not handle backend logic (use Backend agent)
- Does not manage infrastructure (use DevOps agent)
- Focuses on modern browsers (ES2020+)
- Cannot directly modify server-side code

## Success Criteria

A well-built frontend has:
- Accessible to all users (keyboard, screen reader, visual)
- Fast loading and interaction (good Core Web Vitals)
- Works across browsers and devices
- Maintainable code structure
- Optimized bundle size
- Comprehensive test coverage

## Version History

- **1.0.0** (2026-01-19): Initial implementation
  - React and Vue expertise
  - Accessibility-first approach
  - Build optimization focus
  - Integration with web domain skills and rules
