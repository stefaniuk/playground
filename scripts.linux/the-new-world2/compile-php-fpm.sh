#!/bin/bash

##
## variables
##

PHP_FPM_VERSION=
PHP_FPM_MYSQL_NAME=
PHP_FPM_CONFIGURE_OPTIONS=

##
## install function
##

# parameters:
#	$1 php_version
function download_php_fpm_snapshot {

	for((d=0; d<7; d++))
	do
		for((h=22; h>=0; h=h-2))
		do
			if [ $d -eq 0 ]; then
				TIMESTAMP=$(date +%Y%m%d)$(printf "%.2d" "$h")30
			else
				TIMESTAMP=$(date --date="-$d day" +%Y%m%d)$(printf "%.2d" "$h")30
			fi
			wget http://snaps.php.net/php$1-$TIMESTAMP.tar.gz -O php-fpm-$1.tar.gz
			if [ -s php-fpm-$1.tar.gz ]; then
				break
			fi
		done
		if [ -s php-fpm-$1.tar.gz ]; then
			break
		fi
	done

}

function install_php_fpm {

# variables

PHP_FPM_INSTALL_DIR=$INSTALL_DIR/php-fpm-$PHP_FPM_VERSION
PHP_FPM_INSTALL_DIR_ESC=`echo "$PHP_FPM_INSTALL_DIR" | sed 's/\//\\\\\//g'`

# check dependencies

if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: PHP FPM requires zlib!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: PHP FPM requires OpenSSL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$PHP_FPM_MYSQL_NAME/bin/mysqld ]; then
	echo "Error: PHP FPM requires MySQL!"
	exit 1
fi
# optional
if [ -f $INSTALL_DIR/libiconv/bin/iconv ]; then
	PHP_FPM_CONFIGURE_OPTIONS="--with-iconv=shared,$INSTALL_DIR/libiconv"
fi

# download

if [ "$DOWNLOAD" = "Y" ]; then
	[ -f php-fpm-$PHP_FPM_VERSION.tar.gz ] && rm php-fpm-$PHP_FPM_VERSION.tar.gz
	download_php_fpm_snapshot $PHP_FPM_VERSION
fi
if [ ! -f php-fpm-$PHP_FPM_VERSION.tar.gz ]; then
	echo "Error: Unable to download php-fpm-$PHP_FPM_VERSION.tar.gz file!"
	exit 1
fi

# install

echo "Installing PHP FPM $PHP_FPM_VERSION":
# create user and group
[ -d $PHP_FPM_INSTALL_DIR ] && rm -rf $PHP_FPM_INSTALL_DIR
tar -zxf php-fpm-$PHP_FPM_VERSION.tar.gz
PHP_FPM_SRC_DIR_NAME=`find -name "php*$PHP_FPM_VERSION*" -type d -exec basename '{}' ';'`
cd $PHP_FPM_SRC_DIR_NAME
./configure \
	--prefix=$PHP_FPM_INSTALL_DIR \
	--sbindir=$PHP_FPM_INSTALL_DIR/bin \
	--sysconfdir=$PHP_FPM_INSTALL_DIR/conf \
	--localstatedir=$PHP_FPM_INSTALL_DIR/log \
	--with-config-file-path=$PHP_FPM_INSTALL_DIR/conf \
	--disable-cgi \
	--enable-fpm \
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
	--with-mysql=shared,$INSTALL_DIR/$PHP_FPM_MYSQL_NAME \
	--with-mysql-sock=$INSTALL_DIR/$PHP_FPM_MYSQL_NAME/log/mysql.sock \
	--with-mysqli=shared,$INSTALL_DIR/$PHP_FPM_MYSQL_NAME/bin/mysql_config \
	--with-pdo-mysql=shared,$INSTALL_DIR/$PHP_FPM_MYSQL_NAME \
	--with-openssl=shared,$INSTALL_DIR/openssl \
	--with-zlib-dir=shared,$INSTALL_DIR/zlib \
	$PHP_FPM_CONFIGURE_OPTIONS \
&& make && make install && echo "PHP $PHP_FPM_VERSION installed successfully!" \
&& cp -v sapi/fpm/init.d.php-fpm $PHP_FPM_INSTALL_DIR/bin/php-fpm.sh \
&& rm -rfv $PHP_FPM_INSTALL_DIR/{man,log/*,php} \
&& cp -v $PHP_FPM_INSTALL_DIR/conf/php-fpm.conf.default $PHP_FPM_INSTALL_DIR/conf/php-fpm.conf \
&& mkdir $PHP_FPM_INSTALL_DIR/conf/pools
cd ..

# TODO: http://www.hardened-php.net/suhosin/index.html

# check
if [ ! -f $PHP_FPM_INSTALL_DIR/bin/php-fpm ]; then
	echo "Error: PHP FPM $PHP_FPM_VERSION has NOT been installed successfully!"
	exit 1
fi

# extensions
PHP_FPM_EXTENSIONS_DIR_NAME=`ls $PHP_FPM_INSTALL_DIR/lib/php/extensions/`
rm -v $PHP_FPM_INSTALL_DIR/lib/php/extensions/$PHP_FPM_EXTENSIONS_DIR_NAME/*.a

# configure

echo "Strip symbols:"
strip_debug_symbols $PHP_FPM_INSTALL_DIR/bin
strip_debug_symbols $PHP_FPM_INSTALL_DIR/lib/php/extensions/$PHP_FPM_EXTENSIONS_DIR_NAME

echo "Shared library dependencies for $PHP_FPM_INSTALL_DIR/bin/php-fpm:"
ldd $PHP_FPM_INSTALL_DIR/bin/php-fpm

# amend startup script
replace_in_file '\/log\/run\/php-fpm.pid' '\/log\/php-fpm.pid' $PHP_FPM_INSTALL_DIR/bin/php-fpm.sh

# php-fpm.conf
cat <<EOF > $PHP_FPM_INSTALL_DIR/conf/php-fpm.conf
[global]
pid = $PHP_FPM_INSTALL_DIR/log/php-fpm.pid
error_log = $PHP_FPM_INSTALL_DIR/log/php-fpm.log
log_level = notice
emergency_restart_threshold = 5
emergency_restart_interval = 2
process_control_timeout = 2
daemonize = yes
include = $PHP_FPM_INSTALL_DIR/conf/pools/*.conf
EOF

# set files permission
chown -R root:root $PHP_FPM_INSTALL_DIR
chmod 555 $PHP_FPM_INSTALL_DIR/bin
chmod 555 $PHP_FPM_INSTALL_DIR/bin/*

# test
echo -e "\n\n *** PHP settings ***\n"
$PHP_FPM_INSTALL_DIR/bin/php -i
echo -e "\n\n"

# clean up

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f php-fpm-$PHP_FPM_VERSION.tar.gz ] && rm php-fpm-$PHP_FPM_VERSION.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d $PHP_FPM_SRC_DIR_NAME ] && rm -rf $PHP_FPM_SRC_DIR_NAME

}

##
## parse arguments and install
##

while [ "$1" != "" ]; do
	case $1 in
		--php-fpm)	shift && PHP_FPM_VERSION=$1
					shift && PHP_FPM_MYSQL_NAME=$1
					install_php_fpm
					;;
	esac
	shift
done
