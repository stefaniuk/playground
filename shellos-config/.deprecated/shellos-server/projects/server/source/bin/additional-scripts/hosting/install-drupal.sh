#!/bin/bash
#
# File: install-drupal.sh
#
# Description: Installs Drupal.
#
# Usage:
#
#   install-drupal.sh --user <system_user> --path <install_path> --drush-dir <drush_install_dir>

##
## includes
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

DRUPAL_VERSION="7.14"
DRUPAL_SYSTEM_USER=
DRUPAL_INSTALL_PATH=
DRUPAL_DRUSH_DIR=
DRUPAL_MYSQL_NAME="mysql"
DRUPAL_HTTPD_NAME="httpd"

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --user)         shift && DRUPAL_SYSTEM_USER=$1
                        ;;
        --path)         shift && DRUPAL_INSTALL_PATH=$1
                        ;;
        --drush-dir)    shift && DRUPAL_DRUSH_DIR=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$DRUPAL_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: Drupal requires MySQL!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$DRUPAL_HTTPD_NAME/bin/httpd ]; then
    echo "Error: Drupal requires Apache HTTPD Server!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$DRUPAL_HTTPD_NAME/modules/libphp5.so ]; then
    echo "Error: Drupal requires PHP!"
    exit 1
fi
if [ ! -x $DRUPAL_DRUSH_DIR/drush ]; then
    echo "Error: Drupal requires Drush!"
    exit 1
fi
if [ ! -d $DRUPAL_INSTALL_PATH ]; then
    echo "Error: Drupal requires '$DRUPAL_INSTALL_PATH' directory to exist!"
    exit 1
fi

##
## download
##

# core
URL="http://ftp.drupal.org/files/projects/drupal-$DRUPAL_VERSION.tar.gz"
FILE=drupal-$DRUPAL_VERSION.tar.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE)
if [ "$RESULT" = "error" ]; then
    echo "Error: Unable to download $FILE file!"
    exit 1
fi
# translation
URL="http://ftp.drupal.org/files/translations/7.x/drupal/drupal-$DRUPAL_VERSION.pl.po"
FILE=drupal-$DRUPAL_VERSION.pl.po
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE)
if [ "$RESULT" = "error" ]; then
    echo "Error: Unable to download $FILE file!"
    exit 1
fi

##
## install
##

CURRENT_DIR=`pwd`
[ ! -d $DRUPAL_INSTALL_PATH/drupal ] && mkdir $DRUPAL_INSTALL_PATH/drupal
mv drupal-$DRUPAL_VERSION.tar.gz $DRUPAL_INSTALL_PATH/drupal
mv drupal-$DRUPAL_VERSION.pl.po $DRUPAL_INSTALL_PATH/drupal
cd $DRUPAL_INSTALL_PATH/drupal
tar -zxf drupal-$DRUPAL_VERSION.tar.gz
mv drupal-$DRUPAL_VERSION/{*,.ht*} .
mv drupal-$DRUPAL_VERSION.pl.po profiles/standard/translations
mkdir -p sites/default/{files,modules,themes}
cp sites/default/default.settings.php sites/default/settings.php
chown -R $DRUPAL_SYSTEM_USER:$DRUPAL_SYSTEM_USER $DRUPAL_INSTALL_PATH/drupal
chown $DRUPAL_SYSTEM_USER:$DRUPAL_SYSTEM_USER .*
chown $DRUPAL_HTTPD_NAME:$DRUPAL_HTTPD_NAME sites/default/files
chown $DRUPAL_HTTPD_NAME:$DRUPAL_HTTPD_NAME sites/default/settings.php
chmod 644 profiles/standard/translations/*.po
rm drupal-$DRUPAL_VERSION.tar.gz
rm -rf drupal-$DRUPAL_VERSION
cd $CURRENT_DIR

exit 0
