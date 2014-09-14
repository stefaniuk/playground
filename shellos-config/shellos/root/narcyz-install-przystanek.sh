#!/bin/bash

source $SHELLOS_DIR/lib/base > /dev/null 2>&1

user="narcyz"
user_dir=/var/shellos/hosting/usr/local/accounts/$user
user_public_dir=$user_dir/home/$user/public
domain="przystanek.co.uk"

# site
cd $user_public_dir
rm -rf $domain
tar zxf ~/przystanek_co_uk-site.tar.gz ./

# site database
mysql_drop_database "przystanekcouk"
mysql_create_database "przystanekcouk"
mysql_drop_user "przystanekcouk"
mysql_create_user "przystanekcouk" "przystanekcouk" "YChcUbbNJWQZOuUxa85PAeW6PTTH7En6"
mysql_restore_database_from_archive ~/przystanek_co_uk-database-site.tar.gz "przystanekcouk"

# forum database
mysql_drop_database "przystanek_forum"
mysql_create_database "przystanek_forum"
mysql_drop_user "przystanek_forum"
mysql_create_user "przystanek_forum" "przystanek_forum" "fYhElhPETCtrFlKcGqZCj3JGfsa79J0z"
mysql_restore_database_from_archive ~/przystanek_co_uk-database-forum.tar.gz "przystanek_forum"

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
httpd_vhost_create.pl -s httpd -t account -n $user -i $IP_ADDRESS -d $domain -p 80 -c "$vhost_config"

exit 0

