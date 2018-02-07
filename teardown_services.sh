#!/bin/bash

echo ""
echo "=================================="
echo "Begin services teardown..."
echo "=================================="

# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# remove all services
docker service rm $(docker service ls -q)

# remove all configs
docker config rm $(docker config ls -q)

# sleep to make sure they're really gone
sleep 10

# remove all services
docker service rm $(docker service ls -q)

echo "=================================="
echo "End services teardown!"
echo "=================================="
echo ""
