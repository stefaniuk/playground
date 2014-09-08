#!/bin/bash
#
# File: build-vps.sh
#
# Description: This script configures the server and builds selected services from source.
#
# Usage:
#
#	./build-vps.sh \
#		--initialize \
#		--download \
#		--remove-src-dirs \
#		--zlib \
#		--openssl \
#		--apr \
#		--mysql "name" "port" "user" "group" \
#		--httpd "name" "port" "port_ssl" "user" "group" \
#		--geoip "httpd_name" \
#		--libiconv \
#		--php "mysql_name" "httpd_name" "port" \
#		--php-fpm "php_version" "mysql_name" \
#		--imagemagick \
#		--phpmyadmin "mysql_name" "httpd_name" \
#		--proftpd "mysql_name" \
#		--postfix "mysql_name" \
#		--dovecot "mysql_name" \
#		--finalize "xxx.xxx.xxx.xxx" 2>&1 | tee build-vps.log

echo Script started on $(date)

###
### variables
###

ARGS=$*
INSTALL_DIR=/srv
INSTALL_DIR_ESC=`echo "$INSTALL_DIR" | sed 's/\//\\\\\//g'`
CURRENT_DIR=`pwd`
WORKING_DIR=$CURRENT_DIR

INITIALIZE="N"
FINALIZE="N"

DOWNLOAD="N"
REMOVE_SOURCE_FILES="N"
REMOVE_SOURCE_DIRECTORIES="N"

ZLIB_INSTALL="N"
OPENSSL_INSTALL="N"
APR_INSTALL="N"
MYSQL_INSTALL="N"
HTTPD_INSTALL="N"
GEOIP_INSTALL="N"
LIBICONV_INSTALL="N"
PHP_INSTALL="N"
PHP_FPM_INSTALL="N"
IMAGEMAGICK_INSTALL="N"
PHPMYADMIN_INSTALL="N"
PROFTPD_INSTALL="N"
POSTFIX_INSTALL="N"
DOVECOT_INSTALL="N"
OPENJDK_INSTALL="N"
ANT_INSTALL="N"
TOMCAT_INSTALL="N"

# set permission
chown root:root $INSTALL_DIR/*.{sh,pl,log} > /dev/null 2>&1
chmod 500 $INSTALL_DIR/*.{sh,pl} > /dev/null 2>&1
chmod 400 $INSTALL_DIR/*.log > /dev/null 2>&1
chown -R root:root $INSTALL_DIR/{conf,scripts}
chmod 700 $INSTALL_DIR/{conf,scripts}
chmod 500 $INSTALL_DIR/{conf,scripts}/*

###
### process arguments
###

while [ "$1" != "" ]; do
	case $1 in
		--initialize)		INITIALIZE="Y"
							;;
		--finalize)			FINALIZE="Y"
							;;
		--download)			DOWNLOAD="Y"
							;;
		--zlib)				ZLIB_INSTALL="Y"
							;;
		--openssl)			OPENSSL_INSTALL="Y"
							;;
		--apr)				APR_INSTALL="Y"
							;;
		--mysql)			MYSQL_INSTALL="Y"
							;;
		--httpd)			HTTPD_INSTALL="Y"
							;;
		--geoip)			GEOIP_INSTALL="Y"
							;;
		--libiconv)			LIBICONV_INSTALL="Y"
							;;
		--php)				PHP_INSTALL="Y"
							;;
		--php-fpm)			PHP_FPM_INSTALL="Y"
							;;
		--imagemagick)		IMAGEMAGICK_INSTALL="Y"
							;;
		--phpmyadmin)		PHPMYADMIN_INSTALL="Y"
							;;
		--proftpd)			PROFTPD_INSTALL="Y"
							;;
		--postfix)			POSTFIX_INSTALL="Y"
							;;
		--dovecot)			DOVECOT_INSTALL="Y"
							;;
		--openjdk)			OPENJDK_INSTALL="Y"
							;;
		--ant)				ANT_INSTALL="Y"
							;;
		--tomcat)			TOMCAT_INSTALL="Y"
							;;
		--remove-src-files)	REMOVE_SOURCE_FILES="Y"
							;;
		--remove-src-dirs)	REMOVE_SOURCE_DIRECTORIES="Y"
							;;
	esac
	shift
done

cd $WORKING_DIR

source $INSTALL_DIR/scripts/common.sh

###
### initialize
###

if [ "$INITIALIZE" = "Y" ]; then
	. ./build-vps-initialize.sh $ARGS
fi

###
### install zlib
###

if [ "$ZLIB_INSTALL" = "Y" ]; then
	. ./compile-zlib.sh $ARGS
fi

###
### install OpenSSL
###

if [ "$OPENSSL_INSTALL" = "Y" ]; then
	. ./compile-openssl.sh $ARGS
fi

###
### install APR
###

if [ "$APR_INSTALL" = "Y" ]; then
	. ./compile-apr.sh $ARGS
fi

###
### install MySQL
###

if [ "$MYSQL_INSTALL" = "Y" ]; then
	. ./compile-mysql.sh $ARGS
fi

###
### install Apache HTTPD Server
###

if [ "$HTTPD_INSTALL" = "Y" ]; then
	. ./compile-httpd.sh $ARGS
fi

###
### install GeoIP
###

if [ "$GEOIP_INSTALL" = "Y" ]; then
	. ./compile-geoip.sh $ARGS
fi

###
### install libiconv
###

if [ "$LIBICONV_INSTALL" = "Y" ]; then
	. ./compile-libiconv.sh $ARGS
fi

###
### install PHP
###

if [ "$PHP_INSTALL" = "Y" ]; then
	. ./compile-php.sh $ARGS
fi

###
### install PHP (FPM)
###

if [ "$PHP_FPM_INSTALL" = "Y" ]; then
	. ./compile-php-fpm.sh $ARGS
fi

###
### install ImageMagick
###

if [ "$IMAGEMAGICK_INSTALL" = "Y" ]; then
	. ./compile-imagemagick.sh $ARGS
fi

###
### install phpMyAdmin
###

if [ "$PHPMYADMIN_INSTALL" = "Y" ]; then
	. ./compile-phpmyadmin.sh $ARGS
fi

###
### install ProFTPD
###

if [ "$PROFTPD_INSTALL" = "Y" ]; then
	. ./compile-proftpd.sh $ARGS
fi

###
### install Postfix
###

if [ "$POSTFIX_INSTALL" = "Y" ]; then
	. ./compile-postfix.sh $ARGS
fi

###
### install Dovecot
###

if [ "$DOVECOT_INSTALL" = "Y" ]; then
	. ./compile-dovecot.sh $ARGS
fi

###
### finalize
###

if [ "$FINALIZE" = "Y" ]; then
	. ./build-vps-finalize.sh $ARGS
fi

cd $CURRENT_DIR

echo Script ended on $(date)
