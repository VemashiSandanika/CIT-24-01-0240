#!/usr/bin/env bash
set -e
IMAGE_NAME="webapp-flask:latest"
NETWORK_NAME="webapp-net"
VOLUME_NAME="webapp-redis-data"
REDIS_CONTAINER="webapp-redis"
WEB_CONTAINER="webapp-web"
HOST_PORT=5000

echo "Running app ..."
if [ "$(docker ps -aq -f name=^${REDIS_CONTAINER}$)" ]; then
    docker start "$REDIS_CONTAINER"
else
    docker run -d --name "$REDIS_CONTAINER" --network "$NETWORK_NAME" --restart unless-stopped \
      -v "${VOLUME_NAME}:/data" redis:7-alpine redis-server --save 60 1 --appendonly yes
fi
if [ "$(docker ps -aq -f name=^${WEB_CONTAINER}$)" ]; then
    docker start "$WEB_CONTAINER"
else
    docker run -d --name "$WEB_CONTAINER" --network "$NETWORK_NAME" --restart unless-stopped \
      -e REDIS_HOST=webapp-redis -e REDIS_PORT=6379 -p ${HOST_PORT}:5000 "$IMAGE_NAME"
fi
echo "The app is available at http://localhost:${HOST_PORT}"
