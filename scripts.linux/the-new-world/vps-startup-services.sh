#!/bin/bash
#
# File: vps-startup-services.sh
#
# Description: This script starts all the services.
#
# Usage:
#
#	./vps-startup-services.sh

# load firewall rules
if [ -d ./vps-load-firewall-rules.sh ]; then
	./vps-load-firewall-rules.sh
fi

# mysql
if [ -d /usr/local/mysql ]; then
	pkill mysql
	sleep 1
	/usr/local/mysql/bin/mysqld_safe --user=mysql &
fi

# apache
if [ -d /usr/local/apache ]; then
	pkill httpd
	sleep 1
	/usr/local/apache/bin/apachectl -k start
fi

# vsftpd
if [ -d /usr/local/vsftpd ]; then
	pkill vsftpd
	sleep 1
	/usr/local/vsftpd/bin/vsftpd /usr/local/vsftpd/conf/vsftpd.conf &
fi

# postfix
if [ -d /usr/local/postfix ]; then
	pkill master
	sleep 1
	/usr/local/postfix/bin/postfix start
fi

# dovecot
if [ -d /usr/local/dovecot ]; then
	pkill dovecot
	sleep 1
	/usr/local/dovecot/bin/dovecot
fi

# make sure this script ends
kill -s SIGINT $$
