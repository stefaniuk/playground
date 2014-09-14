#!/bin/bash

##
## variables
##

PROFTPD_MYSQL_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --proftpd)  shift && PROFTPD_MYSQL_NAME=$1
                    ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: ProFTPD requires MySQL!"
    exit 1
fi

##
## download
##

PKG_NAME="proftpd-$PROFTPD_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="ftp://ftp.proftpd.org/distrib/source/proftpd-$PROFTPD_VERSION.tar.gz"
    FILE=proftpd-$PROFTPD_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 5000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

pkill proftpd

# create user and group
user_create "proftpd" 530 "proftpd" 530

# add jail group
groupadd -g 9999 ftpjail

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile ProFTPD":
    [ -d $INSTALL_DIR/proftpd ] && rm -rf $INSTALL_DIR/proftpd
    tar -zxf proftpd-$PROFTPD_VERSION.tar.gz
    cd proftpd-$PROFTPD_VERSION
    install_user=root install_group=root CFLAGS=-DHAVE_OPENSSL LIBS=-lcrypto ./configure \
        --prefix=$INSTALL_DIR/proftpd \
        --sbindir=$INSTALL_DIR/proftpd/bin \
        --sysconfdir=$INSTALL_DIR/proftpd/conf \
        --localstatedir=$INSTALL_DIR/proftpd/log \
        --enable-openssl \
        --enable-auth-pam \
        --with-modules=mod_sql:mod_sql_mysql:mod_quotatab:mod_quotatab_sql:mod_sql_passwd:mod_tls:mod_wrap:mod_wrap2:mod_wrap2_sql \
        --with-includes=$INSTALL_DIR/mysql/include \
    && make && make install && echo "ProFTPD installed successfully!"
    rm -rf $INSTALL_DIR/proftpd/share
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/proftpd/bin
    echo "Create package:"
    package_create $INSTALL_DIR/proftpd $PKG_NAME
else
    echo "Install ProFTPD from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/proftpd/bin/proftpd ]; then
    echo "Error: ProFTPD has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/proftpd/bin/proftpd:"
ldd $INSTALL_DIR/proftpd/bin/proftpd

echo "Copy includes:"
cp -rfv $INSTALL_DIR/proftpd/include/* /usr/include

echo "Copy pkgconfig:"
cp -vf $INSTALL_DIR/proftpd/lib/pkgconfig/* /usr/lib/pkgconfig

# create links to the log files
ln -sfv /var/log/ftp.log $INSTALL_DIR/proftpd/log/ftp.log

# log queue
mkfifo -m644 $INSTALL_DIR/proftpd/log/proftpd-log.fifo

# database access
FTP_DB_NAME="ftp"
FTP_DB_USER="ftp"
FTP_DB_PASS=`get_random_string 32`
mysql_add_user_password "$FTP_DB_USER" "$FTP_DB_PASS"
host4ge_conf_set_option "ftp_db_name" "$FTP_DB_NAME"
host4ge_conf_set_option "ftp_db_user" "$FTP_DB_USER"
host4ge_conf_set_option "ftp_db_pass" "$FTP_DB_PASS"

# generate certificate
generate_certificate "proftpd"

# proftpd.conf
cat <<EOF > $INSTALL_DIR/proftpd/conf/proftpd.conf
ServerType standalone
ServerIdent on "FTP Server"
DefaultServer on
UseReverseDNS off
IdentLookups off
Port 21
PassivePorts 1900 1999
MaxInstances 30

User proftpd
Group proftpd
Umask 022

SyslogFacility ftp
SyslogLevel info
LogFormat custom_log "%a %u \"%r\" %s %b"
ExtendedLog $INSTALL_DIR/proftpd/log/proftpd-log.fifo ALL custom_log

RootLogin off
RequireValidShell off
DefaultRoot ~ ftpjail
AllowOverwrite on
ShowSymlinks off

<IfModule mod_tls.c>
    TLSEngine on
    TLSLog $INSTALL_DIR/proftpd/log/proftpd-log.fifo
    TLSProtocol SSLv23
    TLSOptions NoCertRequest
    TLSRSACertificateFile $CERTIFICATES_DIR/proftpd.crt
    TLSRSACertificateKeyFile $CERTIFICATES_DIR/proftpd.key
    TLSVerifyClient off
    TLSRequired off
</IfModule>

SQLBackend mysql
SQLAuthTypes Plaintext
SQLAuthenticate users groups
SQLMinID 10001
SQLConnectInfo $FTP_DB_NAME@localhost $FTP_DB_USER $FTP_DB_PASS
SQLGroupInfo groups name gid user
SQLUserInfo users name password uid gid homedir shell

# update count and accessed everytime user logs in
SQLLog PASS updatecount
SQLNamedQuery updatecount UPDATE "count=count+1, accessed=now() WHERE name='%u'" users

# update modified everytime user uploads or deletes a file
SQLLog STOR,DELE modified
SQLNamedQuery modified UPDATE "modified=now() WHERE name='%u'" users
EOF

if [ "$CHROOT" == "N" ]; then

    # get mysql root password
    MYSQL_ROOT_PASSWORD=`mysql_get_user_password root`
    # config database
    $INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysql.server start
    sleep 5
    cat <<EOF | $INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysql --user=root --password=$MYSQL_ROOT_PASSWORD
CREATE DATABASE $FTP_DB_NAME;
GRANT SELECT, INSERT, UPDATE, DELETE ON $FTP_DB_NAME.* TO '$FTP_DB_USER'@'localhost' IDENTIFIED BY '$FTP_DB_PASS';
USE $FTP_DB_NAME;
CREATE TABLE groups (
    name varchar(30) NOT NULL,
    gid int(11) NOT NULL,
    user varchar(30) NOT NULL,
    KEY name (name),
    UNIQUE KEY group_user (name, user)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE users (
    id int(11) NOT NULL auto_increment,
    name varchar(30) NOT NULL,
    password varchar(255) NOT NULL,
    uid int(11) NOT NULL,
    gid int(11) NOT NULL,
    homedir varchar(255) NOT NULL,
    shell varchar(255) NOT NULL default '/usr/sbin/nologin',
    count int(11) NOT NULL default '0',
    accessed datetime NOT NULL default '0000-00-00 00:00:00',
    modified datetime NOT NULL default '0000-00-00 00:00:00',
    PRIMARY KEY (id),
    UNIQUE KEY name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
EOF
    sleep 1
    $INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown
    sleep 3
    # clear password variable
    MYSQL_ROOT_PASSWORD=

fi

# set files permission
chmod 700 $INSTALL_DIR/proftpd/bin
chmod 500 $INSTALL_DIR/proftpd/bin/*
chmod 700 $INSTALL_DIR/proftpd/conf
chmod 600 $INSTALL_DIR/proftpd/conf/proftpd.conf

##
## post install
##

[ -f proftpd-$PROFTPD_VERSION.tar.gz ] && rm proftpd-$PROFTPD_VERSION.tar.gz
[ -d proftpd-$PROFTPD_VERSION ] && rm -rf proftpd-$PROFTPD_VERSION

# log event
logger -p local0.notice -t host4ge "proftpd $PROFTPD_VERSION installed successfully"

# save package version
package_add_version "proftpd" "$PROFTPD_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/proftpd/bin
hashes_add_dir $INSTALL_DIR/proftpd/lib

exit 0
