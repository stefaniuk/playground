#!/bin/bash

source /srv/host4ge/sbin/include.sh

[ "$HOSTNAME" != "mercury" ] && exit 1

cd /srv/hosting/domains/przystanek.co.uk/var

rm ~/przystanek_co_uk-site.tar.gz > /dev/null 2>&1
mv ./www ./przystanek.co.uk
tar zcf ~/przystanek_co_uk-site.tar.gz ./przystanek.co.uk
mv ./przystanek.co.uk ./www
chmod 400 ~/przystanek_co_uk-site.tar.gz

rm ~/przystanek_co_uk-database-site.tar.gz > /dev/null 2>&1
mysql_backup_database_to_archive "przystanekcouk" ~/przystanek_co_uk-database-site.tar.gz
chmod 400 ~/przystanek_co_uk-database-site.tar.gz

rm ~/przystanek_co_uk-database-forum.tar.gz > /dev/null 2>&1
mysql_backup_database_to_archive "przystanek_forum" ~/przystanek_co_uk-database-forum.tar.gz
chmod 400 ~/przystanek_co_uk-database-forum.tar.gz

scp ~/przystanek_co_uk-*.tar.gz root@web.stefaniuk.org:/root

exit 0

