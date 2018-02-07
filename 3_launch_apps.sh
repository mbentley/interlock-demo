#!/bin/bash

echo ""
echo "=================================="
echo "Begin demo apps setup..."
echo "=================================="
export DOCKER_HOST="tcp://localhost:1001"

# create overlay network
docker network create -d overlay demo

# create example application
docker service create \
  --name demo-overlay \
  --network demo \
  --detach=false \
  --label com.docker.lb.hosts=demo.interlock.mac \
  --label com.docker.lb.port=8080 \
  --env METADATA="demo-overlay" \
  ehazlett/docker-demo:latest

echo "Your demo app should be available at http://demo.interlock.mac shortly"

# create example application w/host mode
docker service create \
  --name demo-hostmode \
  --detach=false \
  --label com.docker.lb.hosts=demo-hostmode.interlock.mac \
  --label com.docker.lb.port=8080 \
  --publish mode=host,target=8080 \
  --env METADATA="demo-hostmode" \
  ehazlett/docker-demo:latest

echo "Your demo app should be available at http://demo-hostmode.interlock.mac shortly"
echo "=================================="
echo "End demo apps setup!"
echo "=================================="
echo ""
