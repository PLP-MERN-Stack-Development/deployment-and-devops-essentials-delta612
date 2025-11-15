#!/bin/bash
# Deployment script for Heroku

set -e

echo "🚀 Starting deployment to Heroku..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    echo "Please install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

echo -e "${BLUE}Step 1: Authenticating with Heroku...${NC}"
heroku login

echo -e "${BLUE}Step 2: Creating Heroku applications...${NC}"
heroku apps:create ${HEROKU_APP_NAME}-backend || true
heroku apps:create ${HEROKU_APP_NAME}-frontend || true

echo -e "${BLUE}Step 3: Setting environment variables...${NC}"
heroku config:set NODE_ENV=production --app ${HEROKU_APP_NAME}-backend
heroku config:set MONGODB_URI=${MONGODB_URI} --app ${HEROKU_APP_NAME}-backend
heroku config:set JWT_SECRET=${JWT_SECRET} --app ${HEROKU_APP_NAME}-backend

echo -e "${BLUE}Step 4: Deploying...${NC}"
git push heroku main

echo -e "${GREEN}✓ Deployment complete${NC}"
