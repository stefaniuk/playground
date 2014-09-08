#!/bin/bash
#
# File: project-prepare.sh
#
# Description: Prepare project.

##
## includes
##

source $(dirname $(readlink -f $0))/includes.sh

##
## variables
##

CURRENT_DIR=$(pwd)

##
## main
##

[ ! -d $SOURCE_DIR/libraries ] && mkdir $SOURCE_DIR/libraries

# set up git repository
echo "set up git repository"
cd $PROJECT_DIR
git config user.name "$ADMIN_NAME"
git config user.email "$ADMIN_MAIL"
git config core.autocrlf false
git config core.filemode true
repositories_add_dir $PROJECT_DIR

# install drush
echo "install drush"
install-drush.sh \
    --user $USER \
    --path $SOURCE_DIR

# install zend framework
echo "install zend framework"
install-zendframework.sh \
    --user $USER \
    --path $SOURCE_DIR/libraries/zendframework \
    --dir-name "1.x"

cd $CURRENT_DIR

exit 0
