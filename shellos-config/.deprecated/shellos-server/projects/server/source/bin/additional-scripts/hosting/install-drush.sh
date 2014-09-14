#!/bin/bash
#
# File: install-drush.sh
#
# Description: Installs Drush.
#
# Usage:
#
#   install-drush.sh --user <system_user> --path <install_path>

##
## includes
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

DRUSH_VERSION="7.x-5.1"
DRUSH_SYSTEM_USER=
DRUSH_INSTALL_PATH=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --user) shift && DRUSH_SYSTEM_USER=$1
                ;;
        --path) shift && DRUSH_INSTALL_PATH=$1
                ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -d $DRUSH_INSTALL_PATH ]; then
    echo "Error: Drush requires '$DRUSH_INSTALL_PATH' directory to exist!"
    exit 1
fi

##
## download
##

URL="http://ftp.drupal.org/files/projects/drush-$DRUSH_VERSION.tar.gz"
FILE=drush-$DRUSH_VERSION.tar.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 300000)
if [ "$RESULT" = "error" ]; then
    echo "Error: Unable to download $FILE file!"
    exit 1
fi

##
## install
##

CURRENT_DIR=`pwd`
mv $FILE $DRUSH_INSTALL_PATH
cd $DRUSH_INSTALL_PATH
tar -zxf $FILE
cp $DRUSH_INSTALL_PATH/drush/examples/example.drush.ini $DRUSH_INSTALL_PATH/drush/drush.ini
replace_in_file ";disable_functions =" "disable_functions =" $DRUSH_INSTALL_PATH/drush/drush.ini
chown -R $DRUSH_SYSTEM_USER:$DRUSH_SYSTEM_USER $DRUSH_INSTALL_PATH/drush
rm $FILE
cd $CURRENT_DIR

exit 0
