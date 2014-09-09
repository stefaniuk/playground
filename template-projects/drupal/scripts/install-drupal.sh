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

source $(dirname $(readlink -f $0))/includes/variables.sh
source $(dirname $(readlink -f $0))/includes/constants.sh
source $(dirname $(readlink -f $0))/includes/functions.sh

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --user)         shift && drupal_system_user=$1
                        ;;
        --path)         shift && drupal_install_path=$1
                        ;;
        --drush-dir)    shift && drush_dir=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -x $drush_dir/drush ]; then
    echo "Error: Drupal requires Drush!"
    exit 1
fi
if [ ! -d $drupal_install_path ]; then
    echo "Error: Drupal requires '$drupal_install_path' directory to exist!"
    exit 1
fi

##
## download
##

# core
url="http://ftp.drupal.org/files/projects/drupal-$DRUPAL_VERSION.tar.gz"
file=drupal-$DRUPAL_VERSION.tar.gz
result=$(file_download --url $url --file $file --check-file-size 3000000)
if [ "$result" = "error" ]; then
    echo "Error: Unable to download $file file!"
    exit 1
fi
# translation
url="http://ftp.drupal.org/files/translations/7.x/drupal/drupal-$DRUPAL_VERSION.pl.po"
file=drupal-$DRUPAL_VERSION.pl.po
result=$(file_download --url $url --file $file --check-file-size 500000)
if [ "$result" = "error" ]; then
    echo "Error: Unable to download $file file!"
    exit 1
fi

##
## install
##

[ ! -d $drupal_dir ] && mkdir $drupal_dir
rm -rf $drupal_dir/*
mv drupal-$DRUPAL_VERSION.tar.gz $drupal_dir
mv drupal-$DRUPAL_VERSION.pl.po $drupal_dir
cd $drupal_dir
tar -zxf drupal-$DRUPAL_VERSION.tar.gz
mv -f drupal-$DRUPAL_VERSION/{*,.ht*} .
mv -f drupal-$DRUPAL_VERSION.pl.po profiles/standard/translations
mkdir -p sites/default/{files,modules,themes}
cp -f sites/default/default.settings.php sites/default/settings.php
chown -R $drupal_system_user:$drupal_system_user $drupal_dir
chown $drupal_system_user:$drupal_system_user .*
chown $HTTPD_USER:$HTTPD_USER sites/default/files
chmod 644 profiles/standard/translations/*.po
rm drupal-$DRUPAL_VERSION.tar.gz
rm -rf drupal-$DRUPAL_VERSION

exit 0
