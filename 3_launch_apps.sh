#!/bin/bash

echo ""
echo "=================================="
echo "Begin demo apps setup..."
echo "=================================="
# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# create overlay network
docker network create -d overlay demo

# create example application that uses an overlay network (like HRM did in UCP 2.x)
docker service create \
  --name demo-overlay \
  --network demo \
  --detach=false \
  --label com.docker.lb.hosts=demo.interlock.mac \
  --label com.docker.lb.port=8080 \
  --env METADATA="demo-overlay" \
  ehazlett/docker-demo:latest

echo -e "\\nYour demo app should be available at http://demo.interlock.mac shortly\\n"

# create example application w/host mode (well tested method of routing to apps like Interlock 1.x and others)
docker service create \
  --name demo-hostmode \
  --detach=false \
  --label com.docker.lb.hosts=demo-hostmode.interlock.mac \
  --label com.docker.lb.port=8080 \
  --publish mode=host,target=8080 \
  --env METADATA="demo-hostmode" \
  ehazlett/docker-demo:latest

echo -e "\\nYour demo app should be available at http://demo-hostmode.interlock.mac shortly\\n"
echo "=================================="
echo "End demo apps setup!"
echo "=================================="
echo ""
