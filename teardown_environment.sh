#!/bin/bash

echo ""
echo "=================================="
echo "Begin environment teardown..."
echo "=================================="
docker stop -t 10 mirror
docker rm mirror

docker kill docker{1..3}
docker rm docker{1..3}
docker volume rm docker1 docker1-etc docker2 docker2-etc docker3 docker3-etc

docker network rm dind

# check to see if containers are using the volume for the shared mirror
SHARED_CONTAINERS="$(docker ps -a --format '{{.Names}}' --filter=volume=shared-mirror-cache | tr '\\n' ' ' | sed 's/ *$//')"
if [ -z "${SHARED_CONTAINERS}" ]
then
  #shellcheck disable=SC2086
  docker volume rm shared-mirror-cache
fi

echo "=================================="
echo "End environment teardown!"
echo "=================================="
echo ""
