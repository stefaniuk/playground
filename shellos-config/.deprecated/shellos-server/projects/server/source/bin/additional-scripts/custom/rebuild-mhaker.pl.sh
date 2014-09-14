#!/bin/bash

# (1) backup
# rebuild-mhaker.pl.sh --phase1 2>&1 | tee $HOST4GE_DIR/log/rebuild-mhaker.pl.sh.log; chmod 400 $HOST4GE_DIR/log/rebuild-mhaker.pl.sh.log

# (2) restore
# rebuild-mhaker.pl.sh --phase2 2>&1 | tee $HOST4GE_DIR/log/rebuild-mhaker.pl.sh.log; chmod 400 $HOST4GE_DIR/log/rebuild-mhaker.pl.sh.log

source $HOST4GE_DIR/conf/includes.sh

ACCOUNT_TYPE="account"
USER1="mhaker"
DIR1="$HOST4GE_DIR/var/hosting/${ACCOUNT_TYPE}s/$USER1"
FTP_NAME1=$USER1
FTP_PASS1=`get_random_string 32`
FTP_DIR1=$DIR1/usr/local

if [ "$1" == "--phase1" ] && [ `hostname` != "earth" ]; then

    # backup
    echo "backup"
    ssh root@earth.host4ge.com -p 2200 'bash -s' < $HOST4GE_DIR/bin/additional-scripts/custom/rebuild-mhaker.pl-remote-script.sh
    # pause
    read -n1 -p "press any key to continue... "
    echo
    # copy archives
    rm ~/site-mhaker* > /dev/null 2>&1
    rm ~/database-mhaker* > /dev/null 2>&1
    echo "copy archives"
    scp -P 2200 root@earth.host4ge.com:~/*mhaker* ~
    # verify
    echo "verify archives"
    cd ~
    sha1sum -c site-mhaker.tar.gz.sha1
    sha1sum -c database-mhaker.tar.gz.sha1

fi

if [ "$1" == "--phase2" ]; then

    # verify
    echo "verify archives"
    cd ~
    sha1sum -c site-mhaker.tar.gz.sha1
    sha1sum -c database-mhaker.tar.gz.sha1

    # restore databases
    echo "restore databases"
    [ `mysql_database_exists mhaker` == "yes" ] && mysql_drop_database "mhaker"
    echo "mhaker"
    mysql_create_database "mhaker"
    mysql_restore_database_from_archive ~/database-mhaker.tar.gz mhaker
    [ `mysql_database_exists mhaker_cms` == "yes" ] && mysql_drop_database "mhaker_cms"
    echo "mhaker_cms"
    mysql_create_database "mhaker_cms"
    mysql_restore_database_from_archive ~/database-mhaker_cms.tar.gz mhaker_cms
    [ `mysql_database_exists mhaker_forum` == "yes" ] && mysql_drop_database "mhaker_forum"
    echo "mhaker_forum"
    mysql_create_database "mhaker_forum"
    mysql_restore_database_from_archive ~/database-mhaker_forum.tar.gz mhaker_forum

    # create database users
    echo "create database users"
    mysql_create_user "mhaker" "mhaker" "ExPlT8mHb9NFq6ZcGrhM9y4CHD5JnCPg"
    mysql_create_user "mhaker_cms mhaker_forum" "mhaker_cms" "KMhFM4IAdjkSR49xCskYqCUmwBjDhBKl"
    mysql_create_user "mhaker_forum mhaker_cms" "mhaker_forum" "YT4meu54GGzQXKvdpnePxOYBQ5HYotzd"
    mysql_create_user "mhaker_cms_dev mhaker_forum_dev" "mhaker_cms_dev" "i70QCIU9kIfNMEHiLcsv6YgMNmxNxiZG"
    mysql_create_user "mhaker_forum_dev mhaker_cms_dev" "mhaker_forum_dev" "S0cX3cp8reacvIiGn7XgQTrUZQ2LQ9xn"

    # create mhaker account
    echo "create mhaker account"
    [ `user_exists $USER1` == "yes" ] && userdel -f "$USER1"
    [ -d $DIR1 ] && rm -rf $DIR1
    user_create.pl -u "$USER1" -d "$DIR1"
    #[ `ftp_account_exists $FTP_NAME1` == "yes" ] && ftp_account_remove.pl -u $FTP_NAME1
    #ftp_account_create.pl -u $FTP_NAME1 -p $FTP_PASS1 -i `id -u $USER1` -d $FTP_DIR1
    echo "------------------------------------------------------"
    echo "System user:          $USER1"
    echo "System directory:     $DIR1"
    #echo "FTP name:             $FTP_NAME1"
    #echo "FTP pass:             $FTP_PASS1"
    #echo "FTP directory:        $FTP_DIR1"
    echo "------------------------------------------------------"

    # restore site
    echo "restore site"
    tar -zxf site-mhaker.tar.gz -C $DIR1/usr/local

    # install libraries
    echo "install libraries"
    install-zendframework.sh \
        --user $USER1 \
        --path $DIR1/usr/local/libraries/zendframework \
        --dir-name "1"

    # version control
    echo "version control"
    cd $DIR1/usr/local
    repositories_add_dir $PWD
    git init && chmod 700 .git
    git config user.name "$ADMIN_NAME"
    git config user.email "$ADMIN_MAIL"
    git config core.autocrlf false
    git config core.filemode true
    git add .
    git commit -m "initial commit"

    # create vhosts
    echo "create vhosts"
    function create_vhost {
        ACCOUNT_TYPE=$2
        USERNAME=$3
        DOMAIN_NAME=$4
        DOCUMENT_ROOT=$1/usr/local/domains/$DOMAIN_NAME
        STR=$(cat <<END_HEREDOC
\tServerAlias www.$DOMAIN_NAME
\tDocumentRoot $DOCUMENT_ROOT
\t<Directory $DOCUMENT_ROOT>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder allow,deny
\t\tAllow from all
\t</Directory>
END_HEREDOC
)
        httpd_vhost_remove.pl -s "httpd" -t "$ACCOUNT_TYPE" -n "$USERNAME" -i '178.79.157.69' -d "$DOMAIN_NAME" -p 80
        httpd_vhost_create.pl -s "httpd" -t "$ACCOUNT_TYPE" -n "$USERNAME" -i '178.79.157.69' -d "$DOMAIN_NAME" -p 80 -c "$STR"
        STR=$(cat <<END_HEREDOC
\tDocumentRoot $DOCUMENT_ROOT
\t<Directory $DOCUMENT_ROOT>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder allow,deny
\t\tAllow from all
\t</Directory>
\tSSLEngine on
\tSSLCertificateFile $HOST4GE_DIR/var/certificates/$DOMAIN_NAME.pem
\tSSLCertificateKeyFile $HOST4GE_DIR/var/certificates/$DOMAIN_NAME.key
END_HEREDOC
)
        httpd_vhost_remove.pl -s "httpd" -t "$ACCOUNT_TYPE" -n "$USERNAME" -i '178.79.157.69' -d "$DOMAIN_NAME" -p 443
        httpd_vhost_create.pl -s "httpd" -t "$ACCOUNT_TYPE" -n "$USERNAME" -i '178.79.157.69' -d "$DOMAIN_NAME" -p 443 -c "$STR"
        generate_certificate $DOMAIN_NAME
    }
    create_vhost $DIR1 $ACCOUNT_TYPE $USER1 "mhaker.pl"

    echo "restart web server"
    httpd_restart

fi

exit 0
