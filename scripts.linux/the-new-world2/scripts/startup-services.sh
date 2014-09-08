#!/bin/bash
#
# File: startup-services.sh
#
# Description: This script starts all services.
#
# Usage:
#
#	./startup-services.sh

# installation directory
INSTALL_DIR=/srv

# load firewall rules
[ -f $INSTALL_DIR/scripts/load-firewall-rules.sh ] && $INSTALL_DIR/scripts/load-firewall-rules.sh

# kill all running services
pkill mysql; pkill httpd; pkill proftpd; pkill master; pkill dovecot;
sleep 1

# log event
logger -p local0.notice -t host4ge "start up all services"

# mysql
if [ -f $INSTALL_DIR/mysql/bin/mysql.server ]; then
	logger -p local0.notice -t host4ge "start MySQL"
	$INSTALL_DIR/mysql/bin/mysql.server start
fi

# httpd
if [ -f $INSTALL_DIR/httpd/bin/apachectl ]; then
	logger -p local0.notice -t host4ge "start Apache HTTPD"
	$INSTALL_DIR/httpd/bin/apachectl -k start
fi

# proftpd
if [ -f $INSTALL_DIR/proftpd/bin/proftpd ]; then
	logger -p local0.notice -t host4ge "start ProFTPD"
	nohup $INSTALL_DIR/proftpd/bin/log-proftpd.pl > /dev/null 2>&1 &
	$INSTALL_DIR/proftpd/bin/proftpd
fi

# postfix
if [ -f $INSTALL_DIR/postfix/bin/postfix ]; then
	logger -p local0.notice -t host4ge "start Postfix"
	$INSTALL_DIR/postfix/bin/postfix start
fi

# dovecot
if [ -f $INSTALL_DIR/dovecot/bin/dovecot ]; then
	logger -p local0.notice -t host4ge "start Dovecot"
	$INSTALL_DIR/dovecot/bin/dovecot
fi
