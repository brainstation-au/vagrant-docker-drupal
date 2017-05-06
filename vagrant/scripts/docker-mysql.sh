#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Get parameters.
VARS_FILE="/vagrant/bin/vars.sh"
if [ ! -f $VARS_FILE ]; then
  echo "Variables file is missing."
  exit 0
fi
source $VARS_FILE
CONTAINER_NAME=$MYSQL_CONTAINER

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Print all executed commands to the terminal
set -x

# Check if mysql container is already installed.
if [ -z "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
  # Get 'mysql' docker image.
  if [ -f /vagrant/apps/mysql/drupal.sql.gz ]; then
    DOCKER_IMAGE="brainstation/mysql:latest"
    docker build -t $DOCKER_IMAGE /vagrant/apps/mysql
  else
    DOCKER_IMAGE="mysql:${MYSQL_VERSION}"
    docker pull $DOCKER_IMAGE
  fi

  # Run the 'mysql' docker image.
  docker run --name ${CONTAINER_NAME} \
    -h ${CONTAINER_NAME} \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    -e MYSQL_DATABASE=${MYSQL_DATABASE} \
    -e MYSQL_USER=${MYSQL_USER} \
    -e MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    -d $DOCKER_IMAGE
else
  if [ -z "$(docker ps | grep ${CONTAINER_NAME})" ]; then
    docker start ${CONTAINER_NAME}
  fi
fi

echo "MySQL default server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})"
