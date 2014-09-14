#!/bin/bash
#
# File: bin/task/system-monitor.sh
#
# Description: Scheduled job. This script writes into a database performance indicators of the system.
#
# Usage:
#
#   system-monitor.sh

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

DB_NAME="host4ge"
DB_USER="host4ge"
DB_PASS=`mysql_get_user_password host4ge`
HOSTNAME=`hostname`

# monitor cpu
VALUES=`mpstat | sed -n 4p | awk '{ print "\x27" $3 "\x27,\x27"  $4 "\x27,\x27"  $5 "\x27,\x27"  $6 "\x27,\x27"  $7 "\x27,\x27"  $8 "\x27,\x27"  $9 "\x27,\x27"  $10 "\x27,\x27"  $11 "\x27" }'`
cat <<EOF | $CMD_MYSQL --user=$DB_USER --password=$DB_PASS
insert into $DB_NAME.server_cpu (date,servername,usr,nice,sys,iowait,irq,soft,steal,guest,idle) values (now(),'$HOSTNAME',$VALUES);
EOF

# monitor memory
VALUES=$(echo `free` | awk '{ print "\x27" $8 "\x27,\x27"  $9 "\x27,\x27"  $19 "\x27,\x27"  $20 "\x27,\x27" $16 "\x27" }')
cat <<EOF | $CMD_MYSQL --user=$DB_USER --password=$DB_PASS
insert into $DB_NAME.server_memory (date,servername,mem_total,mem_used,swap_total,swap_used,buffers_used) values (now(),'$HOSTNAME',$VALUES);
EOF

# monitor disk space
OLD_IFS=$IFS
IFS=$'\n'
FILESYSTEM=`df | awk '{ if ( NR == 2 ) { print } }' | awk '{print $1}'`
if [ ${#FILESYSTEM} -gt 12 ]; then
    for LINE in `df | grep '/$'`; do
        VALUES=$(echo $LINE | awk '{ print "\x27" $5 "\x27,\x27" $2 "\x27,\x27" $1 "\x27" }')
        cat <<EOF | $CMD_MYSQL --user=$DB_USER --password=$DB_PASS
insert into $DB_NAME.server_disk_space (date,servername,filesystem,mounted_on,used,avail) values (now(),'$HOSTNAME','$FILESYSTEM',$VALUES);
EOF
    done
else
    for LINE in `df | grep '^/dev/'`; do
        VALUES=$(echo $LINE | awk '{ print "\x27" $1 "\x27,\x27" $6 "\x27,\x27" $3 "\x27,\x27" $4 "\x27" }')
        cat <<EOF | $CMD_MYSQL --user=$DB_USER --password=$DB_PASS
insert into $DB_NAME.server_disk_space (date,servername,filesystem,mounted_on,used,avail) values (now(),'$HOSTNAME',$VALUES);
EOF
    done
fi
IFS=$OLD_IFS

# monitor traffic

# monitor network connections

# monitor processes
# http://abdussamad.com/archives/488-Memory-usage-of-a-process-under-Linux.html
# http://muzso.hu/2010/08/11/how-to-find-the-processes-using-the-most-swap-space-in-linux
#DATA=$(ps -eo rss,vsz,user,pid,cmd | awk '{ if ( NR > 1  ) { print } }'); echo "$DATA" | egrep -v '[ ^I]+0[ ^I]+0[ ^I]+' | grep -v 'ps -eo rss,vsz,user,pid,cmd' | grep -v 'awk { if ( NR > 1  ) { print } }' | sort -nr
# sum rss
#echo "$DATA" | egrep -v '[ ^I]+0[ ^I]+0[ ^I]+' | grep -v 'ps -eo rss,vsz,user,pid,cmd' | grep -v 'awk { if ( NR > 1  ) { print } }' | awk '{ sum+=$1} END {print sum}'
# sum vsz
#echo "$DATA" | egrep -v '[ ^I]+0[ ^I]+0[ ^I]+' | grep -v 'ps -eo rss,vsz,user,pid,cmd' | grep -v 'awk { if ( NR > 1  ) { print } }' | awk '{ sum+=$2} END {print sum}'

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
