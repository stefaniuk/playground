#!/bin/bash

source $HOST4GE_DIR/sbin/include.sh

CURRENT_DIR=`pwd`

TIMESTAMP=$(date +"%Y%m%d%H%M")
cd /srv/hosting/domains/mhaker.pl/var/www
tar -zcf $CURRENT_DIR/site-mhaker-$TIMESTAMP.tar.gz .
cd $CURRENT_DIR

sha1sum site-mhaker-$TIMESTAMP.tar.gz > $CURRENT_DIR/site-mhaker-$TIMESTAMP.tar.gz.sha1
sha1sum -c site-mhaker-$TIMESTAMP.tar.gz.sha1
chmod 400 site-mhaker-$TIMESTAMP.*

# [ -f /root/.ssh/known_hosts ] && rm /root/.ssh/known_hosts
# scp -P 2200 /srv/hosting/domains/*-mhaker-*.tar.gz* root@mercury.host4ge.com:/srv/host4ge/projects/mhaker.pl
