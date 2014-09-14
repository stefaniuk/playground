#!/bin/bash
#
# File: bin/task/update-geoip-database.sh
#
# Description: Scheduled job. This script updates GeoIP database.
#
# Usage:
#
#   update-geoip-database.sh

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
URL="http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
FILE=GeoLiteCity.dat.gz
DIR=$INSTALL_DIR/geoip/share/GeoIP

CHKSUM=`sha1sum $DOWNLOADS_DIR/GeoLiteCity.dat.gz`
RESULT=$(file_download --url $URL --file $FILE --donwload-directory $DIR --force)
if [ "$RESULT" = "success" ]; then

    # compare check sum
    CHKSUM_NEW=`sha1sum $DOWNLOADS_DIR/GeoLiteCity.dat.gz`
    if [ "$CHKSUM" !=  "$CHKSUM_NEW" ]; then
        gunzip -d $DIR/GeoLiteCity.dat.gz
        mv $DIR/GeoLiteCity.dat $DIR/GeoIPCity.dat
        MSG="database updated"
    fi

    # set permission
    chmod 644 $DIR/GeoIPCity.dat

    # check if database file exists
    if [ ! -f $DIR/GeoIPCity.dat ]; then
        MSG="database file does NOT exist"
    fi

else
    MSG="database NOT updated"
fi

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
