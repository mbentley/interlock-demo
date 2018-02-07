#!/bin/bash

echo ""
echo "=================================="
echo "Begin launching engines..."
echo "=================================="
# create docker network
docker network create --driver bridge --subnet="172.250.1.0/24" dind
DIND_SUBNET_PREFIX="$(docker network inspect --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}' dind | awk -F '/' '{print $1}' | awk -F '.' '{print $1"."$2"."$3"."}')"

# create registry mirror volume if needed
if [ "$(docker volume ls -q --filter name="shared-mirror-cache" | grep -w "shared-mirror-cache")" = "shared-mirror-cache" ]
then
  # do nothing
  echo -n ""
else
  # create volume
  docker volume create \
    --driver local \
    shared-mirror-cache
fi

# create registry mirror
docker run -d \
  -p 5000:5000 \
  --name mirror \
  --hostname mirror \
  --net dind \
  -v shared-mirror-cache:/var/lib/registry \
  mbentley/docker-in-docker:mirror > /dev/null

# launch engines
ENGINE_NUM="1"
docker run -d \
  --name docker${ENGINE_NUM} \
  --privileged \
  --net dind \
  --name docker${ENGINE_NUM} \
  --hostname docker${ENGINE_NUM} \
  --ip "${DIND_SUBNET_PREFIX}"$((ENGINE_NUM+51)) \
  -p 127.0.0.1:100${ENGINE_NUM}:2375 \
  -v /lib/modules:/lib/modules:ro \
  -v docker${ENGINE_NUM}:/var/lib/docker \
  -v docker${ENGINE_NUM}-etc:/etc/docker \
  --tmpfs /run \
  mbentley/docker-in-docker:ee-test \
  dockerd -s overlay2 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375 --registry-mirror http://mirror:5000

ENGINE_NUM="2"
docker run -d \
  --name docker${ENGINE_NUM} \
  --privileged \
  --net dind \
  --name docker${ENGINE_NUM} \
  --hostname docker${ENGINE_NUM} \
  --ip "${DIND_SUBNET_PREFIX}"$((ENGINE_NUM+51)) \
  -p 127.0.0.1:100${ENGINE_NUM}:2375 \
  -p 80:80 \
  -p 81:81 \
  -p 82:82 \
  -p 443:443 \
  -p 444:444 \
  -p 445:445 \
  -v /lib/modules:/lib/modules:ro \
  -v docker${ENGINE_NUM}:/var/lib/docker \
  -v docker${ENGINE_NUM}-etc:/etc/docker \
  --tmpfs /run \
  mbentley/docker-in-docker:ee-test \
  dockerd -s overlay2 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375 --registry-mirror http://mirror:5000

ENGINE_NUM="3"
docker run -d \
  --name docker${ENGINE_NUM} \
  --privileged \
  --net dind \
  --name docker${ENGINE_NUM} \
  --hostname docker${ENGINE_NUM} \
  --ip "${DIND_SUBNET_PREFIX}"$((ENGINE_NUM+51)) \
  -p 127.0.0.1:100${ENGINE_NUM}:2375 \
  -v /lib/modules:/lib/modules:ro \
  -v docker${ENGINE_NUM}:/var/lib/docker \
  -v docker${ENGINE_NUM}-etc:/etc/docker \
  --tmpfs /run \
  mbentley/docker-in-docker:ee-test \
  dockerd -s overlay2 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375 --registry-mirror http://mirror:5000

echo "=================================="
echo "End launching engines!"
echo "=================================="
echo ""
echo "=================================="
echo "Begin Swarm setup..."
echo "=================================="
# init swarm
docker -H tcp://localhost:1001 swarm init

# get token and create join command
TOKEN="$(docker -H tcp://localhost:1001 swarm join-token worker -q)"
JOIN_COMMAND="swarm join --token ${TOKEN} $(docker container inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' docker1):2377"

# join engines
# shellcheck disable=SC2086
docker -H tcp://localhost:1002 ${JOIN_COMMAND}
# shellcheck disable=SC2086
docker -H tcp://localhost:1003 ${JOIN_COMMAND}

# check status
docker -H tcp://localhost:1001 node ls

# add labels
docker -H tcp://localhost:1001 node update --label-add nodetype=loadbalancer docker2
echo "=================================="
echo "End Swarm setup!"
echo "=================================="
echo ""
