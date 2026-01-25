#!/bin/bash
# Update system packages
apt update -y

# Install Docker
apt install -y docker.io

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Wait for Docker daemon to be ready
sleep 10

# Pull application images from Docker Hub
docker pull akhilkhatri/devops-backend:latest

docker pull akhilkhatri/devops-frontend:latest

# Run backend container
docker run -d -p 8000:8000 --name backend akhilkhatri/devops-backend:latest

# Run frontend container
docker run -d -p 80:80 --name frontend -e VITE_API_URL=http://backend:8000 akhilkhatri/devops-frontend:latest
