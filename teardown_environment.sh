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
echo "=================================="
echo "End environment teardown!"
echo "=================================="
echo ""
