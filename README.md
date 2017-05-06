# vagrant-docker-drupal
A Drupal development box with Vagrant and Docker.

## Objectives
1. We can create a fresh project with latest version of drupal installed with
all necessary php libraries.
1. We can use this as a development environment for our existing project.

### 1. Create a fresh drupal-8 project

- Clone the repo.
  ```
  $ git clone https://github.com/brainstation-au/vagrant-docker-drupal.git drupal8
  ```
  *Remember the `drupal8` in the line above is your project folder. you can name
  this folder as you like.*
- Get into the project folder.
  ```
  $ cd drupal8
  ```
- Create a new folder for drupal installation.
  ```
  $ mkdir drupal
  ```
  *This new folder name has to be `drupal`. You have another folder at here
  `vagrant` came from the repo.*
- Set your own installation parameter. (If you are happy to go with default
  values, you can skip this step.)
  ```
  $ cd vagrant/bin
  $ nano vars.sh
  $ cd ../..
  ```
  *You could use your preferred IDE to change the default parameters.*
- Start the vagrant box
  ```
  $ cd vagrant
  $ vagrant up
  ```
  *I assume that you are now in your project folder and you have a folder called
  `vagrant` came from the repo.*
- Boom, you are done.
- Wait, your site is not ready is not ready yet.
- If you keep an eye in the `drupal` directory that you created, you will start
  getting new directories and files in there. Wait until your installation is
  finished, then you can see `drupal/web/sites/default/settings.php`.
- Once the vagrant box is successfully built, there are some background process
  is still running and it will take time to download around 200MB of files and 
  install them. So wait untill you can access http://192.168.33.100/.
- You can find all your drupal code in the `drupal` directory in your project
  root and any modification in the code will take effect to the site, that means
  it's auto synced.
  