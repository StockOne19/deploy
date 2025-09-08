#!/bin/bash

set -e

echo "Starting deployment..."

if command -v docker &> /dev/null; then
    echo "Pulling latest images..."
    docker-compose pull
fi

echo "Restarting services..."
docker-compose up -d

echo "Running health check..."
sleep 15

if ./health-check.sh; then
    echo "Deployment successful"
    docker image prune -f
else
    echo "Deployment failed"
    exit 1
fi

echo "Deployment completed"