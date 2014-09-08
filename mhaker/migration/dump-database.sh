#!/bin/bash

source $HOST4GE_DIR/sbin/include.sh

CURRENT_DIR=`pwd`

cd /srv/hosting/domains
TIMESTAMP=$(date +"%Y%m%d%H%M")
DB_ROOT_PASSWORD=`mysql_get_user_password root`

mysql_backup_database_to_file "mhaker_cms" database-mhaker-$TIMESTAMP.tar.gz

sha1sum database-mhaker-$TIMESTAMP.tar.gz > database-mhaker-$TIMESTAMP.tar.gz.sha1
sha1sum -c database-mhaker-$TIMESTAMP.tar.gz.sha1
chmod 400 database-mhaker-$TIMESTAMP.*

cd $CURRENT_DIR

# [ -f /root/.ssh/known_hosts ] && rm /root/.ssh/known_hosts
# scp -P 2200 /srv/hosting/domains/*-mhaker-*.tar.gz* root@mercury.host4ge.com:/srv/host4ge/projects/mhaker.pl
