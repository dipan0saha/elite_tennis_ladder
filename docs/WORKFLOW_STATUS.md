# Workflow Status Dashboard

## All Workflows

| Workflow | Status | Purpose |
|----------|--------|---------|
| Flutter CI | [![Flutter CI](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/flutter-ci.yml) | Continuous integration for code quality, testing, and builds |
| Deploy Staging | [![Deploy Staging](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/deploy-staging.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/deploy-staging.yml) | Automated staging deployment |
| Deploy Production | [![Deploy Production](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/deploy-production.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/deploy-production.yml) | Production deployment |
| Security Scan | [![Security Scan](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/security-scan.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/security-scan.yml) | Security and vulnerability scanning |
| Release | [![Release](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/release.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/release.yml) | Automated release creation |
| PR Labeler | [![PR Labeler](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/pr-labeler.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/pr-labeler.yml) | Automatic PR labeling |

## Quick Links

- [All Workflow Runs](https://github.com/dipan0saha/elite_tennis_ladder/actions)
- [CI/CD Documentation](CI_CD.md)
- [Security Alerts](https://github.com/dipan0saha/elite_tennis_ladder/security)
- [Releases](https://github.com/dipan0saha/elite_tennis_ladder/releases)

## Workflow Details

### 🔄 Continuous Integration (CI)
**Trigger:** Every push and pull request  
**Duration:** ~5-10 minutes  
**Platforms:** Android, iOS, Web  

**Steps:**
1. Code analysis and formatting check
2. Unit and widget tests with coverage
3. Platform-specific builds

### 🚀 Deployment Pipelines

#### Staging
**Trigger:** Push to `develop` branch  
**Target:** Staging environment  
**Auto-deploy:** Yes  

#### Production
**Trigger:** Push to `main` or version tags  
**Target:** Production environment  
**Requires:** Manual approval  

### 🔒 Security Scanning
**Trigger:** PR, push, and weekly schedule  
**Scans:**
- Dependency vulnerabilities
- Code quality issues
- Security best practices

**Tools:**
- CodeQL
- Dependency Review
- Flutter Analyzer

### 📦 Release Automation
**Trigger:** Version tags (e.g., `v1.0.0`)  
**Generates:**
- GitHub release with notes
- APK and AAB files
- Web build artifacts

## Status Legend

| Icon | Status | Meaning |
|------|--------|---------|
| ✅ | Passing | All checks successful |
| ❌ | Failing | One or more checks failed |
| 🟡 | Pending | Workflow in progress |
| ⚪ | Skipped | Workflow not triggered |
| 📋 | Queued | Waiting to start |

## Recent Activity

Check the [Actions tab](https://github.com/dipan0saha/elite_tennis_ladder/actions) for:
- Recent workflow runs
- Build artifacts
- Workflow logs
- Job summaries

## Troubleshooting

If a workflow fails:
1. Click the failing status badge
2. Review the workflow logs
3. Check the specific job that failed
4. Review error messages
5. Fix issues and push again

For detailed troubleshooting, see [CI/CD Documentation](CI_CD.md#troubleshooting).

## Configuration Files

All workflow configurations are in `.github/workflows/`:
- `flutter-ci.yml` - Main CI pipeline
- `deploy-staging.yml` - Staging deployment
- `deploy-production.yml` - Production deployment
- `security-scan.yml` - Security scanning
- `release.yml` - Release automation
- `pr-labeler.yml` - PR labeling

## Monitoring

### Metrics to Watch
- Build success rate
- Test pass rate
- Code coverage percentage
- Deployment frequency
- Security alerts

### Notifications
Configure notifications in GitHub settings:
- Email on workflow failure
- Slack integration (planned)
- Discord webhooks (planned)

---

Last updated: 2024-12-23
