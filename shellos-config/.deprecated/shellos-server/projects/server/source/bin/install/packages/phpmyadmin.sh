#!/bin/bash

##
## variables
##

PHPMYADMIN_MYSQL_NAME=
PHPMYADMIN_HTTPD_NAME=
PHPMYADMIN_INSTALL_DIR=$HOSTING_APPLICATIONS_DIR/phpmyadmin

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --phpmyadmin)   shift && PHPMYADMIN_MYSQL_NAME=$1
                        shift && PHPMYADMIN_HTTPD_NAME=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: phpMyAdmin requires MySQL!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/bin/httpd ]; then
    echo "Error: phpMyAdmin requires Apache HTTPD Server!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/modules/libphp5.so ]; then
    echo "Error: phpMyAdmin requires PHP!"
    exit 1
fi

##
## download
##

URL="http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz"
FILE=phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 5000000)
if [ "$RESULT" == "error" ]; then
	echo "Error: Unable to download $FILE file!"
	exit 1
fi

##
## install
##

echo "Installing phpMyAdmin:"
[ -d $PHPMYADMIN_INSTALL_DIR ] && rm -rf $PHPMYADMIN_INSTALL_DIR
mkdir -p $PHPMYADMIN_INSTALL_DIR
tar -zxf phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz -C $PHPMYADMIN_INSTALL_DIR
mv $PHPMYADMIN_INSTALL_DIR/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages/* $PHPMYADMIN_INSTALL_DIR && rm -rf $PHPMYADMIN_INSTALL_DIR/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages
rm -rfv $PHPMYADMIN_INSTALL_DIR/setup

# check
if [ ! -s $PHPMYADMIN_INSTALL_DIR/index.php ]; then
    echo "Error: phpMyAdmin has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

# database user
PHPMYADMIN_DB_NAME="phpmyadmin"
PHPMYADMIN_DB_USER="phpmyadmin"
PHPMYADMIN_DB_PASS=`get_random_string 32`
mysql_add_user_password "$PHPMYADMIN_DB_USER" "$PHPMYADMIN_DB_PASS"

# generate server certificate
generate_certificate "phpmyadmin.$(hostname).$DOMAIN"

# default language
PHPMYADMIN_DEFAULT_LANGUAGE="en"
if [ "$LOCATION" == "PL" ]; then
    PHPMYADMIN_DEFAULT_LANGUAGE="pl"
fi

# config.inc.php
PHPMYADMIN_BLOWFISH_SECRET=`get_random_string 32`
cat <<EOF > $PHPMYADMIN_INSTALL_DIR/config.inc.php
<?php
\$cfg['blowfish_secret'] = '$PHPMYADMIN_BLOWFISH_SECRET';
\$cfg['Lang'] = '$PHPMYADMIN_DEFAULT_LANGUAGE';
\$i = 0;
\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
//\$cfg['Servers'][\$i]['host'] = '127.0.0.1';
\$cfg['Servers'][\$i]['socket'] = '$INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/log/mysql.sock';
\$cfg['Servers'][\$i]['connect_type'] = 'socket';
\$cfg['Servers'][\$i]['compress'] = true;
\$cfg['Servers'][\$i]['extension'] = 'mysql';
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;
\$cfg['Servers'][\$i]['AllowRoot'] = false;
\$cfg['Servers'][\$i]['controluser'] = '$PHPMYADMIN_DB_USER';
\$cfg['Servers'][\$i]['controlpass'] = '$PHPMYADMIN_DB_PASS';
\$cfg['Servers'][\$i]['pmadb'] = '$PHPMYADMIN_DB_NAME';
\$cfg['Servers'][\$i]['bookmarktable'] = 'pma_bookmark';
\$cfg['Servers'][\$i]['column_info'] = 'pma_column_info';
\$cfg['Servers'][\$i]['designer_coords'] = 'pma_designer_coords';
\$cfg['Servers'][\$i]['history'] = 'pma_history';
\$cfg['Servers'][\$i]['pdf_pages'] = 'pma_pdf_pages';
\$cfg['Servers'][\$i]['recent'] = 'pma_recent';
\$cfg['Servers'][\$i]['relation'] = 'pma_relation';
\$cfg['Servers'][\$i]['table_coords'] = 'pma_table_coords';
\$cfg['Servers'][\$i]['table_info'] = 'pma_table_info';
\$cfg['Servers'][\$i]['table_uiprefs'] = 'pma_table_uiprefs';
\$cfg['Servers'][\$i]['tracking'] = 'pma_tracking';
\$cfg['Servers'][\$i]['userconfig'] = 'pma_userconfig';
?>
EOF

if [ "$CHROOT" == "N" ]; then

    # config vhost 80
    STR=$(cat <<END_HEREDOC
\tRedirect permanent / https://phpmyadmin.$(hostname).$DOMAIN/
END_HEREDOC
)
    $HOST4GE_DIR/bin/httpd_vhost_create.pl -s "httpd" -t "application" -n "phpmyadmin" -i $IP_ADDRESS -d "phpmyadmin.$(hostname).$DOMAIN" -p 80 -c "$STR"
    # config vhost 443
    STR=$(cat <<END_HEREDOC
\tDocumentRoot $PHPMYADMIN_INSTALL_DIR
\t<Directory $PHPMYADMIN_INSTALL_DIR>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder allow,deny
\t\tAllow from all
\t\tRequire ip 192.168.1.0/255.255.255.0
\t\tRequire ip $VPN_NETWORK/$VPN_NETMASK
\t\tRequire ip 82.32.0.0/255.255.0.0
\t</Directory>
\tSSLEngine on
\tSSLCertificateFile $CERTIFICATES_DIR/phpmyadmin.$(hostname).$DOMAIN.pem
\tSSLCertificateKeyFile $CERTIFICATES_DIR/phpmyadmin.$(hostname).$DOMAIN.key
END_HEREDOC
)
    $HOST4GE_DIR/bin/httpd_vhost_create.pl -s "httpd" -t "application" -n "phpmyadmin" -i $IP_ADDRESS -d "phpmyadmin.$(hostname).$DOMAIN" -p 443 -c "$STR"

    # get mysql root password
    MYSQL_ROOT_PASSWORD=`mysql_get_user_password root`
    # config database
    $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysql.server start
    sleep 5
    [ `mysql_database_exists $PHPMYADMIN_DB_NAME` == "yes" ] && mysql_drop_database $PHPMYADMIN_DB_NAME
    replace_in_file 'phpmyadmin' "$PHPMYADMIN_DB_NAME" $PHPMYADMIN_INSTALL_DIR/examples/create_tables.sql
    $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysql --user="root" --password="$MYSQL_ROOT_PASSWORD" < $PHPMYADMIN_INSTALL_DIR/examples/create_tables.sql
    cat <<EOF | $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysql --user="root" --password="$MYSQL_ROOT_PASSWORD"
GRANT USAGE ON mysql.* TO '$PHPMYADMIN_DB_USER'@'localhost' IDENTIFIED BY '$PHPMYADMIN_DB_PASS';
GRANT SELECT (
    Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv,
    Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv,
    File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,
    Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv,
    Execute_priv, Repl_slave_priv, Repl_client_priv
) ON mysql.user TO '$PHPMYADMIN_DB_USER'@'localhost';
GRANT SELECT ON mysql.db TO '$PHPMYADMIN_DB_USER'@'localhost';
GRANT SELECT ON mysql.host TO '$PHPMYADMIN_DB_USER'@'localhost';
GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv) ON mysql.tables_priv TO '$PHPMYADMIN_DB_USER'@'localhost';
GRANT USAGE ON $PHPMYADMIN_DB_NAME.* TO '$PHPMYADMIN_DB_USER'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON $PHPMYADMIN_DB_NAME.* TO '$PHPMYADMIN_DB_USER'@'localhost';
EOF
    sleep 1
    $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysqladmin --user="root" --password="$MYSQL_ROOT_PASSWORD" shutdown
    sleep 3
    # clear password variable
    MYSQL_ROOT_PASSWORD=

fi

# clean up
rm -rfv $PHPMYADMIN_INSTALL_DIR/examples

# set files permission
chown -R root:root $PHPMYADMIN_INSTALL_DIR
chown $PHPMYADMIN_HTTPD_NAME:$PHPMYADMIN_HTTPD_NAME $PHPMYADMIN_INSTALL_DIR/config.inc.php
chmod 400 $PHPMYADMIN_INSTALL_DIR/config.inc.php

##
## post install
##

[ -f phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz ] && rm phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz

# log event
logger -p local0.notice -t host4ge "phpmyadmin $PHPMYADMIN_VERSION installed successfully"

# save package version
package_add_version "phpmyadmin" "$PHPMYADMIN_VERSION"

# version control
git=$INSTALL_DIR/git/bin/git
if [ "$CHROOT" == "N" ] && [ -x $git ]; then
    cd $PHPMYADMIN_INSTALL_DIR
    $git init && chmod 700 .git
    $git config user.name "$ADMIN_NAME"
    $git config user.email "$ADMIN_MAIL"
    $git config core.autocrlf false
    $git config core.filemode true
    $git add .
    $git commit -m "initial commit"
    repositories_add_dir $PWD
fi

exit 0
