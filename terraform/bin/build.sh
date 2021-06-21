#!/bin/bash

set -e

# This is the order of arguments
build_folder=$1
aws_ecr_repository_url=$2
image_tag=$3
aws_region=$4

# Check that aws is installed
which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }

# Connect into aws
$(aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin $aws_ecr_repository_url) || { echo 'ERROR: aws ecr login failed' ; exit 1; }



# Check that docker is installed and running
which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }

# Some Useful Debug
echo "Building $aws_ecr_repository_url:$image_tag from $build_folder/Dockerfile"

# Build image
docker build -t $aws_ecr_repository_url:$image_tag $build_folder

# Push image
docker push $aws_ecr_repository_url:$image_tag