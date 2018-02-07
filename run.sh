#!/bin/bash

# create overlay network
docker network create -d overlay interlock > /dev/null 2>&1

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
    interlockdemo/interlock:a2b1b323 -D run -c /config.toml
