#!/bin/bash

set -e

SERVICE_NAME=$1

echo "Starting deployment..."

if [ -z "$SERVICE_NAME" ]; then
   echo "Usage: $0 <service-name>"
   exit 1
fi

### 전체 리셋
sudo docker-compose pull api-server data-server
sudo docker-compose up -d
###

# if command -v docker &> /dev/null; then
#    echo "Pulling latest image for $SERVICE_NAME..."
#    sudo docker-compose pull $SERVICE_NAME
# fi

# echo "Restarting $SERVICE_NAME service..."
# sudo docker-compose stop $SERVICE_NAME
# sudo docker rm -f $SERVICE_NAME 2>/dev/null || true
# sudo docker-compose up -d --no-deps $SERVICE_NAME

# if [ "$SERVICE_NAME" == "api-server" ] || [ "$SERVICE_NAME" == "data-server" ]; then

#    echo "Restarting nginx to refresh upstream connections..."
#    sudo docker-compose restart nginx
# fi

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