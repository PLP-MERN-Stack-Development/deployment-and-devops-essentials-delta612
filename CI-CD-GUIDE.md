# 🔧 CI/CD Pipeline Guide

This guide explains how to set up and use the continuous integration and continuous deployment (CI/CD) pipelines.

## Overview

The CI/CD pipeline automates:
- **Testing** - Runs unit tests on every push
- **Linting** - Checks code quality
- **Building** - Compiles and builds your application
- **Deploying** - Automatically deploys to production on main branch

## Workflow Files

### 1. Frontend CI (`frontend-ci.yml`)

Triggers on: Every push to frontend/ folder

**Steps:**
1. Check out code
2. Setup Node.js with caching
3. Install dependencies
4. Run linting (ESLint)
5. Run tests with coverage
6. Build application
7. Upload coverage to Codecov

### 2. Backend CI (`backend-ci.yml`)

Triggers on: Every push to backend/ folder

**Steps:**
1. Check out code
2. Setup Node.js with caching
3. Start MongoDB service
4. Install dependencies
5. Run linting
6. Run tests with coverage
7. Upload coverage to Codecov
8. Build application (if applicable)

### 3. Frontend CD (`frontend-cd.yml`)

Triggers on: Push to main branch + frontend/ changes

**Steps:**
1. Check out code
2. Build production bundle
3. Deploy to Vercel/Netlify/GitHub Pages

### 4. Backend CD (`backend-cd.yml`)

Triggers on: Push to main branch + backend/ changes

**Steps:**
1. Check out code
2. Install dependencies
3. Run tests
4. Deploy to Render/Railway/Heroku

## Setting Up Secrets

GitHub Actions require secrets for sensitive information.

### Required Secrets

Go to **GitHub Repository → Settings → Secrets and variables → Actions**

**General Secrets:**
```
MONGODB_URI          - MongoDB connection string
JWT_SECRET           - JWT signing secret
REACT_APP_API_URL    - Backend API URL for frontend
SENTRY_DSN           - Sentry error tracking DSN
```

**Deployment-Specific Secrets:**

**For Vercel:**
```
VERCEL_TOKEN         - Your Vercel API token
VERCEL_ORG_ID        - Organization ID
VERCEL_PROJECT_ID    - Project ID
```

**For Netlify:**
```
NETLIFY_SITE_ID      - Site ID
NETLIFY_AUTH_TOKEN   - API token
```

**For Render:**
```
RENDER_DEPLOY_HOOK   - Deploy webhook URL
```

**For Railway:**
```
RAILWAY_TOKEN        - API token
```

**For Heroku:**
```
HEROKU_API_KEY       - API key
HEROKU_APP_NAME      - App name
HEROKU_EMAIL         - Email address
```

### How to Add Secrets

1. Go to repository Settings
2. Click "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Enter name and value
5. Click "Add secret"

## Customizing Workflows

### Modifying CI Checks

Edit `.github/workflows/frontend-ci.yml` or `backend-ci.yml`:

```yaml
# Change Node.js versions to test
strategy:
  matrix:
    node-version: [16.x, 18.x, 20.x]

# Add custom test commands
- name: Run custom tests
  run: npm run test:integration
```

### Modifying CD Deployment

Edit `.github/workflows/frontend-cd.yml` or `backend-cd.yml`:

```yaml
# Uncomment your deployment method
# For Vercel:
- name: Deploy to Vercel
  uses: vercel/action@master

# For Netlify:
- name: Deploy to Netlify
  uses: netlify/actions/cli@master
```

## Workflow Status

### Viewing Workflow Runs

1. Go to GitHub repository
2. Click "Actions" tab
3. View workflow status:
   - 🟢 **Success** - All checks passed, deployment initiated
   - 🟡 **Running** - Workflow in progress
   - 🔴 **Failed** - Checks failed or deployment error

### Viewing Logs

1. Click on workflow run
2. Expand job to see detailed logs
3. Expand step to see step output

## Common Issues

### Workflow Not Triggering

**Problem:** Workflow file exists but doesn't run

**Solutions:**
- Ensure workflow file is in `.github/workflows/`
- Verify branch and path filters in `on:` section
- Check if branch is `main` or `develop`
- Ensure changes are to the correct folder (frontend/ or backend/)

### Tests Failing in CI but Passing Locally

**Common Causes:**
- Different Node.js version
- Environment variables not set
- Missing dependencies
- Mock data differs

**Solutions:**
```bash
# Use same Node version as CI
nvm use 20

# Install exact dependencies
npm ci

# Run tests in CI mode
CI=true npm test
```

### Deployment Failing

**Check logs for:**
- Missing environment variables
- Secrets not set in GitHub
- Build command errors
- Invalid API endpoints

**Verify:**
```bash
# Test build locally
npm run build

# Verify environment variables
echo $REACT_APP_API_URL
```

## Best Practices

### 1. Commit Regularly

```bash
git commit -m "Add new feature"
git push
```

Small, focused commits help identify issues quickly.

### 2. Use Branch Protection

Prevent merging to main if CI fails:

1. Go to Settings → Branches
2. Add branch protection rule for `main`
3. Require status checks to pass
4. Require code reviews

### 3. Monitor Deployments

1. Check GitHub Actions status
2. Verify deployment URLs work
3. Check application logs
4. Monitor error tracking (Sentry)

### 4. Rollback Plan

If deployment breaks production:

```bash
# Revert last commit
git revert HEAD
git push

# GitHub Actions will automatically deploy the revert
```

## Advanced Configuration

### Environment-Specific Deployments

```yaml
# Deploy to staging on develop branch
on:
  push:
    branches: [develop, main]

jobs:
  deploy:
    environment: ${{ github.ref == 'refs/heads/main' && 'production' || 'staging' }}
```

### Conditional Deployments

```yaml
# Only deploy if tests pass
deploy:
  needs: test
  if: success()
  runs-on: ubuntu-latest
```

### Parallel Jobs

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    # Runs in parallel with other test jobs

  build:
    runs-on: ubuntu-latest
    # Runs in parallel with test
```

## Monitoring

### Workflow Statistics

GitHub provides metrics on:
- Workflow run duration
- Job duration
- Step duration
- Success/failure rates

View in: **Actions → Workflows → [Workflow Name]**

### Setting Alerts

GitHub sends notifications for:
- Workflow failures
- Required status check failures
- Deployment completions

Configure in: **Settings → Notifications**

## Security Best Practices

1. **Use Short-Lived Secrets**
   - Rotate secrets regularly
   - Remove old tokens

2. **Principle of Least Privilege**
   - Give workflows only necessary permissions
   - Use specific IAM roles

3. **Audit Workflow Usage**
   - Review workflow logs regularly
   - Check for unauthorized access

4. **Encrypt Secrets**
   - GitHub encrypts secrets at rest
   - Secrets never shown in logs

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Security Hardening](https://docs.github.com/en/actions/security-guides)

---

**Next Steps:**
- [ ] Configure all required secrets
- [ ] Test CI pipeline on develop branch
- [ ] Enable branch protection rules
- [ ] Monitor first deployment
- [ ] Set up rollback procedures
