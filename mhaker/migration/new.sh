#
# (1) (source - live server)
#

cd /srv/hosting/domains
DB_ROOT_PASSWORD=`mysql_get_user_password root`
TIMESTAMP=$(date +"%Y%m%d%H%M")
TABLES=$(echo "use mhaker_cms; show tables;" | mysql --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
for TABLE in $TABLES; do
    COLLATION=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = 'mhaker_cms' and t.table_name = '$TABLE';" | mysql --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
    mysqldump --user=root --password=$DB_ROOT_PASSWORD --default-character-set=$COLLATION --extended-insert=FALSE mhaker_cms $TABLE > $TABLE.sql
    file -i $TABLE.sql >> mhaker.encoding.info
done
tar -zcf mhaker-$TIMESTAMP.tar.gz *.sql mhaker.encoding.info
rm {*.sql,mhaker.encoding.info}

tar -zcf mhaker-www-$TIMESTAMP.tar.gz ./mhaker.pl --exclude ./mhaker.pl/.git
sha1sum *-$TIMESTAMP.tar.gz > mhaker-sum-$TIMESTAMP.sha1
sha1sum -c mhaker-sum-$TIMESTAMP.sha1
chmod 400 *-$TIMESTAMP.*
[ -f /root/.ssh/known_hosts ] && rm /root/.ssh/known_hosts
scp -P 2200 /srv/hosting/domains/*.tar.gz root@mercury.host4ge.com:/srv/hosting/domains
# copy last line of the output >>>

#
# (2) (destination - test server)
#

# <<< paste copied text "TIMESTAMP=$TIMESTAMP"
cd /srv/hosting/domains
sha1sum -c mhaker-sum-$TIMESTAMP.sha1
# -- test only ---
MHAKER_SYSTEM_USER="mhaker"
MHAKER_DIR=/srv/hosting/domains/mhaker.pl
MHAKER_DOMAIN="test.host4ge.com"
user_create.pl -u $MHAKER_SYSTEM_USER -d $MHAKER_DIR
httpd_vhost_create.pl -s httpd -t domain -n $MHAKER_SYSTEM_USER -i '*' -d $MHAKER_DOMAIN -p 80 -c "\tSuexecUserGroup $MHAKER_SYSTEM_USER $MHAKER_SYSTEM_USER\n\tDocumentRoot $MHAKER_DIR/public\n\t<Directory $MHAKER_DIR/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</Directory>"
httpd_vhost_create.pl -s httpd -t domain -n $MHAKER_SYSTEM_USER -i '*' -d $MHAKER_DOMAIN -p 443 -c "\tSuexecUserGroup $MHAKER_SYSTEM_USER $MHAKER_SYSTEM_USER\n\tDocumentRoot $MHAKER_DIR/public\n\t<Directory $MHAKER_DIR/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</Directory>\n\tSSLEngine on\n\tSSLCertificateFile /srv/openssl/certs/$MHAKER_DOMAIN.pem\n\tSSLCertificateKeyFile /srv/openssl/certs/$MHAKER_DOMAIN.key"
generate_certificate $MHAKER_DOMAIN
apachectl -k restart
httpd -S
DB_ROOT_PASSWORD="4REXnAFv89UQcMUgAE5cKbi1xKodKWt4" # TODO: update database root password
DB_MHAKER_PASSWORD="VEXoXenxySTCadJetbAtt15"
cat <<EOF | mysql --user=root --password=$DB_ROOT_PASSWORD
DROP DATABASE IF EXISTS mhaker_cms;
CREATE DATABASE mhaker_cms DEFAULT COLLATE latin1_swedish_ci;
GRANT SELECT, INSERT, UPDATE, DELETE ON mhaker_cms.* TO 'mhaker_cms'@'localhost' IDENTIFIED BY '$DB_MHAKER_PASSWORD';
USE mhaker_cms;
EOF
tar -zxf $(ls mhaker-db-*.tar.gz)
FILES=$(ls *.sql)
for f in $FILES; do
    mysql --user=root --password=$DB_ROOT_PASSWORD mhaker_cms < $f
done
rm {*.sql,encoding.info}
tar -zxf $(ls mhaker-www-*.tar.gz)
rm -r ./mhaker.pl/{.htpasswd,logs,private_html,public_ftp,stats}
mv ./mhaker.pl/public_html/{*,.ht*} ./mhaker.pl/var/www
rm -r ./mhaker.pl/public_html
chown -R $MHAKER_SYSTEM_USER:$MHAKER_SYSTEM_USER ./mhaker.pl/var/www
chown httpd:httpd ./mhaker.pl/var/www/config/config.php
chmod 0400 ./mhaker.pl/var/www/config/config.php

#
# (3) (source - test server)
#

cd /srv/hosting/domains
TIMESTAMP=
scp -P 2200 /srv/hosting/domains/*-$TIMESTAMP.* root@earth.host4ge.com:/srv/hosting/domains
echo "TIMESTAMP=$TIMESTAMP"
# copy last line of the output >>>

#
# (4) (destination - live server)
#
# <<< paste copied text "TIMESTAMP=$TIMESTAMP"
cd /srv/hosting/domains
sha1sum -c mhaker-sum-$TIMESTAMP.sha1
MHAKER_SYSTEM_USER="mhaker"
MHAKER_DIR=/srv/hosting/domains/mhaker.pl
MHAKER_DOMAIN="mhaker.pl"
user_create.pl -u $MHAKER_SYSTEM_USER -d $MHAKER_DIR
httpd_vhost_create.pl -s httpd -t domain -n $MHAKER_SYSTEM_USER -i '*' -d $MHAKER_DOMAIN -p 80 -c "\tSuexecUserGroup $MHAKER_SYSTEM_USER $MHAKER_SYSTEM_USER\n\tDocumentRoot $MHAKER_DIR/public\n\t<Directory $MHAKER_DIR/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</Directory>"
httpd_vhost_create.pl -s httpd -t domain -n $MHAKER_SYSTEM_USER -i '*' -d $MHAKER_DOMAIN -p 443 -c "\tSuexecUserGroup $MHAKER_SYSTEM_USER $MHAKER_SYSTEM_USER\n\tDocumentRoot $MHAKER_DIR/public\n\t<Directory $MHAKER_DIR/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</Directory>\n\tSSLEngine on\n\tSSLCertificateFile /srv/openssl/certs/$MHAKER_DOMAIN.pem\n\tSSLCertificateKeyFile /srv/openssl/certs/$MHAKER_DOMAIN.key"
generate_certificate $MHAKER_DOMAIN
apachectl -k restart
httpd -S
DB_ROOT_PASSWORD="23s31RCQ9XFKfZRBo24yRCGWct9kbd5w" # TODO: update database root password
DB_MHAKER_PASSWORD="VEXoXenxySTCadJetbAtt15"
cat <<EOF | mysql --user=root --password=$DB_ROOT_PASSWORD
DROP DATABASE IF EXISTS mhaker_cms;
CREATE DATABASE mhaker_cms DEFAULT COLLATE latin1_swedish_ci;
GRANT SELECT, INSERT, UPDATE, DELETE ON mhaker_cms.* TO 'mhaker_cms'@'localhost' IDENTIFIED BY '$DB_MHAKER_PASSWORD';
USE mhaker_cms;
EOF
tar -zxf $(ls mhaker-db-*.tar.gz)
FILES=$(ls *.sql)
for f in $FILES; do
    mysql --user=root --password=$DB_ROOT_PASSWORD mhaker_cms < $f
done
rm {*.sql,encoding.info}
tar -zxf $(ls mhaker-www-*.tar.gz)
rm -r ./mhaker.pl/{.htpasswd,logs,private_html,public_ftp,stats}
mv ./mhaker.pl/public_html/{*,.ht*} ./mhaker.pl/var/www
rm -r ./mhaker.pl/public_html
chown -R $MHAKER_SYSTEM_USER:$MHAKER_SYSTEM_USER ./mhaker.pl/var/www
chown httpd:httpd ./mhaker.pl/var/www/config/config.php
chmod 0400 ./mhaker.pl/var/www/config/config.php

#
# (4)
#

<VirtualHost *:80>
	ServerName hosting.host4ge.pl
	ProxyRequests Off
	<Proxy *>
		Order deny,allow
		Allow from all
	</Proxy>
	ProxyPass / http://vpspanel.kylos.net.pl:5353/
	ProxyPassReverse / http://vpspanel.kylos.net.pl:5353/
</VirtualHost>

#
# (x) drush + drupal + phpbb
#

DRUPAL_SYSTEM_USER="test"
DRUPAL_DOMAIN="test.host4ge.com"
DRUPAL_DIR="/srv/hosting/domains/$DRUPAL_DOMAIN"
user_create.pl -u $DRUPAL_SYSTEM_USER -d $DRUPAL_DIR
httpd_vhost_create.pl -s httpd -t domain -n $DRUPAL_SYSTEM_USER -i '*' -d $DRUPAL_DOMAIN -p 80 -c "\tSuexecUserGroup $DRUPAL_SYSTEM_USER $DRUPAL_SYSTEM_USER\n\tDocumentRoot $DRUPAL_DIR/public\n\t<Directory $DRUPAL_DIR/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</Directory>"
httpd_vhost_create.pl -s httpd -t domain -n $DRUPAL_SYSTEM_USER -i '*' -d $DRUPAL_DOMAIN -p 443 -c "\tSuexecUserGroup $DRUPAL_SYSTEM_USER $DRUPAL_SYSTEM_USER\n\tDocumentRoot $DRUPAL_DIR/public\n\t<Directory $DRUPAL_DIR/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</Directory>\n\tSSLEngine on\n\tSSLCertificateFile /srv/openssl/certs/$DRUPAL_DOMAIN.pem\n\tSSLCertificateKeyFile /srv/openssl/certs/$DRUPAL_DOMAIN.key"
generate_certificate $DRUPAL_DOMAIN
apachectl -k restart
install-drush.sh
install-drupal.sh
install-phpbb3.sh
install-phpbbdrupalbridge.sh

cd /srv/hosting/domains/$DRUPAL_DOMAIN/public
rm phpBB3/install -r
# profile
/srv/hosting/domains/$DRUPAL_DOMAIN/usr/local/drush/drush -y dl entity og profile2 field_permissions userpoints userpoints_nc
/srv/hosting/domains/$DRUPAL_DOMAIN/usr/local/drush/drush -y en entity og profile2 field_permissions userpoints userpoints_nc

# remove login facility from phpbb3
cp $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/index_body.html $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/index_body.html.old
file_content_replace.pl -s "<form method=\"post\" action=\"{S_LOGIN_ACTION}\" class=\"headerspace\">.*?<\/form>" -r "" -f $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/index_body.html
cp $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/login_body.html $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/login_body.html.old
file_content_replace.pl -s "<form action=\"{S_LOGIN_ACTION}\" method=\"post\" id=\"login\">.*?<\/form>" -r "" -f $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/login_body.html
cp $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/login_forum.html $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/login_forum.html.old
file_content_replace.pl -s "<form id=\"login_forum\" method=\"post\" action=\"{S_LOGIN_ACTION}\">.*?<\/form>" -r "" -f $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/login_forum.html
cp $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/viewforum_body.html $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/viewforum_body.html.old
file_content_replace.pl -s "<form action=\"{S_LOGIN_ACTION}\" method=\"post\">.*?<\/form>" -r "" -f $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/viewforum_body.html
# remove register facility from phpbb3
cp $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/ucp_register.html $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/ucp_register.html.old
file_content_replace.pl -s "<form method=\"post\" action=\"{S_UCP_ACTION}\" id=\"register\">.*?<\/form>" -r "" -f $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/ucp_register.html
# others
cp $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/overall_footer.html $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/overall_footer.html.old
file_content_replace.pl -s "<div class=\"copyright\">.*?<\/div>" -r "" -f $DRUPAL_DIR/var/www/phpBB3/styles/prosilver/template/overall_footer.html
# TODO: problem to login as admin

#
# (x) forum migration
#

DB_ROOT_PASSWORD=`mysql_get_user_password root`
# backup databases
DATABASES="drupal phpbb3"
for DB in $DATABASES; do
    TABLES=$(echo "use $DB; show tables;" | mysql --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
    for TABLE in $TABLES; do
        COLLATION=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = '$DB' and t.table_name = '$TABLE';" | mysql --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
        mysqldump --user="root" --password="$DB_ROOT_PASSWORD" --default-character-set="$COLLATION" --extended-insert=FALSE "$DB" "$TABLE" > $DB.$TABLE.sql
        file -i $DB.$TABLE.sql >> $DB.encoding.info
    done
    COUNT=`ls $DB.*.sql | wc -l`
    echo $DB files $COUNT
    if [ $COUNT -gt 0 ]; then
        [ -f $INSTALL_DIR/backup/databases/database-$DB.tar.gz ] && rm $INSTALL_DIR/backup/databases/database-$DB.tar.gz
        tar -zcf database-$DB.tar.gz $DB.*.sql $DB.encoding.info
        rm {$DB.*.sql,$DB.encoding.info}
        mv database-$DB.tar.gz $INSTALL_DIR/backup/databases
        chmod 400 $INSTALL_DIR/backup/databases/database-$DB.tar.gz
    fi
done
# restore databases
DB_ROOT_PASSWORD=`mysql_get_user_password root`
DATABASES="drupal phpbb3"
for DB in $DATABASES; do
    cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
DROP DATABASE IF EXISTS $DB;
CREATE DATABASE $DB;
GRANT ALL ON $DB.* TO '$DB'@'localhost' IDENTIFIED BY '$DB';
EOF
    tar -zxf $INSTALL_DIR/backup/databases/database-$DB.tar.gz
    FILES=$(ls *.sql)
    for FILE in $FILES; do
        mysql --user="root" --password="$DB_ROOT_PASSWORD" "$DB" < $FILE
    done
    rm {*.sql,*.encoding.info}
done
#
# mhaker forum migration
#
DB_ROOT_PASSWORD=`mysql_get_user_password root`
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use mhaker_pl_forum;
delete from acl_groups;
insert into acl_groups (group_id, forum_id, auth_option_id, auth_role_id, auth_setting) values
(1, 0, 85, 0, 1),(1, 0, 93, 0, 1),(1, 0, 111, 0, 1),(5, 0, 0, 5, 0),(5, 0, 0, 1, 0),(2, 0, 0, 6, 0),(3, 0, 0, 6, 0),(4, 0, 0, 5, 0),(4, 0, 0, 10, 0),(7, 0, 0, 23, 0),(5, 3, 0, 14, 0),(5, 4, 0, 14, 0),(5, 5, 0, 14, 0),(5, 6, 0, 14, 0),(5, 7, 0, 14, 0),(5, 8, 0, 14, 0),(5, 9, 0, 14, 0),(5, 10, 0, 14, 0),(5, 11, 0, 14, 0),(5, 12, 0, 14, 0),(5, 13, 0, 14, 0),(5, 14, 0, 14, 0),(5, 15, 0, 14, 0),(5, 16, 0, 14, 0),(6, 3, 0, 19, 0),(6, 4, 0, 19, 0),(6, 5, 0, 19, 0),(6, 6, 0, 19, 0),(6, 7, 0, 19, 0),(6, 8, 0, 19, 0),(6, 9, 0, 19, 0),(6, 10, 0, 19, 0),(6, 11, 0, 19, 0),(6, 12, 0, 19, 0),(6, 13, 0, 19, 0),(6, 14, 0, 19, 0),(6, 15, 0, 19, 0),(6, 16, 0, 19, 0),(4, 3, 0, 14, 0),(4, 4, 0, 14, 0),(4, 5, 0, 14, 0),(4, 6, 0, 14, 0),(4, 7, 0, 14, 0),(4, 8, 0, 14, 0),(4, 9, 0, 14, 0),(4, 10, 0, 14, 0),(4, 11, 0, 14, 0),(4, 12, 0, 14, 0),(4, 13, 0, 14, 0),(4, 14, 0, 14, 0),(4, 15, 0, 14, 0),(4, 16, 0, 14, 0),(1, 3, 0, 17, 0),(1, 4, 0, 17, 0),(1, 5, 0, 17, 0),(1, 6, 0, 17, 0),(1, 7, 0, 17, 0),(1, 8, 0, 17, 0),(1, 9, 0, 17, 0),(1, 10, 0, 17, 0),(1, 11, 0, 17, 0),(1, 12, 0, 17, 0),(1, 13, 0, 17, 0),(1, 14, 0, 17, 0),(1, 15, 0, 17, 0),(1, 16, 0, 17, 0),(7, 3, 0, 17, 0),(7, 4, 0, 17, 0),(7, 5, 0, 17, 0),(7, 6, 0, 17, 0),(7, 7, 0, 17, 0),(7, 8, 0, 17, 0),(7, 9, 0, 17, 0),(7, 10, 0, 17, 0),(7, 11, 0, 17, 0),(7, 12, 0, 17, 0),(7, 13, 0, 17, 0),(7, 14, 0, 17, 0),(7, 15, 0, 17, 0),(7, 16, 0, 17, 0),(2, 3, 0, 15, 0),(2, 4, 0, 15, 0),(2, 5, 0, 15, 0),(2, 6, 0, 15, 0),(2, 7, 0, 15, 0),(2, 8, 0, 15, 0),(2, 9, 0, 15, 0),(2, 10, 0, 15, 0),(2, 11, 0, 15, 0),(2, 12, 0, 15, 0),(2, 13, 0, 15, 0),(2, 14, 0, 15, 0),(2, 15, 0, 15, 0),(2, 16, 0, 15, 0);
EOF

cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use mhaker_pl_forum;
delete from acl_roles_data;
insert into acl_roles_data (role_id, auth_option_id, auth_setting) values
(1, 44, 1),(1, 46, 1),(1, 47, 1),(1, 48, 1),(1, 50, 1),(1, 51, 1),(1, 52, 1),(1, 56, 1),(1, 57, 1),(1, 58, 1),(1, 59, 1),(1, 60, 1),(1, 61, 1),(1, 62, 1),(1, 63, 1),(1, 66, 1),(1, 68, 1),(1, 70, 1),(1, 71, 1),(1, 72, 1),(1, 73, 1),(1, 79, 1),(1, 80, 1),(1, 81, 1),(1, 82, 1),(1, 83, 1),(1, 84, 1),(2, 44, 1),(2, 47, 1),(2, 48, 1),(2, 56, 1),(2, 57, 1),(2, 58, 1),(2, 59, 1),(2, 66, 1),(2, 71, 1),(2, 79, 1),(2, 82, 1),(2, 83, 1),(3, 44, 1),(3, 47, 1),(3, 48, 1),(3, 50, 1),(3, 60, 1),(3, 61, 1),(3, 62, 1),(3, 72, 1),(3, 79, 1),(3, 80, 1),(3, 82, 1),(3, 83, 1),(4, 44, 1),(4, 45, 1),(4, 46, 1),(4, 47, 1),(4, 48, 1),(4, 49, 1),(4, 50, 1),(4, 51, 1),(4, 52, 1),(4, 53, 1),(4, 54, 1),(4, 55, 1),(4, 56, 1),(4, 57, 1),(4, 58, 1),(4, 59, 1),(4, 60, 1),(4, 61, 1),(4, 62, 1),(4, 63, 1),(4, 64, 1),(4, 65, 1),(4, 66, 1),(4, 67, 1),(4, 68, 1),(4, 69, 1),(4, 70, 1),(4, 71, 1),(4, 72, 1),(4, 73, 1),(4, 74, 1),(4, 75, 1),(4, 76, 1),(4, 77, 1),(4, 78, 1),(4, 79, 1),(4, 80, 1),(4, 81, 1),(4, 82, 1),(4, 83, 1),(4, 84, 1),(5, 85, 1),(5, 86, 1),(5, 87, 1),(5, 88, 1),(5, 89, 1),(5, 90, 1),(5, 91, 1),(5, 92, 1),(5, 93, 1),(5, 94, 1),(5, 95, 1),(5, 96, 1),(5, 97, 1),(5, 98, 1),(5, 99, 1),(5, 100, 1),(5, 101, 1),(5, 102, 1),(5, 103, 1),(5, 104, 1),(5, 105, 1),(5, 106, 1),(5, 107, 1),(5, 108, 1),(5, 109, 1),(5, 110, 1),(5, 111, 1),(5, 112, 1),(5, 113, 1),(5, 114, 1),(5, 115, 1),(5, 116, 1),(5, 117, 1),(6, 85, 1),(6, 86, 1),(6, 87, 1),(6, 88, 1),(6, 89, 1),(6, 92, 1),(6, 93, 1),(6, 94, 1),(6, 96, 1),(6, 97, 1),(6, 98, 1),(6, 99, 1),(6, 100, 1),(6, 101, 1),(6, 102, 1),(6, 103, 1),(6, 106, 1),(6, 107, 1),(6, 108, 1),(6, 109, 1),(6, 110, 1),(6, 111, 1),(6, 112, 1),(6, 113, 1),(6, 114, 1),(6, 115, 1),(6, 117, 1),(7, 85, 1),(7, 87, 1),(7, 88, 1),(7, 89, 1),(7, 92, 1),(7, 93, 1),(7, 94, 1),(7, 99, 1),(7, 100, 1),(7, 101, 1),(7, 102, 1),(7, 105, 1),(7, 106, 1),(7, 107, 1),(7, 108, 1),(7, 109, 1),(7, 114, 1),(7, 115, 1),(7, 117, 1),(8, 85, 1),(8, 87, 1),(8, 88, 1),(8, 89, 1),(8, 92, 1),(8, 93, 1),(8, 94, 1),(8, 96, 0),(8, 97, 0),(8, 109, 0),(8, 114, 0),(8, 115, 1),(8, 117, 1),(9, 85, 1),(9, 87, 0),(9, 88, 1),(9, 89, 1),(9, 92, 1),(9, 93, 1),(9, 94, 1),(9, 99, 1),(9, 100, 1),(9, 101, 1),(9, 102, 1),(9, 105, 1),(9, 106, 1),(9, 107, 1),(9, 108, 1),(9, 109, 1),(9, 114, 1),(9, 115, 1),(9, 117, 1),(10, 31, 1),(10, 32, 1),(10, 33, 1),(10, 34, 1),(10, 35, 1),(10, 36, 1),(10, 37, 1),(10, 38, 1),(10, 39, 1),(10, 40, 1),(10, 41, 1),(10, 42, 1),(10, 43, 1),(11, 31, 1),(11, 32, 1),(11, 34, 1),(11, 35, 1),(11, 36, 1),(11, 37, 1),(11, 38, 1),(11, 39, 1),(11, 40, 1),(11, 41, 1),(11, 43, 1),(12, 31, 1),(12, 34, 1),(12, 35, 1),(12, 36, 1),(12, 40, 1),(13, 31, 1),(13, 32, 1),(13, 35, 1),(14, 1, 1),(14, 2, 1),(14, 3, 1),(14, 4, 1),(14, 5, 1),(14, 6, 1),(14, 7, 1),(14, 8, 1),(14, 9, 1),(14, 10, 1),(14, 11, 1),(14, 12, 1),(14, 13, 1),(14, 14, 1),(14, 15, 1),(14, 16, 1),(14, 17, 1),(14, 18, 1),(14, 19, 1),(14, 20, 1),(14, 21, 1),(14, 22, 1),(14, 23, 1),(14, 24, 1),(14, 25, 1),(14, 26, 1),(14, 27, 1),(14, 28, 1),(14, 29, 1),(14, 30, 1),(15, 1, 1),(15, 3, 1),(15, 4, 1),(15, 5, 1),(15, 6, 1),(15, 7, 1),(15, 8, 1),(15, 9, 1),(15, 11, 1),(15, 13, 1),(15, 14, 1),(15, 15, 1),(15, 17, 1),(15, 18, 1),(15, 19, 1),(15, 20, 1),(15, 21, 1),(15, 22, 1),(15, 23, 1),(15, 24, 1),(15, 25, 1),(15, 27, 1),(15, 29, 1),(15, 30, 1),(16, 1, 0),(17, 1, 1),(17, 7, 1),(17, 14, 1),(17, 19, 1),(17, 20, 1),(17, 23, 1),(17, 27, 1),(18, 1, 1),(18, 4, 1),(18, 7, 1),(18, 8, 1),(18, 9, 1),(18, 13, 1),(18, 14, 1),(18, 15, 1),(18, 17, 1),(18, 18, 1),(18, 19, 1),(18, 20, 1),(18, 21, 1),(18, 22, 1),(18, 23, 1),(18, 24, 1),(18, 25, 1),(18, 27, 1),(18, 29, 1),(19, 1, 1),(19, 7, 1),(19, 14, 1),(19, 19, 1),(19, 20, 1),(20, 1, 1),(20, 3, 1),(20, 4, 1),(20, 7, 1),(20, 8, 1),(20, 9, 1),(20, 13, 1),(20, 14, 1),(20, 15, 0),(20, 17, 1),(20, 18, 1),(20, 19, 1),(20, 20, 1),(20, 21, 1),(20, 22, 1),(20, 23, 1),(20, 24, 1),(20, 25, 1),(20, 27, 1),(20, 29, 1),(21, 1, 1),(21, 3, 1),(21, 4, 1),(21, 5, 1),(21, 6, 1),(21, 7, 1),(21, 8, 1),(21, 9, 1),(21, 11, 1),(21, 13, 1),(21, 14, 1),(21, 15, 1),(21, 16, 1),(21, 17, 1),(21, 18, 1),(21, 19, 1),(21, 20, 1),(21, 21, 1),(21, 22, 1),(21, 23, 1),(21, 24, 1),(21, 25, 1),(21, 27, 1),(21, 29, 1),(21, 30, 1),(22, 1, 1),(22, 4, 1),(22, 7, 1),(22, 8, 1),(22, 9, 1),(22, 13, 1),(22, 14, 1),(22, 15, 1),(22, 16, 1),(22, 17, 1),(22, 18, 1),(22, 19, 1),(22, 20, 1),(22, 21, 1),(22, 22, 1),(22, 23, 1),(22, 24, 1),(22, 25, 1),(22, 27, 1),(22, 29, 1),(23, 96, 0),(23, 97, 0),(23, 114, 0),(24, 15, 0);
EOF

cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use mhaker_pl_forum;
delete from forums;
insert into forums (forum_id, parent_id, left_id, right_id, forum_parents, forum_name, forum_desc, forum_desc_bitfield, forum_desc_options, forum_desc_uid, forum_link, forum_password, forum_style, forum_image, forum_rules, forum_rules_link, forum_rules_bitfield, forum_rules_options, forum_rules_uid, forum_topics_per_page, forum_type, forum_status, forum_posts, forum_topics, forum_topics_real, forum_last_post_id, forum_last_poster_id, forum_last_post_subject, forum_last_post_time, forum_last_poster_name, forum_last_poster_colour, forum_flags, forum_options, display_subforum_list, display_on_index, enable_indexing, enable_icons, enable_prune, prune_next, prune_days, prune_viewed, prune_freq) values
(3, 0, 1, 6, '', 'Opinie i uwagi', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', 32, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(4, 3, 2, 3, '', 'Opinie i uwagi', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(5, 3, 4, 5, '', 'Problemy i skargi', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(6, 0, 7, 20, '', 'Hacking | Security', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', 32, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(7, 6, 8, 9, '', 'Hacking', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(8, 6, 10, 11, '', 'Security', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(9, 6, 12, 13, '', 'Strefa zrzutu', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(10, 6, 14, 15, '', 'Toturiale', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(11, 6, 16, 17, '', 'Systemy', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(12, 6, 18, 19, '', 'GSM', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(13, 0, 21, 28, '', 'Inne', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', 32, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(14, 13, 22, 23, '', 'Programowanie', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(15, 13, 24, 25, '', 'Off topic', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(16, 13, 26, 27, '', 'Kosz', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1);
EOF

# reset groups' forum permissions

DB_ROOT_PASSWORD=`mysql_get_user_password root`
# load mhaker database from file
DATABASES="mhaker"
for DB in $DATABASES; do
    cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
DROP DATABASE IF EXISTS $DB;
CREATE DATABASE $DB;
GRANT ALL ON $DB.* TO '$DB'@'localhost' IDENTIFIED BY '$DB';
EOF
    tar -zxf $INSTALL_DIR/backup/databases/database-$DB.tar.gz
    FILES=$(ls *.sql)
    for FILE in $FILES; do
        mysql --user="root" --password="$DB_ROOT_PASSWORD" "$DB" < $FILE
    done
    rm {*.sql,*.info}
done
# dump tables and convert files
DATABASES="mhaker"
for DB in $DATABASES; do
    TABLES=$(echo "use $DB; show tables;" | mysql --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
    for TABLE in $TABLES; do
        COLLATION=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = '$DB' and t.table_name = '$TABLE';" | mysql --user=root --password=$DB_ROOT_PASSWORD | awk '{ if ( NR > 1  ) { print } }')
        mysqldump --user="root" --password="$DB_ROOT_PASSWORD" --default-character-set="$COLLATION" --extended-insert=FALSE "$DB" "$TABLE" > $DB.$TABLE.sql
        file -i $DB.$TABLE.sql >> $DB.encoding.info
        iconv -f $COLLATION -t utf8 $DB.$TABLE.sql > $DB.$TABLE-utf8.sql
        replace_in_file "40101 SET NAMES ${COLLATION}" "40101 SET NAMES utf8" $DB.$TABLE-utf8.sql
        replace_in_file "CHARSET=${COLLATION}" "CHARSET=utf8" $DB.$TABLE-utf8.sql
        replace_in_file "${COLLATION}_general_ci" "utf8_general_ci" $DB.$TABLE-utf8.sql
        ./char-converter.sh $DB.$TABLE-utf8.sql $DB.$TABLE-utf8-conv.sql 1
    done
done
# load converted tables
FILES=$(ls *-utf8-conv.sql)
for FILE in $FILES; do
    mysql --user="root" --password="$DB_ROOT_PASSWORD" --default-character-set=utf8 "$DB" < $FILE
done
rm {*.sql,*.info}

# copy topics
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use phpbb3;
delete from phpbb3.topics;
insert into phpbb3.topics (topic_id, forum_id, topic_title, topic_status, topic_type)
select t.id, fp.forum_id, t.name, 0, 0
from mhaker.mhaker_forum_topics t, mhaker.mhaker_forum_forums fm, phpbb3.forums fp
where
    t.forum = fm.id and
    fm.name =  fp.forum_name and
    fp.forum_type = 1
EOF

# copy posts
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use phpbb3;
delete from phpbb3.posts;
insert into phpbb3.posts (topic_id, forum_id, poster_id, icon_id, post_time, post_approved, enable_bbcode, enable_smilies, enable_magic_url, enable_sig, post_subject, post_text, post_postcount)
select t.id, fp.forum_id, 2, 0, unix_timestamp(m.time), 1, 1, 1, 1, 1, '', m.message, 1
from mhaker.mhaker_forum_messages m, mhaker.mhaker_forum_topics t, mhaker.mhaker_forum_forums fm, phpbb3.forums fp
where
    m.topic = t.id and
    t.forum = fm.id and
    fm.name =  fp.forum_name and
    fp.forum_type = 1
EOF

# update number of topics
DB_ROOT_PASSWORD=`mysql_get_user_password root`
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use mhaker_pl_forum;
drop table if exists temp;
create table temp (id int, count int);
insert into temp (id, count)
select t.forum_id, count(1) as 'count'
from mhaker_pl_forum.topics t, mhaker_pl_forum.forums f
where
    t.forum_id = f.forum_id and
    f.forum_type = 1
group by t.forum_id;
update mhaker_pl_forum.forums, temp
set mhaker_pl_forum.forums.forum_topics = temp.count
where mhaker_pl_forum.forums.forum_id = temp.id;
drop table if exists temp;
EOF











# restore databases
DB_ROOT_PASSWORD=`mysql_get_user_password root`
DATABASES="mhaker_pl_cms mhaker_pl_forum"
for DB in $DATABASES; do
    cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
DROP DATABASE IF EXISTS $DB;
CREATE DATABASE $DB;
GRANT ALL ON $DB.* TO '$DB'@'localhost';
EOF
    tar -zxf $INSTALL_DIR/backup/databases/database-$DB.tar.gz
    FILES=$(ls *.sql)
    for FILE in $FILES; do
        mysql --user="root" --password="$DB_ROOT_PASSWORD" "$DB" < $FILE
    done
    rm {*.sql,*.encoding.info}
done
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
DROP DATABASE IF EXISTS mhaker;
CREATE DATABASE $mhaker;
EOF
tar -zxf $INSTALL_DIR/backup/databases/database-mhaker-1.tar.gz
FILES=$(ls *.sql)
for FILE in $FILES; do
	mysql --user="root" --password="$DB_ROOT_PASSWORD" "$DB" < $FILE
done
rm {*.sql,*.encoding.info}

tar -zxf /srv/backup/sites/nowy.mhaker.pl.tar.gz
rm -r /srv/hosting/domains/nowy.mhaker.pl
mv nowy.mhaker.pl /srv/hosting/domains/
