#!/bin/bash
#
# File: database-restore.sh
#
# Description: Restores database.

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
mysql_restore_database_from_files $project_dir/database $drupal_db_name

exit 0
