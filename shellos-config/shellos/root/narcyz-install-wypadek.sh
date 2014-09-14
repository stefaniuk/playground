#!/bin/bash

source $SHELLOS_DIR/lib/base > /dev/null 2>&1

user="narcyz"
user_dir=/var/shellos/hosting/usr/local/accounts/$user
user_public_dir=$user_dir/home/$user/public
domain="wypadek.cc"

# site
cd $user_public_dir
rm -rf $domain
tar zxf ~/wypadek_cc-site.tar.gz ./

# database
mysql_drop_database "wypadekcc"
mysql_create_database "wypadekcc"
mysql_drop_user "wypadekcc"
mysql_create_user "wypadekcc" "wypadekcc" "jURc79BvotZcRXI3SJA8QHGJAVTMH5AL"
mysql_restore_database_from_archive ~/wypadek_cc-database.tar.gz "wypadekcc"
cat <<EOF | mysql --user="root" --password="`mysql_get_user_password root`"
USE wypadekcc;
CREATE TABLE IF NOT EXISTS AclPermissionView (roleId INT, roleName INT, resourceId INT, resourceName INT, resourceType INT, privilege INT, access INT);
DROP VIEW IF EXISTS AclPermissionView ;
DROP TABLE IF EXISTS AclPermissionView;
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=wypadekcc@localhost SQL SECURITY DEFINER VIEW AclPermissionView AS select roles.id AS roleId,roles.name AS roleName,res.id AS resourceId,res.name AS resourceName,res.type AS resourceType,perm.privilege AS privilege,perm.access AS access from ((AclRoles roles join AclResources res) join AclPermissions perm) where ((roles.id = perm.idRole) and (perm.idResource = res.id));
EOF

# vhost
httpd_vhost_remove.pl -s httpd -t account -n $user -i $IP_ADDRESS -d $domain -p 80
vhost_dir=/$HOSTING_ACCOUNTS_RELATIVE_DIR/$user/home/$user/public/$domain/public
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

