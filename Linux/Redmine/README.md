
# How to Install Redmine on Ubuntu 16.04

- Redmine is a project management web app that allows users to manage projects flexibly while offering robust tracking tools and an extensive library of plug-ins.

1. Install Dependencies:
   - `sudo apt install build-essential mysql-server ruby ruby-dev libmysqlclient-dev imagemagick libmagickwand-dev`

2. Configure MySQL:
   - `mysql -u root -p`
   - After logging in, create a new database

3. Configure redmine with gmail as notification sender
   - click "here"[http://www.redmine.org/boards/2/topics/30670?page=2"]
   - remember to run `sudo setsebool httpd_can_network_connect 1`
