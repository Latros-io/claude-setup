# Explore Agent Examples

## Example 1: Finding Error Handling Code

**User Query:** "Where are errors from the client handled?"

**Agent Response:**

I'll search for error handling related to clients in the codebase.

*Searches in parallel:*
- Grep for "error" AND "client"
- Grep for "catch" in client-related files
- Look for error middleware

**Findings:**

1. **src/services/clientService.ts:45**
   ```typescript
   try {
     await client.connect();
   } catch (error) {
     logger.error('Client connection failed:', error);
     throw new ClientConnectionError(error);
   }
   ```

2. **src/middleware/errorHandler.ts:23**
   ```typescript
   if (error instanceof ClientConnectionError) {
     return res.status(503).json({ message: 'Service unavailable' });
   }
   ```

3. **src/utils/clientErrors.ts:10**
   ```typescript
   export class ClientConnectionError extends Error {
     constructor(originalError: Error) {
       super(`Client failed: ${originalError.message}`);
     }
   }
   ```

**Summary:** Client errors are handled in three places:
- Connection errors caught in `clientService.ts:45`
- HTTP responses handled in `errorHandler.ts:23`
- Custom error class defined in `clientErrors.ts:10`

---

## Example 2: Locating React Components with Hooks

**User Query:** "Find all React components that use the useState hook"

**Agent Response:**

I'll search for React components using useState.

*Searches:*
1. Glob for `**/*.tsx` and `**/*.jsx`
2. Grep for "useState" in those files

**Findings:**

1. **src/components/Counter.tsx:5**
   ```tsx
   const [count, setCount] = useState(0);
   ```

2. **src/components/Form.tsx:12**
   ```tsx
   const [formData, setFormData] = useState({ name: '', email: '' });
   const [errors, setErrors] = useState({});
   ```

3. **src/components/Modal.tsx:8**
   ```tsx
   const [isOpen, setIsOpen] = useState(false);
   ```

4. **src/hooks/useAuth.ts:7**
   ```tsx
   const [user, setUser] = useState<User | null>(null);
   const [loading, setLoading] = useState(true);
   ```

**Summary:** Found 4 components/hooks using useState:
- Counter.tsx (1 state variable)
- Form.tsx (2 state variables)
- Modal.tsx (1 state variable)
- useAuth.ts (2 state variables)

---

## Example 3: Understanding Codebase Structure

**User Query:** "What is the codebase structure?"

**Agent Response:**

I'll analyze the codebase structure.

*Examines:*
1. Top-level directories
2. package.json for metadata
3. tsconfig.json for TypeScript config
4. Main entry points

**Structure:**

```
project-root/
├── src/                    # Main source code
│   ├── components/         # React components (12 files)
│   ├── services/           # Business logic (8 files)
│   ├── utils/              # Helper functions (15 files)
│   ├── hooks/              # Custom React hooks (5 files)
│   ├── types/              # TypeScript types (6 files)
│   └── index.tsx           # Application entry point
├── tests/                  # Test files (23 files)
├── public/                 # Static assets
└── config/                 # Configuration files
```

**Technology Stack:**
- TypeScript 5.0
- React 18.2
- Vite (build tool)
- Vitest (testing)

**Key Entry Points:**
- `src/index.tsx` - Application bootstrap
- `src/App.tsx` - Root component
- `src/services/api.ts` - API client

**Architecture Pattern:**
- Component-based React architecture
- Service layer for API calls
- Custom hooks for shared logic
- TypeScript for type safety

---

## Example 4: Finding API Endpoints

**User Query:** "Where are the API endpoints defined?"

**Agent Response:**

I'll search for API endpoint definitions.

*Searches:*
1. Grep for "api", "endpoint", "route"
2. Look for Express/Fastify/etc. patterns
3. Check common API file locations

**Findings:**

1. **src/routes/api.ts:15-35**
   ```typescript
   router.get('/users', getAllUsers);
   router.get('/users/:id', getUserById);
   router.post('/users', createUser);
   router.put('/users/:id', updateUser);
   router.delete('/users/:id', deleteUser);
   ```

2. **src/routes/auth.ts:10-15**
   ```typescript
   router.post('/login', login);
   router.post('/logout', logout);
   router.post('/refresh', refreshToken);
   ```

3. **src/routes/index.ts:8-12**
   ```typescript
   app.use('/api/v1', apiRoutes);
   app.use('/auth', authRoutes);
   ```

**Summary:** API endpoints are organized in:
- User endpoints: `src/routes/api.ts`
- Auth endpoints: `src/routes/auth.ts`
- Route registration: `src/routes/index.ts`

All endpoints are prefixed with `/api/v1` or `/auth`.

---

## Example 5: Finding Configuration Files

**User Query:** "Find all configuration files in the project"

**Agent Response:**

I'll search for configuration files.

*Searches:*
1. Glob for common config patterns: `**/*.config.*`, `**/.*rc`, `**/config/*`
2. Look in root directory

**Findings:**

**Root Configuration:**
- `package.json` - Project metadata and dependencies
- `tsconfig.json` - TypeScript configuration
- `vite.config.ts` - Vite build tool configuration
- `.eslintrc.json` - ESLint rules
- `.prettierrc` - Prettier formatting
- `.gitignore` - Git ignore patterns

**Config Directory:**
- `config/database.ts` - Database connection settings
- `config/environment.ts` - Environment variables
- `config/logger.ts` - Logging configuration

**Environment Files:**
- `.env.example` - Environment variable template
- `.env.local` - Local overrides (gitignored)

**Summary:** Found 11 configuration files across root and config/ directory.

---

## Example 6: Searching for Security Issues

**User Query:** "Are there any potential SQL injection vulnerabilities?"

**Agent Response:**

I'll search for potential SQL injection vulnerabilities.

*Searches:*
1. Grep for raw SQL query construction
2. Look for string concatenation in queries
3. Check for prepared statements

**Findings:**

**Potential Issues:**

1. **src/services/userService.ts:45** ⚠️
   ```typescript
   const query = `SELECT * FROM users WHERE email = '${email}'`;
   db.execute(query);
   ```
   Uses string interpolation - vulnerable to SQL injection.

**Safe Implementations:**

2. **src/services/productService.ts:23** ✅
   ```typescript
   const query = 'SELECT * FROM products WHERE id = ?';
   db.execute(query, [productId]);
   ```
   Uses parameterized queries - safe.

3. **src/services/orderService.ts:67** ✅
   ```typescript
   const query = 'INSERT INTO orders (user_id, total) VALUES (?, ?)';
   db.execute(query, [userId, total]);
   ```
   Uses parameterized queries - safe.

**Summary:**
- **Found 1 potential vulnerability** in `userService.ts:45`
- **Recommendation**: Replace string interpolation with parameterized queries
- Other database queries appear to use safe practices

---

## Example 7: Finding Test Files

**User Query:** "Show me all test files for the authentication module"

**Agent Response:**

I'll find test files related to authentication.

*Searches:*
1. Glob for test files: `**/*.test.*`, `**/*.spec.*`
2. Filter for "auth" in path or filename
3. Grep for "auth" in test files

**Findings:**

1. **tests/auth/login.test.ts**
   - Tests login functionality
   - 8 test cases
   - Coverage: login validation, token generation, error handling

2. **tests/auth/logout.test.ts**
   - Tests logout functionality
   - 4 test cases
   - Coverage: token invalidation, session cleanup

3. **tests/auth/middleware.test.ts**
   - Tests authentication middleware
   - 6 test cases
   - Coverage: token verification, protected routes

4. **tests/integration/auth.spec.ts**
   - Integration tests for auth flow
   - 5 test cases
   - Coverage: end-to-end authentication scenarios

**Summary:** Found 4 test files with 23 total test cases for authentication.

---

## Example 8: Understanding Dependencies

**User Query:** "What external libraries does this project depend on?"

**Agent Response:**

I'll examine the project dependencies.

*Reads:*
1. package.json - main dependencies
2. Check for peer dependencies
3. Look for imports to identify usage

**Dependencies:**

**Production (16 packages):**
- **react** (18.2.0) - UI framework
- **react-dom** (18.2.0) - React rendering
- **axios** (1.6.0) - HTTP client
- **zustand** (4.4.1) - State management
- **react-router-dom** (6.20.0) - Routing
- **date-fns** (2.30.0) - Date utilities
- **zod** (3.22.4) - Schema validation

**Development (12 packages):**
- **typescript** (5.0.0)
- **vite** (5.0.0)
- **vitest** (1.0.0)
- **eslint** (8.55.0)
- **prettier** (3.1.0)

**Key Libraries:**
- **UI**: React, React Router
- **State**: Zustand (lightweight state management)
- **HTTP**: Axios
- **Validation**: Zod
- **Build**: Vite
- **Testing**: Vitest

**Summary:** Project uses a modern React stack with Vite build tool and minimal dependencies.
