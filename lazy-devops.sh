#!/bin/bash

# install required packages

apt-get update > /dev/null
apt-get upgrade -y > /dev/null
apt-get install neofetch apache2 php libapache2-mod-php -y > /dev/null

echo "clear neofetch" >> $HOME/.bashrc

site_name="${1:-my-web}"

mkdir /var/www/$site_name
mkdir /var/www/$site_name/logic
mkdir /var/www/$site_name/logic/config
mkdir /var/www/$site_name/logic/controllers
mkdir /var/www/$site_name/logic/core
mkdir /var/www/$site_name/logic/models
mkdir /var/www/$site_name/logic/views
mkdir /var/www/$site_name/presentation
mkdir /var/www/$site_name/presentation/css
mkdir /var/www/$site_name/presentation/js
mkdir /var/www/$site_name/presentation/src

echo "
<?php

\$uri=\$_SERVER['REQUEST_URI'];

echo \$uri;
" > /var/www/$site_name/presentation/index.php

echo "
<VirtualHost *:80>
    DocumentRoot /var/www/${site_name}/presentation
    ErrorLog /var/log/apache2/${site_name}-error.log
    CustomLog /var/log/apache2/${site_name}-access.log combined
    <Directory /var/www/${site_name}/presentation>
        Options -Indexes
        DirectorySlash Off
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^ index.php
    </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/$site_name.conf

a2enmod rewrite > /dev/null
a2dissite 000-default > /dev/null
a2ensite $site_name > /dev/null

systemctl restart apache2

reboot
