#!/bin/bash
set -x

WORKDIR="/var/www/html"
VARS_FILE="/drupal/bin/vars.sh"

# Download drupal and libraries.
if [ ! -f "${WORKDIR}/web/index.php" ]; then
  composer create-project drupal-composer/drupal-project:8.x-dev $WORKDIR --stability dev --no-interaction
fi

# Create a public folder for files.
PUBLIC_FILES="/drupal/sites-default/files"
if [ ! -d ${PUBLIC_FILES} ]; then mkdir -p ${PUBLIC_FILES}; fi

# Create a public folder for files.
PRIVATE_FILES="/drupal/sites-default/private"
if [ ! -d ${PRIVATE_FILES} ]; then mkdir -p ${PRIVATE_FILES}; fi
chown -R www-data:www-data /drupal/sites-default

# Create symlink for public file folder.
DEFAULT_DIR="${WORKDIR}/web/sites/default"
if [ ! -L ${DEFAULT_DIR}/files ]; then
  cd ${DEFAULT_DIR}
  ln -s ${PUBLIC_FILES}/ files
  chmod +x files
fi
if [ ! -L ${DEFAULT_DIR}/private ]; then
  cd ${DEFAULT_DIR}
  ln -s ${PRIVATE_FILES}/ private
  chmod +x private
fi
cd ${WORKDIR}

# Install drupal.
if [ -f "${VARS_FILE}" ] && [ -z "$(${WORKDIR}/vendor/drush/drush/drush status | grep ${MYSQL_CONTAINER})" ]; then
  cd ${WORKDIR}/web
  source $VARS_FILE
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
fi

# CMD coming from https://raw.githubusercontent.com/docker-library/php/fa6464a43d74d8b0a5ec3f22d53ac330f63ad22d/7.1/apache/Dockerfile
source /usr/local/bin/apache2-foreground
