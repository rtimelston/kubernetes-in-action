#!/bin/bash
if [[ $# -ne 1 ]];then
    echo "Usage: ./run-app.sh <docker-hub-id>"
    exit 1
fi

DOCKER_HUB_ID="$1"
echo $DOCKER_HUB_ID

# 2.1.4 Building the container image
docker build -t kubia .
docker images | grep "REPOSITORY\|kubia"

# 2.1.5 Running the container image
docker run --name kubia-container -p 8080:8080 -d kubia
sleep 2
curl localhost:8080
docker ps | grep "CONTAINER ID\|kubia-container"
docker inspect kubia-container

# 2.1.6 Exploring the inside of a running container
docker exec -it kubia-container bash

# Now, in the container terminal, run:
#   ./explore.sh

# 2.1.7 Stopping and removing a container
docker stop kubia-container
sleep 5
docker rm kubia-container

# 2.1.8 Pushing the image to an image registry
## This step requires being logged in to a Docker Hub account and having 
##  entered your Docker Hub ID as a parameter to this script.
docker tag kubia $DOCKER_HUB_ID/kubia
docker images | head | grep kubia
./put-your-docker-hub-password-in-this-file.txt | docker login -u $DOCKER_HUB_ID --password-stdin
docker push $DOCKER_HUB_ID/kubia