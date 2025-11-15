#!/bin/bash
# Setup script for MERN deployment
# This script helps validate your setup

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🚀 MERN Deployment Setup Checker"
echo "=================================="

# Check Node.js
echo -n "Checking Node.js... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} $NODE_VERSION"
else
    echo -e "${RED}✗${NC} Node.js not installed"
    echo "Install from: https://nodejs.org/"
    exit 1
fi

# Check npm
echo -n "Checking npm... "
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✓${NC} $NPM_VERSION"
else
    echo -e "${RED}✗${NC} npm not installed"
    exit 1
fi

# Check Git
echo -n "Checking Git... "
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✓${NC} $GIT_VERSION"
else
    echo -e "${RED}✗${NC} Git not installed"
    exit 1
fi

# Check Docker
echo -n "Checking Docker... "
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓${NC} $DOCKER_VERSION"
else
    echo -e "${YELLOW}⚠${NC} Docker not installed (optional)"
fi

# Check project structure
echo ""
echo "Checking project structure..."

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1"
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
    else
        echo -e "${RED}✗${NC} $1/"
    fi
}

check_file "backend/package.json"
check_file "frontend/package.json"
check_file ".github/workflows/backend-ci.yml"
check_file ".github/workflows/frontend-ci.yml"
check_file "deployment/docker-compose.yml"

# Check dependencies
echo ""
echo "Checking dependencies..."

check_node_module() {
    if grep -q "$1" backend/package.json 2>/dev/null || grep -q "$1" frontend/package.json 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${YELLOW}⚠${NC} $1 (optional)"
    fi
}

check_node_module "express"
check_node_module "mongoose"
check_node_module "react"
check_node_module "react-dom"

echo ""
echo "✨ Setup check complete!"
echo ""
echo "Next steps:"
echo "1. Set up MongoDB Atlas: https://www.mongodb.com/cloud/atlas"
echo "2. Create deployment accounts: Render/Railway/Heroku"
echo "3. Update environment variables"
echo "4. Read QUICKSTART.md for step-by-step deployment"
echo ""
