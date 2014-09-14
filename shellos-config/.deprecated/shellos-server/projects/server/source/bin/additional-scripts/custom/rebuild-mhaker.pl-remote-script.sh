#!/bin/bash

source ~/.profile > /dev/null 2>&1
source $HOST4GE_DIR/sbin/include.sh > /dev/null 2>&1

# clean
echo "clean"
rm ~/site-mhaker* > /dev/null 2>&1
rm ~/database-mhaker* > /dev/null 2>&1

# backup site
cd /srv/hosting/accounts/mhaker/usr/local
echo "backup site"
[ -f ~/site-mhaker.tar.gz ] && rm ~/site-mhaker.tar.gz
tar zcf ~/site-mhaker.tar.gz databases documentation domains drupal drush libraries modules resources scripts toolbox .gitignore
echo "create site check sum"
[ -f ~/site-mhaker.tar.gz.sha1 ] && rm ~/site-mhaker.tar.gz.sha1
sha1sum ~/site-mhaker.tar.gz > ~/site-mhaker.tar.gz.sha1

# backup databases
cd ~
echo "backup mhaker database"
[ -f database-mhaker.tar.gz ] && rm database-mhaker.tar.gz
mysql_backup_database_to_archive mhaker database-mhaker.tar.gz
echo "backup mhaker_cms database"
[ -f database-mhaker_cms.tar.gz ] && rm database-mhaker_cms.tar.gz
mysql_backup_database_to_archive mhaker_cms database-mhaker_cms.tar.gz
echo "backup mhaker_forum database"
[ -f database-mhaker_forum.tar.gz ] && rm database-mhaker_forum.tar.gz
mysql_backup_database_to_archive mhaker_forum database-mhaker_forum.tar.gz
echo "create databases check sum"
[ -f database-mhaker.tar.gz.sha1 ] && rm database-mhaker.tar.gz.sha1
sha1sum ~/database-*.tar.gz > ~/database-mhaker.tar.gz.sha1

# set permissions
chmod 400 ~/*mhaker*

exit 0
