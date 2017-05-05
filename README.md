# vagrant-docker-drupal
A Drupal development box with Vagrant and Docker.

## Get it in action

- Clone the repo.
  ```
  $ git clone https://github.com/brainstation-au/vagrant-docker-drupal.git drupal8
  ```
- Start the vagrant box
  ```
  $ cd drupal8/vagrant
  $ vagrant up
  ```
- Boom, you are done.
- Wait, your site is not ready is not ready yet.
- Once the vagrant box is successfully built, there are some background process
is still running and it will take time to download around 200MB of files and 
install them. So wait untill you can access http://192.168.33.100/.
- You can find all your drupal code in `drupal8/www/html` and any modification
in the code will take effect to the site, that means it's auto synced.