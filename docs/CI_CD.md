# CI/CD Pipeline Documentation

## Overview

Elite Tennis Ladder uses GitHub Actions for continuous integration, continuous deployment, and automated workflows. This document describes all CI/CD pipelines configured for the project.

## Workflows

### 1. Flutter CI (`flutter-ci.yml`)

**Triggers:**
- Push to `main`, `develop`, `copilot/**` branches
- Pull requests to `main`, `develop`
- Manual dispatch

**Jobs:**
1. **Analyze and Test**
   - Runs Flutter analyzer with fatal warnings
   - Executes all unit and widget tests
   - Generates code coverage reports
   - Uploads coverage to Codecov
   - Checks code formatting

2. **Build Android APK**
   - Builds release APK
   - Uploads artifact (14-day retention)
   - Runs only after tests pass

3. **Build iOS**
   - Builds iOS app without code signing
   - Validates iOS compatibility
   - Runs only after tests pass

4. **Build Web**
   - Builds web application
   - Uploads artifact (14-day retention)
   - Runs only after tests pass

**Badge:** 
```markdown
[![Flutter CI](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/flutter-ci.yml)
```

### 2. Deploy to Staging (`deploy-staging.yml`)

**Triggers:**
- Push to `develop` branch
- Manual dispatch

**Environment:** `staging`

**Process:**
1. Runs full test suite
2. Builds web app with staging configuration
3. Uploads staging artifacts
4. Ready for deployment to staging environment

**Notes:**
- Actual deployment step requires hosting platform configuration (Firebase Hosting, Netlify, Vercel, etc.)
- Artifacts are retained for 7 days

### 3. Deploy to Production (`deploy-production.yml`)

**Triggers:**
- Push to `main` branch
- Tags matching `v*.*.*` pattern
- Manual dispatch

**Environment:** `production`

**Process:**
1. Runs full test suite
2. Builds web app with production configuration
3. Builds Android APK for production
4. Uploads production artifacts
5. Ready for deployment to production environment

**Notes:**
- Artifacts are retained for 30 days
- Requires environment protection rules in GitHub settings
- Actual deployment requires hosting platform configuration

### 4. Security Scan (`security-scan.yml`)

**Triggers:**
- Push to `main`, `develop` branches
- Pull requests to `main`, `develop`
- Scheduled: Every Monday at 9 AM UTC
- Manual dispatch

**Jobs:**
1. **Dependency Review**
   - Analyzes dependency changes in PRs
   - Flags vulnerable dependencies
   - Fails on moderate+ severity issues

2. **CodeQL Analysis**
   - Performs static security analysis
   - Scans for common vulnerabilities
   - Creates security alerts

3. **Flutter Security Check**
   - Checks for outdated packages
   - Runs Flutter analyzer with strict checks
   - Validates code quality

### 5. Automated Release (`release.yml`)

**Triggers:**
- Tags matching `v*.*.*` pattern (e.g., v1.0.0)

**Process:**
1. Runs full test suite
2. Builds all platforms (Android APK, AAB, Web)
3. Generates changelog from commits
4. Creates GitHub release with:
   - Release notes
   - APK and AAB files
   - Web build artifacts
5. Artifacts retained for 90 days

**Usage:**
```bash
# Create and push a new version tag
git tag v1.0.0
git push origin v1.0.0
```

### 6. PR Labeler (`pr-labeler.yml`)

**Triggers:**
- Pull request opened, edited, synchronized, or reopened

**Features:**
1. **File-based labeling**
   - Automatically labels PRs based on changed files
   - Categories: docs, tests, code, config, ui, backend, ci-cd, dependencies

2. **Size labeling**
   - XS: 0-10 lines
   - S: 11-100 lines
   - M: 101-500 lines
   - L: 501-1000 lines
   - XL: 1000+ lines

3. **Semantic commit validation**
   - Validates PR title follows conventional commits
   - Required types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

## Environment Configuration

### GitHub Environments

Configure these environments in GitHub repository settings:

1. **Staging**
   - URL: `https://staging.elitetennisladder.com`
   - Auto-deploy from `develop` branch
   - No approval required

2. **Production**
   - URL: `https://elitetennisladder.com`
   - Deploys from `main` branch and version tags
   - Requires approval from maintainers
   - Production secrets and variables

### Required Secrets

Configure these in GitHub repository settings → Secrets and variables → Actions:

#### Optional (for enhanced features):
- `CODECOV_TOKEN`: For Codecov coverage reporting
- `SLACK_WEBHOOK`: For Slack notifications (future enhancement)
- `FIREBASE_TOKEN`: If using Firebase Hosting
- `NETLIFY_AUTH_TOKEN`: If using Netlify

## Branch Protection Rules

### Main Branch
- Require pull request reviews (1 approver)
- Require status checks to pass:
  - Analyze and Test
  - Build Android APK
  - Build iOS
  - Build Web
- Require branches to be up to date
- Require conversation resolution
- No force pushes
- No deletions

### Develop Branch
- Require status checks to pass:
  - Analyze and Test
- Require pull request reviews (optional)
- Allow force pushes from admins (for cleanup)

## Artifact Management

### Retention Periods
- **CI builds:** 14 days
- **Staging deployments:** 7 days
- **Production deployments:** 30 days
- **Releases:** 90 days

### Download Artifacts
1. Go to Actions tab in GitHub
2. Select workflow run
3. Scroll to Artifacts section
4. Download desired artifact

## Code Quality Standards

### Automated Checks
1. **Format:** `dart format --output=none --set-exit-if-changed .`
2. **Analyze:** `flutter analyze --fatal-infos`
3. **Tests:** `flutter test --coverage --reporter expanded`
4. **Coverage:** Uploaded to Codecov

### Quality Gates
- Code must be formatted correctly
- No analyzer warnings or errors
- All tests must pass
- Test coverage tracked (target: >80%)
- No high/critical security vulnerabilities

## Deployment Process

### Staging Deployment
1. Merge feature branch to `develop`
2. Automated workflow triggers
3. Tests run automatically
4. Web build created
5. Deploy to staging environment (manual step currently)
6. QA team validates

### Production Deployment

#### Option 1: Main Branch Push
1. Merge `develop` to `main` (via PR)
2. Automated workflow triggers
3. Full test suite runs
4. All platforms build
5. Deploy to production (manual step currently)

#### Option 2: Release Tag
1. Create version tag: `git tag v1.0.0`
2. Push tag: `git push origin v1.0.0`
3. Release workflow triggers
4. GitHub release created automatically
5. Artifacts attached to release
6. Deploy to production (manual step currently)

## Monitoring and Alerts

### Workflow Notifications
- GitHub automatically notifies on workflow failures
- Check Actions tab for detailed logs
- Review job summaries for quick status

### Security Alerts
- CodeQL alerts appear in Security tab
- Dependabot alerts for vulnerable dependencies
- Dependency Review blocks risky PRs

## Troubleshooting

### Common Issues

#### Build Failures
1. Check workflow logs in Actions tab
2. Verify Flutter version compatibility
3. Ensure all dependencies are available
4. Check for code formatting issues

#### Test Failures
1. Run tests locally: `flutter test`
2. Check for environment-specific issues
3. Review test logs in workflow output
4. Ensure test data is available

#### Deployment Issues
1. Verify environment configuration
2. Check secrets and variables
3. Review deployment logs
4. Validate artifact contents

### Getting Help
- Review workflow logs
- Check [GitHub Actions documentation](https://docs.github.com/en/actions)
- Open issue with `ci-cd` label
- Contact DevOps team

## Future Enhancements

### Planned Features
1. **Automated deployments**
   - Firebase Hosting integration
   - Netlify deployment
   - App Store/Play Store publishing

2. **Enhanced testing**
   - Integration tests
   - E2E tests with Flutter Drive
   - Performance benchmarks

3. **Additional checks**
   - License compliance
   - Dependency audits
   - Accessibility testing

4. **Notifications**
   - Slack integration
   - Email notifications
   - Discord webhooks

5. **Advanced deployments**
   - Blue-green deployments
   - Canary releases
   - Rollback automation

## Best Practices

### For Developers
1. Always create feature branches
2. Keep PRs focused and small
3. Write meaningful commit messages
4. Include tests with code changes
5. Review CI feedback promptly
6. Fix issues before merging

### For Maintainers
1. Review and approve deployments
2. Monitor security alerts
3. Keep workflows updated
4. Maintain environment secrets
5. Review and improve pipelines
6. Document workflow changes

## Resources

- [Flutter CI/CD Best Practices](https://flutter.dev/docs/deployment/cd)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

## Changelog

### 2024-12-23
- Initial CI/CD pipeline setup
- Added Flutter CI workflow
- Implemented deployment workflows (staging/production)
- Added security scanning
- Implemented automated releases
- Added PR labeling automation
- Created comprehensive documentation

---

For questions or issues related to CI/CD, please open an issue with the `ci-cd` label.
