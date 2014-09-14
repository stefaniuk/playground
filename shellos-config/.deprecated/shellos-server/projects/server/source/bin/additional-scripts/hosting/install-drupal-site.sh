#!/bin/bash
#
# File: install-drupal-site.sh
#
# Description: Installs Drupal site.
#
# Usage:
#
#   install-drupal-site.sh \
#       --drupal-path <drupal_path> \
#       --drush-path <drush_path> \
#       --domain-path <domain_install_path> \
#       --domain <domain_name> \
#       --user <system_user> \
#       --admin-name <drupal_admin_name> \
#       --admin-pass <drupal_admin_password> \
#       --db-name <db_name> \
#       --db-user <db_user> \
#       --db-pass <db_pass>

##
## includes
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

DRUPAL_PATH=
DRUSH_PATH=
DRUPAL_DOMAIN_PATH=
DRUPAL_DOMAIN=
DRUPAL_SYSTEM_USER=
DRUPAL_DB_NAME=
DRUPAL_DB_USER=
DRUPAL_DB_PASS=
DRUPAL_ADMIN_NAME=
DRUPAL_ADMIN_PASS=
DRUPAL_MYSQL_NAME="mysql"
DRUPAL_HTTPD_NAME="httpd"

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --drupal-path)  shift && DRUPAL_PATH=$1
                        ;;
        --drush-path)   shift && DRUSH_PATH=$1
                        ;;
        --domain-path)  shift && DRUPAL_DOMAIN_PATH=$1
                        ;;
        --domain)       shift && DRUPAL_DOMAIN=$1
                        ;;
        --user)         shift && DRUPAL_SYSTEM_USER=$1
                        ;;
        --admin-name)   shift && DRUPAL_ADMIN_NAME=$1
                        ;;
        --admin-pass)   shift && DRUPAL_ADMIN_PASS=$1
                        ;;
        --db-name)      shift && DRUPAL_DB_NAME=$1
                        ;;
        --db-user)      shift && DRUPAL_DB_USER=$1
                        ;;
        --db-pass)      shift && DRUPAL_DB_PASS=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$DRUPAL_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: Drupal site requires MySQL!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$DRUPAL_HTTPD_NAME/bin/httpd ]; then
    echo "Error: Drupal site requires Apache HTTPD Server!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$DRUPAL_HTTPD_NAME/modules/libphp5.so ]; then
    echo "Error: Drupal site requires PHP!"
    exit 1
fi
if [ ! -f $DRUPAL_PATH/drupal/index.php ]; then
    echo "Error: Drupal site requires Drupal!"
    exit 1
fi
if [ ! -x $DRUSH_PATH/drush/drush ]; then
    echo "Error: Drupal site requires Drush!"
    exit 1
fi
if [ ! -d $DRUPAL_DOMAIN_PATH ]; then
    echo "Error: Drupal site requires '$DRUPAL_DOMAIN_PATH' directory to exist!"
    exit 1
fi

##
## install
##

CURRENT_DIR=`pwd`

# create drupal multi-site domain
$DRUSH_PATH/drush/drush site-install -y \
    --db-url=mysql://root:$(mysql_get_user_password root)@localhost/$DRUPAL_DB_NAME \
    --account-name=$DRUPAL_ADMIN_NAME \
    --account-pass=$DRUPAL_ADMIN_PASS \
    --account-mail=admin@$DRUPAL_DOMAIN \
    --locale=pl \
    --clean-url=1 \
    --site-name=$DRUPAL_DOMAIN \
    --site-mail=admin@$DRUPAL_DOMAIN \
    --sites-subdir=$DRUPAL_DOMAIN
mkdir $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/{modules,themes}

# create database user
cat <<EOF | mysql --user="root" --password=$(mysql_get_user_password root)
GRANT ALL ON $DRUPAL_DB_NAME.* TO '$DRUPAL_DB_USER'@'localhost' IDENTIFIED BY '$DRUPAL_DB_PASS';
EOF
replace_in_file "'root'" "'$DRUPAL_DB_USER'" $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/settings.php
replace_in_file "$(mysql_get_user_password root)" "$DRUPAL_DB_PASS" $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/settings.php

# create domain
cd $DRUPAL_DOMAIN_PATH
[ -d $DRUPAL_DOMAIN ] && rm -r $DRUPAL_DOMAIN
mkdir -p $DRUPAL_DOMAIN/sites/$DRUPAL_DOMAIN
cd $DRUPAL_DOMAIN

cp $DRUPAL_PATH/drupal/.htaccess .
cp $DRUPAL_PATH/drupal/robots.txt .

ln -s $DRUPAL_PATH/drupal/misc misc
ln -s $DRUPAL_PATH/drupal/modules modules
ln -s $DRUPAL_PATH/drupal/themes themes
ln -s $DRUPAL_PATH/drupal/sites/all sites/all

ln -s $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/files sites/$DRUPAL_DOMAIN/files
ln -s $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/modules sites/$DRUPAL_DOMAIN/modules
ln -s $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/themes sites/$DRUPAL_DOMAIN/themes

# httpd-mpm.conf
cat <<EOF > ./index.php
<?php
    chdir('$DRUPAL_PATH/drupal/');
    \$file_name = substr(strrchr(__FILE__, '/'), 1);
    include('./' . \$file_name);
?>
EOF
cp ./index.php ./authorize.php
cp ./index.php ./cron.php
cp ./index.php ./update.php
cp ./index.php ./xmlrpc.php

# set files permission
chown -R $DRUPAL_SYSTEM_USER:$DRUPAL_SYSTEM_USER $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN
chown -R $DRUPAL_HTTPD_NAME:$DRUPAL_HTTPD_NAME $DRUPAL_PATH/drupal/sites/$DRUPAL_DOMAIN/files
chown -R $DRUPAL_SYSTEM_USER:$DRUPAL_SYSTEM_USER $DRUPAL_DOMAIN_PATH/$DRUPAL_DOMAIN

# configure modules
cd $DRUPAL_PATH/drupal
#$DRUSH_PATH/drush/drush --uri=http://$DRUPAL_DOMAIN -y pm-disable overlay
#$DRUSH_PATH/drush/drush --uri=http://$DRUPAL_DOMAIN -y pm-uninstall overlay
$DRUSH_PATH/drush/drush --uri=http://$DRUPAL_DOMAIN -y pm-enable garland
$DRUSH_PATH/drush/drush --uri=http://$DRUPAL_DOMAIN -y vset theme_default garland
$DRUSH_PATH/drush/drush --uri=http://$DRUPAL_DOMAIN -y vset admin_theme seven
echo '1' | $DRUSH_PATH/drush/drush --uri=http://$DRUPAL_DOMAIN cache-clear

# remove modules
#rm -r $DRUPAL_PATH/drupal/modules/overlay

cd $CURRENT_DIR

exit 0
