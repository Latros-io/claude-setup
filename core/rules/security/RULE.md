---
name: security
description: Security best practices to prevent common vulnerabilities
version: 1.0.0
author: Latros.io
category: security
enforcement: error
tags: [security, vulnerabilities, owasp, secrets, encryption]
---

# Security Rule

Prevent common security vulnerabilities and follow security best practices to protect applications and data.

## Purpose

Security best practices provide:
- **Protection**: Prevent data breaches and attacks
- **Compliance**: Meet regulatory requirements
- **Trust**: Build user confidence in your application
- **Cost Savings**: Prevent expensive security incidents
- **Risk Mitigation**: Reduce attack surface and vulnerabilities

## Rules

### 1. No Hardcoded Secrets

**Severity**: Critical

**Rule**: Never commit secrets, credentials, or sensitive data to version control

**What to avoid**:
- API keys
- Passwords
- Private keys
- OAuth tokens
- Database credentials
- Encryption keys

**Example**:
```javascript
// CRITICAL - Never do this
const API_KEY = 'sk-1234567890abcdef';
const DATABASE_URL = 'postgresql://user:password@localhost/db';

// Good - use environment variables
const API_KEY = process.env.API_KEY;
const DATABASE_URL = process.env.DATABASE_URL;

// Better - use secret management
import { getSecret } from './secrets';
const API_KEY = await getSecret('api-key');
```

**Environment variables (.env)**:
```bash
# .env (add to .gitignore!)
API_KEY=sk-1234567890abcdef
DATABASE_URL=postgresql://user:password@localhost/db
```

**Detection patterns**:
- Check for common patterns: `password=`, `api_key=`, `secret=`
- Scan commit history for exposed secrets
- Use pre-commit hooks to prevent commits with secrets

### 2. SQL Injection Prevention

**Severity**: Critical

**Rule**: Always use parameterized queries or ORMs with proper escaping

**Example (Vulnerable)**:
```javascript
// CRITICAL VULNERABILITY - SQL Injection
const userId = req.params.id;
const query = `SELECT * FROM users WHERE id = '${userId}'`;
db.query(query);

// Attacker can inject: ' OR '1'='1
// Resulting query: SELECT * FROM users WHERE id = '' OR '1'='1'
```

**Example (Secure)**:
```javascript
// Good - parameterized query
const userId = req.params.id;
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);

// Good - ORM with sanitization
const user = await User.findByPk(userId);

// Good - prepared statements
const stmt = db.prepare('SELECT * FROM users WHERE id = ?');
const user = stmt.get(userId);
```

**Python example**:
```python
# Bad - vulnerable to SQL injection
user_id = request.args.get('id')
query = f"SELECT * FROM users WHERE id = '{user_id}'"
cursor.execute(query)

# Good - parameterized query
user_id = request.args.get('id')
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))

# Good - ORM
user = User.query.filter_by(id=user_id).first()
```

### 3. XSS (Cross-Site Scripting) Prevention

**Severity**: Critical

**Rule**: Sanitize user input and escape output in HTML contexts

**Example (Vulnerable)**:
```javascript
// CRITICAL VULNERABILITY - XSS
const userName = req.query.name;
res.send(`<h1>Hello ${userName}</h1>`);

// Attacker can inject: <script>alert('XSS')</script>
```

**Example (Secure)**:
```javascript
// Good - use templating with auto-escaping
res.render('hello', { name: userName }); // Template engines escape by default

// Good - manual escaping
const escapeHtml = (str) => {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
};
res.send(`<h1>Hello ${escapeHtml(userName)}</h1>`);

// Good - React automatically escapes
return <h1>Hello {userName}</h1>;
```

**Content Security Policy**:
```javascript
// Add CSP header to prevent inline scripts
app.use((req, res, next) => {
  res.setHeader(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self'"
  );
  next();
});
```

### 4. CSRF (Cross-Site Request Forgery) Protection

**Severity**: Warning

**Rule**: Implement CSRF tokens for state-changing operations

**Example**:
```javascript
// Install CSRF protection middleware
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: true });

app.use(csrfProtection);

// Include CSRF token in forms
app.get('/form', (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});

// Verify token on POST
app.post('/submit', (req, res) => {
  // CSRF middleware automatically validates token
  // Process form...
});
```

**HTML form**:
```html
<form method="POST" action="/submit">
  <input type="hidden" name="_csrf" value="{{csrfToken}}">
  <button type="submit">Submit</button>
</form>
```

**SameSite cookies**:
```javascript
res.cookie('session', sessionId, {
  httpOnly: true,
  secure: true,
  sameSite: 'strict'
});
```

### 5. Secure Dependencies

**Severity**: Error

**Rule**: Keep dependencies updated and scan for vulnerabilities

**Regular audits**:
```bash
# npm
npm audit
npm audit fix

# yarn
yarn audit

# pnpm
pnpm audit

# pip
pip-audit

# cargo
cargo audit
```

**Automated checks**:
```json
// package.json - use exact versions for security
{
  "dependencies": {
    "express": "4.18.2",  // Not "^4.18.2"
  }
}
```

**CI/CD integration**:
```yaml
# .github/workflows/security.yml
- name: Run security audit
  run: npm audit --audit-level=moderate
```

### 6. Authentication and Password Security

**Severity**: Critical

**Rule**: Hash passwords with strong algorithms, never store plaintext

**Example (Vulnerable)**:
```javascript
// CRITICAL - Never store plaintext passwords
const user = {
  username: 'john',
  password: 'myPassword123'
};
db.save(user);
```

**Example (Secure)**:
```javascript
// Good - use bcrypt or similar
const bcrypt = require('bcrypt');
const saltRounds = 12;

// Hash password before storing
const hashedPassword = await bcrypt.hash(password, saltRounds);
const user = {
  username: 'john',
  password: hashedPassword
};
db.save(user);

// Verify password
const isValid = await bcrypt.compare(inputPassword, user.password);
```

**Rate limiting**:
```javascript
const rateLimit = require('express-rate-limit');

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts'
});

app.post('/login', loginLimiter, async (req, res) => {
  // Handle login
});
```

### 7. Data Encryption

**Severity**: Error

**Rule**: Encrypt sensitive data in transit and at rest

**HTTPS only**:
```javascript
// Redirect HTTP to HTTPS
app.use((req, res, next) => {
  if (!req.secure && process.env.NODE_ENV === 'production') {
    return res.redirect(`https://${req.headers.host}${req.url}`);
  }
  next();
});

// Strict Transport Security
app.use((req, res, next) => {
  res.setHeader('Strict-Transport-Security', 'max-age=31536000');
  next();
});
```

**Encrypt sensitive fields**:
```javascript
const crypto = require('crypto');

// Encrypt data before storing
function encrypt(text) {
  const algorithm = 'aes-256-gcm';
  const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  const iv = crypto.randomBytes(16);

  const cipher = crypto.createCipheriv(algorithm, key, iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');

  const authTag = cipher.getAuthTag();

  return {
    iv: iv.toString('hex'),
    encrypted,
    authTag: authTag.toString('hex')
  };
}
```

## Configuration

Customize in `.claude/rules/security.config.json`:

```json
{
  "no_hardcoded_secrets": {
    "enabled": true,
    "use_environment_variables": true
  },
  "sql_injection_prevention": {
    "require_parameterized_queries": true
  },
  "secure_dependencies": {
    "audit_regularly": true
  }
}
```

## OWASP Top 10 Coverage

This rule addresses:
1. **A01:2021 - Broken Access Control**: Authentication/authorization rules
2. **A02:2021 - Cryptographic Failures**: Encryption requirements
3. **A03:2021 - Injection**: SQL injection, XSS prevention
4. **A04:2021 - Insecure Design**: Security by design principles
5. **A05:2021 - Security Misconfiguration**: Secure defaults
6. **A06:2021 - Vulnerable Components**: Dependency scanning
7. **A07:2021 - Identification Failures**: Authentication security
8. **A08:2021 - Data Integrity Failures**: Input validation
9. **A09:2021 - Security Logging Failures**: Audit logging
10. **A10:2021 - SSRF**: Input validation and allow-lists

## Integration

**Works with**:
- Security scanners (Snyk, Dependabot)
- Secret scanning (GitHub, GitGuardian)
- SAST tools (SonarQube, Semgrep)
- Penetration testing tools
- CI/CD security checks

**Enforcement points**:
- Pre-commit hooks for secret scanning
- CI/CD pipeline security checks
- Automated dependency audits
- Code review checklists
- Security-focused testing

## Enforcement

Claude should:
1. **Flag hardcoded secrets** immediately
2. **Require parameterized queries** for database operations
3. **Verify input validation** and output escaping
4. **Check dependency versions** for known vulnerabilities
5. **Suggest security headers** for web applications
6. **Recommend encryption** for sensitive data
7. **Warn about insecure patterns** during code review

## Best Practices

### Defense in Depth
- Multiple layers of security
- Assume each layer can fail
- Validate at every boundary

### Principle of Least Privilege
- Minimum necessary permissions
- Separate service accounts
- Time-limited access tokens

### Security by Default
- Secure defaults in configuration
- Opt-out of security, not opt-in
- Fail securely

### Regular Security Reviews
- Periodic security audits
- Dependency updates
- Penetration testing
- Code reviews with security focus

## Common Vulnerabilities Checklist

- [ ] No hardcoded secrets or credentials
- [ ] SQL queries use parameterization
- [ ] User input is validated and sanitized
- [ ] Output is properly escaped
- [ ] CSRF protection on state-changing operations
- [ ] HTTPS enforced in production
- [ ] Passwords hashed with strong algorithms
- [ ] Rate limiting on authentication endpoints
- [ ] Security headers configured
- [ ] Dependencies scanned for vulnerabilities
- [ ] Sensitive data encrypted at rest
- [ ] Proper error handling (no sensitive info in errors)
- [ ] Logging includes security events
- [ ] Access control properly implemented

## Version History

**1.0.0** (2026-01-18)
- Initial release
- OWASP Top 10 coverage
- Common vulnerability prevention
- Multi-language security patterns
