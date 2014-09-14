#!/bin/bash
#
# File: bin/task/system-status.sh
#
# Description: Scheduled job. This script sends a system status report via an e-mail.
#
# Usage:
#
#   system-status.sh

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

test -x $INSTALL_DIR/postfix/bin/mailx || exit 1

TIME=`date +"%T %Z (%d %b %G)"`

# memory
MEM_STR=$(echo `free -m` | awk '{print $8 " " $9 " " $19 " " $20}')
MEM_TOTAL=`echo $MEM_STR | awk '{print $1}'`
MEM_USED=`echo $MEM_STR | awk '{print $2}'`
MEM_SWAP_TOTAL=`echo $MEM_STR | awk '{print $3}'`
MEM_SWAP_USED=`echo $MEM_STR | awk '{print $4}'`

# disk space
FILESYSTEM=`df | awk '{ if ( NR == 2 ) { print } }' | awk '{print $1}'`
if [ ${#FILESYSTEM} -gt 12 ]; then
    DISK_SIZE=`df -h | grep '/$' | awk '{print $1}'`
    DISK_USED=`df -h | grep '/$' | awk '{print $2}'`
    DISK_FREE=`df -h | grep '/$' | awk '{print $3}'`
else
    DISK_SIZE=`df -h | grep $FILESYSTEM | awk '{print $2}'`
    DISK_USED=`df -h | grep $FILESYSTEM | awk '{print $3}'`
    DISK_FREE=`df -h | grep $FILESYSTEM | awk '{print $4}'`
fi

# file hashes
FILE_HASH=`sha1sum $HASH_FILES_FILE | awk '{print $1}'`
FILE_HASHES_NO_CHK=`cat $HASH_FILES_FILE | wc -l`
FILE_HASHES_NO_BAD=`hashes_count_bad`

# locks
LOCK_LIST=`job_lock_list 'system-status'`
[ -z "$LOCK_LIST" ] && LOCK_LIST="no locks"

# TODO: include git status in the report

# report system status
(   echo -e "Time: $TIME" && \
    echo -e "\nConnections (`expr \`netstat -tuapn | grep -v '0.0.0.0:*' | grep -v ':::*' | sed '1 d' | wc -l\` - 1`):\n" && \
    echo -e "`netstat -tuapn | grep -v '0.0.0.0:*' | grep -v ':::*' | sed '1 d'`" && \
    echo -e "\nMemory:\n" && \
    echo -e "Total: ${MEM_TOTAL}M" && \
    echo -e "Used: ${MEM_USED}M" && \
    echo -e "Swap total: ${MEM_SWAP_TOTAL}M" && \
    echo -e "Swap used: ${MEM_SWAP_USED}M" && \
    echo -e "\nDisk:\n" && \
    echo -e "Filesystem: $FILESYSTEM" && \
    echo -e "Total size: $DISK_SIZE" && \
    echo -e "Used space: $DISK_USED" && \
    echo -e "Free space: $DISK_FREE" && \
    echo -e "\nFile hashes:\n" && \
    echo -e "Hash: $FILE_HASH" && \
    echo -e "Number of files checked: $FILE_HASHES_NO_CHK" && \
    echo -e "Number of bad hashes: $FILE_HASHES_NO_BAD" && \
    echo -e "\nLocks: $LOCK_LIST" && \
    echo -e "\nProcesses (`expr \`ps aux --sort -vsize | grep -v '0:00 \[' | wc -l\` - 3`):\n" && \
    echo -e "`ps aux --sort -vsize | grep -v '0:00 \['`" && \
    echo -e "\nUpdates:\n" && \
    echo -e "`cat /var/log/update.log`" \
) | $INSTALL_DIR/postfix/bin/mailx -s "`hostname -f` - status at $TIME" $ADMIN_MAIL

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
