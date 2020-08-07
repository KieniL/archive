#!/bin/sh
sudo apt-get update && sudo apt-get install -y apache2
sudo service apache2 start
echo "<html><body><h1>Awesome !!!</h1>" > /var/www/html/index.html
echo "</body></html>" >> /var/www/html/index.html
sudo service apache2 reload
