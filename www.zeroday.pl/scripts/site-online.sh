#!/bin/bash
#
# File: site-online.sh
#
# Description: Take the site online.

##
## includes
##

source $(dirname $(readlink -f $0))/includes.sh

##
## variables
##

CURRENT_DIR=$(pwd)
SCRIPT_DIR=$(dirname $(readlink -f $0))

##
## main
##

cd $PROJECT_DIR/config

if [ -f $USER.conf ]; then
    cp -fv $USER.conf $INSTALL_DIR/httpd/conf/accounts
    chown root:root $INSTALL_DIR/httpd/conf/accounts/$USER.conf
    chmod 644 $INSTALL_DIR/httpd/conf/accounts/$USER.conf
    apachectl -k restart
fi

cd $CURRENT_DIR

exit 0
