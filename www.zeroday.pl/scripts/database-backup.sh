#!/bin/bash
#
# File: database-backup.sh
#
# Description: Backup database.

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

echo '1' | $SOURCE_DIR/drush/drush --uri=http://$DOMAIN_NAME cache-clear > /dev/null 2>&1
mysql_backup_database_to_files $DATABASE_NAME $PROJECT_DIR/database

cd $CURRENT_DIR

exit 0
