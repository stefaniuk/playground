#!/bin/bash
#
# File: site-offline.sh
#
# Description: Take the site offline.

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
    rm -fv $INSTALL_DIR/httpd/conf/accounts/$USER.conf
    apachectl -k restart
fi

cd $CURRENT_DIR

exit 0
