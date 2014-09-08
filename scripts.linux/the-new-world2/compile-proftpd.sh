#!/bin/bash

##
## variables
##

PROFTPD_VERSION="1.3.4rc2"
PROFTPD_MYSQL_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--proftpd)	shift
					PROFTPD_MYSQL_NAME=$1
					;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: ProFTPD requires OpenSSL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysqld ]; then
	echo "Error: ProFTPD requires MySQL!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f proftpd.tar.gz ]; then
	wget ftp://ftp.proftpd.org/distrib/source/proftpd-$PROFTPD_VERSION.tar.gz -O proftpd.tar.gz
fi
if [ ! -f proftpd.tar.gz ]; then
	echo "Error: Unable to download proftpd.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing ProFTPD":
pkill proftpd
[ -d $INSTALL_DIR/proftpd ] && rm -rf $INSTALL_DIR/proftpd
tar -zxf proftpd.tar.gz
cd proftpd-$PROFTPD_VERSION
groupadd -g 530 proftpd
useradd -u 530 -d /dev/null -s /usr/sbin/nologin -g proftpd proftpd
groupadd -g 531 proftpdjail
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

# check
if [ ! -f $INSTALL_DIR/proftpd/bin/proftpd ]; then
	echo "Error: ProFTPD has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/proftpd/bin

echo "Shared library dependencies for $INSTALL_DIR/proftpd/bin/proftpd:"
ldd $INSTALL_DIR/proftpd/bin/proftpd

# create links to the log files
ln -sfv /var/log/ftp.log $INSTALL_DIR/proftpd/log/ftp.log

# copy script that will pipe logs to the syslog
mkfifo -m644 $INSTALL_DIR/proftpd/log/proftpd-log.fifo
cp -v $INSTALL_DIR/conf/log-proftpd.pl $INSTALL_DIR/proftpd/bin
chown -R root:root $INSTALL_DIR/proftpd/bin/log-proftpd.pl
chmod 500 $INSTALL_DIR/proftpd/bin/log-proftpd.pl

# TODO: configure ProFTPD
# http://www.proftpd.org/docs/directives/linked/configuration.html
# http://batland.de/subdomains/codes/index.php/p/proftpdadmin/source/tree/001e085648ecdf256770d665a6917be59e29402f/misc/proftpd/proftpd.conf
# http://www.proftpd.org/docs/howto/Logging.html

# proftpd.conf
cat <<EOF > $INSTALL_DIR/proftpd/conf/proftpd.conf
ServerType standalone
ServerIdent on "Host4ge FTP Server"
DefaultServer on
UseReverseDNS off
IdentLookups off
Port 21
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
DefaultRoot ~ proftpdjail
AllowOverwrite on
ShowSymlinks off
EOF

# database user
PROFTPD_DB_USER_NAME="proftpd"
PROFTPD_DB_USER_PASSWORD=`get_random_string 32`
echo "$PROFTPD_DB_USER_NAME=$PROFTPD_DB_USER_PASSWORD" >> $INSTALL_DIR/mysql/.details/.users

# TODO: configure ProFTPD to work with MySQL

# config database
PROFTPD_DB_NAME="proftpd"
$INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysql.server start
sleep 5
cat <<EOF | $INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysql -u root
CREATE DATABASE $PROFTPD_DB_NAME;
GRANT SELECT, INSERT, UPDATE, DELETE ON $PROFTPD_DB_NAME.* TO '$PROFTPD_DB_USER_NAME'@'localhost' IDENTIFIED BY '$PROFTPD_DB_USER_PASSWORD';
USE $PROFTPD_DB_NAME;
CREATE TABLE groups (
	groupname VARCHAR(30) NOT NULL,
	gid INTEGER NOT NULL,
	members VARCHAR(255)
);
CREATE TABLE users (
	userid VARCHAR(30) NOT NULL UNIQUE,
	passwd VARCHAR(80) NOT NULL,
	uid INTEGER UNIQUE,
	gid INTEGER,
	homedir VARCHAR(255),
	shell VARCHAR(255)
);
EOF
sleep 1
$INSTALL_DIR/$PROFTPD_MYSQL_NAME/bin/mysqladmin -u root shutdown
sleep 3

# set files permission
chmod 500 $INSTALL_DIR/proftpd/bin
chmod 500 $INSTALL_DIR/proftpd/bin/*

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f proftpd.tar.gz ] && rm proftpd.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d proftpd-$PROFTPD_VERSION ] && rm -rf proftpd-$PROFTPD_VERSION
