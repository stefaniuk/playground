#!/bin/bash
#
# File: database-restore.sh
#
# Description: Restore database.

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

cd $SOURCE_DIR/drupal

mysql_restore_database_from_files $PROJECT_DIR/database $DATABASE_NAME

cd $CURRENT_DIR

exit 0
