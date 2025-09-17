#!/bin/bash

set -e

SERVICE_NAME=$1

echo "Starting deployment..."

if [ -z "$SERVICE_NAME" ]; then
   echo "Usage: $0 <service-name>"
   exit 1
fi

if command -v docker &> /dev/null; then
   echo "Pulling latest image for $SERVICE_NAME..."
   sudo docker-compose pull $SERVICE_NAME
fi

echo "Restarting $SERVICE_NAME service..."
sudo docker rm -f $SERVICE_NAME 2>/dev/null || true
sudo docker-compose up -d $SERVICE_NAME

echo "Restarting nginx to apply changes..."
sudo docker rm -f nginx 2>/dev/null || true
sudo docker-compose up -d --no-deps nginx

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