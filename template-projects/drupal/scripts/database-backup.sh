#!/bin/bash
#
# File: database-backup.sh
#
# Description: Backups database.

##
## includes
##

source $(dirname $(readlink -f $0))/includes/variables.sh
source $(dirname $(readlink -f $0))/includes/constants.sh
source $(dirname $(readlink -f $0))/includes/functions.sh

##
## main
##

cd $drupal_dir
echo '1' | $drush_dir/drush --uri=http://$drupal_domain cache-clear > /dev/null 2>&1
mysql_backup_database_to_files $drupal_db_name $project_dir/database

exit 0
