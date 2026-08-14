# CCS3308 Assignment 1 - Dockerized Visit-Counter Web App

A two-service, containerized web application built for **CCS3308 - Virtualization
and Containers, Assignment 1**. A Python Flask web server records how many times
the page has been visited by storing a counter in a Redis database. The counter's
data is kept on a persistent Docker volume, so it survives container restarts.

## 1. Deployment Requirements

- Docker Engine (v20.10 or later)
- Docker Compose (v2, optional — only needed if using 'docker-compose.yaml'
  instead of the shell scripts)
- Bash shell (Linux/Ubuntu)
- Port 5000 free on the host

## 2. Application Description

The app is a simple visit counter:

- Visiting http://localhost:5000/ increments a 'visits' key in Redis and
  displays the current count on a styled welcome page.
- The homepage HTML is rendered from 'app/templates/index.html' using Flask's
  render_template'.
- 'GET /api/count' returns the current count as JSON.
- 'GET /health' reports whether the web service can reach Redis.

## 3. Network and Volume Details

| Resource | Name | Purpose |
|---|---|---|
| Docker network | 'webapp-net' (bridge driver) | Lets the 'webapp-web' and 'webapp-redis' containers reach each other by container name, isolated from other Docker networks on the host. |
| Named volume | 'webapp-redis-data' | Mounted at '/data' inside the Redis container. Stores Redis's append-only file (AOF) and RDB snapshots, so visit counts persist across 'stop-app.sh' / 'start-app.sh' cycles and container recreation. |

## 4. Container Configuration

- **4.1 webapp-redis**
  - Image: redis:7-alpine (official Docker Hub image, no build required)
  - Command: redis-server --save 60 1 --appendonly yes
  - Volume: webapp-redis-data:/data
  - Network: webapp-net
  - Restart policy: unless-stopped

- **4.2 webapp-web**
  - Image: webapp-flask:latest (custom image built from './app/Dockerfile',
    based on 'python:3.12-slim')
  - Environment variables: REDIS_HOST=webapp-redis`, `REDIS_PORT=6379
  - Port mapping: 5000:5000 (host:container)
  - Network: webapp-net
  - Restart policy: unless-stopped

## 5. Container List

| Container | Role |
|---|---|
| webapp-web | Serves the Flask web application on port 5000; handles HTTP requests and reads/writes the visit counter in Redis. |
| webapp-redis | In-memory key-value store used as the app's persistent backend; stores the visit counter on the named volume. |

## 6. Instructions

### 6.1 Prepare the application (build images, create network/volume)
chmod +x prepare-app.sh start-app.sh stop-app.sh remove-app.sh
./prepare-app.sh

### 6.2 Run the application
./start-app.sh

Both containers run with '--restart unless-stopped', so they automatically
restart if they crash or the Docker daemon restarts.

### 6.3 Access the application
Open a web browser and go to:
http://localhost:5000
Each page refresh increments and displays the visit counter.

### 6.4 Pause the application (stop containers, keep data)
./stop-app.sh
Containers are stopped, not removed - the volume and its data remain intact.
Resume with './start-app.sh'.

### 6.5 Delete all application resources
./remove-app.sh
Removes the containers, the custom image, the network, and the named volume.

### 6.6 Alternative: using Docker Compose
docker-compose up -d --build   # prepare + start
docker-compose stop            # pause, keep data
docker-compose down            # remove containers + network (add -v to also remove the volume)


## 7. Example Workflow

# Create application resources
./prepare-app.sh
Preparing app ...
...
App prepared successfully.

# Run the application
./start-app.sh
Running app ...
...
The app is available at http://localhost:5000

# Open a web browser and interact with the application
# -> visit http://localhost:5000, refresh a few times, watch the counter increase

# Pause the application
./stop-app.sh
Stopping app ...
App stopped. Data preserved in the named volume; run start-app.sh to resume.

# Delete all application resources
./remove-app.sh
Removing app ...
Removed app.

## 8. Screenshots

All screenshots are in the 'screenshots/' folder.

| File | Description |
|---|---|
| screenshots/Step1.png | Docker and Git version check |
| screenshots/Step2.1.png | 'prepare-app.sh' building the custom web app image |
| screenshots/Step2.2.png | 'prepare-app.sh' pulling the Redis image |
| screenshots/Step3.png | 'start-app.sh' starting both containers |
| screenshots/Step4.png | 'docker ps' confirming both containers are running |
| screenshots/Step5.png | Web app displayed in the browser with the visit counter |
| screenshots/Step6.png | Counter increasing on refresh |
| screenshots/Step7.png | 'stop-app.sh' and 'start-app.sh' output |
| screenshots/Step8.png | Counter persisting correctly after a restart (proves the persistent volume works) |
| screenshots/Step9.png | 'remove-app.sh' cleanup output |
| screenshots/Step10.png | Confirmation that all Docker resources (containers, network, volume) were removed |

## 9. Conclusion

The CCS3308 Assignment 1 successfully demonstrated how to deploy a Flask web application using Docker and Redis. The two containers communicated through a custom Docker network, while a persistent volume ensured that the visit count was maintained after restarts. The project provided practical experience with Docker containers, images, networks, volumes, and application management.

