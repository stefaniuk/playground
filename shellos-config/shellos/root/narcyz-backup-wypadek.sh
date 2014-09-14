#!/bin/bash

source /srv/host4ge/sbin/include.sh

[ "$HOSTNAME" != "mercury" ] && exit 1

cd /srv/hosting/domains

rm ~/wypadek_cc-site.tar.gz > /dev/null 2>&1
tar zcf ~/wypadek_cc-site.tar.gz ./wypadek.cc
chmod 400 ~/wypadek_cc-site.tar.gz

rm ~/wypadek_cc-database.tar.gz > /dev/null 2>&1
mysql_backup_database_to_archive "wypadekcc" ~/wypadek_cc-database.tar.gz
chmod 400 ~/wypadek_cc-database.tar.gz

scp ~/wypadek_cc-*.tar.gz root@web.stefaniuk.org:/root

exit 0

