#!/bin/bash

##
## variables
##

ROUNDCUBE_MYSQL_NAME=
ROUNDCUBE_HTTPD_NAME=
ROUNDCUBE_INSTALL_DIR=$HOSTING_APPLICATIONS_DIR/roundcube
ROUNDCUBE_TIMEZONE="Europe/London"
ROUNDCUBE_LANGUAGE="en"
if [ "$LOCATION" == "PL" ]; then
    ROUNDCUBE_TIMEZONE="Europe/Warsaw"
    ROUNDCUBE_LANGUAGE="pl"
fi
ROUNDCUBE_TIMEZONE_ESC=`echo "$ROUNDCUBE_TIMEZONE" | sed 's/\//\\\\\//g'`

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --roundcube)    shift && ROUNDCUBE_MYSQL_NAME=$1
                        shift && ROUNDCUBE_HTTPD_NAME=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$ROUNDCUBE_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: roundcube requires MySQL!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$ROUNDCUBE_HTTPD_NAME/bin/httpd ]; then
    echo "Error: roundcube requires Apache HTTPD Server!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$ROUNDCUBE_HTTPD_NAME/modules/libphp5.so ]; then
    echo "Error: roundcube requires PHP!"
    exit 1
fi

##
## download
##

#URL="http://downloads.sourceforge.net/project/roundcubemail/roundcubemail/$ROUNDCUBE_VERSION/roundcubemail-$ROUNDCUBE_VERSION.tar.gz"
URL="http://sourceforge.net/projects/roundcubemail/files/roundcubemail-beta/$ROUNDCUBE_VERSION/roundcubemail-$ROUNDCUBE_VERSION.tar.gz/download"
FILE=roundcubemail-$ROUNDCUBE_VERSION.tar.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 3000000)
if [ "$RESULT" == "error" ]; then
	echo "Error: Unable to download $FILE file!"
	exit 1
fi

##
## install
##

echo "Installing roundcube:"
[ -d $ROUNDCUBE_INSTALL_DIR ] && rm -rf $ROUNDCUBE_INSTALL_DIR
mkdir -p $ROUNDCUBE_INSTALL_DIR
tar -zxf roundcubemail-$ROUNDCUBE_VERSION.tar.gz -C $ROUNDCUBE_INSTALL_DIR
mv $ROUNDCUBE_INSTALL_DIR/roundcubemail-$ROUNDCUBE_VERSION/* $ROUNDCUBE_INSTALL_DIR && rm -rf $ROUNDCUBE_INSTALL_DIR/roundcubemail-$ROUNDCUBE_VERSION

# check
if [ ! -s $ROUNDCUBE_INSTALL_DIR/index.php ]; then
    echo "Error: roundcube has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

# database user
ROUNDCUBE_DB_NAME="roundcube"
ROUNDCUBE_DB_USER="roundcube"
ROUNDCUBE_DB_PASS=`get_random_string 32`
mysql_add_user_password "$ROUNDCUBE_DB_USER" "$ROUNDCUBE_DB_PASS"

# generate server certificate
generate_certificate "roundcube.$(hostname).$DOMAIN"

# config files
cp $ROUNDCUBE_INSTALL_DIR/config/db.inc.php.dist $ROUNDCUBE_INSTALL_DIR/config/db.inc.php
replace_in_file "mysql:\/\/roundcube:pass@localhost\/roundcubemail" "mysql:\/\/$ROUNDCUBE_DB_USER:$ROUNDCUBE_DB_PASS@localhost\/$ROUNDCUBE_DB_NAME" $ROUNDCUBE_INSTALL_DIR/config/db.inc.php
cp $ROUNDCUBE_INSTALL_DIR/config/main.inc.php.dist $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['create_default_folders'\] = false;" "\$rcmail_config\['create_default_folders'\] = true;" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['default_charset'\] = 'ISO-8859-1';" "\$rcmail_config\['default_charset'\] = 'UTF-8';" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['default_host'\] = '';" "\$rcmail_config\['default_host'\] = 'localhost';" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['force_https'\] = false;" "\$rcmail_config\['force_https'\] = true;" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['language'\] = null;" "\$rcmail_config\['language'\] = '$ROUNDCUBE_LANGUAGE';" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['message_cache_lifetime'\] = '10d';" "\$rcmail_config\['message_cache_lifetime'\] = '30m';" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['password_charset'\] = 'ISO-8859-1';" "\$rcmail_config\['password_charset'\] = 'UTF-8';" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php
replace_in_file "\$rcmail_config\['timezone'\] = 'auto';" "\$rcmail_config\['timezone'\] = '$ROUNDCUBE_TIMEZONE_ESC';" $ROUNDCUBE_INSTALL_DIR/config/main.inc.php

if [ "$CHROOT" == "N" ]; then

    # config vhost 80
    STR=$(cat <<END_HEREDOC
\tRedirect permanent / https://roundcube.$(hostname).$DOMAIN/
END_HEREDOC
)
    $HOST4GE_DIR/bin/httpd_vhost_create.pl -s "httpd" -t "application" -n "roundcube" -i $IP_ADDRESS -d "roundcube.$(hostname).$DOMAIN" -p 80 -c "$STR"
    # config vhost 443
    STR=$(cat <<END_HEREDOC
\tDocumentRoot $ROUNDCUBE_INSTALL_DIR
\t<Directory $ROUNDCUBE_INSTALL_DIR>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder allow,deny
\t\tAllow from all
\t\tRequire ip 192.168.1.0/255.255.255.0
\t\tRequire ip $VPN_NETWORK/$VPN_NETMASK
\t\tRequire ip 82.32.0.0/255.255.0.0
\t</Directory>
\tSSLEngine on
\tSSLCertificateFile $CERTIFICATES_DIR/roundcube.$(hostname).$DOMAIN.pem
\tSSLCertificateKeyFile $CERTIFICATES_DIR/roundcube.$(hostname).$DOMAIN.key
END_HEREDOC
)
    $HOST4GE_DIR/bin/httpd_vhost_create.pl -s "httpd" -t "application" -n "roundcube" -i $IP_ADDRESS -d "roundcube.$(hostname).$DOMAIN" -p 443 -c "$STR"

    # get mysql root password
    MYSQL_ROOT_PASSWORD=`mysql_get_user_password root`
    # config database
    $INSTALL_DIR/$ROUNDCUBE_MYSQL_NAME/bin/mysql.server start
    sleep 5
    [ `mysql_database_exists $ROUNDCUBE_DB_NAME` == "yes" ] && mysql_drop_database $ROUNDCUBE_DB_NAME
    cat <<EOF | $INSTALL_DIR/$ROUNDCUBE_MYSQL_NAME/bin/mysql --user=root --password=$MYSQL_ROOT_PASSWORD
CREATE DATABASE $ROUNDCUBE_DB_NAME;
GRANT ALL PRIVILEGES ON $ROUNDCUBE_DB_NAME.* TO $ROUNDCUBE_DB_USER@localhost IDENTIFIED BY '$ROUNDCUBE_DB_PASS';
EOF
    $INSTALL_DIR/$ROUNDCUBE_MYSQL_NAME/bin/mysql --user=root --password=$MYSQL_ROOT_PASSWORD $ROUNDCUBE_DB_NAME < $ROUNDCUBE_INSTALL_DIR/SQL/mysql.initial.sql
    sleep 1
    $INSTALL_DIR/$ROUNDCUBE_MYSQL_NAME/bin/mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown
    sleep 3
    # clear password variable
    MYSQL_ROOT_PASSWORD=

fi

# set files permission
chown -R root:root $ROUNDCUBE_INSTALL_DIR
chown $ROUNDCUBE_HTTPD_NAME:$ROUNDCUBE_HTTPD_NAME $ROUNDCUBE_INSTALL_DIR/{config,logs,temp}
chmod 700 $ROUNDCUBE_INSTALL_DIR/{config,logs,temp}
chown -R $ROUNDCUBE_HTTPD_NAME:$ROUNDCUBE_HTTPD_NAME $ROUNDCUBE_INSTALL_DIR/config/*
chmod 400 $ROUNDCUBE_INSTALL_DIR/config/*

##
## post install
##

[ -f roundcubemail-$ROUNDCUBE_VERSION.tar.gz ] && rm roundcubemail-$ROUNDCUBE_VERSION.tar.gz

# log event
logger -p local0.notice -t host4ge "roundcube $ROUNDCUBE_VERSION installed successfully"

# save package version
package_add_version "roundcube" "$ROUNDCUBE_VERSION"

# version control
git=$INSTALL_DIR/git/bin/git
if [ "$CHROOT" == "N" ] && [ -x $git ]; then
    cd $ROUNDCUBE_INSTALL_DIR
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
