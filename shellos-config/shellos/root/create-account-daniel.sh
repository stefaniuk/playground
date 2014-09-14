#!/bin/bash

source $SHELLOS_DIR/lib/base > /dev/null 2>&1

user="daniel"
user_dir=/var/shellos/hosting/usr/local/accounts/$user
user_public_dir=$user_dir/home/$user/public
pass_scp="uPETyvy7P8a6GEyvjRIFld2OzDE3Kgr4"
pass_ftp="YGwGacQQ8y6Vw43bETD0cCoXmROYHlaR"

# scp
user_remove.pl -u $user
user_create.pl -u $user -g $user -G $OPENSSH_JAIL_GROUP -p $pass_scp -d $user_dir

# ftp
ftp_account_remove.pl -u $user
ftp_account_create.pl -u $user -p $pass_ftp -i $(id -u $user) -d $user_public_dir

# domains
function setup_domain() {

    local domain=$1
    local database=$2
    local password=$3

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
    echo -e "<?php phpinfo(); ?>" > $HOSTING_DIR/$vhost_dir/$(random 32).php
    chown $user:$user $HOSTING_DIR/$vhost_dir/{.*,*}

    # database
    mysql_drop_database $database
    mysql_create_database $database
    mysql_drop_user $database
    mysql_create_user $database $database $password

}
setup_domain "stefaniuk.org" "stefaniuk" "v0ZNnQwCZTjUGGg573XEN7Ir7eVrwQZm"
setup_domain "zendframework.pl" "zendframework" "K8Y2aXBV4TSLW09iHaNNnPZIMPrcTH4I"
setup_domain "dojotoolkit.pl" "dojotoolkit" "0NAu4CCDFTKddTGJX3FahoiSzMWk0btw"
setup_domain "aplikacje-mobilne.pl" "aplikacjemobilne" "4JQU8Rhk8e6hHEcVacBbypqV2QohSGXU"

exit 0

