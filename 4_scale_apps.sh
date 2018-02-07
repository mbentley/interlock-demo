#!/bin/bash

echo ""
echo "=================================="
echo "Begin scaling apps..."
echo "=================================="

# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# scale both apps to 3 replicas
docker service scale demo-overlay=3 demo-hostmode=3

echo "=================================="
echo "End scaling apps!"
echo "=================================="
echo ""
