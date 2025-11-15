# 🐳 Docker Deployment Guide

This guide explains how to use Docker for local development and production deployment.

## Prerequisites

- Docker Desktop installed ([Download](https://www.docker.com/products/docker-desktop))
- Docker Compose (included with Docker Desktop)
- Your MERN application files

## Project Structure

```
project/
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
├── deployment/
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   ├── nginx.conf
│   ├── docker-compose.yml
│   └── docker-compose-monitoring.yml
└── monitoring/
    └── ...
```

## Building Docker Images

### Backend Image

Create `backend/Dockerfile`:

```dockerfile
FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build --if-present

EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:5000/api/health || exit 1

CMD ["npm", "start"]
```

Build image:
```bash
docker build -f deployment/Dockerfile.backend -t mern-backend:latest ./backend
```

### Frontend Image

Create `frontend/Dockerfile`:

```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

ARG REACT_APP_API_URL=http://localhost:5000/api
ENV REACT_APP_API_URL=$REACT_APP_API_URL

RUN npm run build

FROM nginx:alpine
COPY deployment/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Build image:
```bash
docker build -f deployment/Dockerfile.frontend -t mern-frontend:latest ./frontend
```

## Docker Compose

### Local Development

```bash
# Start all services
docker-compose -f deployment/docker-compose.yml up

# Start in background
docker-compose -f deployment/docker-compose.yml up -d

# View logs
docker-compose -f deployment/docker-compose.yml logs -f

# Stop services
docker-compose -f deployment/docker-compose.yml down
```

### Services Included

1. **Backend** - Node.js Express API on port 5000
2. **Frontend** - React app on port 80
3. **MongoDB** - Database on port 27017

### Environmental Variables

Create `.env` in root directory:

```
JWT_SECRET=your_secret_key
MONGODB_PASSWORD=your_password
REACT_APP_API_URL=http://localhost:5000/api
```

## Production Deployment

### Using Docker with Render

1. **Push Docker Image to Container Registry**

```bash
# Build image
docker build -f deployment/Dockerfile.backend -t mern-backend:latest .

# Tag for registry
docker tag mern-backend:latest <registry>/mern-backend:latest

# Push
docker push <registry>/mern-backend:latest
```

2. **Deploy on Render**

- Choose "Docker" environment
- Set container image URL
- Configure environment variables
- Deploy

### Using Docker with Railway

1. **Connect Repository**
   - Railway automatically detects Dockerfile

2. **Build and Deploy**
   - Railway builds image
   - Deploys container
   - Manages scaling

## Docker Best Practices

### 1. Use Alpine Images

```dockerfile
# Good - smaller image size
FROM node:20-alpine

# Avoid - larger image size
FROM node:20
```

### 2. Multi-Stage Builds

```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/index.js"]
```

### 3. Layer Caching

Order Dockerfile commands to maximize cache:

```dockerfile
# Copy package first (changes less frequently)
COPY package*.json ./
RUN npm ci

# Copy source code (changes more frequently)
COPY . .
RUN npm run build
```

### 4. Security

```dockerfile
# Run as non-root user
RUN useradd -m -u 1000 appuser
USER appuser

# Don't run as root
# USER nobody  # Alternative

# Scan for vulnerabilities
# docker scan mern-backend:latest
```

### 5. Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:5000/api/health || exit 1
```

## Useful Docker Commands

```bash
# Build image
docker build -t my-app:latest .

# Run container
docker run -p 5000:5000 my-app:latest

# Run with environment variables
docker run -e NODE_ENV=production -p 5000:5000 my-app:latest

# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View images
docker images

# Logs from container
docker logs <container_id>

# Execute command in container
docker exec -it <container_id> /bin/sh

# Stop container
docker stop <container_id>

# Remove container
docker rm <container_id>

# Remove image
docker rmi <image_id>

# Prune unused resources
docker system prune
```

## Troubleshooting

### Port Already in Use

```bash
# Find what's using the port
lsof -i :5000

# Kill process
kill -9 <PID>

# Or use different port
docker run -p 5001:5000 my-app:latest
```

### Container Won't Start

```bash
# View logs
docker logs <container_id>

# Run interactively
docker run -it my-app:latest /bin/sh
```

### Slow Builds

```bash
# Clear build cache
docker build --no-cache -t my-app:latest .

# Check layer sizes
docker history my-app:latest
```

## Orchestration

### For Advanced Production Deployments

**Kubernetes** - Container orchestration
```bash
kubectl apply -f deployment.yaml
```

**Docker Swarm** - Built-in orchestration
```bash
docker service create --name backend my-app:latest
```

## Monitoring Docker

### Docker Stats

```bash
# Real-time container metrics
docker stats

# For specific container
docker stats <container_id>
```

### Included Monitoring

```bash
# Start monitoring stack
docker-compose -f monitoring/docker-compose-monitoring.yml up
```

Access:
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Specification](https://docs.docker.com/compose/compose-file/)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---

**Next Steps:**
- [ ] Create Dockerfile for backend
- [ ] Create Dockerfile for frontend
- [ ] Test with docker-compose locally
- [ ] Push images to registry
- [ ] Deploy to production
