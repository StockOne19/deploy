#!/bin/bash

MAX_RETRIES=10
RETRY_INTERVAL=10

echo "Checking health of services..."

for i in $(seq 1 $MAX_RETRIES); do
    if curl -f -s http://localhost:8081/actuator/health > /dev/null 2>&1; then
        echo "API server is healthy"
        exit 0
    fi
    
    echo "Attempt $i/$MAX_RETRIES failed, retrying in ${RETRY_INTERVAL}s..."
    sleep $RETRY_INTERVAL
done

echo "Health check failed after $MAX_RETRIES attempts"
exit 1