#!/bin/bash

##
## variables
##

DOVECOT_VERSION="2.0.13"
DOVECOT_MYSQL_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--dovecot)	shift
					DOVECOT_MYSQL_NAME=$1
					;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: Dovecot requires zlib!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: Dovecot requires OpenSSL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$DOVECOT_MYSQL_NAME/bin/mysqld ]; then
	echo "Error: Dovecot requires MySQL!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f dovecot.tar.gz ]; then
	wget http://www.dovecot.org/releases/2.0/dovecot-$DOVECOT_VERSION.tar.gz -O dovecot.tar.gz
fi
if [ ! -f dovecot.tar.gz ]; then
	echo "Error: Unable to download dovecot.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing Dovecot":
pkill dovecot
[ -d $INSTALL_DIR/dovecot ] && rm -rf $INSTALL_DIR/dovecot
tar -zxf dovecot.tar.gz
groupadd -g 550 dovecot
useradd -u 550 -d /dev/null -s /usr/sbin/nologin -g dovecot dovecot
groupadd -g 551 dovenull
useradd -u 551 -d /dev/null -s /usr/sbin/nologin -g dovenull dovenull
cd dovecot-$DOVECOT_VERSION
CPPFLAGS="-I$INSTALL_DIR/openssl/include" LDFLAGS="-L$INSTALL_DIR/openssl/lib -ldl" ./configure \
	--prefix=$INSTALL_DIR/dovecot \
	--sbindir=$INSTALL_DIR/dovecot/bin \
	--with-zlib \
	--with-ssl=openssl \
	--with-ssldir=$INSTALL_DIR/openssl \
	--with-mysql \
	--with-sql=plugin \
&& make && make install && echo "Dovecot installed successfully!"
mkdir $INSTALL_DIR/dovecot/log
cd ..

# check
if [ ! -f $INSTALL_DIR/dovecot/bin/dovecot ]; then
	echo "Error: Dovecot has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/dovecot/bin
strip_debug_symbols_file $INSTALL_DIR/dovecot/libexec/dovecot
strip_debug_symbols_file $INSTALL_DIR/dovecot/lib/dovecot

echo "Shared library dependencies for $INSTALL_DIR/dovecot/bin/dovecot:"
ldd $INSTALL_DIR/dovecot/bin/dovecot

# create link to the log file
ln -sfv /var/log/mail.log $INSTALL_DIR/dovecot/log/mail.log
ln -sfv /var/log/mail.err $INSTALL_DIR/dovecot/log/mail.err

cp -rf $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/conf.d $INSTALL_DIR/dovecot/etc/dovecot
cp $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/dovecot.conf $INSTALL_DIR/dovecot/etc/dovecot/dovecot.conf
rm -rf $INSTALL_DIR/dovecot/share
replace_in_file "#ssl = yes" "ssl = yes" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
replace_in_file "ssl_cert = <\/etc\/ssl\/certs\/dovecot.pem" "ssl_cert = <$INSTALL_DIR_ESC\/openssl\/certs\/dovecot.pem" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
replace_in_file "ssl_key = <\/etc\/ssl\/private\/dovecot.pem" "ssl_key = <$INSTALL_DIR_ESC\/openssl\/certs\/dovecot.pem" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf

# generate certificate
generate_certificate "dovecot"

# database user
DOVECOT_DB_USER_NAME="dovecot"
DOVECOT_DB_USER_PASSWORD=`get_random_string 32`
echo "$DOVECOT_DB_USER_NAME=$DOVECOT_DB_USER_PASSWORD" >> $INSTALL_DIR/$DOVECOT_MYSQL_NAME/.details/.users

# TODO: configure Dovecot to work with MySQL

# config database
DOVECOT_DB_NAME="dovecot"
$INSTALL_DIR/$DOVECOT_MYSQL_NAME/bin/mysql.server start
sleep 5
cat <<EOF | $INSTALL_DIR/$DOVECOT_MYSQL_NAME/bin/mysql -u root
CREATE DATABASE $DOVECOT_DB_NAME;
GRANT SELECT, INSERT, UPDATE, DELETE ON $DOVECOT_DB_NAME.* TO '$DOVECOT_DB_USER_NAME'@'localhost' IDENTIFIED BY '$DOVECOT_DB_USER_PASSWORD';
USE $DOVECOT_DB_NAME;
EOF
sleep 1
$INSTALL_DIR/$DOVECOT_MYSQL_NAME/bin/mysqladmin -u root shutdown
sleep 3

# set files permission
chmod 500 $INSTALL_DIR/dovecot/bin
chmod 500 $INSTALL_DIR/dovecot/bin/*

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f dovecot.tar.gz ] && rm dovecot.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d dovecot-$DOVECOT_VERSION ] && rm -rf dovecot-$DOVECOT_VERSION
