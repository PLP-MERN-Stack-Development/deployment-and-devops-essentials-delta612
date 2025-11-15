# ⚡ Quick Start Guide

Get your MERN application deployed in minutes!

## 1️⃣ Prerequisites (5 minutes)

Before you start, create accounts at:
- [ ] [GitHub](https://github.com) - Push your code
- [ ] [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) - Database
- [ ] **Choose ONE for Backend:**
  - [ ] [Render](https://render.com) - Recommended (free tier)
  - [ ] [Railway](https://railway.app)
  - [ ] [Heroku](https://heroku.com)
- [ ] **Choose ONE for Frontend:**
  - [ ] [Vercel](https://vercel.com) - Recommended (free tier)
  - [ ] [Netlify](https://netlify.com)
  - [ ] [GitHub Pages](https://pages.github.com)

## 2️⃣ Database Setup (10 minutes)

### MongoDB Atlas

```bash
# 1. Go to https://www.mongodb.com/cloud/atlas
# 2. Create cluster (free tier)
# 3. Create database user
# 4. Add IP whitelist (0.0.0.0/0 for development)
# 5. Copy connection string: mongodb+srv://user:pass@cluster.mongodb.net/dbname
```

Add to GitHub Secrets:
```
MONGODB_URI = your_connection_string
```

## 3️⃣ Backend Deployment (10 minutes)

### Option A: Deploy to Render

```bash
# 1. Go to https://render.com
# 2. Connect GitHub account
# 3. Create new Web Service
# 4. Select your repository and "backend" folder
# 5. Set environment:
#    - Build Command: npm install && npm run build
#    - Start Command: npm start
# 6. Add environment variables:
#    - MONGODB_URI
#    - JWT_SECRET (generate a strong secret)
#    - NODE_ENV=production
# 7. Click "Deploy"
# 8. Wait 2-3 minutes for deployment
# 9. Copy your backend URL (e.g., https://backend.render.com)
```

### Option B: Deploy to Railway

```bash
# 1. Go to https://railway.app
# 2. Create new project → Deploy from GitHub
# 3. Select your repository
# 4. Railway auto-detects Node.js
# 5. Add environment variables
# 6. Deploy starts automatically
```

### Option C: Deploy to Heroku

```bash
# 1. Install Heroku CLI: npm install -g heroku
# 2. heroku login
# 3. heroku create your-app-backend
# 4. heroku config:set MONGODB_URI="your_uri"
# 5. heroku config:set JWT_SECRET="your_secret"
# 6. git push heroku main
```

## 4️⃣ Frontend Deployment (10 minutes)

### Option A: Deploy to Vercel (Recommended)

```bash
# 1. Go to https://vercel.com
# 2. Import project from GitHub
# 3. Select your repository
# 4. Framework: Next.js / Create React App
# 5. Root Directory: frontend
# 6. Build Command: npm run build
# 7. Output Directory: build
# 8. Environment Variable:
#    - REACT_APP_API_URL = https://your-backend-url/api
# 9. Click Deploy
# 10. Wait 2-3 minutes
# 11. Copy your frontend URL (e.g., https://app.vercel.app)
```

### Option B: Deploy to Netlify

```bash
# 1. Go to https://netlify.com
# 2. Connect GitHub → New site from Git
# 3. Select your repository
# 4. Build Command: cd frontend && npm run build
# 5. Publish Directory: frontend/build
# 6. Add Environment:
#    REACT_APP_API_URL = your-backend-url/api
# 7. Deploy
```

### Option C: Deploy to GitHub Pages

```bash
# 1. Update frontend/package.json:
#    "homepage": "https://yourusername.github.io/repo-name"
# 2. npm install --save-dev gh-pages
# 3. Add scripts:
#    "predeploy": "npm run build"
#    "deploy": "gh-pages -d build"
# 4. npm run deploy
```

## 5️⃣ Setup CI/CD (5 minutes)

### Add GitHub Secrets

1. Go to Settings → Secrets and variables → Actions
2. Add these secrets:

```
MONGODB_URI               = your_mongodb_connection_string
JWT_SECRET                = your_secret_key_here
REACT_APP_API_URL         = https://your-backend.com/api
SENTRY_DSN               = (optional, for error tracking)

# Platform-specific (choose one):

# For Vercel:
VERCEL_TOKEN             = your_token
VERCEL_ORG_ID            = your_org_id
VERCEL_PROJECT_ID        = your_project_id

# For Netlify:
NETLIFY_SITE_ID          = your_site_id
NETLIFY_AUTH_TOKEN       = your_token

# For Render:
RENDER_DEPLOY_HOOK       = your_webhook_url
```

### Update Workflow Files

Uncomment your deployment method in:
- `.github/workflows/frontend-cd.yml` - Frontend deployment
- `.github/workflows/backend-cd.yml` - Backend deployment

## 6️⃣ Update README (5 minutes)

Update your main `README.md`:

```markdown
# Your MERN App

## Deployed URLs
- **Frontend**: https://your-frontend-url.com
- **Backend**: https://your-backend-url.com/api

## Features
- User authentication
- Data management
- Real-time updates

## Deployment
- Frontend hosted on [Vercel/Netlify]
- Backend hosted on [Render/Railway]
- Database on MongoDB Atlas
- CI/CD with GitHub Actions

## Getting Started
...
```

## 7️⃣ First Deployment Test

```bash
# 1. Make a small change to test CI/CD
echo "# Updated" >> README.md

# 2. Commit and push
git add .
git commit -m "Test deployment"
git push origin main

# 3. Watch GitHub Actions
# Go to Actions tab and watch the workflow

# 4. Check deployed application
# Visit your frontend and backend URLs
```

## 🧪 Verification Checklist

After deployment:

- [ ] Frontend loads without errors
- [ ] Backend API responds to requests
- [ ] Database connection works
- [ ] Authentication works
- [ ] GitHub Actions CI passes
- [ ] CI/CD deploys automatically on push
- [ ] No console errors in browser
- [ ] No errors in backend logs

## 📊 Monitoring Setup

### Error Tracking (Optional but Recommended)

```bash
# 1. Sign up for Sentry: https://sentry.io
# 2. Create projects for frontend and backend
# 3. Add DSN to environment variables:
#    SENTRY_DSN = your_dsn
# 4. Errors now tracked automatically
```

### Uptime Monitoring

```bash
# 1. Sign up for UptimeRobot: https://uptimerobot.com
# 2. Add monitor: https://your-backend.com/api/health
# 3. Set interval: 5 minutes
# 4. Get alerts if service is down
```

## 🚀 Done!

Your MERN application is now deployed! 🎉

**Next Steps:**
1. Test all features
2. Share your URLs
3. Monitor for issues
4. Continue development and push to auto-deploy

## ❓ Troubleshooting

### Deployment Failed

1. Check GitHub Actions logs
2. Verify environment variables are set
3. Ensure all secrets are correct
4. Check platform-specific documentation

### API Connection Error

1. Verify backend URL in frontend `.env`
2. Check CORS settings in backend
3. Ensure backend is running
4. Check network in browser DevTools

### Database Connection Error

1. Verify MongoDB URI
2. Check IP whitelist in MongoDB Atlas
3. Confirm database user credentials
4. Check network connectivity

## 📚 Documentation

Read detailed guides:
- [DEPLOYMENT.md](DEPLOYMENT.md) - Comprehensive guide
- [CI-CD-GUIDE.md](CI-CD-GUIDE.md) - GitHub Actions setup
- [MONITORING.md](MONITORING.md) - Error tracking & monitoring
- [DOCKER.md](DOCKER.md) - Docker deployment

---

**Questions?** Refer to the detailed guides or platform documentation.
