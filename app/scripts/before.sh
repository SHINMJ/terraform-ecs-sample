#!/bin/bash

if [ -d /home/ubuntu/build ]; then
    rm -rf /home/ubuntu/build
fi

mkdir -vp /home/ubuntu/build

sudo docker stop testapp
sudo docker rm testapp

if [[ "$(docker images -q testapp:latest 2> /dev/null)" != "" ]]; then
docker rmi -f $(docker images --format '{{.Repository}}:{{.Tag}}' --filter=reference='testapp:latest')
fi