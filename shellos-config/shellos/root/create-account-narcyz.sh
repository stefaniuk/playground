#!/bin/bash

source $SHELLOS_DIR/lib/base > /dev/null 2>&1

user="narcyz"
user_dir=/var/shellos/hosting/usr/local/accounts/$user
user_public_dir=$user_dir/home/$user/public
pass_scp="MQrqsLSKA2sMSCJW"
pass_ftp="Ks6LkiH7T16yfPcW"
pass_db="9v6q90EZ0pzGvKHN"
domain="nowy.wypadek.cc"

exit 0

# scp
user_remove.pl -u $user
user_create.pl -u $user -g $user -G $OPENSSH_JAIL_GROUP -p $pass_scp -d $user_dir

# ftp
ftp_account_remove.pl -u $user
ftp_account_create.pl -u $user -p $pass_ftp -i $(id -u $user) -d $user_public_dir

# vhost
httpd_vhost_remove.pl -s httpd -t account -n $user -i $IP_ADDRESS -d $domain -p 80
vhost_dir=/$HOSTING_ACCOUNTS_RELATIVE_DIR/$user/home/$user/public/$domain
vhost_config=$(cat <<HEREDOC
    DocumentRoot $vhost_dir
    <Directory $vhost_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
HEREDOC
)
mkdir -p $HOSTING_DIR/$vhost_dir
httpd_vhost_create.pl -s httpd -t account -n $user -i $IP_ADDRESS -d $domain -p 80 -c "$vhost_config"
# .htaccess
cat << EOF > $HOSTING_DIR/$vhost_dir/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} -s [OR]
RewriteCond %{REQUEST_FILENAME} -l [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^.*$ - [NC,L]
RewriteRule ^.*$ index.php [NC,L]
EOF
# index.php
cat << EOF > $HOSTING_DIR/$vhost_dir/index.php
<!doctype html>
<html>
    <head>
    <title>$domain is under construction</title>
    <link rel="shortcut icon" href="/under_construction_favicon.ico" />
    <style type="text/css">
        body {
            background-color: black;
        }
        #under-construction {
            width: 500px;
            height: 300px;
            background-image:url(/under_construction.png);
        }
    </style>
    </head>
    <body>
        <div id="under-construction"></div>
    </body>
</html>
EOF
cp /var/shellos/hosting/var/www/under_construction.png $HOSTING_DIR/$vhost_dir
cp /var/shellos/hosting/var/www/under_construction_favicon.ico $HOSTING_DIR/$vhost_dir
# php info
echo -e "<?php phpinfo(); ?>" > $HOSTING_DIR/$vhost_dir/xrzogjunwopmjitg.php
chown $user:$user $HOSTING_DIR/$vhost_dir/{.*,*}

# database
mysql_drop_database $user
mysql_create_database $user
mysql_drop_user $user
mysql_create_user $user $user $pass_db

exit 0

:<<comment

SCP
===

IP address: 109.74.206.202
port: 22
username: narcyz
password: MQrqsLSKA2sMSCJW

FTP
===

IP address: 109.74.206.202
port: 21
username: narcyz
password: Ks6LkiH7T16yfPcW

PHP Info
========

URL: http://nowy.wypadek.cc/xrzogjunwopmjitg.php

phpMyAdmin & database
=====================

URL: https://phpmyadmin.web.stefaniuk.org
username: narcyz
password: 9v6q90EZ0pzGvKHN

comment

