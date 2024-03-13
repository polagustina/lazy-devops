#!/bin/bash

# install required packages
apt-get update
apt-get upgrade -y
apt-get install neofetch apache2 php libapache2-mod-php -y

# add neofetch at start
echo "clear\nneofetch" >> $HOME/.bashrc

# set site name if defined
site_name="${1:-my-web}"

# setup app directory tree
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

#create index.php
echo "
<?php

\$uri=\$_SERVER['REQUEST_URI'];

echo \$uri;
" > /var/www/$site_name/presentation/index.php

# create config file
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

# apply config
a2enmod rewrite
a2dissite 000-default
a2ensite $site_name
systemctl restart apache2
