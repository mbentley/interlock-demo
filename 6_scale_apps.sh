#!/bin/bash

echo ""
echo "=================================="
echo "Begin scaling multi-region apps..."
echo "=================================="

# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# scale both apps to 3 replicas
docker service scale demo-east=3 demo-west=3

echo "=================================="
echo "End scaling multi-region apps!"
echo "=================================="
echo ""
