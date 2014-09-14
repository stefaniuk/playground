#!/bin/bash
#
# File: bin/task/system-update.sh
#
# Description: Scheduled job. This script starts system update.
#
# Usage:
#
#	system-update.sh

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

# variables
LOG_FILE=/var/log/update.log

# update system
(   DEBIAN_FRONTEND='noninteractive'
    apt-get --yes update
    apt-get -y --force-yes upgrade
    apt-get autoremove
    apt-get autoclean
    rm -rvf /var/cache/apt/archives/*.deb
) 2>&1 | tee $LOG_FILE

# set log file permission
chown root:root $LOG_FILE
chmod 400 $LOG_FILE

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
