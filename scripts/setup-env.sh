#!/bin/bash
# Environment setup helper

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📝 Setting up environment files...${NC}"

# Create backend .env
if [ ! -f "backend/.env.production" ]; then
    echo "Creating backend/.env.production..."
    cp .env.backend.example backend/.env.production
    echo -e "${GREEN}✓${NC} Created backend/.env.production"
    echo "⚠️  Update backend/.env.production with your values"
else
    echo "backend/.env.production already exists"
fi

# Create frontend .env
if [ ! -f "frontend/.env.production" ]; then
    echo "Creating frontend/.env.production..."
    cp .env.frontend.example frontend/.env.production
    echo -e "${GREEN}✓${NC} Created frontend/.env.production"
    echo "⚠️  Update frontend/.env.production with your values"
else
    echo "frontend/.env.production already exists"
fi

echo ""
echo -e "${GREEN}Environment setup complete!${NC}"
echo ""
echo "Required values to update:"
echo "  Backend:"
echo "    - MONGODB_URI (from MongoDB Atlas)"
echo "    - JWT_SECRET (generate a secure secret)"
echo "    - CORS_ORIGIN (your frontend URL)"
echo ""
echo "  Frontend:"
echo "    - REACT_APP_API_URL (your backend URL)"
