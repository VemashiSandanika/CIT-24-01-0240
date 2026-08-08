#!/usr/bin/env bash
set -e
echo "Removing app ..."
docker rm -f webapp-web 2>/dev/null || echo "Web container not found."
docker rm -f webapp-redis 2>/dev/null || echo "Redis container not found."
docker volume rm webapp-redis-data 2>/dev/null || echo "Volume not found."
docker network rm webapp-net 2>/dev/null || echo "Network not found."
docker rmi webapp-flask:latest 2>/dev/null || echo "Image not found."
echo "Removed app."
