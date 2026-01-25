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

docker network create devops-net

# Run backend container
docker run -d --name backend --network devops-net --restart unless-stopped -p 8000:8000 akhilkhatri/devops-backend:latest

# Run frontend container
docker run -d --name frontend --network devops-net --restart unless-stopped -p 80:80 akhilkhatri/devops-frontend:latest

