# https://github.com/docker-library/drupal
FROM drupal:latest

# Install composer.
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y wget \
  && curl -sS https://raw.githubusercontent.com/brainstation-au/shortcuts/master/composer/install.sh | bash /dev/stdin global

# Install drupal console globally.
# https://docs.drupalconsole.com/en/getting/launcher.html
RUN curl https://drupalconsole.com/installer -L -o drupal.phar \
  && mv drupal.phar /usr/local/bin/drupal \
  && chmod +x /usr/local/bin/drupal \
  && drupal self-update

COPY ["drupal.conf", "/etc/apache2/sites-available/"]

RUN mkdir -p /var/www/html/web \
  && a2dissite 000-default \
  && a2ensite drupal

CMD ["bash", "/drupal/bin/drupal-installation.sh"]
