#!/bin/bash

sudo rm -r /var/www/html/grav
sudo cp -r ~/development/website_work/grav-admin/ /var/www/html/grav
sudo chown -R www-data:www-data /var/www/html/grav
sudo service apache2 restart
sudo service nginx restart
