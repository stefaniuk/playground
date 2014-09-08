#!/bin/bash

##
## variables
##

POSTFIX_VERSION="2.8.4"
MAILX_VERSION="12.4"
POSTFIX_MYSQL_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--postfix)	shift
					POSTFIX_MYSQL_NAME=$1
					;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: Postfix requires OpenSSL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysqld ]; then
	echo "Error: Postfix requires MySQL!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f postfix.tar.gz ]; then
	wget http://mirror.tje.me.uk/pub/mirrors/postfix-release/official/postfix-$POSTFIX_VERSION.tar.gz -O postfix.tar.gz
fi
if [ ! -f postfix.tar.gz ]; then
	echo "Error: Unable to download postfix.tar.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f mailx.tar.bz2 ]; then
	wget http://downloads.sourceforge.net/project/heirloom/heirloom-mailx/$MAILX_VERSION/mailx-$MAILX_VERSION.tar.bz2 -O mailx.tar.bz2
fi
if [ ! -f mailx.tar.bz2 ]; then
	echo "Error: Unable to download mailx.tar.bz2 file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f mailx-openssl_1.0.0_build_fix-1.patch ]; then
	wget http://www.linuxfromscratch.org/patches/blfs/svn/mailx-$MAILX_VERSION-openssl_1.0.0_build_fix-1.patch -O mailx-openssl_1.0.0_build_fix-1.patch
fi
if [ ! -f mailx-openssl_1.0.0_build_fix-1.patch ]; then
	echo "Error: Unable to download mailx-openssl_1.0.0_build_fix-1.patch file!"
	exit 1
fi

##
## install
##

echo "Installing Postfix:"
pkill master
[ -d $INSTALL_DIR/postfix ] && rm -rf $INSTALL_DIR/postfix
tar -zxf postfix.tar.gz
cd postfix-$POSTFIX_VERSION
groupadd -g 540 postfix
groupadd -g 541 postdrop
useradd -u 540 -d /dev/null -s /usr/sbin/nologin -g postfix postfix
make makefiles \
CCARGS='-DDEF_COMMAND_DIR=\"/srv/postfix/bin\" \
	-DDEF_CONFIG_DIR=\"/srv/postfix/conf\" \
	-DDEF_DAEMON_DIR=\"/srv/postfix/bin\" \
	-DDEF_DATA_DIR=\"/srv/postfix/data\" \
	-DDEF_HTML_DIR=\"/srv/postfix/doc/html\" \
	-DDEF_MANPAGE_DIR=\"/srv/postfix/man\" \
	-DDEF_QUEUE_DIR=\"/srv/postfix/queue\" \
	-DDEF_README_DIR=\"/srv/postfix/doc/README\" \
	-DDEF_MAILQ_PATH=\"/srv/postfix/bin/mailq\" \
	-DDEF_SENDMAIL_PATH=\"/srv/postfix/bin/sendmail\" \
	-DUSE_TLS -I/srv/openssl/include/openssl \
	-DHAS_MYSQL -I/srv/mysql/include' \
	AUXLIBS='-L/usr/lib -lssl -lcrypto -lmysqlclient -lz -lm' && \
make && chmod u+x ./postfix-install && sh ./postfix-install -non-interactive && echo "Postfix installed successfully!"
rm -rf $INSTALL_DIR/postfix/{bin/*cf,doc,man}
mkdir $INSTALL_DIR/postfix/log
cd ..

# check
if [ ! -f $INSTALL_DIR/postfix/bin/postfix ]; then
	echo "Error: Postfix has NOT been installed successfully!"
	exit 1
fi

echo "Installing Mailx:"
tar -jxf mailx.tar.bz2
cd mailx-$MAILX_VERSION
patch -Np1 -i ../mailx-openssl_1.0.0_build_fix-1.patch && \
	make SENDMAIL=$INSTALL_DIR/postfix/bin/sendmail && \
	make PREFIX=$INSTALL_DIR/postfix UCBINSTALL=/usr/bin/install install && \
	ln -sfv $INSTALL_DIR/postfix/bin/mailx $INSTALL_DIR/postfix/bin/mail && \
	ln -sfv $INSTALL_DIR/postfix/bin/mailx $INSTALL_DIR/postfix/bin/nail && \
echo "Mailx installed successfully!"
rm -rf $INSTALL_DIR/postfix/share
cd ..

# check
if [ ! -f $INSTALL_DIR/postfix/bin/mailx ]; then
	echo "Error: Mailx has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/postfix/bin
echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/postfix/bin/mailx

echo "Shared library dependencies for $INSTALL_DIR/postfix/bin/postfix:"
ldd $INSTALL_DIR/postfix/bin/postfix
echo "Shared library dependencies for $INSTALL_DIR/postfix/bin/mailx:"
ldd $INSTALL_DIR/postfix/bin/mailx

# create link to the log file
ln -sfv /var/log/mail.log $INSTALL_DIR/postfix/log/mail.log
ln -sfv /var/log/mail.err $INSTALL_DIR/postfix/log/mail.err

# main.cf
replace_in_file '#myhostname = virtual.domain.tld' "myhostname = `hostname -f`" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#mydomain = domain.tld' "mydomain = `hostname -f`" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#myorigin = $myhostname' "myorigin = `hostname -f`" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#smtpd_banner = $myhostname ESMTP $mail_name ($mail_version)' 'smtpd_banner = $myhostname Host4ge SMTP Server' $INSTALL_DIR/postfix/conf/main.cf
newaliases

$INSTALL_DIR/postfix/bin/postconf -n

# database user
POSTFIX_DB_USER_NAME="postfix"
POSTFIX_DB_USER_PASSWORD=`get_random_string 32`
echo "$POSTFIX_DB_USER_NAME=$POSTFIX_DB_USER_PASSWORD" >> $INSTALL_DIR/$POSTFIX_MYSQL_NAME/.details/.users

# TODO: configure Postfix to work with MySQL

# config database
POSTFIX_DB_NAME="postfix"
$INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysql.server start
sleep 5
cat <<EOF | $INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysql -u root
CREATE DATABASE $POSTFIX_DB_NAME;
GRANT SELECT, INSERT, UPDATE, DELETE ON $POSTFIX_DB_NAME.* TO '$POSTFIX_DB_USER_NAME'@'localhost' IDENTIFIED BY '$POSTFIX_DB_USER_PASSWORD';
USE $POSTFIX_DB_NAME;
EOF
sleep 1
$INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysqladmin -u root shutdown
sleep 3

# set files permission
chown -R postfix:postfix $INSTALL_DIR/postfix/log
chmod 500 $INSTALL_DIR/postfix/bin
chmod 500 $INSTALL_DIR/postfix/bin/*
chmod 700 $INSTALL_DIR/postfix/log
chown root:postdrop $INSTALL_DIR/postfix/bin/{postqueue,postdrop}
chmod uga+xrs $INSTALL_DIR/postfix/bin/{postqueue,postdrop}

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f postfix.tar.gz ] && rm postfix.tar.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f mailx.tar.gz ] && rm mailx.tar.bz2
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f mailx-openssl_1.0.0_build_fix-1.patch ] && rm mailx-openssl_1.0.0_build_fix-1.patch
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d postfix-$POSTFIX_VERSION ] && rm -rf postfix-$POSTFIX_VERSION
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d mailx-$MAILX_VERSION ] && rm -rf mailx-$MAILX_VERSION
