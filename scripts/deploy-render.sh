#!/bin/bash
# Deployment script for Render.com

set -e

echo "🚀 Starting deployment to Render..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Building backend...${NC}"
cd backend
npm install
npm run build
echo -e "${GREEN}✓ Backend build complete${NC}"
cd ..

echo -e "${BLUE}Step 2: Building frontend...${NC}"
cd frontend
npm install
REACT_APP_API_URL=$REACT_APP_API_URL npm run build
echo -e "${GREEN}✓ Frontend build complete${NC}"
cd ..

echo -e "${BLUE}Step 3: Pushing to GitHub...${NC}"
git add .
git commit -m "Deployment build - $(date +'%Y-%m-%d %H:%M:%S')" || true
git push origin main

echo -e "${GREEN}✓ Code pushed to GitHub${NC}"
echo -e "${GREEN}✓ Render will automatically deploy your application${NC}"
echo -e "${BLUE}Check your Render dashboard for deployment status${NC}"
