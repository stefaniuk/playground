#!/bin/bash
#
# usage:
#
#	./build.sh --init --zlib --openssl --apr --download 2>&1 | tee build.base.out && source ~/.profile
#
#	./build.sh --mysql mysql3306 mysql3306 mysql3306 3306 --download 2>&1 | tee build.mysql3306.out
#	./build.sh --mysql mysql3307 mysql3307 mysql3307 3307 --download 2>&1 | tee build.mysql3307.out
#
#	./build.sh --apache proxy apache80 apache80 apache80 80 443 --download 2>&1 | tee build.apache80.out
#	./build.sh --apache webserver apache8081 apache8081 apache8081 8081 1443 --php mod mysql3306 --apc --download 2>&1 | tee build.apache8081.out
#	./build.sh --apache webserver apache8082 apache8082 apache8082 8082 2443 --php fpm mysql3307 --apc --download 2>&1 | tee build.apache8082.out
#
#	./build.sh --vsftpd --download 2>&1 | tee build.vsftpd.out
#
#	./build.sh --phpmyadmin --download 2>&1 | tee build.application-phpmyadmin.out
#
#	./build.sh --openjdk --tomcat tomcat8080 tomcat8080 tomcat8080 8080 8443 --download 2>&1 | tee build.tomcat8080.out
#
#	./build.sh --site site1 apache80 apache8081 8081 1443 2>&1 | tee build.site-site1.out
#	./build.sh --site site2 apache80 apache8082 8082 2443 2>&1 | tee build.site-site2.out
#	./build.sh --app app1 apache80 tomcat8080 8080 8443 2>&1 | tee build.app-app1.out
#
#	./build.sh --ssl-entry app1 apache80 ajp 8009 2>&1 | tee build.ssl-app1.out
#

# TODO: link libraries - zlib, openssl, apr
# TODO: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName
# TODO: mysql: create log files in the logs directory
# TODO: httpd: configure Apache HTTPD log format
# TODO: tomcat: The APR based Apache Tomcat Native library which allows optimal performance in production environments was not found
# TODO: server strtup script

echo Script started on $(date)

###
### variables
###

CURRENT_DIR=`pwd`
WORKING_DIR=$CURRENT_DIR
INSTALL_DIR=/usr/local

INITIALIZE=N
DOWNLOAD=N

ZLIB_INSTALL=N
OPENSSL_INSTALL=N
APR_INSTALL=N
MYSQL_INSTALL=N
MYSQL_INSTANCE_NAME=
MYSQL_USER=
MYSQL_GROUP=
MYSQL_PORT=
APACHE_INSTALL=N
APACHE_INSTANCE_TYPE=
APACHE_INSTANCE_NAME=
APACHE_USER=
APACHE_GROUP=
APACHE_PORT=
APACHE_PORT_SSL=
PHP_INSTALL=N
PHP_TYPE=
PHP_MYSQL_INSTANCE=
APC_INSTALL=N
MEMCACHED_INSTALL=N
PHPMYADMIN_INSTALL=N
VSFTPD_INSTALL=N
OPENJDK_INSTALL=N
TOMCAT_INSTALL=N
TOMCAT_INSTANCE_NAME=
TOMCAT_USER=
TOMCAT_GROUP=
TOMCAT_PORT=
TOMCAT_PORT_SSL=

SITE_DOMAIN=
SITE_DOMAIN_PROXY_NAME=
SITE_DOMAIN_INSTANCE_NAME=
SITE_DOMAIN_INSTANCE_PORT=
SITE_DOMAIN_INSTANCE_PORT_SSL=

APP_DOMAIN=
APP_DOMAIN_PROXY_NAME=
APP_DOMAIN_INSTANCE_NAME=
APP_DOMAIN_INSTANCE_PORT=
APP_DOMAIN_INSTANCE_PORT_SSL=

SSL_ENTRY_DOMAIN=
SSL_ENTRY_PROXY_NAME=
SSL_ENTRY_INSTANCE_PROTOCOL=
SSL_ENTRY_INSTANCE_PORT=

ZLIB_VERSION=1.2.5
OPENSSL_VERSION=1.0.0d
APR_VERSION=1.4.2
APR_UTIL_VERSION=1.3.10
MYSQL_VERSION=5.1.56
APACHE_VERSION=2.2.17
PHP_VERSION=5.3.6
APC_VERSION=3.1.7
LIBEVENT_VERSION=2.0.6-rc
MEMCACHED_VERSION=1.4.5
PHPMYADMIN_VERSION=3.4.0-beta4
VSFTPD_VERSION=2.3.4
TOMCAT_VERSION=7.0.11
TOMCAT_COMMONS_DAEMON_VERSION=1.0.5

REMOVE_SOURCE_FILES=N
REMOVE_SOURCE_DIRECTORIES=Y

###
### process arguments
###

while [ "$1" != "" ]; do

	case $1 in
		--init)				INITIALIZE=Y
							;;
		--download)			DOWNLOAD=Y
							;;
		--zlib)				ZLIB_INSTALL=Y
							;;
		--openssl)			OPENSSL_INSTALL=Y
							;;
		--apr)				APR_INSTALL=Y
							;;
		--mysql)			MYSQL_INSTALL=Y
							shift
							MYSQL_INSTANCE_NAME=$1
							shift
							MYSQL_USER=$1
							shift
							MYSQL_GROUP=$1
							shift
							MYSQL_PORT=$1
							;;
		--apache)			APACHE_INSTALL=Y
							shift
							APACHE_INSTANCE_TYPE=$1
							shift
							APACHE_INSTANCE_NAME=$1
							shift
							APACHE_USER=$1
							shift
							APACHE_GROUP=$1
							shift
							APACHE_PORT=$1
							shift
							APACHE_PORT_SSL=$1
							;;
		--php)				PHP_INSTALL=Y
							shift
							PHP_TYPE=$1
							shift
							PHP_MYSQL_INSTANCE=$1
							;;
		--apc)				APC_INSTALL=Y
							;;
		--memcached)		MEMCACHED_INSTALL=Y
							;;
		--phpmyadmin)		PHPMYADMIN_INSTALL=Y
							;;
		--vsftpd)			VSFTPD_INSTALL=Y
							;;
		--openjdk)			OPENJDK_INSTALL=Y
							;;
		--tomcat)			TOMCAT_INSTALL=Y
							shift
							TOMCAT_INSTANCE_NAME=$1
							shift
							TOMCAT_USER=$1
							shift
							TOMCAT_GROUP=$1
							shift
							TOMCAT_PORT=$1
							shift
							TOMCAT_PORT_SSL=$1
							;;
		--site) 			shift
							SITE_DOMAIN=$1
							shift
							SITE_DOMAIN_PROXY_NAME=$1
							shift
							SITE_DOMAIN_INSTANCE_NAME=$1
							shift
							SITE_DOMAIN_INSTANCE_PORT=$1
							shift
							SITE_DOMAIN_INSTANCE_PORT_SSL=$1
							;;
		--app) 				shift
							APP_DOMAIN=$1
							shift
							APP_DOMAIN_PROXY_NAME=$1
							shift
							APP_DOMAIN_INSTANCE_NAME=$1
							shift
							APP_DOMAIN_INSTANCE_PORT=$1
							shift
							APP_DOMAIN_INSTANCE_PORT_SSL=$1
							;;
		--ssl-entry)		shift
							SSL_ENTRY_DOMAIN=$1
							shift
							SSL_ENTRY_PROXY_NAME=$1
							shift
							SSL_ENTRY_INSTANCE_PROTOCOL=$1
							shift
							SSL_ENTRY_INSTANCE_PORT=$1
							;;
	esac
	shift

done

INSTALL_DIR_ESC="`echo "$INSTALL_DIR" | awk '{ gsub(/\//, "\\\/"); print }'`"

cd $WORKING_DIR

###
### functions
###

# parameters: str_to_replace new_str file_name
function replace_in_file {

	TMP_FILE=/tmp/replace_in_file.$$
	sed "s/$1/$2/g" $3 > $TMP_FILE && mv $TMP_FILE $3
}

# parameters: str_to_remove file_name
function remove_from_file {

	TMP_FILE=/tmp/remove_from_file.$$
	TMP_STR='1h;1!H;${;g;s/'
	sed -n "$TMP_STR$1//g;p;}" $2 > $TMP_FILE && mv $TMP_FILE $2
}

# parameters: url
function run_apache_performance_test {

	pkill httpd
	sleep 1 && $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/bin/apachectl -k start
	echo -e "\n\n *** Apache Benchmark ***\n"
	$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/bin/ab -n 50000 -c 100 $1
	echo -e "\n\n"
	sleep 5 && $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/bin/apachectl -k stop
	rm $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/logs/access_log
	rm $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/logs/error_log
}

# parameters: domain proxy instance_name instance_port
function create_web_site {

	# make sure the directory does not exist
	[ -d $INSTALL_DIR/www/sites/$1 ] && rm -rf $INSTALL_DIR/www/sites/$1

	# create directory structure
	mkdir -p $INSTALL_DIR/www/sites/$1/{logs,public}
	(	echo -e "RewriteEngine On" && \
		echo -e "RewriteCond %{REQUEST_FILENAME} -s [OR]" && \
		echo -e "RewriteCond %{REQUEST_FILENAME} -l [OR]" && \
		echo -e "RewriteCond %{REQUEST_FILENAME} -d" && \
		echo -e "RewriteRule ^.*$ - [NC,L]" && \
		echo -e "RewriteRule ^.*$ index.php [NC,L]" \
	) > $INSTALL_DIR/www/sites/$1/public/.htaccess
	echo -e "The <i><b>$1</b></i> is under construction..." > $INSTALL_DIR/www/sites/$1/public/index.php

	###
	### update Apache HTTPD instance
	###

	# add vhost configuration to httpd-vhosts.conf
	remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/www/$3/conf/extra/httpd-vhosts.conf
	(	echo -e "# BEGIN: vhost $1" && \
		echo -e "<VirtualHost *:$4>" && \
		echo -e "\tServerName $1" && \
		echo -e "\tServerAlias www.$1" && \
		echo -e "\tDocumentRoot \"$INSTALL_DIR/www/sites/$1/public\"" && \
		echo -e "\t<Directory \"$INSTALL_DIR/www/sites/$1/public\">" && \
		echo -e "\t\tOptions Indexes FollowSymLinks" && \
		echo -e "\t\tAllowOverride All" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from all" && \
		echo -e "\t</Directory>" && \
		echo -e "\tErrorLog \"$INSTALL_DIR/www/sites/$1/logs/error_log\"" && \
		echo -e "\tCustomLog \"$INSTALL_DIR/www/sites/$1/logs/access_log\" \"%t %h \\\"%r\\\" %b\"" && \
		echo -e "</VirtualHost>" && \
		echo -e "# END: vhost $1" \
	) >> $INSTALL_DIR/www/$3/conf/extra/httpd-vhosts.conf

	###
	### update Apache HTTPD proxy
	###

	# add vhost configuration to httpd-vhosts.conf
	remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/www/$2/conf/extra/httpd-vhosts.conf
	(	echo -e "# BEGIN: vhost $1" && \
		echo -e "<VirtualHost *:80>" && \
		echo -e "\tServerName $1" && \
		echo -e "\tServerAlias www.$1" && \
		echo -e "\t<Proxy *>" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from *" && \
		echo -e "\t</Proxy>" && \
		echo -e "\tProxyPass / http://$1:$4" && \
		echo -e "\tProxyPassReverse / http://$1:$4" && \
		echo -e "\t<Location />" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from all" && \
		echo -e "\t</Location>" && \
		echo -e "</VirtualHost>" && \
		echo -e "# END: vhost $1" \
	) >> $INSTALL_DIR/www/$2/conf/extra/httpd-vhosts.conf

	remove_from_file "\n127.0.0.1 $1" /etc/hosts
	echo "127.0.0.1 $1" >> /etc/hosts
}

# parameters: domain proxy instance_name instance_port instance_port_ssl
function create_web_app {

	# make sure the directory does not exist
	[ -d $INSTALL_DIR/www/sites/$1 ] && rm -rf $INSTALL_DIR/www/sites/$1

	# create directory structure
	mkdir -p $INSTALL_DIR/www/sites/$1/{META-INF,WEB-INF/{classes,lib}}

	###
	### update Tomcat instance
	###

	# TODO: update Tomcat instance

	###
	### update Apache HTTPD proxy
	###

	# add vhost configuration to httpd-vhosts.conf
	remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/www/$2/conf/extra/httpd-vhosts.conf
	(	echo -e "# BEGIN: vhost $1" && \
		echo -e "<VirtualHost *:80>" && \
		echo -e "\tServerName $1" && \
		echo -e "\tServerAlias www.$1" && \
		echo -e "\t<Proxy *>" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from *" && \
		echo -e "\t</Proxy>" && \
		echo -e "\tProxyPass / ajp://$1:8009/" && \
		echo -e "\tProxyPassReverse / ajp://$1:8009/" && \
		echo -e "\t<Location />" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from all" && \
		echo -e "\t</Location>" && \
		echo -e "</VirtualHost>" && \
		echo -e "# END: vhost $1" \
	) >> $INSTALL_DIR/www/$2/conf/extra/httpd-vhosts.conf

	remove_from_file "\n127.0.0.1 $1" /etc/hosts
	echo "127.0.0.1 $1" >> /etc/hosts
}

# parameters: domain proxy protocol port
function create_ssl_entry {

	# generate certificate

	#$INSTALL_DIR/openssl/bin/openssl genrsa -des3 -out $1.key 2048
	#$INSTALL_DIR/openssl req -new -key $1.key -out $1.csr

	$INSTALL_DIR/openssl/bin/openssl req \
		-new -x509 -nodes -sha1 -newkey rsa:1024 -days 365 -subj "/O=unknown/OU=unknown/CN=$1" \
		-keyout $INSTALL_DIR/openssl/certs/$1.key \
		-out $INSTALL_DIR/openssl/certs/$1.crt
	cat $INSTALL_DIR/openssl/certs/$1.crt $INSTALL_DIR/openssl/certs/$1.key > $INSTALL_DIR/openssl/certs/$1.pem
	chmod 400 $INSTALL_DIR/openssl/certs/$1.key
	chmod 400 $INSTALL_DIR/openssl/certs/$1.pem

	# add vhost configuration to httpd-ssl.conf
	remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/www/$2/conf/extra/httpd-ssl.conf
	(	echo -e "# BEGIN: vhost $1" && \
		echo -e "<VirtualHost *:443>" && \
		echo -e "\tServerName $1" && \
		echo -e "\tServerAlias www.$1" && \
		echo -e "\tSSLEngine on" && \
		echo -e "\tSSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL" && \
		echo -e "\tSSLCertificateFile \"$INSTALL_DIR/openssl/certs/$1.crt\"" && \
		echo -e "\tSSLCertificateKeyFile \"$INSTALL_DIR/openssl/certs/$1.key\"" && \
		echo -e "\tBrowserMatch \".*MSIE.*\" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0" && \
		echo -e "\t<Proxy *>" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from *" && \
		echo -e "\t</Proxy>" && \
		echo -e "\tProxyPass / $3://$1:$4/" && \
		echo -e "\tProxyPassReverse / $3://$1:$4/" && \
		echo -e "\t<Location />" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from all" && \
		echo -e "\t</Location>" && \
		echo -e "</VirtualHost>" && \
		echo -e "# END: vhost $1" \
	) >> $INSTALL_DIR/www/$2/conf/extra/httpd-ssl.conf

}

###
### dependencies
###

if [ "$INITIALIZE" = "Y" ]; then

	# apt-get
	apt-get update && apt-get -y install \
		build-essential libncurses5-dev libssl-dev libxml2-dev autoconf libexpat1-dev \
		libjpeg62-dev libpng12-dev libmcrypt-dev git-core

	# $PATH
	NEW_PATH=$INSTALL_DIR/openssl/bin:$INSTALL_DIR/jdk/bin
	remove_from_file "\n# BEGIN: server settings.*END: server settings\n" ~/.profile
	echo -e "# BEGIN: server settings" >> ~/.profile
	echo -e "export JAVA_HOME=$INSTALL_DIR/jdk" >> ~/.profile
	echo -e "export CATALINA_HOME=$INSTALL_DIR/www/tomcat8080" >> ~/.profile
	echo -e "export PATH=\"$NEW_PATH:/usr/sbin:/usr/bin:/sbin:/bin\"" >> ~/.profile
	echo -e "# END: server settings\n" >> ~/.profile

fi

###
### download
###

if [ "$DOWNLOAD" = "Y" ]; then

	if [ "$ZLIB_INSTALL" = "Y" ] && [ ! -f zlib.tar.gz ]; then
		wget http://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz -O zlib.tar.gz
	fi
	if [ "$OPENSSL_INSTALL" = "Y" ] && [ ! -f openssl.tar.gz ]; then
		wget http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -O openssl.tar.gz
	fi
	if [ "$APR_INSTALL" = "Y" ] && [ ! -f apr.tar.gz ]; then
		wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//apr/apr-$APR_VERSION.tar.gz -O apr.tar.gz
	fi
	if [ "$APR_INSTALL" = "Y" ] && [ ! -f apr-util.tar.gz ]; then
		wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//apr/apr-util-$APR_UTIL_VERSION.tar.gz -O apr-util.tar.gz
	fi
	if [ "$MYSQL_INSTALL" = "Y" ] && [ ! -f mysql.tar.gz ]; then
		wget http://www.mysql.com/get/Downloads/MySQL-5.1/mysql-$MYSQL_VERSION.tar.gz/from/http://www.mirrorservice.org/sites/ftp.mysql.com/ -O mysql.tar.gz
	fi
	if [ "$APACHE_INSTALL" = "Y" ] && [ ! -f httpd.tar.gz ]; then
		wget http://apache.favoritelinks.net/httpd/httpd-$APACHE_VERSION.tar.gz -O httpd.tar.gz
	fi
	if [ "$PHP_INSTALL" = "Y" ] && [ ! -f php.tar.gz ]; then
		wget http://de.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror -O php.tar.gz
	fi
	if [ "$APC_INSTALL" = "Y" ] && [ ! -f apc.tgz ]; then
		wget http://pecl.php.net/get/APC-$APC_VERSION.tgz -O apc.tgz
	fi
	if [ "$MEMCACHED_INSTALL" = "Y" ] && [ ! -f libevent.tar.gz ]; then
		wget http://monkey.org/~provos/libevent-$LIBEVENT_VERSION.tar.gz -O libevent.tar.gz
	fi
	if [ "$MEMCACHED_INSTALL" = "Y" ] && [ ! -f memcached.tar.gz ]; then
		wget http://memcached.googlecode.com/files/memcached-$MEMCACHED_VERSION.tar.gz -O memcached.tar.gz
	fi
	if [ "$PHPMYADMIN_INSTALL" = "Y" ] && [ ! -f phpmyadmin.tar.gz ]; then
		wget http://sourceforge.net/projects/phpmyadmin/files%2FphpMyAdmin%2F$PHPMYADMIN_VERSION%2FphpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz/download -O phpmyadmin.tar.gz
	fi
	if [ "$VSFTPD_INSTALL" = "Y" ] && [ ! -f vsftpd.tar.gz ]; then
		wget ftp://vsftpd.beasts.org/users/cevans/vsftpd-$VSFTPD_VERSION.tar.gz -O vsftpd.tar.gz
	fi
	if [ "$OPENJDK_INSTALL" = "Y" ] && [ ! -f openjdk.tar.gz ]; then
		wget http://www.java.net/download/jdk7/archive/b133/binaries/jdk-7-ea-bin-b133-linux-x64-10_mar_2011.tar.gz -O openjdk.tar.gz
	fi
	if [ "$TOMCAT_INSTALL" = "Y" ] && [ ! -f tomcat.tar.gz ]; then
		wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//tomcat/tomcat-7/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -O tomcat.tar.gz
	fi

fi

###
### pre-install
###

[ ! -h /usr/lib/libexpat.so.0 ] && ln -s /usr/lib/libexpat.so /usr/lib/libexpat.so.0
[ ! -h /usr/lib/libjpeg.so ] && ln -s /usr/lib/libjpeg.so.62 /usr/lib/libjpeg.so

###
### install zlib
###

if [ "$ZLIB_INSTALL" = "Y" ]; then

echo Installing zlib:
[ -d $INSTALL_DIR/zlib ] && rm -rf $INSTALL_DIR/zlib
tar -zxf zlib.tar.gz
cd zlib-$ZLIB_VERSION
./configure \
	--prefix=$INSTALL_DIR/zlib \
&& make && make install && echo zlib installed successfully!
cd ..
rm -rf $INSTALL_DIR/zlib/share

fi

###
### install OpenSSL
###

if [ "$OPENSSL_INSTALL" = "Y" ]; then

echo Installing OpenSSL:
[ -d $INSTALL_DIR/openssl ] && rm -rf $INSTALL_DIR/openssl
tar -zxf openssl.tar.gz
cd openssl-$OPENSSL_VERSION
./config \
	--prefix=$INSTALL_DIR/openssl \
	--openssldir=$INSTALL_DIR/openssl \
	--with-zlib-lib=$INSTALL_DIR/zlib/lib \
	--with-zlib-include=$INSTALL_DIR/zlib/include \
&& make && make install && echo OpenSSL installed successfully!
cd ..
rm -rf $INSTALL_DIR/openssl/man

fi

###
### install APR
###

if [ "$APR_INSTALL" = "Y" ]; then

echo Installing APR:
[ -d $INSTALL_DIR/apr ] && rm -rf $INSTALL_DIR/apr
tar -zxf apr.tar.gz
cd apr-$APR_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr/ \
&& make && make install && echo APR installed successfully!
cd ..

echo Installing APR Util:
[ -d $INSTALL_DIR/apr-util ] && rm -rf $INSTALL_DIR/apr-util
tar -zxf apr-util.tar.gz
cd apr-util-$APR_UTIL_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr-util/ \
	--with-apr=$INSTALL_DIR/apr/ \
&& make && make install && echo APR Util installed successfully!
cd ..

fi

###
### install MySQL
###

if [ "$MYSQL_INSTALL" = "Y" ]; then

echo Installing MySQL:
[ -d $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME ] && rm -rf $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME
tar -zxf mysql.tar.gz
cd mysql-$MYSQL_VERSION
CFLAGS="-O3" CXX=gcc CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti" ./configure \
	--prefix=$INSTALL_DIR/db/$MYSQL_INSTANCE_NAME \
	--enable-assembler \
	--enable-thread-safe-client \
	--with-charset=utf8 \
	--with-collation=utf8_general_ci \
	--with-ssl=$INSTALL_DIR/openssl/lib \
	--with-zlib-dir=$INSTALL_DIR/zlib \
	--without-docs \
	--without-man \
&& make && make install && echo MySQL installed successfully!
rm -rf $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/mysql-test
cp support-files/my-medium.cnf $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/my.cnf
replace_in_file '= 3306' "= $MYSQL_PORT" $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/my.cnf
cd ..
groupadd $MYSQL_GROUP
useradd -g $MYSQL_GROUP $MYSQL_USER
chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME
$INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/bin/mysql_install_db --user=$MYSQL_USER
sleep 5 && pkill mysqld # the script may fail without this
$INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/bin/mysqld_safe --user=$MYSQL_USER &
sleep 5 # the script may fail without this
$INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/bin/mysqladmin -u root -f drop test
sleep 5 # the script may fail without this
echo 'use mysql; delete from db;' | $INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/bin/mysql -u root
#$INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/bin/mysqladmin -u root password 'password'
#$INSTALL_DIR/db/$MYSQL_INSTANCE_NAME/bin/mysqladmin -u root shutdown -p
sleep 5 && pkill mysqld # clean up

fi

###
### install Apache HTTPD Server
###

if [ "$APACHE_INSTALL" = "Y" ]; then

echo Installing Apache HTTPD Server:
[ -d $INSTALL_DIR/www/$APACHE_INSTANCE_NAME ] && rm -rf $INSTALL_DIR/www/$APACHE_INSTANCE_NAME
tar -zxf httpd.tar.gz
cd httpd-$APACHE_VERSION
replace_in_file '#define AP_SERVER_BASEPRODUCT "Apache"' '#define AP_SERVER_BASEPRODUCT "Code4ge Server"' ./include/ap_release.h
if [ "$APACHE_INSTANCE_TYPE" = "proxy" ]; then
	./configure \
		--prefix=$INSTALL_DIR/www/$APACHE_INSTANCE_NAME \
		--with-mpm=worker \
		--disable-actions \
		--disable-asis \
		--disable-auth \
		--disable-autoindex \
		--disable-cgi \
		--disable-cgid \
		--disable-include \
		--disable-negotiation \
		--disable-status \
		--disable-userdir \
		--enable-deflate \
		--enable-headers \
		--enable-proxy \
		--enable-rewrite \
		--enable-so \
		--enable-ssl \
		--with-apr=$INSTALL_DIR/apr \
		--with-apr-util=$INSTALL_DIR/apr-util \
		--with-ssl=$INSTALL_DIR/openssl \
		--with-z=$INSTALL_DIR/zlib \
	&& make && make install && echo "Apache HTTPD Server (proxy) installed successfully!"
fi
if [ "$APACHE_INSTANCE_TYPE" = "webserver" ]; then
	./configure \
		--prefix=$INSTALL_DIR/www/$APACHE_INSTANCE_NAME \
		--with-mpm=worker \
		--disable-actions \
		--disable-asis \
		--disable-auth \
		--disable-autoindex \
		--disable-cgi \
		--disable-cgid \
		--disable-include \
		--disable-negotiation \
		--disable-status \
		--disable-userdir \
		--enable-deflate \
		--enable-headers \
		--enable-rewrite \
		--enable-so \
		--enable-ssl \
		--with-apr=$INSTALL_DIR/apr \
		--with-apr-util=$INSTALL_DIR/apr-util \
		--with-ssl=$INSTALL_DIR/openssl \
		--with-z=$INSTALL_DIR/zlib \
	&& make && make install && echo "Apache HTTPD Server (www) installed successfully!"
fi
cd ..
rm -rf $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/cgi-bin
rm -rf $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/man
rm -rf $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/manual
# httpd.conf
(	echo -e "ServerRoot \"$INSTALL_DIR/www/$APACHE_INSTANCE_NAME\"\n" && \
	echo -e "User $APACHE_USER" && \
	echo -e "Group $APACHE_GROUP\n" && \
	echo -e "ServerTokens Prod" && \
	echo -e "ServerSignature Off\n" && \
	echo -e "ServerAdmin \"daniel (dot) stefaniuk (at) gmail (dot) com\"\n" && \
	echo -e "DocumentRoot \"$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs\"\n" && \
	echo -e "<Directory />" && \
	echo -e "\tOptions FollowSymLinks" && \
	echo -e "\tAllowOverride None" && \
	echo -e "\tOrder deny,allow" && \
	echo -e "\tDeny from all" && \
	echo -e "</Directory>" && \
	echo -e "<Directory \"$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs\">" && \
	echo -e "\tOptions Indexes FollowSymLinks" && \
	echo -e "\tAllowOverride None" && \
	echo -e "\tOrder allow,deny" && \
	echo -e "\tAllow from all" && \
	echo -e "</Directory>" && \
	echo -e "<FilesMatch \"^\\.ht\">" && \
	echo -e "\tOrder allow,deny" && \
	echo -e "\tDeny from all" && \
	echo -e "\tSatisfy All" && \
	echo -e "</FilesMatch>\n" && \
	echo -e "DirectoryIndex index.html\n" && \
	echo -e "ErrorLog \"logs/error_log\"" && \
	echo -e "LogLevel warn" && \
	echo -e "LogFormat \"%h %l %u %t \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\" combined" && \
	echo -e "LogFormat \"%h %l %u %t \\\"%r\\\" %>s %b\" common" && \
	echo -e "CustomLog \"logs/access_log\" common\n" && \
	echo -e "DefaultType text/plain" && \
	echo -e "TypesConfig conf/mime.types\n" \
) > $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
if [ "$APACHE_INSTANCE_TYPE" = "proxy" ]; then
	(	echo -e "ProxyRequests Off" && \
		echo -e "ProxyPreserveHost Off\n" \
	) >> $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
fi
(	echo -e "Include conf/extra/httpd-mpm.conf" && \
	echo -e "Include conf/extra/httpd-vhosts.conf" && \
	echo -e "Include conf/extra/httpd-ssl.conf\n" && \
	echo -e "# LoadModule foo_module modules/mod_foo.so" \
) >> $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
# httpd-vhosts.conf
(	echo -e "Listen $APACHE_PORT" && \
	echo -e "NameVirtualHost *:$APACHE_PORT\n" && \
	echo -e "<VirtualHost _default_:$APACHE_PORT>" && \
	echo -e "\tDocumentRoot \"$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs\"" && \
	echo -e "</VirtualHost>\n" \
) > $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/extra/httpd-vhosts.conf
# httpd-ssl.conf
(	echo -e "Listen $APACHE_PORT_SSL" && \
	echo -e "NameVirtualHost *:$APACHE_PORT_SSL\n" && \
	echo -e "SSLRandomSeed startup builtin" && \
	echo -e "SSLRandomSeed connect builtin" && \
	echo -e "AddType application/x-x509-ca-cert .crt" && \
	echo -e "AddType application/x-pkcs7-crl .crl" && \
	echo -e "SSLPassPhraseDialog builtin" && \
	echo -e "SSLSessionCache \"shmcb:$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/logs/ssl_scache(512000)\"" && \
	echo -e "SSLSessionCacheTimeout 300" && \
	echo -e "SSLMutex \"file:$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/logs/ssl_mutex\"\n" \
) > $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/extra/httpd-ssl.conf
groupadd $APACHE_GROUP
useradd -d $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs -g $APACHE_GROUP $APACHE_USER
chown -R $APACHE_USER:$APACHE_GROUP $INSTALL_DIR/www/$APACHE_INSTANCE_NAME
echo -e "\n\n *** Apache Modules ***\n"
$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/bin/apachectl -l
run_apache_performance_test http://localhost:$APACHE_PORT/index.html
rm -rf $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs/*

fi

###
### install PHP
###

if [ "$APACHE_INSTALL" = "Y" ] && [ "$PHP_INSTALL" = "Y" ]; then

echo Installing PHP:
PHP_INSTALL_DIR=$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/php
[ -d $PHP_INSTALL_DIR ] && rm -rf $PHP_INSTALL_DIR
tar -zxf php.tar.gz
cd php-$PHP_VERSION
if [ "$PHP_TYPE" = "mod" ]; then
	./configure \
		--prefix=$PHP_INSTALL_DIR \
		--with-apxs2=$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/bin/apxs \
		--with-config-file-path=$PHP_INSTALL_DIR/etc \
		--disable-cgi \
		--enable-mbstring --with-gd --with-jpeg-dir=/usr/lib --with-png-dir=/usr/lib --with-mcrypt --with-mhash --with-pear \
		--enable-pdo=shared \
		--with-sqlite=shared \
		--with-pdo-sqlite=shared \
		--with-mysql=shared,$INSTALL_DIR/db/$PHP_MYSQL_INSTANCE \
		--with-pdo-mysql=shared,$INSTALL_DIR/db/$PHP_MYSQL_INSTANCE \
		--with-zlib-dir=$INSTALL_DIR/zlib \
	&& make && make install && echo "PHP (mod) installed successfully!"
fi
if [ "$PHP_TYPE" = "fpm" ]; then
	./configure \
		--prefix=$PHP_INSTALL_DIR \
		--with-config-file-path=$PHP_INSTALL_DIR/etc \
		--enable-fpm \
		--disable-cgi \
		--enable-pdo=shared \
		--with-pdo-mysql=shared,$INSTALL_DIR/mysql \
		--with-zlib-dir=$INSTALL_DIR/zlib \
	&& make && make install && echo "PHP (fpm) installed successfully!"
	cp -p $PHP_INSTALL_DIR/etc/php-fpm.conf.default $PHP_INSTALL_DIR/etc/php-fpm.conf
fi
cp -p php.ini-production $PHP_INSTALL_DIR/etc/php.ini
replace_in_file 'expose_php = On' 'expose_php = Off' $PHP_INSTALL_DIR/etc/php.ini
echo -e "\nextension=mysql.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "\nextension=pdo.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=pdo_mysql.so" >> $PHP_INSTALL_DIR/etc/php.ini
cd ..
rm $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf.bak
rm -rf $PHP_INSTALL_DIR/man
replace_in_file 'DirectoryIndex index.html' 'DirectoryIndex index.html index.php' $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
replace_in_file 'LoadModule php5_module        modules\/libphp5.so' 'LoadModule php5_module modules\/libphp5.so' $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
echo -e "\n<FilesMatch \.php$>\n\tSetHandler application/x-httpd-php\n</FilesMatch>" >> $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
echo -e "<?php phpinfo(); ?>" > $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs/info.php
chown -R $APACHE_USER:$APACHE_GROUP $INSTALL_DIR/www/$APACHE_INSTANCE_NAME
echo -e "\n\n *** PHP settings ***\n"
$PHP_INSTALL_DIR/bin/php -i
echo -e "\n\n"
run_apache_performance_test http://localhost:$APACHE_PORT/info.php
rm -f $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/htdocs/info.php

fi

###
### install APC
###

if [ "$APACHE_INSTALL" = "Y" ] && [ "$PHP_INSTALL" = "Y" ] && [ "$APC_INSTALL" = "Y" ]; then

echo Installing APC:
APC_INSTALL_DIR=$INSTALL_DIR/www/$APACHE_INSTANCE_NAME/apc
[ -d $APC_INSTALL_DIR ] && rm -rf $APC_INSTALL_DIR
tar -zxf apc.tgz
cd APC-$APC_VERSION
$PHP_INSTALL_DIR/bin/phpize
./configure \
	--with-php-config=$PHP_INSTALL_DIR/bin/php-config \
	--enable-apc \
&& make && make install && echo APC installed successfully!
cd ..
rm package.xml
echo -e "extension=apc.so" >> $PHP_INSTALL_DIR/etc/php.ini
chown -R $APACHE_USER:$APACHE_GROUP $INSTALL_DIR/www/$APACHE_INSTANCE_NAME
echo -e "\n\n *** APC settings ***\n"
$PHP_INSTALL_DIR/bin/php -i | grep apc
echo -e "\n\n"
run_apache_performance_test http://localhost:$APACHE_PORT/info.php

fi

###
### post-install Apache HTTPD Server
###

if [ "$APACHE_INSTALL" = "Y" ]; then
	replace_in_file 'Allow from all' 'Deny from all' $INSTALL_DIR/www/$APACHE_INSTANCE_NAME/conf/httpd.conf
fi

###
### install Memcached
###

if [ "$MEMCACHED_INSTALL" = "Y" ]; then

echo Installing Memcached:
[ -d $INSTALL_DIR/libevent ] && rm -rf $INSTALL_DIR/libevent
tar -zxf libevent.tar.gz
cd libevent-$LIBEVENT_VERSION
./configure \
	--prefix=$INSTALL_DIR/libevent \
&& make && make install && echo libevent installed successfully!
cd ..
rm /usr/lib/libevent-2.0.so.2
ln -s $INSTALL_DIR/libevent/lib/libevent-2.0.so.2 /usr/lib
rm -rf $INSTALL_DIR/memcached
tar -zxf memcached.tar.gz
cd memcached-$MEMCACHED_VERSION
./configure \
	--prefix=$INSTALL_DIR/memcached \
	--with-libevent=$INSTALL_DIR/libevent \
&& make && make install && echo Memcached installed successfully!
cd ..
rm -rf $INSTALL_DIR/memcached/share
#$INSTALL_DIR/php/bin/pecl install memcache
#echo -e "extension=memcache.so" >> $INSTALL_DIR/php/etc/php.ini
#memcached -d -m 1024 -u root -l 127.0.0.1 -p 11211

fi

###
### install phpMyAdmin
###

if [ "$PHPMYADMIN_INSTALL" = "Y" ]; then

echo Installing phpMyAdmin:
[ -d $INSTALL_DIR/www/applications/phpmyadmin ] && rm -rf $INSTALL_DIR/www/applications/phpmyadmin
mkdir -p $INSTALL_DIR/www/applications
tar -zxf phpmyadmin.tar.gz -C $INSTALL_DIR/www/applications
mv $INSTALL_DIR/www/applications/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages $INSTALL_DIR/www/applications/phpmyadmin
cat >> $INSTALL_DIR/www/applications/phpmyadmin/config.inc.php << "EOF"
<?php
$cfg['blowfish_secret'] = 'ba17c1ec07d65003';
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['extension'] = 'mysql';
$cfg['Servers'][$i]['AllowNoPassword'] = false;
?>
EOF
#[ -d $INSTALL_DIR/www/sites/test.przystanek.co.uk/public/phpmyadmin ] && rm -rf $INSTALL_DIR/www/sites/test.przystanek.co.uk/public/phpmyadmin
#ln -s $INSTALL_DIR/www/applications/phpmyadmin $INSTALL_DIR/www/sites/test.przystanek.co.uk/public/phpmyadmin
[ -d $INSTALL_DIR/www/apache8081/htdocs/phpmyadmin ] && rm -rf $$INSTALL_DIR/www/apache8081/htdocs/phpmyadmin
ln -s $INSTALL_DIR/www/applications/phpmyadmin $INSTALL_DIR/www/apache8081/htdocs/phpmyadmin

fi

###
### install vsftpd
###

if [ "$VSFTPD_INSTALL" = "Y" ]; then

echo Installing vsftpd:
[ -d $INSTALL_DIR/vsftpd ] && rm -rf $INSTALL_DIR/vsftpd
tar -zxf vsftpd.tar.gz
cd vsftpd-$VSFTPD_VERSION
replace_in_file '#undef VSF_BUILD_SSL' '#define VSF_BUILD_SSL' builddefs.h
make && \
	mkdir -p $INSTALL_DIR/vsftpd/bin && \
	cp vsftpd $INSTALL_DIR/vsftpd/bin/vsftpd && \
	cp EXAMPLE/INTERNET_SITE_NOINETD/vsftpd.conf $INSTALL_DIR/vsftpd/vsftpd.conf && \
	echo vsftpd installed successfully!
mkdir /usr/share/empty
mkdir /var/ftp
useradd -d /var/ftp ftp
chown root.root /var/ftp
chmod og-w /var/ftp
# see http://vsftpd.beasts.org/vsftpd_conf.html and http://howto.gumph.org/content/setup-virtual-users-and-directories-in-vsftpd/
#replace_in_file "# Security" "# Security\nssl_enable=YES\nrsa_cert_file=$INSTALL_DIR_ESC\/vsftpd\/cert\/vsftpd.pem" $INSTALL_DIR/vsftpd/vsftpd.conf
#$INSTALL_DIR/vsftpd/bin/vsftpd $INSTALL_DIR/vsftpd/vsftpd.conf &
#ps -A | grep vsftpd
#pkill vsftpd
cd ..

fi

###
### install OpenJDK
###

if [ "$OPENJDK_INSTALL" = "Y" ]; then

echo Installing OpenJDK:
[ -d $INSTALL_DIR/jdk ] && rm -rf $INSTALL_DIR/jdk
tar -zxf openjdk.tar.gz
mv jdk1.7.0  $INSTALL_DIR/jdk
rm -rf $INSTALL_DIR/jdk/{db/demo,demo,man,sample,src.zip}

fi

###
### install Tomcat
###

if [ "$TOMCAT_INSTALL" = "Y" ]; then

echo Installing Tomcat:
[ -d $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME ] && rm -rf $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME
tar -zxf tomcat.tar.gz
mkdir -p $INSTALL_DIR/www && mv apache-tomcat-$TOMCAT_VERSION $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME
replace_in_file 'port="8005"' 'port="-1"' $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME/conf/server.xml
rm -rf $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME/webapps/{docs,examples}
cd $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME/bin
tar -zxf commons-daemon-native.tar.gz
cd commons-daemon-$TOMCAT_COMMONS_DAEMON_VERSION-native-src/unix
./configure \
	--with-java=$INSTALL_DIR/jdk \
&& make && cp jsvc ../.. && echo JSVC installed successfully!
rm -rf commons-daemon-$TOMCAT_COMMONS_DAEMON_VERSION-native-src
cd $WORKING_DIR
groupadd $TOMCAT_GROUP
useradd -d $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME/webapps -g $TOMCAT_GROUP $TOMCAT_USER
chown -R $TOMCAT_USER:$TOMCAT_GROUP $INSTALL_DIR/www/$TOMCAT_INSTANCE_NAME

fi

###
### create web site
###

if [ -n "$SITE_DOMAIN" ] && [ -n "$SITE_DOMAIN_PROXY_NAME" ] && [ -n "$SITE_DOMAIN_INSTANCE_NAME" ] && [ -n "$SITE_DOMAIN_INSTANCE_PORT" ]; then

	if [ ! -d "$INSTALL_DIR/www/sites/$SITE_DOMAIN" ]; then
		create_web_site $SITE_DOMAIN $SITE_DOMAIN_PROXY_NAME $SITE_DOMAIN_INSTANCE_NAME $SITE_DOMAIN_INSTANCE_PORT
	fi

fi

###
### create web application
###

if [ -n "$APP_DOMAIN" ] && [ -n "$APP_DOMAIN_PROXY_NAME" ] && [ -n "$APP_DOMAIN_INSTANCE_NAME" ] && [ -n "$APP_DOMAIN_INSTANCE_PORT" ]; then

	if [ ! -d "$INSTALL_DIR/www/sites/$APP_DOMAIN" ]; then
		create_web_app $APP_DOMAIN $APP_DOMAIN_PROXY_NAME $APP_DOMAIN_INSTANCE_NAME $APP_DOMAIN_INSTANCE_PORT
	fi

fi

###
### create SSL entry
###

if [ -n "$SSL_ENTRY_DOMAIN" ] && [ -n "$SSL_ENTRY_PROXY_NAME" ] && [ -n "$SSL_ENTRY_INSTANCE_PROTOCOL" ] && [ -n "$SSL_ENTRY_INSTANCE_PORT" ]; then

	create_ssl_entry $SSL_ENTRY_DOMAIN $SSL_ENTRY_PROXY_NAME $SSL_ENTRY_INSTANCE_PROTOCOL $SSL_ENTRY_INSTANCE_PORT

fi

###
### remove source archive files
###

if [ "$REMOVE_SOURCE_FILES" = "Y" ]; then

	[ -f zlib.tar.gz ] && rm zlib.tar.gz
	[ -f openssl.tar.gz ] && rm openssl.tar.gz
	[ -f apr.tar.gz ] && rm apr.tar.gz
	[ -f apr-util.tar.gz ] && rm apr-util.tar.gz
	[ -f mysql.tar.gz ] && rm mysql.tar.gz
	[ -f httpd.tar.gz ] && rm httpd.tar.gz
	[ -f php.tar.gz ] && rm php.tar.gz
	[ -f apc.tgz ] && rm apc.tgz
	[ -f libevent.tar.gz ] && rm libevent.tar.gz
	[ -f memcached.tar.gz ] && rm memcached.tar.gz
	[ -f vsftpd.tar.gz ] && rm vsftpd.tar.gz
	[ -f tomcat.tar.gz ] && rm tomcat.tar.gz

fi

###
### remove source directories
###

if [ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ]; then

	[ -d zlib-$ZLIB_VERSION ] && rm -rf zlib-$ZLIB_VERSION
	[ -d openssl-$OPENSSL_VERSION ] && rm -rf openssl-$OPENSSL_VERSION
	[ -d apr-$APR_VERSION ] && rm -rf apr-$APR_VERSION
	[ -d apr-util-$APR_UTIL_VERSION ] && rm -rf apr-util-$APR_UTIL_VERSION
	[ -d mysql-$MYSQL_VERSION ] && rm -rf mysql-$MYSQL_VERSION
	[ -d httpd-$APACHE_VERSION ] && rm -rf httpd-$APACHE_VERSION
	[ -d php-$PHP_VERSION ] && rm -rf php-$PHP_VERSION
	[ -d APC-$APC_VERSION ] && rm -rf APC-$APC_VERSION
	[ -d libevent-$LIBEVENT_VERSION ] && rm -rf libevent-$LIBEVENT_VERSION
	[ -d memcached-$MEMCACHED_VERSION ] && rm -rf memcached-$MEMCACHED_VERSION
	[ -d vsftpd-$VSFTPD_VERSION ] && rm -rf vsftpd-$VSFTPD_VERSION

fi

cd $CURRENT_DIR

echo Script ended on $(date)
