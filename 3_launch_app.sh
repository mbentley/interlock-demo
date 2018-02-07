#!/bin/bash

export DOCKER_HOST="tcp://localhost:1001"

# create overlay network
docker network create -d overlay demo

# create example application
docker service create \
    --name demo \
    --network demo \
    --detach=false \
    --label com.docker.lb.hosts=demo.interlock.mac \
    --label com.docker.lb.port=8080 \
    --env METADATA="demo" \
    ehazlett/docker-demo:latest
