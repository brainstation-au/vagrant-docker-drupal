# vagrant-docker-drupal
A Drupal development box with Vagrant and Docker.

## Objectives

1. We can create a fresh project with latest version of drupal installed with
all necessary php libraries.
1. We can use this as a development environment for our existing project.

### 1. Create a fresh drupal-8 project

- Clone the repo.
  ```
  $ git clone https://github.com/brainstation-au/vagrant-docker-drupal.git myproject
  ```
  *Remember the `myproject` in the line above is your project folder. you can name
  this folder as you like.*
- Get into the project folder.
  ```
  $ cd myproject
  ```
- Create a new folder for drupal installation.
  ```
  $ mkdir drupal
  ```
  *This new folder name has to be `drupal`. You have another folder at here
  `vagrant` came from the repo.*
- Set your own installation parameter in `vars.sh` file in `vagrant/bin`
  directory. (If you are happy to go with default values, you can skip this
  step.)
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

### 2. Get your existing project up and running.

#### Pre-requisites:

- Get your project database file ready as `drupal.sql.gz`.
- If your project is a drupal 7 project, the path for the private files should
  be `sites/default/private`
- Please note that we handle data directories in a way that every time you
  rebuild your box, you will get fresh data files that matches with you dbdump.

#### Follow the steps below:

- Clone the repo.
  ```
  $ git clone https://github.com/brainstation-au/vagrant-docker-drupal.git myproject
  ```
  *Remember the `myproject` in the line above is your project folder. you can name
  this folder as you like.*
- Get into the project folder.
  ```
  $ cd myproject
  ```
- Create a new folder for drupal installation.
  ```
  $ mkdir drupal
  ```
  *This new folder name has to be `drupal`. You have another folder at here
  `vagrant` came from the repo.*
- Create another folder named `web` in `drupal`, get your drupal instance in
  `drupal/web`.
- Go to `drupal/web/sites/default` directory and make a zip file for data
  directories.
  ```
  $ tar -czvf files.tar.gz $(find * -maxdepth 0 -type d)
  ```
- Move this files.tag.gz to `/vagrant/apps/drupal/` directory.
- Delete all the diretories in `/drupal/web/sites/default/`. While you are in
  this directory run:
  ```
  $ rm -rf $(find * -maxdepth 0 -type d)
  ```
- Create symlinks for data directories (`private` one is for D7):
  ```
  $ ln -s /drupal/sites-default/files files
  $ ln -s /drupal/sites-default/private private
  ```
- Set your own installation parameter in `vars.sh` file in `vagrant/bin`
  directory. (If you are happy to go with default values, you can skip this
  step.) Make sure the mysql connection parameters in
  `drupal/web/sites/default/settings.php` matches with `vars.sh` parameters.
  *You could use your preferred IDE to change the default parameters.*
- Now put your database dump file `drupal.sql.gz` in the `vagrant/apps/mysql`
  directory.
- Start the vagrant box
  ```
  $ cd vagrant
  $ vagrant up
  ```
  *I assume that you are now in your project folder and you have a folder called
  `vagrant` came from the repo.*
- I'll now take 4-5 minutes untill you can access http://192.168.33.100/.
