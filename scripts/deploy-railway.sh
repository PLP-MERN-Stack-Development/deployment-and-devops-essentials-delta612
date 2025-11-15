#!/bin/bash
# Deployment script for Railway.app

set -e

echo "🚀 Starting deployment to Railway..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${BLUE}Installing Railway CLI...${NC}"
    npm install -g @railway/cli
fi

echo -e "${BLUE}Step 1: Authenticating with Railway...${NC}"
railway login

echo -e "${BLUE}Step 2: Building and deploying...${NC}"
railway up

echo -e "${GREEN}✓ Deployment complete${NC}"
echo -e "${BLUE}Visit your Railway dashboard to monitor the deployment${NC}"
