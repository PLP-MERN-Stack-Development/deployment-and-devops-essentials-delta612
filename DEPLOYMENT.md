# 📚 Deployment Guide

This guide walks you through deploying your MERN stack application to production.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Database Setup (MongoDB Atlas)](#database-setup)
4. [Backend Deployment](#backend-deployment)
5. [Frontend Deployment](#frontend-deployment)
6. [CI/CD Pipeline Configuration](#cicd-pipeline-configuration)
7. [Monitoring and Logging](#monitoring-and-logging)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

Before deploying, ensure you have:

- ✅ Completed MERN application with frontend and backend
- ✅ Git repository hosted on GitHub
- ✅ Accounts created for:
  - MongoDB Atlas (database)
  - Backend hosting (Render, Railway, or Heroku)
  - Frontend hosting (Vercel, Netlify, or GitHub Pages)
- ✅ Node.js and npm installed locally
- ✅ Docker installed (optional, for local testing)

## Environment Setup

### 1. Create Environment Files

Copy the provided environment templates and fill in your values:

```bash
# Backend environment
cp .env.backend.example backend/.env.production

# Frontend environment
cp .env.frontend.example frontend/.env.production
```

### 2. Define Production Variables

Update your environment files with production values:

**Backend (.env.production):**
```
NODE_ENV=production
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/mern_prod
JWT_SECRET=your_long_secure_secret_key
CORS_ORIGIN=https://your-frontend-domain.com
```

**Frontend (.env.production):**
```
REACT_APP_API_URL=https://your-backend-domain.com/api
REACT_APP_ENABLE_ANALYTICS=true
```

## Database Setup

### MongoDB Atlas Setup

1. **Create a MongoDB Atlas Account**
   - Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - Sign up for a free account

2. **Create a Cluster**
   - Click "Create a New Cluster"
   - Choose "Shared" (free tier)
   - Select your preferred region
   - Wait for cluster to deploy (~10 minutes)

3. **Create Database User**
   - Go to "Database Access"
   - Click "Add New Database User"
   - Set username and generate password
   - Choose "Scram (SCRAM-SHA-1)"

4. **Whitelist IP Address**
   - Go to "Network Access"
   - Click "Add IP Address"
   - For production: Add your backend server IP
   - For development: Add 0.0.0.0/0 (not recommended for production)

5. **Get Connection String**
   - Click "Connect" on your cluster
   - Choose "Connect your application"
   - Copy the connection string
   - Replace \<password\> with your database user password

6. **Enable Backup**
   - Go to "Backup" section
   - Enable automatic daily backups

### Connection Pooling

For better performance, configure connection pooling in your backend:

```javascript
// backend/config/database.js
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI, {
  maxPoolSize: 10,
  minPoolSize: 5,
  socketTimeoutMS: 45000,
});
```

## Backend Deployment

### Option 1: Deploy to Render

1. **Sign up for Render**
   - Go to [Render](https://render.com/)
   - Sign up with GitHub account

2. **Create New Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select "backend" directory

3. **Configure Environment**
   - Set Environment to "Node"
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`
   - Add environment variables from your `.env.production`

4. **Deploy**
   - Click "Create Web Service"
   - Render will automatically deploy

5. **Monitor Deployment**
   - Check logs in the Render dashboard
   - Your backend URL will be displayed once deployed

### Option 2: Deploy to Railway

1. **Sign up for Railway**
   - Go to [Railway](https://railway.app/)
   - Sign up with GitHub

2. **Create New Project**
   - Click "New Project"
   - Select "Deploy from GitHub repo"

3. **Configure Environment**
   - Add environment variables
   - Set PORT to 5000

4. **Deploy**
   - Railway will automatically detect Node.js project
   - Deploy starts automatically

### Option 3: Deploy to Heroku

1. **Install Heroku CLI**
   ```bash
   npm install -g heroku
   heroku login
   ```

2. **Create Heroku App**
   ```bash
   heroku create your-app-name-backend
   ```

3. **Set Environment Variables**
   ```bash
   heroku config:set NODE_ENV=production
   heroku config:set MONGODB_URI=your_connection_string
   heroku config:set JWT_SECRET=your_secret
   ```

4. **Deploy**
   ```bash
   git push heroku main
   ```

## Frontend Deployment

### Option 1: Deploy to Vercel

1. **Sign up for Vercel**
   - Go to [Vercel](https://vercel.com/)
   - Sign up with GitHub

2. **Import Project**
   - Click "New Project"
   - Import your GitHub repository
   - Select the repository

3. **Configure Build Settings**
   - Root Directory: `frontend`
   - Build Command: `npm run build`
   - Output Directory: `build`

4. **Set Environment Variables**
   - Add `REACT_APP_API_URL` pointing to your backend

5. **Deploy**
   - Click "Deploy"
   - Vercel will build and deploy automatically

### Option 2: Deploy to Netlify

1. **Sign up for Netlify**
   - Go to [Netlify](https://www.netlify.com/)
   - Sign up with GitHub

2. **Connect Repository**
   - Click "New site from Git"
   - Authorize and select your repository

3. **Configure Build Settings**
   - Build Command: `cd frontend && npm run build`
   - Publish Directory: `frontend/build`

4. **Set Environment Variables**
   - Add environment variables in Build & Deploy settings

5. **Deploy**
   - Click "Deploy site"

### Option 3: Deploy to GitHub Pages

1. **Update package.json**
   ```json
   {
     "homepage": "https://yourusername.github.io/repo-name",
     ...
   }
   ```

2. **Install gh-pages**
   ```bash
   npm install --save-dev gh-pages
   ```

3. **Add Deploy Scripts**
   ```json
   {
     "scripts": {
       "predeploy": "npm run build",
       "deploy": "gh-pages -d build"
     }
   }
   ```

4. **Deploy**
   ```bash
   npm run deploy
   ```

## CI/CD Pipeline Configuration

### GitHub Actions Workflows

Pre-configured workflows are included in `.github/workflows/`:

1. **frontend-ci.yml** - Runs tests and builds frontend on every push
2. **backend-ci.yml** - Runs tests and builds backend on every push
3. **frontend-cd.yml** - Deploys frontend to production on main branch
4. **backend-cd.yml** - Deploys backend to production on main branch

### Setting Up Secrets

Add required secrets in GitHub Settings → Secrets:

```
MONGODB_URI - Your MongoDB connection string
JWT_SECRET - Your JWT secret key
REACT_APP_API_URL - Your backend API URL
SENTRY_DSN - Your Sentry error tracking DSN
```

For platform-specific deployment:

**Vercel:**
```
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID
```

**Netlify:**
```
NETLIFY_SITE_ID
NETLIFY_AUTH_TOKEN
```

**Railway:**
```
RAILWAY_TOKEN
```

**Heroku:**
```
HEROKU_API_KEY
HEROKU_APP_NAME
HEROKU_EMAIL
```

## Monitoring and Logging

### 1. Application Health Checks

Your backend includes health check endpoints:

```
GET /api/health - Basic health status
GET /api/health/detailed - Detailed service status
GET /api/ready - Readiness probe for Kubernetes
```

### 2. Error Tracking with Sentry

1. **Sign up for Sentry**
   - Go to [Sentry](https://sentry.io/)
   - Create new projects for frontend and backend

2. **Add Sentry DSN to Environment**
   ```
   SENTRY_DSN=your_sentry_dsn
   ```

3. **Errors automatically tracked**
   - Application crashes
   - Unhandled exceptions
   - API errors

### 3. Uptime Monitoring

1. **Sign up for UptimeRobot**
   - Go to [UptimeRobot](https://uptimerobot.com/)
   - Create new HTTP monitor

2. **Monitor Your Services**
   - Backend: `https://your-backend.com/api/health`
   - Frontend: `https://your-frontend.com`

3. **Set up Notifications**
   - Email alerts
   - Slack integration
   - Discord webhooks

### 4. Performance Monitoring

For advanced monitoring, use:

- **New Relic** - Comprehensive APM
- **DataDog** - Infrastructure monitoring
- **CloudFlare** - CDN and analytics

## Troubleshooting

### Backend Deployment Issues

**"Cannot find module" errors:**
```bash
# Reinstall dependencies
npm ci
# Check package-lock.json is committed
git add package-lock.json
git commit -m "Update dependencies"
```

**Database Connection Errors:**
```bash
# Verify connection string format
# Check IP whitelist in MongoDB Atlas
# Confirm database user credentials
```

**Port Issues:**
```bash
# Ensure PORT environment variable is set
# Check firewall rules
```

### Frontend Deployment Issues

**Build Errors:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Clear build cache
npm run build -- --reset-cache
```

**Environment Variables Not Loading:**
```bash
# Ensure variables prefixed with REACT_APP_
# Rebuild after adding new variables
npm run build
```

### CI/CD Pipeline Issues

**GitHub Actions Failing:**
1. Check GitHub Actions logs
2. Verify all secrets are set
3. Ensure branch protection rules allow deployments
4. Check build command works locally first

**Deployment Hooks Not Triggering:**
```bash
# Verify workflow file syntax
# Check branch and path filters
# Ensure .github/workflows/ is committed to main branch
```

## Maintenance

### Database Backups

1. **MongoDB Atlas Automated Backups**
   - Enabled by default
   - Stored for 7 days (free tier)
   - Upgrade for longer retention

2. **Manual Backups**
   ```bash
   mongodump --uri "mongodb+srv://..." --out backup_$(date +%Y%m%d)
   ```

### Regular Updates

- Update dependencies monthly: `npm update`
- Check security vulnerabilities: `npm audit`
- Review and merge dependabot PRs

### Monitoring Schedule

- Daily: Check error tracking (Sentry)
- Weekly: Review performance metrics
- Monthly: Check uptime reports
- Quarterly: Security audit and dependency updates

## Next Steps

- [ ] Set up MongoDB Atlas cluster
- [ ] Deploy backend to production
- [ ] Deploy frontend to production
- [ ] Configure CI/CD pipelines
- [ ] Set up error tracking (Sentry)
- [ ] Enable uptime monitoring
- [ ] Document deployment URLs
- [ ] Set up custom domain (optional)
- [ ] Configure HTTPS/SSL
- [ ] Create runbook for incident response

---

**Need Help?** Check the troubleshooting section or review platform-specific documentation.
