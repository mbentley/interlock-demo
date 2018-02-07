#!/bin/bash

echo ""
echo "=================================="
echo "Begin Interlock teardown..."
echo "=================================="

# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# remove application services
docker service rm demo-overlay demo-hostmode

# remove interlock services
docker service rm interlock interlock-ext interlock-proxy

# remove interlock configs
# shellcheck disable=SC2046
docker config rm $(docker config ls -q)

echo "=================================="
echo "End Interlock teardown!"
echo "=================================="
echo ""

echo ""
echo "=================================="
echo "Begin Interlock multi-region..."
echo "=================================="

# create overlay network
docker network create -d overlay interlock

# create config
docker config create service.interlock.conf interlock.conf.region

# create interlock service
docker service create \
    --name interlock \
    --detach=false \
    --mount src=/var/run/docker.sock,dst=/var/run/docker.sock,type=bind \
    --constraint node.role==manager \
    --network interlock \
    --config src=service.interlock.conf,target=/config.toml \
    interlockdemo/interlock:a2b1b323 -D run -c /config.toml

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

echo -e "\\nYour demo app should be available at http://demo-east.interlock.mac:80 shortly\\n"

docker service create \
  --name demo-west \
  --network demo-west \
  --detach=true \
  --label com.docker.lb.hosts=demo-west.interlock.mac \
  --label com.docker.lb.port=8080 \
  --label com.docker.lb.service_cluster=west \
  --env METADATA="west" \
  ehazlett/docker-demo:latest

echo -e "\\nYour demo app should be available at http://demo-west.interlock.mac:81 shortly\\n"

echo "=================================="
echo "End app launch multi-region!"
echo "=================================="
echo ""
