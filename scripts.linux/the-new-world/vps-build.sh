#!/bin/bash
#
# File: vps-build.sh
#
# Description: This script builds selected services from source and configures the server.
#
# Usage:
#
#	./vps-build.sh --initialize --zlib --openssl --apr --libiconv --imagemagick --download 2>&1 | tee vps-build.base.out
#	./vps-build.sh --mysql mysql mysql mysql 3306 --download 2>&1 | tee vps-build.mysql.out
#	./vps-build.sh --apache apache apache apache 80 443 --geoip --php mysql --imagick --apc --download 2>&1 | tee vps-build.webserver.out
#	./vps-build.sh --vsftpd --download 2>&1 | tee vps-build.vsftpd.out
#	./vps-build.sh --postfix --dovecot --download 2>&1 | tee vps-build.mail.out
#	./vps-build.sh --phpmyadmin mysql apache --download 2>&1 | tee vps-build.site-phpmyadmin.out
#	./vps-build.sh --openjdk --ant --tomcat tomcat tomcat tomcat 8080 8443 --download 2>&1 | tee vps-build.java.out
#	./vps-build.sh --site site1 mysql apache 80 443 2>&1 | tee vps-build.site-site1.out
#	./vps-build.sh --certificate "name" 2>&1 | tee vps-build.certificate-ip.out
#	./vps-build.sh --finalize "xxx.xxx.xxx.xxx" 2>&1 | tee vps-build.finalize.out && source ~/.profile
#
# TODO: script: improve script
#					- move common code to a separate file
#					- use Perl to improve common code
#					- move source code compilation of each service to a separate file
#					- check downloaded files
#					- check source compilation
# TODO: startup: start all services
# TODO: startup: load firewall rules
# TODO: apache: crate favicon /usr/local/apache/htdocs/favicon.ico
# TODO: clean /etc/init.d folder
# TODO: rsyslog: use syslog for all logging
# TODO: rsyslog: rotate logs
# TODO: ryslog: send logs to the remote server
# TODO: xinetd: have a look at this
# TODO: openssh: compile from source
# TODO: openssh: public/private key auth

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
LIBICONV_INSTALL=N
IMAGEMAGICK_INSTALL=N
MYSQL_INSTALL=N
MYSQL_INSTANCE_NAME=
MYSQL_USER=
MYSQL_GROUP=
MYSQL_PORT=
APACHE_INSTALL=N
APACHE_INSTANCE_NAME=
APACHE_USER=
APACHE_GROUP=
APACHE_PORT=
APACHE_PORT_SSL=
GEOIP_INSTALL=N
PHP_INSTALL=N
PHP_MYSQL_INSTANCE=
IMAGICK_INSTALL=N
APC_INSTALL=N
VSFTPD_INSTALL=N
POSTFIX_INSTALL=N
DOVECOT_INSTALL=N
PHPMYADMIN_INSTALL=N
PHPMYADMIN_DATABASE=
PHPMYADMIN_SERVER=
OPENJDK_INSTALL=N
ANT_INSTALL=N
TOMCAT_INSTALL=N
TOMCAT_INSTANCE_NAME=
TOMCAT_USER=
TOMCAT_GROUP=
TOMCAT_PORT=
TOMCAT_PORT_SSL=

SITE=
SITE_DATABASE=
SITE_SERVER_NAME=
SITE_SERVER_PORT=
SITE_SERVER_PORT_SSL=

SSL_CERTIFICATE_NAME=

ZLIB_VERSION=1.2.5
OPENSSL_VERSION=1.0.0d
APR_VERSION=1.4.5
APR_UTIL_VERSION=1.3.12
APR_ICONV_VERSION=1.2.1
LIBICONV_VERSION=1.13.1
IMAGEMAGICK_VERSION=6.6.9-10
MYSQL_VERSION=5.1.57
APACHE_VERSION=2.2.19
GEOIP_VERSION=1.4.7
MOD_GEOIP_VERSION=1.2.5
PHP_VERSION=5.3.6
IMAGICK_VERSION=3.1.0b1
APC_VERSION=3.1.9
VSFTPD_VERSION=2.3.4
POSTFIX_VERSION=2.8.3
DOVECOT_VERSION=2.0.13
MAILX_VERSION=12.4
PHPMYADMIN_VERSION=3.4.1
OPENJDK_VERSION=b143
ANT_VERSION=1.8.2
TOMCAT_VERSION=7.0.14
TOMCAT_COMMONS_DAEMON_VERSION=1.0.5

REMOVE_SOURCE_FILES=N
REMOVE_SOURCE_DIRECTORIES=Y

FINALIZE=N
FINALIZE_IP_ADDRESS=

chmod 500 $INSTALL_DIR/*.sh
chmod 400 $INSTALL_DIR/*.out

###
### process arguments
###

while [ "$1" != "" ]; do

	case $1 in
		--initialize)		INITIALIZE=Y
							;;
		--download)			DOWNLOAD=Y
							;;
		--zlib)				ZLIB_INSTALL=Y
							;;
		--openssl)			OPENSSL_INSTALL=Y
							;;
		--apr)				APR_INSTALL=Y
							;;
		--libiconv)			LIBICONV_INSTALL=Y
							;;
		--imagemagick)		IMAGEMAGICK_INSTALL=Y
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
		--geoip)			GEOIP_INSTALL=Y
							;;
		--php)				PHP_INSTALL=Y
							shift
							PHP_MYSQL_INSTANCE=$1
							;;
		--imagick)			IMAGICK_INSTALL=Y
							;;
		--apc)				APC_INSTALL=Y
							;;
		--vsftpd)			VSFTPD_INSTALL=Y
							;;
		--postfix)			POSTFIX_INSTALL=Y
							;;
		--dovecot)			DOVECOT_INSTALL=Y
							;;
		--phpmyadmin)		PHPMYADMIN_INSTALL=Y
							shift
							PHPMYADMIN_DATABASE=$1
							shift
							PHPMYADMIN_SERVER=$1
							;;
		--openjdk)			OPENJDK_INSTALL=Y
							;;
		--ant)				ANT_INSTALL=Y
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
							SITE=$1
							shift
							SITE_DATABASE=$1
							shift
							SITE_SERVER_NAME=$1
							shift
							SITE_SERVER_PORT=$1
							shift
							SITE_SERVER_PORT_SSL=$1
							;;
		--certificate)		shift
							SSL_CERTIFICATE_NAME=$1
							;;
		--finalize)			FINALIZE=Y
							shift
							FINALIZE_IP_ADDRESS=$1
							;;
	esac
	shift

done

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
	sleep 1
	$INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/apachectl -k start
	sleep 3
	echo -e "\n\n *** Apache Benchmark ***\n"
	$INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/ab -n 10000 -c 10 -k -r $1
	echo -e "\n\n"
	sleep 5
	$INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/apachectl -k stop
	sleep 3
	rm $INSTALL_DIR/$APACHE_INSTANCE_NAME/log/access_log
	rm $INSTALL_DIR/$APACHE_INSTANCE_NAME/log/error_log

}

# parameters:
#	$1 domain
#	$2 database
#	$3 instance_name
#	$4 instance_port
#	$5 instance_port_ssl
function create_web_site {

	# make sure the directory does not exist
	[ -d $INSTALL_DIR/sites/$1 ] && rm -rf $INSTALL_DIR/sites/$1

	# create directory structure
	mkdir -p $INSTALL_DIR/sites/$1/{log,public}
	[ -d $INSTALL_DIR/$3/htdocs/$1 ] && rm -rf $INSTALL_DIR/$3/htdocs/$1
	ln -s $INSTALL_DIR/sites/$1/public $INSTALL_DIR/$3/htdocs/$1
	(	echo -e "RewriteEngine On" && \
		echo -e "RewriteCond %{REQUEST_FILENAME} -s [OR]" && \
		echo -e "RewriteCond %{REQUEST_FILENAME} -l [OR]" && \
		echo -e "RewriteCond %{REQUEST_FILENAME} -d" && \
		echo -e "RewriteRule ^.*$ - [NC,L]" && \
		echo -e "RewriteRule ^.*$ index.php [NC,L]" \
	) > $INSTALL_DIR/sites/$1/public/.htaccess
	echo -e "The <i><b>$1</b></i> is under construction..." > $INSTALL_DIR/sites/$1/public/index.php

	###
	### update Apache HTTPD instance
	###

	# webserver: add vhost configuration to httpd-vhosts.conf
	remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/$3/conf/extra/httpd-vhosts.conf
	(	echo -e "# BEGIN: vhost $1" && \
		echo -e "<VirtualHost *:$4>" && \
		echo -e "\tServerName $1" && \
		echo -e "\tServerAlias www.$1" && \
		echo -e "\tDocumentRoot \"$INSTALL_DIR/sites/$1/public\"" && \
		echo -e "\t<Directory \"$INSTALL_DIR/sites/$1/public\">" && \
		echo -e "\t\tOptions Indexes FollowSymLinks" && \
		echo -e "\t\tAllowOverride All" && \
		echo -e "\t\tOrder allow,deny" && \
		echo -e "\t\tAllow from all" && \
		echo -e "\t</Directory>" && \
		echo -e "\tLogLevel info" && \
		echo -e "\tCustomLog \"$INSTALL_DIR/sites/$1/log/access_log\" custom_log_format" && \
		echo -e "\tErrorLog \"$INSTALL_DIR/sites/$1/log/error_log\"" && \
		echo -e "</VirtualHost>" && \
		echo -e "# END: vhost $1" \
	) >> $INSTALL_DIR/$3/conf/extra/httpd-vhosts.conf

	###
	### update Apache HTTPD proxy
	###

	if [ ! "noproxy" = "noproxy" ]; then
		# proxy: add vhost configuration to httpd-vhosts.conf
		remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/$3/conf/extra/httpd-vhosts.conf
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
		) >> $INSTALL_DIR/$3/conf/extra/httpd-vhosts.conf
	fi

	remove_from_file "\n127.0.0.1 $1" /etc/hosts
	echo "127.0.0.1 $1" >> /etc/hosts

	# add website user
	SYSTEM_USER_PASSWORD=`get_random_str 32`
	userdel -r $1
	groupadd $1
	useradd -d $INSTALL_DIR/sites/$1 -s /bin/bash -p `mkpasswd $SYSTEM_USER_PASSWORD` -g $1 $1
	chown -R $1:$1 $INSTALL_DIR/sites/$1
	chown -R root:root $INSTALL_DIR/sites/$1/log

	# set up ftp access
	remove_from_file "$1" $INSTALL_DIR/vsftpd/conf/vsftpd.user_list
	echo -e "$1" >> $INSTALL_DIR/vsftpd/conf/vsftpd.user_list

	# set up database
	DATABASE_NAME=`echo "$1" | sed 's/\./_/g'`
	DATABASE_USER_NAME=`echo "$1" | sed 's/\./_/g'`
	DATABASE_USER_PASSWORD=`get_random_str 32`
	$INSTALL_DIR/$2/bin/mysqld_safe --user=$2 &
	sleep 5
	cat <<EOF | $INSTALL_DIR/$2/bin/mysql -u root
DELETE FROM mysql.user WHERE User = '$DATABASE_USER_NAME';
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS $DATABASE_NAME;
CREATE DATABASE \`$DATABASE_NAME\` CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_USER_NAME'@'localhost' IDENTIFIED BY '$DATABASE_USER_PASSWORD';
EOF
	sleep 1
	$INSTALL_DIR/$2/bin/mysqladmin -u root shutdown
	sleep 3

	# save access details
	(	echo -e "system.username=$1" && \
		echo -e "system.password=$SYSTEM_USER_PASSWORD" && \
		echo -e "database.name=$DATABASE_NAME" && \
		echo -e "database.username=$DATABASE_USER_NAME" && \
		echo -e "database.password=$DATABASE_USER_PASSWORD" \
	) > $INSTALL_DIR/sites/$1/.access.details
	chown -R root:root $INSTALL_DIR/sites/$1/.access.details
	chmod 400 $INSTALL_DIR/sites/$1/.access.details

}

# parameters: domain protocol port
function create_ssl_entry {

	generate_certificate $1

	if [ -n "$2" ] && [ -n "$3" ]; then
		# add vhost configuration to httpd-ssl.conf
		remove_from_file "\n# BEGIN: vhost $1.*END: vhost $1" $INSTALL_DIR/apache/conf/extra/httpd-ssl.conf
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
			echo -e "\tProxyPass / $2://$1:$3/" && \
			echo -e "\tProxyPassReverse / $2://$1:$3/" && \
			echo -e "\t<Location />" && \
			echo -e "\t\tOrder allow,deny" && \
			echo -e "\t\tAllow from all" && \
			echo -e "\t</Location>" && \
			echo -e "</VirtualHost>" && \
			echo -e "# END: vhost $1" \
		) >> $INSTALL_DIR/apache/conf/extra/httpd-ssl.conf
	fi

}

# parameters: name
function generate_certificate {

	$INSTALL_DIR/openssl/bin/openssl req \
		-new -x509 -nodes -sha1 -newkey rsa:2048 -days 1095 -subj "/O=unknown/OU=unknown/CN=$1" \
		-keyout $INSTALL_DIR/openssl/certs/$1.key \
		-out $INSTALL_DIR/openssl/certs/$1.crt
	cat $INSTALL_DIR/openssl/certs/$1.crt $INSTALL_DIR/openssl/certs/$1.key > $INSTALL_DIR/openssl/certs/$1.pem
	chmod 400 $INSTALL_DIR/openssl/certs/$1.{crt,key,pem}
}

# parameters: length
function get_random_str {

	STR=</dev/urandom tr -dc A-Za-z0-9 | (head -c $ > /dev/null 2>&1 || head -c $1)
	echo $STR

}

# parameters: directory
function strip_debug_symbols {

	ls -la $1/*
	du -ch $1/* | grep total
	strip --strip-debug $1/*
	du -ch $1/* | grep total
	ls -la $1/*

}

# parameters: file
function strip_debug_symbols_file {

	ls -la $1
	strip --strip-debug $1
	ls -la $1

}

# parameters: directory
function fix_libraries {

	ln -sfv $1/*.so* /lib/
	ln -sfv $1/*.so* /usr/lib/
	ln -sfv $1/*.a /usr/lib/

}

###
### initialize
###

if [ "$INITIALIZE" = "Y" ]; then

	uname -a

	echo "Disk usage: " `du -hcs / | grep total`

	dpkg-reconfigure -f noninteractive tzdata
	echo "Europe/London" > /etc/timezone
	dpkg-reconfigure -f noninteractive tzdata
	update-locale

	# load firewall rules
	./vps-load-firewall-rules.sh

	# change sshd port
	replace_in_file 'Port 22' 'Port 2200' /etc/ssh/sshd_config
	service ssh restart

	# remove sendmail and apache
	pkill sendmail
	pkill apache
	# remove forever
	dpkg --get-selections | awk '{ print $1 }' | egrep -i "sysklogd|sendmail|apache" | xargs apt-get --purge -y remove
	# remove temporary
	dpkg --get-selections | awk '{ print $1 }' | egrep -i "portmap" | xargs apt-get --purge -y remove
	apt-get clean

	# exclude packages, to remove exclusion use 'echo package install | dpkg --set-selections'
	echo bind9 hold | dpkg --set-selections
	echo openssh-client hold | dpkg --set-selections
	echo openssh-server hold | dpkg --set-selections
	echo openssl hold | dpkg --set-selections
	echo samba hold | dpkg --set-selections
	echo samba-common-bin hold | dpkg --set-selections

	# apt-get update and install
	apt-get update && apt-get -y --force-yes upgrade && apt-get -y --force-yes install wget build-essential autoconf cmake \
		libncurses5-dev libssl-dev libxml2-dev libexpat1-dev libjpeg62-dev libpng12-dev libmcrypt-dev libdb-dev \
		mkpasswd rsyslog iptables dnsutils git-core perl

	# configure rsyslog
	service rsyslog stop
	find /var/log/* -maxdepth 0 -name 'apt' -prune -o -exec rm -rf '{}' ';'
	cat <<EOF > /etc/rsyslog.d/50-default.conf
# /etc/rsyslog.d/50-default.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
mail.err -/var/log/mail.err
local3.* -/var/log/mysql.log
local3.err -/var/log/mysql.err
user.* -/var/log/user.log
*.emerg *
EOF
	replace_in_file '$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat' '#$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat' /etc/rsyslog.conf
	replace_in_file '$FileCreateMode 0640' '$FileCreateMode 0600' /etc/rsyslog.conf
	service rsyslog start

	# clean up work directory
	rm -rfv /usr/local/{bin,etc,games,include,lib,man,sbin,share,src}

	# fix libraries
	[ ! -h /usr/lib/libexpat.so.0 ] && ln -s /usr/lib/libexpat.so /usr/lib/libexpat.so.0
	[ ! -h /usr/lib/libjpeg.so ] && ln -s /usr/lib/libjpeg.so.62 /usr/lib/libjpeg.so

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
	if [ "$APR_INSTALL" = "Y" ] && [ ! -f apr-iconv.tar.gz ]; then
		wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//apr/apr-iconv-$APR_ICONV_VERSION.tar.gz -O apr-iconv.tar.gz
	fi
	if [ "$LIBICONV_INSTALL" = "Y" ] && [ ! -f libiconv.tar.gz ]; then
		wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz -O libiconv.tar.gz
	fi
	if [ "$IMAGEMAGICK_INSTALL" = "Y" ] && [ ! -f imagemagick.tar.gz ]; then
		wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$IMAGEMAGICK_VERSION.tar.gz -O imagemagick.tar.gz
	fi
	if [ "$MYSQL_INSTALL" = "Y" ] && [ ! -f mysql.tar.gz ]; then
		wget http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-$MYSQL_VERSION.tar.gz/from/http://sunsite.informatik.rwth-aachen.de/mysql/ -O mysql.tar.gz
	fi
	if [ "$APACHE_INSTALL" = "Y" ] && [ ! -f httpd.tar.gz ]; then
		wget http://apache.favoritelinks.net/httpd/httpd-$APACHE_VERSION.tar.gz -O httpd.tar.gz
	fi
	if [ "$GEOIP_INSTALL" = "Y" ] && [ ! -f geoip.tar.gz ]; then
		wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP-$GEOIP_VERSION.tar.gz -O geoip.tar.gz
	fi
	if [ "$GEOIP_INSTALL" = "Y" ] && [ ! -f GeoIPLiteCity.dat.gz ]; then
		wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O GeoIPLiteCity.dat.gz
	fi
	if [ "$GEOIP_INSTALL" = "Y" ] && [ ! -f mod_geoip.tar.gz ]; then
		wget http://geolite.maxmind.com/download/geoip/api/mod_geoip2/mod_geoip2_$MOD_GEOIP_VERSION.tar.gz -O mod_geoip.tar.gz
	fi
	if [ "$PHP_INSTALL" = "Y" ] && [ ! -f php.tar.gz ]; then
		wget http://de.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror -O php.tar.gz
	fi
	if [ "$IMAGICK_INSTALL" = "Y" ] && [ ! -f imagick.tgz ]; then
		wget http://pecl.php.net/get/imagick-$IMAGICK_VERSION.tgz -O imagick.tgz
	fi
	if [ "$APC_INSTALL" = "Y" ] && [ ! -f apc.tgz ]; then
		wget http://pecl.php.net/get/APC-$APC_VERSION.tgz -O apc.tgz
	fi
	if [ "$VSFTPD_INSTALL" = "Y" ] && [ ! -f vsftpd.tar.gz ]; then
		wget ftp://vsftpd.beasts.org/users/cevans/vsftpd-$VSFTPD_VERSION.tar.gz -O vsftpd.tar.gz
	fi
	if [ "$POSTFIX_INSTALL" = "Y" ] && [ ! -f postfix.tar.gz ]; then
		wget http://mirror.tje.me.uk/pub/mirrors/postfix-release/official/postfix-$POSTFIX_VERSION.tar.gz -O postfix.tar.gz
	fi
	if [ "$POSTFIX_INSTALL" = "Y" ] && [ ! -f mailx.tar.bz2 ]; then
		wget http://downloads.sourceforge.net/project/heirloom/heirloom-mailx/$MAILX_VERSION/mailx-$MAILX_VERSION.tar.bz2 -O mailx.tar.bz2
	fi
	if [ "$POSTFIX_INSTALL" = "Y" ] && [ ! -f mailx-openssl_1.0.0_build_fix-1.patch ]; then
		wget http://www.linuxfromscratch.org/patches/blfs/svn/mailx-12.4-openssl_1.0.0_build_fix-1.patch -O mailx-openssl_1.0.0_build_fix-1.patch
	fi
	if [ "$DOVECOT_INSTALL" = "Y" ] && [ ! -f dovecot.tar.gz ]; then
		wget http://www.dovecot.org/releases/2.0/dovecot-$DOVECOT_VERSION.tar.gz -O dovecot.tar.gz
	fi
	if [ "$PHPMYADMIN_INSTALL" = "Y" ] && [ ! -f phpmyadmin.tar.gz ]; then
		wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz -O phpmyadmin.tar.gz
	fi
	if [ "$OPENJDK_INSTALL" = "Y" ] && [ ! -f openjdk.tar.gz ]; then
		wget http://www.java.net/download/jdk7/archive/$OPENJDK_VERSION/binaries/jdk-7-ea-bin-$OPENJDK_VERSION-linux-i586-20_may_2011.tar.gz -O openjdk.tar.gz
	fi
	if [ "$ANT_INSTALL" = "Y" ] && [ ! -f ant.tar.gz ]; then
		wget http://mirror.lividpenguin.com/pub/apache//ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz -O ant.tar.gz
	fi
	if [ "$TOMCAT_INSTALL" = "Y" ] && [ ! -f tomcat.tar.gz ]; then
		wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//tomcat/tomcat-7/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -O tomcat.tar.gz
	fi

fi

###
### install zlib
###

if [ "$ZLIB_INSTALL" = "Y" ]; then

echo Installing zlib:
[ -d $INSTALL_DIR/zlib ] && rm -rf $INSTALL_DIR/zlib
tar -zxf zlib.tar.gz
cd zlib-$ZLIB_VERSION
replace_in_file 'ifdef _LARGEFILE64_SOURCE' 'ifndef _LARGEFILE64_SOURCE' zlib.h
./configure \
	--prefix=$INSTALL_DIR/zlib \
&& make && make install && echo "zlib installed successfully!"
rm -rf $INSTALL_DIR/zlib/share
cd ..
echo "Fix libraries:"
fix_libraries $INSTALL_DIR/zlib/lib
echo "Shared library dependencies for $INSTALL_DIR/zlib/lib/libz.so:"
ldd $INSTALL_DIR/zlib/lib/libz.so
echo "Copy includes:"
rm /usr/include/{zconf.h,zlib.h}
cp -v $INSTALL_DIR/zlib/include/*.h /usr/include/

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
	shared zlib-dynamic enable-camellia \
&& make depend && make && make install && echo "OpenSSL installed successfully!"
rm -rf $INSTALL_DIR/openssl/man
cd ..
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/openssl/bin
strip_debug_symbols $INSTALL_DIR/openssl/lib
echo "Fix libraries:"
fix_libraries $INSTALL_DIR/openssl/lib
echo "Shared library dependencies for $INSTALL_DIR/openssl/bin/openssl:"
ldd $INSTALL_DIR/openssl/bin/openssl
echo "Copy includes:"
rm -rf /usr/include/openssl
cp -rfv $INSTALL_DIR/openssl/include/openssl /usr/include/

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
	--prefix=$INSTALL_DIR/apr \
&& make && make install && echo "APR installed successfully!"
cd ..
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apr-1-config:"
ldd $INSTALL_DIR/apr/bin/apr-1-config

echo Installing APR Util:
tar -zxf apr-util.tar.gz
cd apr-util-$APR_UTIL_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr \
	--with-apr=$INSTALL_DIR/apr \
&& make && make install && echo "APR Util installed successfully!"
cd ..
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apu-1-config:"
ldd $INSTALL_DIR/apr/bin/apu-1-config

echo Installing APR Iconv:
tar -zxf apr-iconv.tar.gz
cd apr-iconv-$APR_ICONV_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr \
	--with-apr=$INSTALL_DIR/apr \
&& make && make install && echo "APR Iconv installed successfully!"
cd ..
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apriconv:"
ldd $INSTALL_DIR/apr/bin/apriconv

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/apr/bin
strip_debug_symbols $INSTALL_DIR/apr/lib
strip_debug_symbols $INSTALL_DIR/apr/lib/iconv
echo "Fix libraries:"
fix_libraries $INSTALL_DIR/apr/lib

fi

###
### install libiconv
###

if [ "$LIBICONV_INSTALL" = "Y" ]; then

echo Installing libiconv:
[ -d $INSTALL_DIR/libiconv ] && rm -rf $INSTALL_DIR/libiconv
tar -zxf libiconv.tar.gz
cd libiconv-$LIBICONV_VERSION
./configure \
	--prefix=$INSTALL_DIR/libiconv \
&& make && make install && echo "libiconv installed successfully!"
rm -rf $INSTALL_DIR/libiconv/share/{doc,man}
cd ..
echo "Shared library dependencies for $INSTALL_DIR/libiconv/bin/iconv:"
ldd $INSTALL_DIR/libiconv/bin/iconv
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/libiconv/bin
strip_debug_symbols $INSTALL_DIR/libiconv/lib
echo "Fix libraries:"
fix_libraries $INSTALL_DIR/libiconv/lib
cp -v $INSTALL_DIR/libiconv/include/*.h /usr/include/

fi

###
### install ImageMagick
###

if [ "$IMAGEMAGICK_INSTALL" = "Y" ]; then

echo Installing ImageMagick:
[ -d $INSTALL_DIR/imagemagick ] && rm -rf $INSTALL_DIR/imagemagick
tar -zxf imagemagick.tar.gz
cd ImageMagick-$IMAGEMAGICK_VERSION
./configure \
	--prefix=$INSTALL_DIR/imagemagick \
&& make && make install && echo "ImageMagick installed successfully!"
rm -rf $INSTALL_DIR/imagemagick/share/{doc,man}
cd ..
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/imagemagick/bin
strip_debug_symbols $INSTALL_DIR/imagemagick/lib
echo "Fix libraries:"
fix_libraries $INSTALL_DIR/imagemagick/lib
cp -rfv $INSTALL_DIR/imagemagick/include/ImageMagick /usr/include/

fi

###
### install MySQL
###

if [ "$MYSQL_INSTALL" = "Y" ]; then

echo Installing MySQL:
pkill mysql
[ -d $INSTALL_DIR/$MYSQL_INSTANCE_NAME ] && rm -rf $INSTALL_DIR/$MYSQL_INSTANCE_NAME
tar -zxf mysql.tar.gz
cd mysql-$MYSQL_VERSION
CFLAGS="-O3" CXX=gcc CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti" ./configure \
	--prefix=$INSTALL_DIR/$MYSQL_INSTANCE_NAME \
	--libexecdir=$INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin \
	--localstatedir=$INSTALL_DIR/$MYSQL_INSTANCE_NAME/data \
	--sysconfdir=$INSTALL_DIR/$MYSQL_INSTANCE_NAME/conf \
	--with-mysqld-user=$MYSQL_USER \
	--enable-assembler \
	--enable-thread-safe-client \
	--with-charset=utf8 \
	--with-collation=utf8_general_ci \
	--with-ssl=$INSTALL_DIR/openssl \
	--with-zlib-dir=$INSTALL_DIR/zlib \
&& make && make install && echo "MySQL installed successfully!"
rm -rf $INSTALL_DIR/$MYSQL_INSTANCE_NAME/{docs,mysql-test,share/man,sql-bench}
mkdir $INSTALL_DIR/$MYSQL_INSTANCE_NAME/{conf,log}
cd ..
# create link to the log file
ln -sfv /var/log/mysql.log $INSTALL_DIR/$MYSQL_INSTANCE_NAME/log/mysql.log
ln -sfv /var/log/mysql.err $INSTALL_DIR/$MYSQL_INSTANCE_NAME/log/mysql.err
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin
strip_debug_symbols $INSTALL_DIR/$MYSQL_INSTANCE_NAME/lib/mysql
echo "Fix libraries:"
fix_libraries $INSTALL_DIR/$MYSQL_INSTANCE_NAME/lib/mysql
echo "Shared library dependencies for $INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysqld:"
ldd $INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysqld
echo "Shared library dependencies for $INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysql:"
ldd $INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysql
# my.cnf
cp $INSTALL_DIR/mysql-$MYSQL_VERSION/support-files/my-small.cnf $INSTALL_DIR/$MYSQL_INSTANCE_NAME/conf/my.cnf
replace_in_file '= 3306' "= $MYSQL_PORT" $INSTALL_DIR/$MYSQL_INSTANCE_NAME/conf/my.cnf
(	echo -e "\n[mysqld]" && \
	echo -e "pid-file=$INSTALL_DIR/$MYSQL_INSTANCE_NAME/log/mysql.pid" && \
	echo -e "general_log=1" && \
	echo -e "slow_query_log=1" && \
	echo -e "slow_query_log_file=$INSTALL_DIR/$MYSQL_INSTANCE_NAME/log/mysql-slow.log" && \
	echo -e "long_query_time=3" && \
	echo -e "log-slow-admin-statements" && \
	echo -e "\n[mysqld_safe]" && \
	echo -e "syslog" && \
	echo -e "syslog-facility = local3" \
) >> $INSTALL_DIR/$MYSQL_INSTANCE_NAME/conf/my.cnf
groupadd -g 510 $MYSQL_GROUP
useradd -u 510 -d /dev/null -s /usr/sbin/nologin -g $MYSQL_GROUP $MYSQL_USER
chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/$MYSQL_INSTANCE_NAME
$INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysql_install_db --user=$MYSQL_USER
sleep 3 # the script may fail without this
$INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysqld_safe --user=$MYSQL_USER &
sleep 5 # the script may fail without this
$INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysqladmin -u root -f drop test
sleep 1 # the script may fail without this
echo 'use mysql; delete from db;' | $INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysql -u root
sleep 1 # the script may fail without this
$INSTALL_DIR/$MYSQL_INSTANCE_NAME/bin/mysqladmin -u root shutdown
sleep 3 # the script may fail without this
chown -R root:root $INSTALL_DIR/$MYSQL_INSTANCE_NAME
chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/$MYSQL_INSTANCE_NAME/{data,log}
chmod 700 $INSTALL_DIR/$MYSQL_INSTANCE_NAME/{data,log}

fi

###
### install Apache HTTPD Server
###

if [ "$APACHE_INSTALL" = "Y" ]; then

echo Installing Apache HTTPD Server:
pkill httpd
[ -d $INSTALL_DIR/$APACHE_INSTANCE_NAME ] && rm -rf $INSTALL_DIR/$APACHE_INSTANCE_NAME
tar -zxf httpd.tar.gz
cd httpd-$APACHE_VERSION
replace_in_file '#define AP_SERVER_BASEPRODUCT "Apache"' '#define AP_SERVER_BASEPRODUCT "Host4ge WWW Server"' ./include/ap_release.h
./configure \
	--prefix=$INSTALL_DIR/$APACHE_INSTANCE_NAME \
	--with-mpm=prefork \
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
	--with-apr-util=$INSTALL_DIR/apr \
	--with-ssl=$INSTALL_DIR/openssl \
	--with-z=$INSTALL_DIR/zlib \
&& make && make install && echo "Apache HTTPD Server (webserver) installed successfully!"
#--enable-proxy \
#
cd ..
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/$APACHE_INSTANCE_NAME/bin
echo "Shared library dependencies for $INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/httpd:"
ldd $INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/httpd
rm -rf $INSTALL_DIR/$APACHE_INSTANCE_NAME/{cgi-bin,conf/extra/*,logs,man,manual}
mkdir $INSTALL_DIR/$APACHE_INSTANCE_NAME/log
# httpd.conf
(	echo -e "ServerRoot \"$INSTALL_DIR/$APACHE_INSTANCE_NAME\"\n" && \
	echo -e "User $APACHE_USER" && \
	echo -e "Group $APACHE_GROUP\n" && \
	echo -e "ServerTokens Prod" && \
	echo -e "ServerSignature Off\n" && \
	echo -e "ServerAdmin \"daniel (dot) stefaniuk (at) gmail (dot) com\"\n" && \
	echo -e "DocumentRoot \"$INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs\"\n" && \
	echo -e "<Directory \"/\">" && \
	echo -e "\tOptions FollowSymLinks" && \
	echo -e "\tAllowOverride None" && \
	echo -e "\tOrder deny,allow" && \
	echo -e "\tDeny from all" && \
	echo -e "</Directory>" && \
	echo -e "<Directory \"$INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs\">" && \
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
	echo -e "LogLevel info" && \
	echo -e "LogFormat \"%{%Y/%m/%d %H:%M:%S}t %h \\\"%{GEOIP_COUNTRY_NAME}e\\\" \\\"%{GEOIP_CITY}e\\\" \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\" custom_log_format" && \
	echo -e "CustomLog \"log/access_log\" custom_log_format" && \
	echo -e "ErrorLog \"log/error_log\"\n" && \
	echo -e "DefaultType text/plain" && \
	echo -e "TypesConfig conf/mime.types\n" \
) > $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
#(	echo -e "ProxyRequests Off" && \
#	echo -e "ProxyPreserveHost Off\n" \
#) >> $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
(	echo -e "Include conf/extra/httpd-mpm.conf" && \
	echo -e "Include conf/extra/httpd-vhosts.conf" && \
	echo -e "Include conf/extra/httpd-ssl.conf\n" && \
	echo -e "# LoadModule foo_module modules/mod_foo.so" \
) >> $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
# httpd-mpm.conf
cat <<EOF > $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/extra/httpd-mpm.conf
PidFile "log/httpd.pid"
LockFile "log/httpd.lock"

# prefork MPM
# StartServers: number of server processes to start
# MinSpareServers: minimum number of server processes which are kept spare
# MaxSpareServers: maximum number of server processes which are kept spare
# MaxClients: maximum number of server processes allowed to start
# MaxRequestsPerChild: maximum number of requests a server process serves
<IfModule mpm_prefork_module>
    StartServers           3
    MinSpareServers        3
    MaxSpareServers        3
    MaxClients             3
    MaxRequestsPerChild 5000
</IfModule>

# worker MPM
# StartServers: initial number of server processes to start
# MaxClients: maximum number of simultaneous client connections
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxRequestsPerChild: maximum number of requests a server process serves
<IfModule mpm_worker_module>
    StartServers           2
    MaxClients           100
    MinSpareThreads       10
    MaxSpareThreads       30
    ThreadsPerChild       10
    MaxRequestsPerChild 5000
</IfModule>
EOF
# httpd-vhosts.conf
(	echo -e "Listen $APACHE_PORT" && \
	echo -e "NameVirtualHost *:$APACHE_PORT\n" && \
	echo -e "<VirtualHost _default_:$APACHE_PORT>" && \
	echo -e "\tDocumentRoot \"$INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs\"" && \
	echo -e "</VirtualHost>\n" \
) > $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/extra/httpd-vhosts.conf
# httpd-ssl.conf
(	echo -e "Listen $APACHE_PORT_SSL" && \
	echo -e "NameVirtualHost *:$APACHE_PORT_SSL\n" && \
	echo -e "SSLRandomSeed startup builtin" && \
	echo -e "SSLRandomSeed connect builtin" && \
	echo -e "AddType application/x-x509-ca-cert .crt" && \
	echo -e "AddType application/x-pkcs7-crl .crl" && \
	echo -e "SSLPassPhraseDialog builtin" && \
	echo -e "SSLSessionCache \"shmcb:$INSTALL_DIR/$APACHE_INSTANCE_NAME/log/ssl_scache(512000)\"" && \
	echo -e "SSLSessionCacheTimeout 300" && \
	echo -e "SSLMutex \"file:$INSTALL_DIR/$APACHE_INSTANCE_NAME/log/ssl_mutex\"\n" \
) > $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/extra/httpd-ssl.conf
groupadd -g 520 $APACHE_GROUP
useradd -u 520 -d $INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs -s /usr/sbin/nologin -g $APACHE_GROUP $APACHE_USER
chown -R $APACHE_USER:$APACHE_GROUP $INSTALL_DIR/$APACHE_INSTANCE_NAME
echo -e "\n\n *** Apache Modules ***\n"
$INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/apachectl -l
run_apache_performance_test http://localhost:$APACHE_PORT/index.html
sleep 1
pkill httpd
sleep 1
chown -R root:root $INSTALL_DIR/$APACHE_INSTANCE_NAME
chown -R $APACHE_USER:$APACHE_GROUP $INSTALL_DIR/$APACHE_INSTANCE_NAME/log
chmod 700 $INSTALL_DIR/$APACHE_INSTANCE_NAME/log

fi

###
### install GeoIP
###

if [ "$APACHE_INSTALL" = "Y" ] && [ "$GEOIP_INSTALL" = "Y" ]; then

echo Installing GeoIP:
[ -d $INSTALL_DIR/geoip ] && rm -rf $INSTALL_DIR/geoip
tar -zxf geoip.tar.gz
cd GeoIP-$GEOIP_VERSION
./configure \
	--prefix=$INSTALL_DIR/geoip \
&& make && make install && echo "GeoIP installed successfully!"
rm -rf $INSTALL_DIR/geoip/share/man
cd ..
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/geoip/bin
strip_debug_symbols $INSTALL_DIR/geoip/lib
echo "Shared library dependencies for $INSTALL_DIR/geoip/bin/geoiplookup:"
ldd $INSTALL_DIR/geoip/bin/geoiplookup
cp GeoIPLiteCity.dat.gz $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat.gz
gunzip -d $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat.gz
# mod_geoip
tar -zxf mod_geoip.tar.gz
cd mod_geoip2_$MOD_GEOIP_VERSION
$INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/apxs \
	-i -a -L$INSTALL_DIR/geoip/lib -I$INSTALL_DIR/geoip/include -lGeoIP -c mod_geoip.c \
&& echo "mod_geoip installed successfully!"
cd ..
echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/apache/modules/mod_geoip.so
echo "Shared library dependencies for $INSTALL_DIR/apache/modules/mod_geoip.so:"
ldd $INSTALL_DIR/apache/modules/mod_geoip.so
replace_in_file 'LoadModule geoip_module       modules\/mod_geoip.so' 'LoadModule geoip_module modules\/mod_geoip.so' $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
(	echo -e "\n<IfModule mod_geoip.c>" && \
	echo -e "\tGeoIPEnable On" && \
	echo -e "\tGeoIPEnableUTF8 On" && \
	echo -e "\tGeoIPDBFile $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat" && \
	echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE CN BlockCountry" && \
	echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE RU BlockCountry" && \
	echo -e "\t<Location \"/\">" && \
	echo -e "\t\tDeny from env=BlockCountry" && \
	echo -e "\t</Location>" && \
	echo -e "</IfModule>" \
) >> $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf

cat <<EOF > $INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs/geoip.php
Continent Code: <?php echo apache_note('GEOIP_CONTINENT_CODE'); ?><br />
Country Code: <?php echo apache_note('GEOIP_COUNTRY_CODE'); ?><br />
Country: <?php echo apache_note('GEOIP_COUNTRY_NAME'); ?><br />
Region: <?php echo apache_note('GEOIP_REGION_NAME'); ?><br />
City: <?php echo apache_note('GEOIP_CITY'); ?><br />
Latitude: <?php echo apache_note('GEOIP_LATITUDE'); ?><br />
Longitude: <?php echo apache_note('GEOIP_LONGITUDE'); ?><br />
EOF

fi

###
### install PHP
###

if [ "$APACHE_INSTALL" = "Y" ] && [ "$PHP_INSTALL" = "Y" ]; then

echo Installing PHP:
PHP_INSTALL_DIR=$INSTALL_DIR/$APACHE_INSTANCE_NAME/php
[ -d $PHP_INSTALL_DIR ] && rm -rf $PHP_INSTALL_DIR
tar -zxf php.tar.gz
cd php-$PHP_VERSION
./configure \
	--prefix=$PHP_INSTALL_DIR \
	--with-apxs2=$INSTALL_DIR/$APACHE_INSTANCE_NAME/bin/apxs \
	--with-config-file-path=$PHP_INSTALL_DIR/etc \
	--disable-cgi \
	--enable-mbstring=shared \
	--enable-calendar=shared \
	--enable-ctype=shared \
	--enable-bcmath=shared \
	--enable-exif=shared \
	--enable-ftp=shared \
	--enable-sockets=shared \
	--enable-soap=shared \
	--enable-zip=shared \
	--enable-cli=shared \
	--enable-libxml=shared \
	--with-mcrypt=shared \
	--with-mhash=shared \
	--with-jpeg-dir=shared \
	--with-png-dir=shared \
	--with-gd=shared \
	--enable-pdo=shared \
	--without-sqlite \
	--with-sqlite3=shared \
	--with-pdo-sqlite=shared \
	--with-mysql=shared,$INSTALL_DIR/$PHP_MYSQL_INSTANCE \
	--with-mysqli=shared,$INSTALL_DIR/$PHP_MYSQL_INSTANCE/bin/mysql_config \
	--with-pdo-mysql=shared,$INSTALL_DIR/$PHP_MYSQL_INSTANCE \
	--with-iconv=shared,$INSTALL_DIR/libiconv \
	--with-openssl=shared,$INSTALL_DIR/openssl \
	--with-zlib-dir=shared,$INSTALL_DIR/zlib \
&& make && make install && echo "PHP installed successfully!"
cd ..
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/$APACHE_INSTANCE_NAME/php/bin
strip_debug_symbols $INSTALL_DIR/$APACHE_INSTANCE_NAME/php/lib/php/extensions/no-debug-non-zts-20090626
strip_debug_symbols $INSTALL_DIR/$APACHE_INSTANCE_NAME/modules
echo "Shared library dependencies for $INSTALL_DIR/$APACHE_INSTANCE_NAME/modules/libphp5.so:"
ldd $INSTALL_DIR/$APACHE_INSTANCE_NAME/modules/libphp5.so
cp -p $INSTALL_DIR/php-$PHP_VERSION/php.ini-production $PHP_INSTALL_DIR/etc/php.ini
replace_in_file 'expose_php = On' 'expose_php = Off' $PHP_INSTALL_DIR/etc/php.ini
replace_in_file 'max_execution_time = 30' 'max_execution_time = 10' $PHP_INSTALL_DIR/etc/php.ini
replace_in_file 'max_input_time = 60' 'max_input_time = 20' $PHP_INSTALL_DIR/etc/php.ini
replace_in_file 'memory_limit = 128M' 'memory_limit = 32M' $PHP_INSTALL_DIR/etc/php.ini
replace_in_file ';date.timezone =' 'date.timezone = "Europe\/London"' $PHP_INSTALL_DIR/etc/php.ini
echo -e "\nextension=bcmath.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=calendar.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=ctype.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=exif.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=ftp.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=iconv.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=gd.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=mbstring.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=mcrypt.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=openssl.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=sqlite3.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=mysql.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=mysqli.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=pdo.so" >> $PHP_INSTALL_DIR/etc/php.ini
# FIXME: cannot load pdo_sqlite.so due to an error 'pdo_sqlite.so: undefined symbol: sqlite3_libversion'
echo -e ";extension=pdo_sqlite.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=pdo_mysql.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=soap.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=sockets.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "extension=zip.so" >> $PHP_INSTALL_DIR/etc/php.ini
rm $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf.bak
rm -rf $PHP_INSTALL_DIR/man
replace_in_file 'DirectoryIndex index.html' 'DirectoryIndex index.html index.php' $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
replace_in_file 'LoadModule php5_module        modules\/libphp5.so' 'LoadModule php5_module modules\/libphp5.so' $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
echo -e "\n<FilesMatch \.php$>\n\tSetHandler application/x-httpd-php\n</FilesMatch>\n" >> $INSTALL_DIR/$APACHE_INSTANCE_NAME/conf/httpd.conf
echo -e "<?php phpinfo(); ?>" > $INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs/info.php
echo -e "\n\n *** PHP settings ***\n"
$PHP_INSTALL_DIR/bin/php -i
echo -e "\n\n"
run_apache_performance_test http://localhost:$APACHE_PORT/info.php
sleep 1
pkill httpd
sleep 1
chown -R root:root $INSTALL_DIR/$APACHE_INSTANCE_NAME
chown -R $APACHE_USER:$APACHE_GROUP $INSTALL_DIR/$APACHE_INSTANCE_NAME/log
chmod 700 $INSTALL_DIR/$APACHE_INSTANCE_NAME/log

fi

###
### install imagick
###

if [ "$APACHE_INSTALL" = "Y" ] && [ "$PHP_INSTALL" = "Y" ] && [ "$IMAGICK_INSTALL" = "Y" ]; then

echo Installing imagick:
tar -zxf imagick.tgz
cd imagick-$IMAGICK_VERSION
$PHP_INSTALL_DIR/bin/phpize
./configure \
	--with-php-config=$PHP_INSTALL_DIR/bin/php-config \
	--with-imagick=$INSTALL_DIR/imagemagick \
&& make && make install && echo "imagick installed successfully!"
cd ..
rm package.xml
echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/$APACHE_INSTANCE_NAME/php/lib/php/extensions/no-debug-non-zts-20090626/imagick.so
echo -e "extension=imagick.so" >> $PHP_INSTALL_DIR/etc/php.ini

fi

###
### install APC
###

if [ "$APACHE_INSTALL" = "Y" ] && [ "$PHP_INSTALL" = "Y" ] && [ "$APC_INSTALL" = "Y" ]; then

echo Installing APC:
tar -zxf apc.tgz
cd APC-$APC_VERSION
$PHP_INSTALL_DIR/bin/phpize
./configure \
	--with-php-config=$PHP_INSTALL_DIR/bin/php-config \
	--enable-apc \
&& make && make install && echo "APC installed successfully!"
cd ..
rm package.xml
echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/$APACHE_INSTANCE_NAME/php/lib/php/extensions/no-debug-non-zts-20090626/apc.so
echo -e "extension=apc.so" >> $PHP_INSTALL_DIR/etc/php.ini
echo -e "<?php phpinfo(); ?>" > $INSTALL_DIR/$APACHE_INSTANCE_NAME/htdocs/info.php
echo -e "\n\n *** APC settings ***\n"
$PHP_INSTALL_DIR/bin/php -i | grep apc
echo -e "\n\n"
run_apache_performance_test http://localhost:$APACHE_PORT/info.php
sleep 1
pkill httpd
sleep 1

fi

###
### install vsftpd
###

if [ "$VSFTPD_INSTALL" = "Y" ]; then

echo Installing vsftpd:
pkill vsftpd
[ -d $INSTALL_DIR/vsftpd ] && rm -rf $INSTALL_DIR/vsftpd
tar -zxf vsftpd.tar.gz
cd vsftpd-$VSFTPD_VERSION
replace_in_file '#undef VSF_BUILD_SSL' '#define VSF_BUILD_SSL' builddefs.h
make && \
	mkdir -p $INSTALL_DIR/vsftpd/{bin,conf,empty,log} && \
	touch $INSTALL_DIR/vsftpd/conf/vsftpd.user_list && \
	cp vsftpd $INSTALL_DIR/vsftpd/bin/vsftpd && \
	cp EXAMPLE/INTERNET_SITE_NOINETD/vsftpd.conf $INSTALL_DIR/vsftpd/conf/vsftpd.conf && \
	echo "vsftpd installed successfully!"
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/vsftpd/bin
cd ..
echo "Shared library dependencies for $INSTALL_DIR/vsftpd/bin/vsftpd:"
ldd $INSTALL_DIR/vsftpd/bin/vsftpd
cat <<EOF > $INSTALL_DIR/vsftpd/conf/vsftpd.conf
# standalone mode
listen=YES

# access rights
anonymous_enable=NO
local_enable=YES
write_enable=YES
force_dot_files=YES
userlist_enable=YES
userlist_file=$INSTALL_DIR/vsftpd/conf/vsftpd.user_list
userlist_deny=NO

# security
ftpd_banner=Host4ge FTP Server
connect_from_port_20=YES
hide_ids=YES
pasv_min_port=50000
pasv_max_port=60000
local_umask=022
chroot_local_user=YES
secure_chroot_dir=$INSTALL_DIR/vsftpd/empty

# encryption
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_tlsv1=YES
rsa_cert_file=$INSTALL_DIR/openssl/certs/vsftpd.pem
rsa_private_key_file=$INSTALL_DIR/openssl/certs/vsftpd.pem

# features
xferlog_enable=YES
vsftpd_log_file=$INSTALL_DIR/vsftpd/log/vsftpd.log
async_abor_enable=YES

# performance
idle_session_timeout=120
data_connection_timeout=300
accept_timeout=60
connect_timeout=60
EOF
generate_certificate "vsftpd"
$INSTALL_DIR/vsftpd/bin/vsftpd $INSTALL_DIR/vsftpd/conf/vsftpd.conf &
sleep 1
pkill vsftpd
sleep 1
chmod 500 $INSTALL_DIR/vsftpd/conf
chmod 600 $INSTALL_DIR/vsftpd/conf/*
chmod 700 $INSTALL_DIR/vsftpd/log

fi

###
### install Postfix
###

if [ "$POSTFIX_INSTALL" = "Y" ]; then

echo Installing Postfix:
[ -d $INSTALL_DIR/postfix ] && rm -rf $INSTALL_DIR/postfix
tar -zxf postfix.tar.gz
groupadd -g 530 postfix
groupadd -g 531 postdrop
useradd -u 530 -d /dev/null -s /usr/sbin/nologin -g postfix postfix
cd postfix-$POSTFIX_VERSION
# with mysql
if [ -d $INSTALL_DIR/mysql ]; then
	make makefiles \
	CCARGS='-DDEF_COMMAND_DIR=\"/usr/local/postfix/bin\" \
		-DDEF_CONFIG_DIR=\"/usr/local/postfix/conf\" \
		-DDEF_DAEMON_DIR=\"/usr/local/postfix/bin\" \
		-DDEF_DATA_DIR=\"/usr/local/postfix/data\" \
		-DDEF_HTML_DIR=\"/usr/local/postfix/doc/html\" \
		-DDEF_MANPAGE_DIR=\"/usr/local/postfix/man\" \
		-DDEF_QUEUE_DIR=\"/usr/local/postfix/queue\" \
		-DDEF_README_DIR=\"/usr/local/postfix/doc/README\" \
		-DDEF_MAILQ_PATH=\"/usr/local/postfix/bin/mailq\" \
		-DDEF_SENDMAIL_PATH=\"/usr/local/postfix/bin/sendmail\" \
		-DUSE_TLS -I/usr/local/openssl/include/openssl \
		-DHAS_MYSQL -I/usr/local/mysql/include/mysql' \
		AUXLIBS='-L/usr/lib -lssl -lcrypto -lmysqlclient -lz -lm' && \
	make && chmod u+x ./postfix-install && sh ./postfix-install -non-interactive && echo "Postfix installed successfully!"
fi
# without mysql (for testing purpose only)
if [ ! -d $INSTALL_DIR/mysql ]; then
	make makefiles \
	CCARGS='-DDEF_COMMAND_DIR=\"/usr/local/postfix/bin\" \
		-DDEF_CONFIG_DIR=\"/usr/local/postfix/conf\" \
		-DDEF_DAEMON_DIR=\"/usr/local/postfix/bin\" \
		-DDEF_DATA_DIR=\"/usr/local/postfix/data\" \
		-DDEF_HTML_DIR=\"/usr/local/postfix/doc/html\" \
		-DDEF_MANPAGE_DIR=\"/usr/local/postfix/man\" \
		-DDEF_QUEUE_DIR=\"/usr/local/postfix/queue\" \
		-DDEF_README_DIR=\"/usr/local/postfix/doc/README\" \
		-DDEF_MAILQ_PATH=\"/usr/local/postfix/bin/mailq\" \
		-DDEF_SENDMAIL_PATH=\"/usr/local/postfix/bin/sendmail\" \
		-DUSE_TLS -I/usr/local/openssl/include/openssl' \
		AUXLIBS='-L/usr/lib -lssl -lcrypto' && \
	make && chmod u+x ./postfix-install && sh ./postfix-install -non-interactive && echo "Postfix installed successfully!"
fi
# create link to the log file
mkdir $INSTALL_DIR/postfix/log
ln -sfv /var/log/mail.log $INSTALL_DIR/postfix/log/mail.log
ln -sfv /var/log/mail.err $INSTALL_DIR/postfix/log/mail.err
echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/postfix/bin
cd ..
rm -rf $INSTALL_DIR/postfix/{bin/*cf,doc,man}
echo "Shared library dependencies for $INSTALL_DIR/postfix/bin/postfix:"
ldd $INSTALL_DIR/postfix/bin/postfix
$INSTALL_DIR/postfix/bin/postconf -n
replace_in_file '#myhostname = virtual.domain.tld' "myhostname = `hostname -f`" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#mydomain = domain.tld' "mydomain = `hostname -f`" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#myorigin = $myhostname' "myorigin = `hostname -f`" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#smtpd_banner = $myhostname ESMTP $mail_name ($mail_version)' 'smtpd_banner = $myhostname Host4ge SMTP Server' $INSTALL_DIR/postfix/conf/main.cf
newaliases

fi

###
### install Mailx
###

if [ "$POSTFIX_INSTALL" = "Y" ]; then

echo Installing Mailx:
tar -jxf mailx.tar.bz2
cd mailx-$MAILX_VERSION
patch -Np1 -i ../mailx-openssl_1.0.0_build_fix-1.patch && \
make SENDMAIL=$INSTALL_DIR/postfix/bin/sendmail && \
make PREFIX=$INSTALL_DIR/postfix UCBINSTALL=/usr/bin/install install && \
ln -sfv $INSTALL_DIR/postfix/bin/mailx $INSTALL_DIR/postfix/bin/mail && \
ln -sfv $INSTALL_DIR/postfix/bin/mailx $INSTALL_DIR/postfix/bin/nail && \
echo "Mailx installed successfully!"
echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/postfix/bin/mailx
cd ..
rm -rf $INSTALL_DIR/postfix/share
echo "Shared library dependencies for $INSTALL_DIR/postfix/bin/mailx:"
ldd $INSTALL_DIR/postfix/bin/mailx

fi

###
### install Dovecot
###

if [ "$DOVECOT_INSTALL" = "Y" ]; then

echo Installing Dovecot:
[ -d $INSTALL_DIR/dovecot ] && rm -rf $INSTALL_DIR/dovecot
tar -zxf dovecot.tar.gz
groupadd -g 540 dovenull
useradd -u 540 -d /dev/null -s /usr/sbin/nologin -g dovenull dovenull
groupadd -g 541 dovecot
useradd -u 541 -d /dev/null -s /usr/sbin/nologin -g dovecot dovecot
cd dovecot-$DOVECOT_VERSION
# with mysql
if [ -d $INSTALL_DIR/mysql ]; then
	CPPFLAGS="-I$INSTALL_DIR/openssl/include" LDFLAGS="-L$INSTALL_DIR/openssl/lib -ldl" ./configure \
		--prefix=$INSTALL_DIR/dovecot \
		--sbindir=$INSTALL_DIR/dovecot/bin \
		--with-zlib \
		--with-ssl=openssl \
		--with-ssldir=$INSTALL_DIR/openssl \
		--with-mysql \
		--with-sql=plugin \
	&& make && make install && echo "Dovecot installed successfully!"
fi
# without mysql (for testing purpose only)
if [ ! -d $INSTALL_DIR/mysql ]; then
	CPPFLAGS="-I$INSTALL_DIR/openssl/include" LDFLAGS="-L$INSTALL_DIR/openssl/lib -ldl" ./configure \
		--prefix=$INSTALL_DIR/dovecot \
		--sbindir=$INSTALL_DIR/dovecot/bin \
		--with-zlib \
		--with-ssl=openssl \
		--with-ssldir=$INSTALL_DIR/openssl \
	&& make && make install && echo "Dovecot installed successfully!"
fi
cp -rf $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/conf.d $INSTALL_DIR/dovecot/etc/dovecot
cp $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/dovecot.conf $INSTALL_DIR/dovecot/etc/dovecot/dovecot.conf
# temporary disable SSL
replace_in_file '#ssl = yes' 'ssl = no' $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
replace_in_file 'ssl_cert = <\/etc\/ssl\/certs\/dovecot.pem' '#ssl_cert = <\/etc\/ssl\/certs\/dovecot.pem' $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
replace_in_file 'ssl_key = <\/etc\/ssl\/private\/dovecot.pem' '#ssl_key = <\/etc\/ssl\/private\/dovecot.pem' $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
echo "Strip symbols:"
strip_debug_symbols_file $INSTALL_DIR/dovecot/bin
strip_debug_symbols_file $INSTALL_DIR/dovecot/libexec/dovecot
strip_debug_symbols_file $INSTALL_DIR/dovecot/lib/dovecot
cd ..
#rm -rf $INSTALL_DIR/dovecot/share
echo "Shared library dependencies for $INSTALL_DIR/dovecot/bin/dovecot:"
ldd $INSTALL_DIR/dovecot/bin/dovecot

fi

###
### install phpMyAdmin
###

if [ "$PHPMYADMIN_INSTALL" = "Y" ]; then

echo Installing phpMyAdmin:
[ -d $INSTALL_DIR/applications/phpmyadmin ] && rm -rf $INSTALL_DIR/applications/phpmyadmin
[ ! -d $INSTALL_DIR/applications ] && mkdir -p $INSTALL_DIR/applications
tar -zxf phpmyadmin.tar.gz -C $INSTALL_DIR/applications
mv $INSTALL_DIR/applications/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages $INSTALL_DIR/applications/phpmyadmin
rm -rf $INSTALL_DIR/applications/phpmyadmin/setup
BLOWFISH_SECRET=`get_random_str 32`
CONTROL_USER_NAME="ctrl_phpmyadmin"
CONTROL_USER_PASSWORD=`get_random_str 32`
cat <<EOF > $INSTALL_DIR/applications/phpmyadmin/config.inc.php
<?php
\$cfg['blowfish_secret'] = '$BLOWFISH_SECRET';
\$i = 0;
\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
\$cfg['Servers'][\$i]['host'] = 'localhost';
\$cfg['Servers'][\$i]['connect_type'] = 'tcp';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['extension'] = 'mysql';
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;
\$cfg['Servers'][\$i]['pmadb'] = 'phpmyadmin';
\$cfg['Servers'][\$i]['controluser'] = '$CONTROL_USER_NAME';
\$cfg['Servers'][\$i]['controlpass'] = '$CONTROL_USER_PASSWORD';
\$cfg['Servers'][\$i]['relation'] = 'TABLE_RELATIONS';
?>
EOF
# config database
$INSTALL_DIR/$PHPMYADMIN_DATABASE/bin/mysqld_safe --user=$PHPMYADMIN_DATABASE &
sleep 5
$INSTALL_DIR/$PHPMYADMIN_DATABASE/bin/mysql -u root < $INSTALL_DIR/applications/phpmyadmin/scripts/create_tables.sql
cat <<EOF | $INSTALL_DIR/$PHPMYADMIN_DATABASE/bin/mysql -u root
GRANT USAGE ON mysql.* TO '$CONTROL_USER_NAME'@'localhost' IDENTIFIED BY '$CONTROL_USER_PASSWORD';
GRANT SELECT (
	Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv,
	Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv,
	File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,
	Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv,
	Execute_priv, Repl_slave_priv, Repl_client_priv
) ON mysql.user TO '$CONTROL_USER_NAME'@'localhost';
GRANT SELECT ON mysql.db TO '$CONTROL_USER_NAME'@'localhost';
GRANT SELECT ON mysql.host TO '$CONTROL_USER_NAME'@'localhost';
GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv) ON mysql.tables_priv TO '$CONTROL_USER_NAME'@'localhost';
EOF
sleep 1
$INSTALL_DIR/$PHPMYADMIN_DATABASE/bin/mysqladmin -u root shutdown
sleep 3
# config webserver
remove_from_file "\n# BEGIN: phpmyadmin configuration.*END: phpmyadmin configuration" $INSTALL_DIR/$PHPMYADMIN_SERVER/conf/httpd.conf
(	echo -e "# BEGIN: phpmyadmin configuration" && \
	echo -e "<Directory $INSTALL_DIR/$PHPMYADMIN_SERVER/htdocs/phpmyadmin/>" && \
	echo -e "\tphp_admin_value apc.enabled 0" && \
	echo -e "</Directory>" && \
	echo -e "# END: phpmyadmin configuration" \
) >> $INSTALL_DIR/$PHPMYADMIN_SERVER/conf/httpd.conf
[ -d $INSTALL_DIR/$PHPMYADMIN_SERVER/htdocs/phpmyadmin ] && rm -rf $INSTALL_DIR/$PHPMYADMIN_SERVER/htdocs/phpmyadmin
ln -s $INSTALL_DIR/applications/phpmyadmin $INSTALL_DIR/$PHPMYADMIN_SERVER/htdocs/phpmyadmin

fi

###
### install OpenJDK
###

if [ "$OPENJDK_INSTALL" = "Y" ]; then

echo Installing OpenJDK:
[ -d $INSTALL_DIR/openjdk ] && rm -rf $INSTALL_DIR/openjdk
tar -zxf openjdk.tar.gz
mv jdk1.7.0  $INSTALL_DIR/openjdk
rm -rf $INSTALL_DIR/openjdk/{db/demo,demo,man,sample,src.zip}
chown -R root:root $INSTALL_DIR/openjdk

fi

###
### install Ant
###

if [ "$ANT_INSTALL" = "Y" ]; then

echo Installing Ant:
[ -d $INSTALL_DIR/ant ] && rm -rf $INSTALL_DIR/ant
tar -zxf ant.tar.gz
mv apache-ant-$ANT_VERSION $INSTALL_DIR/ant
rm -rf $INSTALL_DIR/ant/docs
chown -R root:root $INSTALL_DIR/ant

fi

###
### install Tomcat
###

if [ "$TOMCAT_INSTALL" = "Y" ]; then

echo Installing Tomcat:
[ -d $INSTALL_DIR/$TOMCAT_INSTANCE_NAME ] && rm -rf $INSTALL_DIR/$TOMCAT_INSTANCE_NAME
tar -zxf tomcat.tar.gz
mkdir -p $INSTALL_DIR/www && mv apache-tomcat-$TOMCAT_VERSION $INSTALL_DIR/$TOMCAT_INSTANCE_NAME
replace_in_file 'port="8005"' 'port="-1"' $INSTALL_DIR/$TOMCAT_INSTANCE_NAME/conf/server.xml
rm -rf $INSTALL_DIR/$TOMCAT_INSTANCE_NAME/webapps/{docs,examples}
cd $INSTALL_DIR/$TOMCAT_INSTANCE_NAME/bin
tar -zxf commons-daemon-native.tar.gz
cd commons-daemon-$TOMCAT_COMMONS_DAEMON_VERSION-native-src/unix
./configure \
	--with-java=$INSTALL_DIR/openjdk \
&& make && cp jsvc ../.. && echo JSVC installed successfully!
cd ../..
rm -rf commons-daemon-$TOMCAT_COMMONS_DAEMON_VERSION-native-src
cd ..
groupadd -g 550 $TOMCAT_GROUP
useradd -u 550 -d /dev/null -s /usr/sbin/nologin -g $TOMCAT_GROUP $TOMCAT_USER
chown -R root:root $INSTALL_DIR/$TOMCAT_INSTANCE_NAME

fi

###
### create web site
###

if [ -n "$SITE" ] && [ -n "$SITE_DATABASE" ] && [ -n "$SITE_SERVER_NAME" ] && [ -n "$SITE_SERVER_PORT" ]; then

	if [ ! -d "$INSTALL_DIR/sites/$SITE" ]; then
		create_web_site $SITE $SITE_DATABASE $SITE_SERVER_NAME $SITE_SERVER_PORT
	fi

fi

###
### generate SSL certificate
###

if [ -n "$SSL_CERTIFICATE_NAME" ]; then

	generate_certificate $SSL_CERTIFICATE_NAME

fi

###
### remove source archive files
###

if [ "$REMOVE_SOURCE_FILES" = "Y" ]; then

	[ -f zlib.tar.gz ] && rm zlib.tar.gz
	[ -f openssl.tar.gz ] && rm openssl.tar.gz
	[ -f apr.tar.gz ] && rm apr.tar.gz
	[ -f apr-util.tar.gz ] && rm apr-util.tar.gz
	[ -f apr-iconv.tar.gz ] && rm apr-iconv.tar.gz
	[ -f libiconv.tar.gz ] && rm libiconv.tar.gz
	[ -f imagemagick.tar.gz ] && rm imagemagick.tar.gz
	[ -f mysql.tar.gz ] && rm mysql.tar.gz
	[ -f httpd.tar.gz ] && rm httpd.tar.gz
	[ -f geoip.tar.gz ] && rm geoip.tar.gz
	[ -f GeoIPLiteCity.dat.gz ] && rm GeoIPLiteCity.dat.gz
	[ -f mod_geoip.tar.gz ] && rm mod_geoip.tar.gz
	[ -f php.tar.gz ] && rm php.tar.gz
	[ -f imagick.tgz ] && rm imagick.tgz
	[ -f apc.tgz ] && rm apc.tgz
	[ -f vsftpd.tar.gz ] && rm vsftpd.tar.gz
	[ -f postfix.tar.gz ] && rm postfix.tar.gz
	[ -f mailx.tar.gz ] && rm mailx.tar.bz2
	[ -f mailx-openssl_1.0.0_build_fix-1.patch ] && rm mailx-openssl_1.0.0_build_fix-1.patch
	[ -f dovecot.tar.gz ] && rm dovecot.tar.gz
	[ -f phpmyadmin.tar.gz ] && rm phpmyadmin.tar.gz

fi

###
### remove source directories
###

if [ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ]; then

	[ -d zlib-$ZLIB_VERSION ] && rm -rf zlib-$ZLIB_VERSION
	[ -d openssl-$OPENSSL_VERSION ] && rm -rf openssl-$OPENSSL_VERSION
	[ -d apr-$APR_VERSION ] && rm -rf apr-$APR_VERSION
	[ -d apr-util-$APR_UTIL_VERSION ] && rm -rf apr-util-$APR_UTIL_VERSION
	[ -d apr-iconv-$APR_ICONV_VERSION ] && rm -rf apr-iconv-$APR_ICONV_VERSION
	[ -d libiconv-$LIBICONV_VERSION ] && rm -rf libiconv-$LIBICONV_VERSION
	[ -d ImageMagick-$IMAGEMAGICK_VERSION ] && rm -rf ImageMagick-$IMAGEMAGICK_VERSION
	[ -d mysql-$MYSQL_VERSION ] && rm -rf mysql-$MYSQL_VERSION
	[ -d httpd-$APACHE_VERSION ] && rm -rf httpd-$APACHE_VERSION
	[ -d GeoIP-$GEOIP_VERSION ] && rm -rf GeoIP-$GEOIP_VERSION
	[ -d mod_geoip2_$MOD_GEOIP_VERSION ] && rm -rf mod_geoip2_$MOD_GEOIP_VERSION
	[ -d php-$PHP_VERSION ] && rm -rf php-$PHP_VERSION
	[ -d imagick-$IMAGICK_VERSION ] && rm -rf imagick-$IMAGICK_VERSION
	[ -d APC-$APC_VERSION ] && rm -rf APC-$APC_VERSION
	[ -d vsftpd-$VSFTPD_VERSION ] && rm -rf vsftpd-$VSFTPD_VERSION
	[ -d postfix-$POSTFIX_VERSION ] && rm -rf postfix-$POSTFIX_VERSION
	[ -d mailx-$MAILX_VERSION ] && rm -rf mailx-$MAILX_VERSION
	[ -d dovecot-$DOVECOT_VERSION ] && rm -rf dovecot-$DOVECOT_VERSION

fi

###
### finalize
###

if [ "$FINALIZE" = "Y" ]; then

	# $PATH
	NEW_PATH=$INSTALL_DIR/openssl/bin:$INSTALL_DIR/mysql/bin:$INSTALL_DIR/apache/bin:$INSTALL_DIR/vsftpd/bin:$INSTALL_DIR/postfix/bin:$INSTALL_DIR/dovecot/bin:$INSTALL_DIR/dovecot/sbin:$INSTALL_DIR/geoip/bin:$INSTALL_DIR/openjdk/jre/bin:$INSTALL_DIR/openjdk/bin:$INSTALL_DIR/ant/bin
	remove_from_file "\n# BEGIN: server settings.*END: server settings\n" ~/.profile
	echo -e "# BEGIN: server settings" >> ~/.profile
	echo -e "export INSTALL_DIR=\"$INSTALL_DIR\"" >> ~/.profile
	echo -e "export PATH=\"$NEW_PATH:/usr/sbin:/usr/bin:/sbin:/bin\"" >> ~/.profile
	echo -e "export JRE_HOME=\"$INSTALL_DIR/openjdk/jre\"" >> ~/.profile
	echo -e "export JAVA_HOME=\"$INSTALL_DIR/openjdk\"" >> ~/.profile
	echo -e "export JAVA_OPTS=\"-Xms16m -Xmx32m\"" >> ~/.profile
	echo -e "export ANT_HOME=\"$INSTALL_DIR/ant\"" >> ~/.profile
	echo -e "export ANT_OPTS=\"$JAVA_OPTS\"" >> ~/.profile
	echo -e "# END: server settings\n" >> ~/.profile

	# set mysql password
	if [ -d $INSTALL_DIR/mysql ]; then
		MYSQL_PASSWORD=`get_random_str 32`
		(	echo -e "server.username=root"
			echo -e "server.password=$MYSQL_PASSWORD"
		) >> $INSTALL_DIR/mysql/.access.details
		chown -R root:root $INSTALL_DIR/mysql/.access.details
		chmod 400 $INSTALL_DIR/mysql/.access.details
		$INSTALL_DIR/mysql/bin/mysqld_safe --user=mysql &
		sleep 5
		#/usr/local/mysql/bin/mysqladmin -u root password "$MYSQL_PASSWORD"
		sleep 1 && pkill mysqld
	fi

	# apache
	if [ -d $INSTALL_DIR/apache ]; then
		rm -fv $INSTALL_DIR/apache/htdocs/index.html
		touch $INSTALL_DIR/apache/htdocs/index.html
	fi

	# clean up
	rm -rfv /tmp/*
	rm -rfv /var/{backups,local/*,mail,opt/*,spool/*,www}

	# welcome screen
	cat <<EOF > /etc/motd.tail
    __               __  __ __
   / /_  ____  _____/ /_/ // / ____ ____   _________  ____ ___
  / __ \\/ __ \\/ ___/ __/ // /_/ __ \`/ _ \\ / ___/ __ \\/ __ \`__ \\
 / / / / /_/ (__  ) /_/__  __/ /_/ /  __// /__/ /_/ / / / / / /
/_/ /_/\\____/____/\\__/  /_/  \\__, /\\___(_)___/\\____/_/ /_/ /_/
                            /____/

EOF

	echo "Disk usage: " `du -hcs / | grep total`

	# startup services
	./vps-startup-services.sh

	# get some info about the host
	host $FINALIZE_IP_ADDRESS
	nslookup $FINALIZE_IP_ADDRESS

	# show list of connections
	netstat -tuapn
	# show list of processes
	ps -Af
	# show memory usage
	free

fi

cd $CURRENT_DIR

echo Script ended on $(date)

# make sure this script ends
kill -s SIGINT $$
