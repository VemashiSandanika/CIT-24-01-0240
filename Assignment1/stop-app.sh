#!/usr/bin/env bash
set -e
echo "Stopping app ..."
docker stop webapp-web 2>/dev/null || echo "Web container already stopped or not found."
docker stop webapp-redis 2>/dev/null || echo "Redis container already stopped or not found."
echo "App stopped. Data preserved in the named volume; run start-app.sh to resume."
