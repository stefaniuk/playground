#!/bin/bash

##
## variables
##

PHP_VERSION="5.3.6"
PHP_MYSQL_NAME=
PHP_HTTPD_NAME=
PHP_HTTPD_PORT=
PHP_CONFIGURE_OPTIONS=
PHP_INSTALL_DIR=$INSTALL_DIR/php-mod

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--php)	shift
				PHP_MYSQL_NAME=$1
				shift
				PHP_HTTPD_NAME=$1
				shift
				PHP_HTTPD_PORT=$1
				;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: PHP requires zlib!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: PHP requires OpenSSL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$PHP_MYSQL_NAME/bin/mysqld ]; then
	echo "Error: PHP requires MySQL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$PHP_HTTPD_NAME/bin/httpd ]; then
	echo "Error: PHP requires Apache HTTPD Server!"
	exit 1
fi
# optional
if [ -f $INSTALL_DIR/libiconv/bin/iconv ]; then
	PHP_CONFIGURE_OPTIONS="--with-iconv=shared,$INSTALL_DIR/libiconv"
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f php.tar.gz ]; then
	wget http://de.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror -O php.tar.gz
fi
if [ ! -f php.tar.gz ]; then
	echo "Error: Unable to download php.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing PHP":
[ -d $PHP_INSTALL_DIR ] && rm -rf $PHP_INSTALL_DIR
tar -zxf php.tar.gz
cd php-$PHP_VERSION
./configure \
	--prefix=$PHP_INSTALL_DIR \
	--sysconfdir=$PHP_INSTALL_DIR/conf \
	--with-config-file-path=$PHP_INSTALL_DIR/conf \
	--with-apxs2=$INSTALL_DIR/$PHP_HTTPD_NAME/bin/apxs \
	--disable-cgi \
	--enable-bcmath=shared \
	--enable-calendar=shared \
	--enable-cli=shared \
	--enable-ctype=shared \
	--enable-exif=shared \
	--enable-ftp=shared \
	--enable-libxml=shared \
	--enable-mbstring=shared \
	--enable-soap=shared \
	--enable-sockets=shared \
	--enable-zip=shared \
	--with-bz2=shared \
	--with-gd=shared \
	--with-freetype-dir=/usr/include/freetype2 \
	--with-jpeg-dir=shared \
	--with-png-dir=shared \
	--with-mcrypt=shared \
	--with-mhash=shared \
	--enable-pdo=shared \
	--without-sqlite \
	--with-sqlite3=shared \
	--with-pdo-sqlite=shared \
	--with-mysql=shared,$INSTALL_DIR/$PHP_MYSQL_NAME \
	--with-mysql-sock=$INSTALL_DIR/$PHP_MYSQL_NAME/log/mysql.sock \
	--with-mysqli=shared,$INSTALL_DIR/$PHP_MYSQL_NAME/bin/mysql_config \
	--with-pdo-mysql=shared,$INSTALL_DIR/$PHP_MYSQL_NAME \
	--with-openssl=shared,$INSTALL_DIR/openssl \
	--with-zlib-dir=shared,$INSTALL_DIR/zlib \
	$PHP_CONFIGURE_OPTIONS \
&& make && make install && echo "PHP installed successfully!" \
&& rm -rfv $PHP_INSTALL_DIR/man
cd ..

# TODO: http://www.hardened-php.net/suhosin/index.html

# check
if [ ! -f $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so ]; then
	echo "Error: PHP has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

PHP_EXTENSIONS_DIR_NAME=`ls $PHP_INSTALL_DIR/lib/php/extensions/`

echo "Strip symbols:"
strip_debug_symbols $PHP_INSTALL_DIR/bin
strip_debug_symbols $PHP_INSTALL_DIR/lib/php/extensions/$PHP_EXTENSIONS_DIR_NAME
strip_debug_symbols_file $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so

echo "Shared library dependencies for $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so:"
ldd $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so

# php.ini
cp -p $INSTALL_DIR/php-$PHP_VERSION/php.ini-production $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'expose_php = On' 'expose_php = Off' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'max_execution_time = 30' 'max_execution_time = 10' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'max_input_time = 60' 'max_input_time = 20' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'memory_limit = 128M' 'memory_limit = 32M' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file ';date.timezone =' 'date.timezone = "Europe\/London"' $PHP_INSTALL_DIR/conf/php.ini
echo -e "\nextension=bcmath.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=bz2.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=calendar.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=ctype.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=exif.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=ftp.so" >> $PHP_INSTALL_DIR/conf/php.ini
# iconv.so has to be loaded before gd.so
[ -f $INSTALL_DIR/libiconv/bin/iconv ] && echo -e "extension=iconv.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=gd.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=mbstring.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=mcrypt.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=openssl.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=sqlite3.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=mysql.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=mysqli.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=pdo.so" >> $PHP_INSTALL_DIR/conf/php.ini
# FIXME: cannot load pdo_sqlite.so due to an error 'pdo_sqlite.so: undefined symbol: sqlite3_libversion'
echo -e ";extension=pdo_sqlite.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=pdo_mysql.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=soap.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=sockets.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension=zip.so" >> $PHP_INSTALL_DIR/conf/php.ini

# httpd.conf
rm $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf.bak
replace_in_file 'DirectoryIndex index.html' 'DirectoryIndex index.html index.php' $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf
replace_in_file 'LoadModule php5_module        modules\/libphp5.so' 'LoadModule php5_module modules\/libphp5.so' $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf
echo -e "\n<FilesMatch \.php$>\n\tSetHandler application/x-httpd-php\n</FilesMatch>\n" >> $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf

# set files permission
chown -R root:root $PHP_INSTALL_DIR
chmod 500 $PHP_INSTALL_DIR/bin
chmod 500 $PHP_INSTALL_DIR/bin/*
chmod 500 $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so

# test
echo -e "\n\n *** PHP settings ***\n"
$PHP_INSTALL_DIR/bin/php -i
echo -e "\n\n"
echo -e "<?php phpinfo(); ?>" > $INSTALL_DIR/$PHP_HTTPD_NAME/htdocs/info.php
run_apache_performance_test $PHP_HTTPD_NAME "http://localhost:$PHP_HTTPD_PORT/info.php"

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f php.tar.gz ] && rm php.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d php-$PHP_VERSION ] && rm -rf php-$PHP_VERSION
