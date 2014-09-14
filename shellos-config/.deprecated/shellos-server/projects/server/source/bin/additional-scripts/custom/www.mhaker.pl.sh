#!/bin/bash
#
# File: www.mhaker.pl.sh
#
# Description: This script creates a system account for the www.mhaker.pl web site.
#
# Usage:
#
#   www.mhaker.pl.sh 2>&1 | tee $LOG_DIR/www.mhaker.pl.log

##
## includes
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

USER="mhaker"
#PASS=$(get_random_string 32)
PASS="PBwOH26B2UsGKCdBXT3aeMme4tBjLt32"
DIR=$HOSTING_ACCOUNTS_DIR/$USER
HOME_DIR=$DIR/home/$USER
CURRENT_DIR=$(pwd)
DOMAIN_NAME="mhaker.pl"

##
## main
##

# create account
echo "create account"
[ $(user_exists.pl -u $USER) == "yes" ] && user_remove.pl -u $USER
user_create.pl -u $USER -p $PASS -G "sshjail" -d $DIR

(
    echo "------------------------------------------------------"
    echo "System user:          $USER"
    echo "System pass:          $PASS"
    echo "System directory:     $DIR"
    echo "------------------------------------------------------"
)

cd $CURRENT_DIR

exit 0
