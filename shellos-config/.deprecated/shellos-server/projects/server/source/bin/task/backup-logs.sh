#!/bin/bash
#
# File: bin/task/backup-logs.sh
#
# Description: Scheduled job. This script backups system logs.
#
# Usage:
#
#   backup-logs.sh

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

# remove log backups older than a year
find $BACKUP_LOGS_DIR/* -mtime +$JOB_BACKUP_LOGS_REMOVE_DAYS -exec rm {} \;

# rotate logs
test -x /usr/sbin/logrotate || exit 1
/usr/sbin/logrotate /etc/logrotate.conf

# backup logs
cd /var/log
TIMESTAMP=$(date +"%Y%m%d%H%M")
for LOG in $LOG_FILE_LIST; do
    COUNT=`ls /var/log/$LOG.*.gz | wc -l`
    if [ $COUNT -gt 8 ]; then
        tar -zcf $LOG-$TIMESTAMP.tar.gz $LOG.*.gz
        rm $LOG.*.gz
        mv $LOG-$TIMESTAMP.tar.gz $BACKUP_LOGS_DIR
        chmod 400 $BACKUP_LOGS_DIR/$LOG-$TIMESTAMP.tar.gz
    fi
done

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
