SFPGVER=4.7.1

#Obtain Single File PHP Gallery from http://sye.dk/sfpg/
wget http://sye.dk/sfpg/Single_File_PHP_Gallery_${SFPGVER}.zip -O /tmp/sfpg.zip
sudo unzip /tmp/sfpg.zip index.php -d /var/www/html/
sudo chown www-data. /var/www/html/index.php
sudo chown www-data. /var/www/html/

# Patch the configuration file to our own taste
patch -d /var/www/html/ < index.patch