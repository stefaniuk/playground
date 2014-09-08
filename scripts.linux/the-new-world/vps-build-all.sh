#!/bin/bash
#
# File: vps-build.sh
#
# Description: This script builds all the services from source and configures the server.
#
# Usage:
#
#	./vps-build-all.sh; source ~/.profile
#	./vps-build-all.sh --debug; source ~/.profile

PREFIX=
[ "$1" = "--debug" ] && PREFIX="bash -x "

[ "`hostname`" = "vps1" ] && IP_ADDRESS="95.154.203.14"
[ "`hostname`" = "test" ] && IP_ADDRESS="95.154.203.27"
[ "`hostname`" = "shared" ] && IP_ADDRESS="109.74.193.158"

EMAIL_ADDRESS="daniel.stefaniuk@gmail.com"

$PREFIX./vps-build.sh --initialize --zlib --openssl --apr --libiconv --imagemagick --download 2>&1 | tee vps-build.base.out
$PREFIX./vps-build.sh --mysql mysql mysql mysql 3306 --download 2>&1 | tee vps-build.mysql.out
$PREFIX./vps-build.sh --apache apache apache apache 80 443 --geoip --php mysql --imagick --apc --download 2>&1 | tee vps-build.webserver.out
$PREFIX./vps-build.sh --vsftpd --download 2>&1 | tee vps-build.vsftpd.out
$PREFIX./vps-build.sh --postfix --dovecot --download 2>&1 | tee vps-build.mail.out
$PREFIX./vps-build.sh --phpmyadmin mysql apache --download 2>&1 | tee vps-build.site-phpmyadmin.out
#$PREFIX./vps-build.sh --openjdk --ant --tomcat tomcat tomcat tomcat 8080 8443 --download 2>&1 | tee vps-build.java.out
#$PREFIX./vps-build.sh --site stefaniuk.org mysql apache 80 443 2>&1 | tee vps-build.site-stefaniuk.org.out
$PREFIX./vps-build.sh --finalize $IP_ADDRESS 2>&1 | tee vps-build.finalize.out

if [ -d /usr/local/postfix ]; then
	echo "Server `hostname -f` ($IP_ADDRESS) has been build on `date`." | /usr/local/postfix/bin/mailx -s "`hostname -f` ($IP_ADDRESS)" $EMAIL_ADDRESS
fi

# make sure this script ends
kill -s SIGINT $$
