#!/bin/bash
#
# File: bin/task/backup-databases.sh
#
# Description: Scheduled job. This script backups databases.
#
# Usage:
#
#	backup-databases.sh

# include
source $HOST4GE_DIR/conf/includes.sh

T1=`date +%s`
MSG=

# check lock
[ -f $JOB_LOCK_ALL_FILE ] && exit 0
if [ `job_lock_exists $( basename $0 .sh )` == "yes" ]; then
    logger -p local0.notice -t host4ge "job $( basename $0 .sh ) is locked"
    exit 0
fi
# set lock
job_lock_set $( basename $0 .sh )

if [ $(server_has_role development) == "no" ]; then

# ---------- BEGIN ----------

# remove database backups older than three weeks
find $BACKUP_DATABASES_DIR/* -mtime +$JOB_BACKUP_DATABASES_REMOVE_DAYS -exec rm {} \;

# dump databases
DB_ROOT_PASSWORD=`mysql_get_user_password root`
DATABASES=$(echo "show databases;" | $CMD_MYSQL --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
TIMESTAMP=$(date +"%Y%m%d%H%M")
for DB in $DATABASES; do
    if [ ! "$DB" == "mysql" ] && [ ! "$DB" == "information_schema" ] && [ ! "$DB" == "performance_schema" ]; then
        mysql_backup_database_to_archive $DB $BACKUP_DATABASES_DIR/$DB-$TIMESTAMP.tar.gz
    fi
done
DB_ROOT_PASSWORD=

# ---------- END ------------

fi

# remove lock
job_lock_unset $( basename $0 .sh )

# measure time
T2=`date +%s`
TIME=$((T2-T1))

# log an event only if it takes longer than specified number of seconds or there is a message
[ $TIME -le $JOB_LOG_EVENT_TIME ] && [ "$MSG" == "" ] && exit 0
if [ "$MSG" == "" ]; then
    logger -p local0.notice -t host4ge "job $( basename $0 .sh ) run (time: $TIME s)"
else
    logger -p local0.notice -t host4ge "job $( basename $0 .sh ) run - $MSG (time: $TIME s)"
fi

exit 0
