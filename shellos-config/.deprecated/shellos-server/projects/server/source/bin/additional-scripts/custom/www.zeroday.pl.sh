#!/bin/bash
#
# File: www.zeroday.pl.sh
#
# Description: This script creates a system account for the www.zeroday.pl web site.
#
# Usage:
#
#   www.zeroday.pl.sh 2>&1 | tee $LOG_DIR/www.zeroday.pl.log

##
## includes
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

USER="zeroday"
#PASS=$(get_random_string 32)
PASS="DkIfD9vuvi61V27SY2ReiPYd4mXQyvAS"
DIR=$HOSTING_ACCOUNTS_DIR/$USER
HOME_DIR=$DIR/home/$USER
CURRENT_DIR=$(pwd)
DOMAIN_NAME="zeroday.pl"

##
## main
##

# create account
echo "create account"
[ $(user_exists.pl -u $USER) == "yes" ] && user_remove.pl -u $USER
user_create.pl -u $USER -p $PASS -G "sshjail" -d $DIR

# add key
echo "make sure you have a valid key in ~/.ssh/keys/$DOMAIN_NAME"
read -p "press any key to continue..."
[ -f ~/.ssh/keys/$DOMAIN_NAME ] && ssh-add ~/.ssh/keys/$DOMAIN_NAME

# clone project repository
echo "clone project repository"
cd $HOME_DIR
git clone git@github.com:stefaniuk/www.$DOMAIN_NAME.git ./project

# remove private key
if [ $(server_has_role development) == "no" ]; then
    echo "remove private key"
    [ -f ~/.ssh/keys/$DOMAIN_NAME ] && rm -fv ~/.ssh/keys/$DOMAIN_NAME
fi

(
    echo "------------------------------------------------------"
    echo "System user:          $USER"
    echo "System pass:          $PASS"
    echo "System directory:     $DIR"
    echo "------------------------------------------------------"
)

cd $CURRENT_DIR

exit 0
