#!/bin/bash
#
# File: project-files.sh
#
# Description: Set up file permissions.

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

chown -R $USER:$USER $PROJECT_DIR/{.*,*}

chmod 700 $PROJECT_DIR/{.git*,config,database,documentation,patches,scripts,utils,build*}
chmod 700 $PROJECT_DIR/scripts/*.sh

chown -R $WWW_USER:$WWW_USER $SOURCE_DIR/drupal/sites/default/files
chown -R $WWW_USER:$WWW_USER $SOURCE_DIR/drupal/sites/$DOMAIN_NAME/files

cd $SOURCE_DIR/drupal
find -iname '.htaccess' | xargs chown -R $USER:$USER

cd $CURRENT_DIR

exit 0
