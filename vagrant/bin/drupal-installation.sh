#!/bin/bash
set -x

WORKDIR="/var/www/html"
VARS_FILE="/drupal/bin/vars.sh"

# Load variables.
if [ -f "${VARS_FILE}" ]; then
  source $VARS_FILE
fi

# Download drupal and libraries.
if [ ! -f "${WORKDIR}/web/index.php" ]; then
  composer create-project drupal-composer/drupal-project:8.x-dev $WORKDIR --stability dev --no-interaction
fi

# Install drush if not already installed.
if [ ! -f ${WORKDIR}/vendor/drush/drush/drush ] && [ ! -z $DRUSH_VERSION ]; then
  composer require drush/drush:${DRUSH_VERSION}
fi

# Make drush accessible globally.
if [ -f ${WORKDIR}/vendor/drush/drush/drush ]; then
  ln -s ${WORKDIR}/vendor/drush/drush/drush /usr/local/bin/drush
fi

# Install drupal.
if [ -f "${VARS_FILE}" ] && [ -f ${WORKDIR}/vendor/drush/drush/drush ] && [ -z "$(${WORKDIR}/vendor/drush/drush/drush status | grep ${MYSQL_CONTAINER})" ]; then
  # Create symlink for public/private file folder.
  DRUPAL_DEFAULT="${WORKDIR}/web/sites/default"
  MOUNT_DEFAULT=$D_MOUNT_DEFAULT
  for FOLDER in files private
  do
    if [ ! -L ${DRUPAL_DEFAULT}/${FOLDER} ]; then
      if [ -d ${MOUNT_DEFAULT}/${FOLDER} ]; then rm -rf ${MOUNT_DEFAULT}/${FOLDER}; fi
      mv ${MOUNT_DEFAULT}/${FOLDER} $DRUPAL_DEFAULT
    else
      if [ ! -d ${MOUNT_DEFAULT}/${FOLDER} ]; then mkdir -p ${MOUNT_DEFAULT}/${FOLDER}; fi
    fi
    if [ ! -L ${DRUPAL_DEFAULT}/${FOLDER} ]; then
      ln -s ${MOUNT_DEFAULT}/${FOLDER}/ ${DRUPAL_DEFAULT}/${FOLDER}
      chmod +x ${DRUPAL_DEFAULT}/${FOLDER}
    fi
  done
  chown -R www-data:www-data ${MOUNT_DEFAULT}

  cd ${WORKDIR}/web
  drupal site:install  standard \
    --langcode="en" \
    --db-type="mysql" \
    --db-port="3306" \
    --db-host=$MYSQL_CONTAINER \
    --db-name=$MYSQL_DATABASE \
    --db-user=$MYSQL_USER \
    --db-pass=$MYSQL_PASSWORD \
    --site-name=$SITE_NAME \
    --site-mail=$SITE_MAIL \
    --account-mail=$ACCOUNT_MAIL \
    --account-name=$ACCOUNT_NAME \
    --account-pass=$ACCOUNT_PASS \
    --no-interaction
  chown -R www-data:www-data ${MOUNT_DEFAULT}
  ../vendor/drush/drush/drush cache-rebuild
fi

# CMD coming from https://raw.githubusercontent.com/docker-library/php/fa6464a43d74d8b0a5ec3f22d53ac330f63ad22d/7.1/apache/Dockerfile
source /usr/local/bin/apache2-foreground
