#!/bin/bash

SERVICE_NAME=${1:-"api-server"}
MAX_RETRIES=10
RETRY_INTERVAL=10

# 서비스별 포트 매핑
case "$SERVICE_NAME" in
    "api-server")
        PORT=8081
        HEALTH_PATH="/actuator/health"
        ;;
    *)
        echo "Unknown service: $SERVICE_NAME"
        exit 1
        ;;
esac

echo "Checking health of $SERVICE_NAME at localhost:$PORT$HEALTH_PATH..."

for i in $(seq 1 $MAX_RETRIES); do
    if curl -f -s http://localhost:$PORT$HEALTH_PATH > /dev/null 2>&1; then
        echo "$SERVICE_NAME is healthy"
        exit 0
    fi
    
    echo "Attempt $i/$MAX_RETRIES failed, retrying in ${RETRY_INTERVAL}s..."
    sleep $RETRY_INTERVAL
done

echo "Health check failed for $SERVICE_NAME after $MAX_RETRIES attempts"
exit 1