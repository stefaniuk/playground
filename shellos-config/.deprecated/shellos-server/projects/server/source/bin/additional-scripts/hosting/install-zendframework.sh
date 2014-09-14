#!/bin/bash
#
# File: install-zendframework.sh
#
# Description: Installs Zend Framework, PHP library.
#
# Usage:
#
#   install-zendframework.sh --user system_user --path install_path --dir-name install_dir_name

##
## includes
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

ZF_VERSION="1.11.11"
ZF_SYSTEM_USER=
ZF_INSTALL_PATH=
ZF_INSTALL_DIR_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --user)     shift && ZF_SYSTEM_USER=$1
                    ;;
        --path)     shift && ZF_INSTALL_PATH=$1
                    ;;
        --dir-name) shift && ZF_INSTALL_DIR_NAME=$1
                    ;;
    esac
    shift
done

##
## download
##

URL="http://framework.zend.com/releases/ZendFramework-$ZF_VERSION/ZendFramework-$ZF_VERSION.tar.gz"
FILE=zendframework-$ZF_VERSION.tar.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 15000000)
if [ "$RESULT" == "error" ]; then
    echo "Error: Unable to download $FILE file!"
    exit 1
fi

##
## install
##

CURRENT_DIR=`pwd`
[ ! -d $ZF_INSTALL_PATH ] && mkdir -p $ZF_INSTALL_PATH
mv $FILE $ZF_INSTALL_PATH
cd $ZF_INSTALL_PATH
tar -zxf $FILE
[ -d $ZF_INSTALL_DIR_NAME ] && rm -rf $ZF_INSTALL_DIR_NAME
[ "ZendFramework-$ZF_VERSION" != "$ZF_INSTALL_DIR_NAME" ] && mv ZendFramework-$ZF_VERSION $ZF_INSTALL_DIR_NAME
chown -R $ZF_SYSTEM_USER:$ZF_SYSTEM_USER $ZF_INSTALL_PATH
rm $ZF_INSTALL_PATH/$FILE
cd $CURRENT_DIR

exit 0
