#!/bin/bash

# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

echo ""
echo "=================================="
echo "Begin Interlock multi-region..."
echo "=================================="

# create new config
docker config create service.interlock.conf-v2 interlock.conf.region

# apply new config
docker service update --config-rm service.interlock.conf --config-add src=service.interlock.conf-v2,target=/config.toml interlock

echo "=================================="
echo "End Interlock multi-region!"
echo "=================================="
echo ""

echo ""
echo "=================================="
echo "Begin app launch multi-region..."
echo "=================================="

# create overlay networks
docker network create -d overlay demo-east
docker network create -d overlay demo-west

# create services
docker service create \
  --name demo-east \
  --network demo-east \
  --detach=true \
  --label com.docker.lb.hosts=demo-east.interlock.mac \
  --label com.docker.lb.port=8080 \
  --label com.docker.lb.service_cluster=east \
  --env METADATA="east" \
  ehazlett/docker-demo:latest

echo -e "\\nYour demo app should be available at http://demo-east.interlock.mac:81 shortly\\n"

docker service create \
  --name demo-west \
  --network demo-west \
  --detach=true \
  --label com.docker.lb.hosts=demo-west.interlock.mac \
  --label com.docker.lb.port=8080 \
  --label com.docker.lb.service_cluster=west \
  --env METADATA="west" \
  ehazlett/docker-demo:latest

echo -e "\\nYour demo app should be available at http://demo-west.interlock.mac:82 shortly\\n"

echo "=================================="
echo "End app launch multi-region!"
echo "=================================="
echo ""
