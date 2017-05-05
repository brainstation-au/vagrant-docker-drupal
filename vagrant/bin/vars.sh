#!/bin/bash

# MySQL container.
MYSQL_CONTAINER="mysqlstation"
MYSQL_ROOT_PASSWORD="admin"
MYSQL_DATABASE="drupal"
MYSQL_USER="drupal"
MYSQL_PASSWORD="drupal"
MYSQL_VERSION="latest"

# Drupal container.
DRUPAL_CONTAINER="drupalstation"

# Drupal installation.
SITE_NAME="brainstation"
SITE_MAIL="brainstation@outlook.com.au"
ACCOUNT_MAIL="brainstation@outlook.com.au"
ACCOUNT_NAME="admin"
ACCOUNT_PASS="admin"
SITES_DEFAULT="/drupal/sites-default"
