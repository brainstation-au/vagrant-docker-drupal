#!/bin/bash
set -x

WORKDIR="/var/www/html"
VARS_FILE="/drupal/bin/vars.sh"

# Download drupal and libraries.
if [ ! -f "${WORKDIR}/web/index.php" ]; then
  composer create-project drupal-composer/drupal-project:8.x-dev $WORKDIR --stability dev --no-interaction
fi

# Install drupal.
if [ -f "${VARS_FILE}" ] && [ -z "$(${WORKDIR}/vendor/drush/drush/drush status | grep ${MYSQL_CONTAINER})" ]; then
  source $VARS_FILE

  # Create symlink for public/private file folder.
  DRUPAL_DEFAULT="${WORKDIR}/web/sites/default"
  for FOLDER in files private
  do
    if [ -d ${DRUPAL_DEFAULT}/${FOLDER} ]; then
      if [ -d ${SITES_DEFAULT}/${FOLDER} ]; then rm -rf ${SITES_DEFAULT}/${FOLDER}; fi
      mv ${SITES_DEFAULT}/${FOLDER} $DRUPAL_DEFAULT
    else
      if [ ! -d ${SITES_DEFAULT}/${FOLDER} ]; then mkdir -p ${SITES_DEFAULT}/${FOLDER}; fi
    fi
    if [ ! -L ${DRUPAL_DEFAULT}/${FOLDER} ]; then
      ln -s ${SITES_DEFAULT}/${FOLDER}/ ${DRUPAL_DEFAULT}/${FOLDER}
      chmod +x ${DRUPAL_DEFAULT}/${FOLDER}
    fi
  done
  chown -R www-data:www-data ${SITES_DEFAULT}

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
  chown -R www-data:www-data ${SITES_DEFAULT}
  ../vendor/drush/drush/drush cache-rebuild
fi

# CMD coming from https://raw.githubusercontent.com/docker-library/php/fa6464a43d74d8b0a5ec3f22d53ac330f63ad22d/7.1/apache/Dockerfile
source /usr/local/bin/apache2-foreground
