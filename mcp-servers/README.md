# MCP Server Configurations

This directory contains example configurations for Model Context Protocol (MCP) servers. MCP servers extend Claude's capabilities by providing access to external tools, data sources, and services.

## What are MCP Servers?

MCP (Model Context Protocol) servers are standalone processes that expose specific capabilities to Claude through a standardized protocol. Each server provides:

- **Tools**: Functions Claude can call to perform actions
- **Resources**: Data sources Claude can read from
- **Prompts**: Reusable prompt templates

## Available Server Configurations

### 1. Filesystem (`filesystem/`)
Provides secure file system access with read/write capabilities.

**Use cases:**
- Read and analyze project files
- Write generated code or documentation
- Search through codebases
- Manage project structure

**Configuration:** See `filesystem/config.json`

### 2. GitHub (`github/`)
Integration with GitHub API for repository management.

**Use cases:**
- Manage repositories, branches, and pull requests
- Create and update issues
- Search code across repositories
- Read and modify files in repositories

**Configuration:** See `github/config.json`

**Required:** GitHub personal access token

### 3. Browser (`browser/`)
Playwright-powered browser automation.

**Use cases:**
- Web scraping and data extraction
- Automated testing of web applications
- Screenshot capture
- Form filling and interaction

**Configuration:** See `browser/config.json`

**Required:** Playwright installation (`npx playwright install`)

### 4. PostgreSQL (`postgres/`)
Database access for PostgreSQL databases.

**Use cases:**
- Execute queries and analyze data
- Inspect database schema
- Manage tables and records
- Generate reports and analytics

**Configuration:** See `postgres/config.json`

**Required:** PostgreSQL connection credentials

### 5. Docker (`docker/`)
Container and image management.

**Use cases:**
- Build and deploy containers
- Manage container lifecycle
- Inspect logs and container state
- Orchestrate multi-container applications

**Configuration:** See `docker/config.json`

**Required:** Docker installation and socket access

## How to Configure MCP Servers

### Method 1: Using Claude Desktop

1. Open Claude Desktop settings
2. Navigate to "Developer" → "MCP Servers"
3. Click "Add Server"
4. Copy the configuration from the respective `config.json` file
5. Update environment variables and paths as needed
6. Save and restart Claude Desktop

### Method 2: Manual Configuration

Edit your Claude configuration file:

**macOS/Linux:** `~/.config/claude/config.json`
**Windows:** `%APPDATA%\Claude\config.json`

Add server configurations to the `mcpServers` section:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/directory"],
      "env": {
        "NODE_ENV": "production"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your_token_here"
      }
    }
  }
}
```

### Method 3: Environment Variables

Set required environment variables before starting Claude:

```bash
# GitHub
export GITHUB_TOKEN="ghp_your_token_here"

# PostgreSQL
export POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/db"

# Docker (usually default)
export DOCKER_HOST="unix:///var/run/docker.sock"
```

## Security Best Practices

### General Guidelines

1. **Never commit credentials** to version control
2. **Use environment variables** for sensitive data
3. **Grant minimum privileges** needed for each server
4. **Audit access regularly** to monitor usage
5. **Rotate credentials** periodically (90-day cycle recommended)
6. **Use separate credentials** for different environments (dev/staging/prod)

### Server-Specific Security

#### Filesystem
- Only grant access to specific, trusted directories
- Use read-only mode when write access isn't needed
- Exclude sensitive files and directories
- Never expose system directories

#### GitHub
- Use fine-grained personal access tokens
- Grant only required scopes (start with `repo` only)
- Enable SSO if using organization repositories
- Review token usage in GitHub settings

#### Browser
- Run in headless mode in production
- Set proper user agent to identify your bot
- Respect robots.txt and rate limits
- Use sandboxing in containerized environments

#### PostgreSQL
- Create dedicated database users with limited privileges
- Enable SSL/TLS for all remote connections
- Use read-only mode for analytics queries
- Implement connection pooling limits

#### Docker
- Understand that socket access grants root-level privileges
- Use TLS for remote Docker daemon connections
- Avoid privileged containers unless absolutely necessary
- Scan images for vulnerabilities before deployment

## Troubleshooting

### Server Not Starting

1. Check that the server package is installed:
   ```bash
   npx -y @modelcontextprotocol/server-<name> --version
   ```

2. Verify environment variables are set:
   ```bash
   echo $GITHUB_TOKEN
   echo $POSTGRES_CONNECTION_STRING
   ```

3. Check Claude logs for error messages:
   - macOS: `~/Library/Logs/Claude/`
   - Windows: `%APPDATA%\Claude\logs\`

### Connection Issues

1. Verify service is running (Docker, PostgreSQL, etc.)
2. Check firewall rules and network connectivity
3. Validate credentials and permissions
4. Review server-specific troubleshooting in each `config.json`

### Permission Errors

1. Ensure user has necessary permissions:
   - Docker: Add user to `docker` group
   - Filesystem: Check directory permissions
   - Database: Verify user grants

2. Check configuration paths are absolute, not relative
3. Verify environment variables are properly expanded

## Creating Custom Servers

You can create your own MCP servers to extend Claude's capabilities:

1. **Install MCP SDK:**
   ```bash
   npm install @modelcontextprotocol/sdk
   ```

2. **Implement server interface:**
   - Define tools, resources, and prompts
   - Handle requests and responses
   - Implement error handling

3. **Test locally:**
   ```bash
   node your-server.js
   ```

4. **Add to configuration:**
   ```json
   {
     "custom-server": {
       "command": "node",
       "args": ["/path/to/your-server.js"],
       "env": {}
     }
   }
   ```

For detailed documentation, visit: https://modelcontextprotocol.io

## Resources

- **MCP Documentation:** https://modelcontextprotocol.io
- **Server Registry:** https://github.com/modelcontextprotocol/servers
- **SDK Repository:** https://github.com/modelcontextprotocol/sdk
- **Community Servers:** https://github.com/topics/mcp-server

## Contributing

To add new server configurations:

1. Create a new directory with the server name
2. Add a `config.json` with complete configuration
3. Include all required environment variables
4. Document security considerations
5. Provide practical examples
6. Test the configuration thoroughly

## License

These configuration examples are provided as-is for reference purposes. Refer to individual MCP server licenses for usage terms.
