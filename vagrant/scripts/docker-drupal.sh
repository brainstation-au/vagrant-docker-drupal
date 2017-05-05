#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Print all executed commands to the terminal
set -x

# Get parameters.
VARS_FILE="/vagrant/bin/vars.sh"
if [ ! -f $VARS_FILE ]; then
  echo "Variables file is missing."
  exit 0
fi
source $VARS_FILE
CONTAINER_NAME=$DRUPAL_CONTAINER
VOLUME_MOUNT=$1

# Check if mysql container is already installed.
if [ -z "$(docker ps -a | grep ${MYSQL_CONTAINER})" ]; then
  echo "Drupal has a dependency of MySQL container."
  exit 0
else
  if [ -z "$(docker ps | grep ${MYSQL_CONTAINER})" ]; then
    docker start ${MYSQL_CONTAINER}
  fi
fi

# Check if drupal container is already installed.
if [ -z "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
  # Data mount location.
  MOUNT_LOCATION="${VOLUME_MOUNT}/${CONTAINER_NAME}"
  if [ -d $MOUNT_LOCATION ]; then
    rm -rf ${MOUNT_LOCATION}/*
  else
    mkdir -p $MOUNT_LOCATION
  fi

  # Get a mount point for drupal files.
  DRUPAL_SITES_DEFAULT="${MOUNT_LOCATION}/sites-default"
  mkdir -p $DRUPAL_SITES_DEFAULT
  
  # Create the data zip file.
  DATA_FILE="/vagrant/data/files.tar.gz"
  if [ -f "${DATA_FILE}" ]; then
    tar -xvzf $DATA_FILE -C $DRUPAL_SITES_DEFAULT
  fi

  # Change file user/group to support apache.
  chown -R www-data:www-data $DRUPAL_SITES_DEFAULT

  # Build mysql container.
  docker build -t brainstation/drupal:latest /vagrant/apps/drupal

  # Run the 'mysql' docker image.
  docker run --name ${CONTAINER_NAME} \
    -h ${CONTAINER_NAME} \
    --link ${MYSQL_CONTAINER}:mysql \
    -v ${DRUPAL_SITES_DEFAULT}:/drupal/sites-default \
    -v /vagrant/bin:/drupal/bin \
    -v /var/www/drupal:/var/www/html \
    -p 80:80 \
    -d brainstation/drupal:latest
else
  if [ -z "$(docker ps | grep ${CONTAINER_NAME})" ]; then
    docker start ${CONTAINER_NAME}
  fi
fi

echo "Drupal server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})"
