#!/bin/bash
# Local testing script with Docker Compose

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐳 Starting local MERN stack with Docker Compose...${NC}"

# Check if Docker is running
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker Desktop."
    exit 1
fi

# Start services
echo -e "${BLUE}Starting services...${NC}"
docker-compose -f deployment/docker-compose.yml up --build

echo -e "${GREEN}✓ Services are running!${NC}"
echo ""
echo "Access your application:"
echo "  Frontend: http://localhost:80"
echo "  Backend API: http://localhost:5000/api"
echo "  Database: mongodb://localhost:27017"
echo ""
echo "Press Ctrl+C to stop services"
