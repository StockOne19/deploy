#!/bin/bash

set -e

SERVICE_NAME=$1

echo "Starting deployment..."

if [ -z "$SERVICE_NAME" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

if command -v docker &> /dev/null; then
    echo "Pulling latest images..."
    sudo docker-compose pull
fi

echo "Restarting services..."
sudo docker-compose up -d

echo "Restarting nginx to apply changes..."
docker-compose restart nginx

echo "Running health check for $SERVICE_NAME..."
sleep 15

if ./health-check.sh $SERVICE_NAME; then
    echo "Deployment successful for $SERVICE_NAME"
    sudo docker image prune -f
else
    echo "Deployment failed for $SERVICE_NAME"
    exit 1
fi

echo "Deployment completed for $SERVICE_NAME"