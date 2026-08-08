#!/usr/bin/env bash
set -e
IMAGE_NAME="webapp-flask:latest"
NETWORK_NAME="webapp-net"
VOLUME_NAME="webapp-redis-data"

echo "Preparing app ..."
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    docker network create "$NETWORK_NAME"
fi
if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    docker volume create "$VOLUME_NAME"
fi
docker build -t "$IMAGE_NAME" ./app
docker pull redis:7-alpine
echo "App prepared successfully."
