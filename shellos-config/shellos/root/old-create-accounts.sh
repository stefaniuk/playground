#!/bin/bash
#
#    ./create-accounts.sh 2>&1 | tee ./create-accounts.log
#

exit 1

source $HOST4GE_DIR/sbin/include.sh

function create_domain {

    DOMAIN="$1"
    DOMAIN_DIR=/srv/hosting/domains/$DOMAIN

    DOMAIN_ESC=`echo "$DOMAIN" | sed 's/\.//g'`
    DOMAIN_ESC=`echo "$DOMAIN_ESC" | sed 's/-//g'`

    # create user
    [ -d $DOMAIN_DIR ] && rm -rf $DOMAIN_DIR
    userdel -f "$DOMAIN"
    SYSTEM_PASS=`user_create.pl -u "$DOMAIN" -d "$DOMAIN_DIR" -s`

    DOCUMENT_ROOT=$DOMAIN_DIR/var/www
    if [ "$DOMAIN" == "wypadek.cc" ]; then
        DOCUMENT_ROOT=$DOMAIN_DIR/public
    fi

    # add vhost (port 80)
    STR=$(cat <<END_HEREDOC
\tServerAlias www.$DOMAIN
\tSuexecUserGroup $DOMAIN $DOMAIN
\tDocumentRoot $DOCUMENT_ROOT
\t<Directory $DOCUMENT_ROOT>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder deny,allow
\t\tDeny from all
\t</Directory>
\tCustomLog /srv/httpd/log/vhost-log.fifo log_format
\tErrorLog $DOMAIN_DIR/var/log/httpd.err
END_HEREDOC
)
    httpd_vhost_remove.pl -s "httpd" -t "domain" -n "$DOMAIN" -i '*' -d "$DOMAIN" -p 80
    httpd_vhost_create.pl -s "httpd" -t "domain" -n "$DOMAIN" -i '*' -d "$DOMAIN" -p 80 -c "$STR"
    # add vhost (port 443)
    STR=$(cat <<END_HEREDOC
\tSuexecUserGroup $DOMAIN $DOMAIN
\tDocumentRoot $DOCUMENT_ROOT
\t<Directory $DOCUMENT_ROOT>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder deny,allow
\t\tDeny from all
\t</Directory>
\tCustomLog /srv/httpd/log/vhost-log.fifo log_format
\tErrorLog $DOMAIN_DIR/var/log/httpd.err
\tSSLEngine on
\tSSLCertificateFile /srv/openssl/certs/$DOMAIN.pem
\tSSLCertificateKeyFile /srv/openssl/certs/$DOMAIN.key
END_HEREDOC
)
    httpd_vhost_remove.pl -s "httpd" -t "domain" -n "$DOMAIN" -i '*' -d "$DOMAIN" -p 443
    httpd_vhost_create.pl -s "httpd" -t "domain" -n "$DOMAIN" -i '*' -d "$DOMAIN" -p 443 -c "$STR"

    # generate certificate
    generate_certificate $DOMAIN

    # create database
    DB_NAME=$DOMAIN_ESC
    DB_USER=$DOMAIN_ESC
    DB_PASS=`get_random_string 32`
    mysql_drop_database $DB_NAME
    mysql_create_database $DB_NAME
    mysql_create_user $DB_NAME $DB_USER $DB_PASS

    echo "==============================================="
    echo "Domain:        $DOMAIN"
    echo "System user:   $DOMAIN"
    echo "System pass:   $SYSTEM_PASS"
    echo "Database name: $DB_NAME"
    echo "Database user: $DB_USER"
    echo "Database pass: $DB_PASS"
    if [ "$DOMAIN" == "przystanek.co.uk" ]; then
        # create additional database
        DB_NAME2="przystanek_forum"
        DB_USER2="przystanek_forum"
        DB_PASS2=`get_random_string 32`
        mysql_drop_database $DB_NAME2
        mysql_create_database $DB_NAME2
        mysql_create_user $DB_NAME2 $DB_USER2 $DB_PASS2
        echo "Forum db name: $DB_NAME2"
        echo "Forum db user: $DB_USER2"
        echo "Forum db pass: $DB_PASS2"
    fi
    echo "==============================================="
}

function version_control {

    # version control
    cd /srv/hosting/domains/$1
    [ -d .git ] && rm -r .git
    git init && chmod 700 .git
    git config user.name "Daniel Stefaniuk"
    git config user.email "daniel.stefaniuk@gmail.com"
    git config core.autocrlf false
    git config core.filemode true
    git add .
    git commit -m "initial commit"
}

DOMAINS="clubdrivers.co.uk londynek.uk.net polecam.cc przystanek.co przystanek.co.uk przystanek.de przystanek.info tv-on-line.pl wypadek.cc"
for DOMAIN in $DOMAINS; do
    create_domain $DOMAIN
done

mysql_restore_database_from_file ./db-przystanek_co_uk.tar.gz "przystanekcouk"
mysql_restore_database_from_file ./db-przystanek_co_uk_forum.tar.gz "przystanek_forum"
mysql_restore_database_from_file ./db-wypadek_cc.tar.gz "wypadekcc"
cat <<EOF | mysql --user="root" --password="`mysql_get_user_password root`"
USE wypadekcc;
CREATE TABLE IF NOT EXISTS AclPermissionView (roleId INT, roleName INT, resourceId INT, resourceName INT, resourceType INT, privilege INT, access INT);
DROP VIEW IF EXISTS AclPermissionView ;
DROP TABLE IF EXISTS AclPermissionView;
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=wypadekcc@localhost SQL SECURITY DEFINER VIEW AclPermissionView AS select roles.id AS roleId,roles.name AS roleName,res.id AS resourceId,res.name AS resourceName,res.type AS resourceType,perm.privilege AS privilege,perm.access AS access from ((AclRoles roles join AclResources res) join AclPermissions perm) where ((roles.id = perm.idRole) and (perm.idResource = res.id));
EOF

tar -zxf domains.tar.gz

apachectl -k restart

DOMAINS="clubdrivers.co.uk londynek.uk.net polecam.cc przystanek.co przystanek.co.uk przystanek.de przystanek.info tv-on-line.pl wypadek.cc"
for DOMAIN in $DOMAINS; do
    version_control $DOMAIN
done
