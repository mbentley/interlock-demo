#!/bin/bash

echo ""
echo "=================================="
echo "Begin Interlock setup..."
echo "=================================="
# talk to docker1
export DOCKER_HOST="tcp://localhost:1001"

# create overlay network
docker network create -d overlay interlock

# create config
docker config create service.interlock.conf interlock.conf.nginx

# create interlock service
docker service create \
    --name interlock \
    --detach=false \
    --mount src=/var/run/docker.sock,dst=/var/run/docker.sock,type=bind \
    --constraint node.role==manager \
    --network interlock \
    --config src=service.interlock.conf,target=/config.toml \
    docker/ucp-interlock:3.1.3 run -c /config.toml

echo "=================================="
echo "End Interlock setup!"
echo "=================================="
echo ""
