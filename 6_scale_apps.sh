#!/bin/bash

echo ""
echo "=================================="
echo "Begin scaling multi-region apps..."
echo "=================================="

# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# scale demo-east to 3 replicas
docker service scale demo-east=3

# sleep
echo "Sleeping 15 seconds between scaling..."
sleep 15

# scale demo-west to 3 replicas
docker service scale demo-west=3

echo "=================================="
echo "End scaling multi-region apps!"
echo "=================================="
echo ""
