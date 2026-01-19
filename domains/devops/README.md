# DevOps Domain

**Version:** 1.0.0
**Status:** Planned (0 of 14 components implemented)
**Category:** Infrastructure, CI/CD, Container Orchestration

## Overview

The DevOps domain provides specialized components for infrastructure management, continuous integration/deployment, and cloud operations. It extends the core Claude Code components with DevOps-specific agents, skills, rules, and settings optimized for working with Docker, Kubernetes, Terraform, CI/CD pipelines, and cloud platforms (AWS, Azure, GCP).

This domain is designed for teams managing:
- Containerized applications and microservices
- Kubernetes clusters and orchestration
- Infrastructure as Code (Terraform, CloudFormation)
- CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins)
- Cloud infrastructure and services
- Monitoring, logging, and observability

## Components

### Agents (0 of 2 planned)

| Agent | Status | Purpose |
|-------|--------|---------|
| **Infrastructure** | Planned | Terraform, CloudFormation, cloud services, container management |
| **CICD** | Planned | Pipeline configuration, deployment automation, testing strategies |

**Infrastructure Agent** (Planned)
- Expert in Docker, Kubernetes, Helm
- Terraform and CloudFormation for IaC
- AWS, Azure, GCP cloud services
- Container orchestration and networking
- Security hardening and secrets management
- Cost optimization strategies

**CICD Agent** (Planned)
- Pipeline design (GitHub Actions, GitLab CI, Jenkins, CircleCI)
- Deployment strategies (blue/green, canary, rolling)
- Automated testing in CI pipelines
- Artifact management and versioning
- Environment promotion workflows
- Rollback and disaster recovery

### Skills (0 of 5 planned)

| Skill | Status | Purpose |
|-------|--------|---------|
| **container-manager** | Planned | Build, optimize, scan Docker images |
| **k8s-helper** | Planned | Generate manifests, debug pods, manage resources |
| **terraform-gen** | Planned | Generate Terraform modules and validate configs |
| **pipeline-builder** | Planned | Create CI/CD pipeline configurations |
| **cloud-optimizer** | Planned | Analyze and optimize cloud costs and resources |

### Rules (0 of 5 planned)

| Rule | Status | Purpose |
|------|--------|---------|
| **infrastructure-as-code** | Planned | IaC best practices, state management, modularity |
| **deployment-safety** | Planned | Rollback strategies, health checks, gradual rollouts |
| **secrets-management** | Planned | Never commit secrets, use vaults, rotation policies |
| **container-security** | Planned | Image scanning, minimal base images, user privileges |
| **monitoring-observability** | Planned | Logging standards, metrics collection, alerting |

### Settings Profiles (0 of 4 planned)

| Profile | Status | Purpose |
|---------|--------|---------|
| **docker.json** | Planned | Docker development and optimization |
| **kubernetes.json** | Planned | K8s manifests, Helm, kubectl workflows |
| **terraform.json** | Planned | Terraform modules, state management, providers |
| **aws.json** | Planned | AWS-specific services and configurations |

## Use Cases

### Container Development

**Typical workflow with Infrastructure agent** (when implemented)

Example tasks:
- "Create optimized Dockerfile for Node.js app with multi-stage build"
- "Set up docker-compose for local development with PostgreSQL and Redis"
- "Scan Docker image for vulnerabilities and fix high-severity issues"
- "Optimize image size by using Alpine base and removing build dependencies"

### Kubernetes Deployment

**Typical workflow with Infrastructure agent + k8s-helper skill** (when implemented)

Example tasks:
- "Generate Kubernetes deployment manifest with health checks and resource limits"
- "Create Horizontal Pod Autoscaler based on CPU and custom metrics"
- "Debug failing pod and check logs, events, and describe output"
- "Set up ingress with TLS termination and path-based routing"

### Infrastructure as Code

**Typical workflow with Infrastructure agent + terraform-gen skill** (when implemented)

Example tasks:
- "Create Terraform module for AWS VPC with public and private subnets"
- "Generate EKS cluster configuration with node groups and IAM roles"
- "Add RDS database with automated backups and multi-AZ deployment"
- "Validate Terraform plan and check for security issues"

### CI/CD Pipeline Setup

**Typical workflow with CICD agent + pipeline-builder skill** (when implemented)

Example tasks:
- "Create GitHub Actions workflow for Node.js app with testing and deployment"
- "Add Docker image build and push to ECR in pipeline"
- "Implement blue/green deployment strategy with health checks"
- "Set up multi-environment pipeline with staging and production"

## Integration Instructions

### Quick Start (When Implemented)

**1. Add submodule** (if not already added)
```bash
cd your-infrastructure-project
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
git submodule update --init --recursive
```

**2. Link DevOps components**
```bash
.claude/best-practices/scripts/link.sh --profile=devops
```

This will create symlinks for:
- Core agents (Bash, Explore, Plan)
- Infrastructure and CICD agents
- Core skills (git-workflow, test-runner, doc-generator)
- DevOps skills (container-manager, k8s-helper, etc.)
- Core + DevOps rules

**3. Apply DevOps settings**
```bash
# For Docker workflows
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/devops/settings/docker.json \
    .claude/settings.json

# Or for Kubernetes workflows
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/devops/settings/kubernetes.json \
    .claude/settings.json

# Or for Terraform workflows
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/devops/settings/terraform.json \
    .claude/settings.json
```

**4. Commit changes**
```bash
git add .claude .github
git commit -m "Add Claude Code best practices (devops)"
```

## Configuration Options (Planned)

### Docker Profile

Expected configuration areas:

**Image Building**
- Base image preferences (Alpine, Debian Slim, Ubuntu)
- Multi-stage build templates
- Layer optimization strategies
- Build cache configuration

**Security**
- Image scanning tools (Trivy, Snyk, Grype)
- Vulnerability severity thresholds
- Base image update policies
- User privilege enforcement (non-root)

**Registry**
- Default registry (Docker Hub, ECR, GCR, ACR)
- Tagging strategies (semantic versioning, git SHA)
- Image retention policies

### Kubernetes Profile

Expected configuration areas:

**Manifest Generation**
- API version preferences
- Resource limit defaults
- Label and annotation standards
- Namespace organization

**Deployment Strategies**
- Rolling updates configuration
- Health check templates (readiness, liveness)
- Resource requests and limits
- Autoscaling policies (HPA, VPA)

**Networking**
- Ingress controller (Nginx, Traefik, AWS ALB)
- Service mesh (Istio, Linkerd)
- Network policies
- TLS/SSL configuration

**Monitoring**
- Prometheus metrics
- Log aggregation (Fluentd, Loki)
- Distributed tracing

### Terraform Profile

Expected configuration areas:

**Code Organization**
- Module structure conventions
- Variable naming standards
- Output definitions
- Remote state configuration

**Providers**
- Default provider versions
- Provider configuration templates
- Multi-region strategies

**Best Practices**
- State locking enforcement
- Plan before apply requirement
- Module versioning
- Resource tagging standards

**Security**
- Secrets handling (AWS Secrets Manager, HashiCorp Vault)
- IAM policy generation
- Security group rules
- Encryption enforcement

## Examples (Planned)

### Example 1: Optimize Docker Image

**Task:** "Optimize Dockerfile for production deployment"

**Infrastructure agent will:**
1. Analyze current Dockerfile for inefficiencies
2. Implement multi-stage build to separate build and runtime
3. Switch to Alpine base image for smaller size
4. Order layers for better caching
5. Remove unnecessary dependencies
6. Run as non-root user
7. Scan for vulnerabilities with Trivy
8. Compare before/after image sizes

### Example 2: Deploy to Kubernetes

**Task:** "Create Kubernetes deployment for Node.js API with database"

**Infrastructure agent + k8s-helper skill will:**
1. Generate Deployment manifest with 3 replicas
2. Add readiness and liveness probes
3. Configure resource limits (CPU: 500m, Memory: 512Mi)
4. Create Service (ClusterIP) for internal access
5. Set up ConfigMap for environment variables
6. Create Secret for database credentials
7. Add HorizontalPodAutoscaler (2-10 replicas, 70% CPU target)
8. Generate Ingress with TLS termination
9. Validate manifests with kubectl dry-run

### Example 3: Terraform AWS Infrastructure

**Task:** "Create AWS infrastructure for web application"

**Infrastructure agent + terraform-gen skill will:**
1. Create VPC module with public/private subnets across 3 AZs
2. Set up Internet Gateway and NAT Gateways
3. Configure route tables and security groups
4. Create ECS cluster with Fargate
5. Set up Application Load Balancer
6. Create RDS PostgreSQL with Multi-AZ
7. Add S3 bucket for static assets
8. Configure CloudWatch logging
9. Validate with `terraform plan`
10. Generate state backend configuration (S3 + DynamoDB)

### Example 4: GitHub Actions CI/CD

**Task:** "Set up CI/CD pipeline with automated testing and deployment"

**CICD agent + pipeline-builder skill will:**
1. Create workflow file (.github/workflows/deploy.yml)
2. Add test job (lint, unit tests, integration tests)
3. Add build job (Docker image build and push to ECR)
4. Add deploy job with approval gate for production
5. Implement secrets management for AWS credentials
6. Add deployment health checks
7. Configure rollback on failure
8. Add Slack notifications for status updates

## Dependencies

### Required Core Components

The DevOps domain extends these core components:
- **Agents**: Bash (required for command execution)
- **Skills**: git-workflow (recommended)
- **Rules**: security, git-hygiene (recommended)

### External Tools

**Container & Orchestration:**
- Docker 20+
- kubectl (for Kubernetes)
- Helm (for package management)

**Infrastructure as Code:**
- Terraform 1.0+
- AWS CLI, Azure CLI, or gcloud CLI

**CI/CD Platforms:**
- GitHub Actions, GitLab CI, Jenkins, or CircleCI

**Cloud Providers:**
- AWS, Azure, or Google Cloud Platform account

### MCP Servers

Recommended MCP servers for DevOps:
- **docker**: Container management and operations
- **filesystem**: Navigate infrastructure code
- **github**: CI/CD integration and workflow management

## Roadmap

### v1.0.0 - Planning Phase (Current)
- Design Infrastructure and CICD agents
- Define skill specifications
- Create settings profiles
- Document use cases

### v1.1.0 - Container Ready (Q3 2026)
- ✅ Infrastructure agent (Docker focus)
- ✅ container-manager skill
- ✅ container-security rules
- ✅ secrets-management rules
- ✅ docker.json settings

### v1.2.0 - Kubernetes Complete (Q4 2026)
- ✅ k8s-helper skill
- ✅ deployment-safety rules
- ✅ monitoring-observability rules
- ✅ kubernetes.json settings

### v1.3.0 - Full DevOps Suite (Q1 2027)
- ✅ CICD agent
- ✅ terraform-gen skill
- ✅ pipeline-builder skill
- ✅ cloud-optimizer skill
- ✅ infrastructure-as-code rules
- ✅ terraform.json and aws.json settings

### v1.4.0 - Advanced Features (Q2 2027)
- GitOps workflows (ArgoCD, Flux)
- Service mesh integration
- Multi-cloud strategies
- Advanced observability with OpenTelemetry

## Best Practices (Future Rules)

### Infrastructure as Code
- Version control all infrastructure code
- Use modules for reusability
- Separate environments (dev, staging, prod)
- Implement state locking and remote backends
- Review plans before applying
- Tag all resources for cost tracking

### Deployment Safety
- Always use health checks (readiness, liveness)
- Implement gradual rollouts (canary, blue/green)
- Have rollback procedures ready
- Test in staging before production
- Monitor deployments in real-time
- Set up automated alerts

### Secrets Management
- Never commit secrets to version control
- Use secret management tools (Vault, AWS Secrets Manager)
- Rotate secrets regularly
- Encrypt secrets at rest and in transit
- Limit secret access with IAM/RBAC
- Audit secret access

### Container Security
- Scan images for vulnerabilities
- Use minimal base images (Alpine, distroless)
- Run as non-root user
- Update dependencies regularly
- Sign and verify images
- Implement network policies

### Monitoring & Observability
- Centralized logging (ELK, Loki, CloudWatch)
- Metrics collection (Prometheus, DataDog)
- Distributed tracing (Jaeger, Zipkin)
- Set up meaningful alerts
- Create dashboards for key metrics
- Practice chaos engineering

## Contributing

We welcome contributions to the DevOps domain!

**Needed components (all planned):**
- Infrastructure agent
- CICD agent
- Skills: container-manager, k8s-helper, terraform-gen, pipeline-builder, cloud-optimizer
- Rules: infrastructure-as-code, deployment-safety, secrets-management, container-security, monitoring-observability
- Settings: docker.json, kubernetes.json, terraform.json, aws.json

**How to contribute:**
1. Check [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines
2. Follow existing component structure (AGENT.md, config.json, etc.)
3. Include examples with real infrastructure code
4. Add comprehensive documentation
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
**Status:** Accepting design feedback and contributions
