#!/bin/bash
#
# File: check-services.sh
#
# Description: This script checks if all services are running.
#
# Usage:
#
#	./check-services.sh

# installation directory
INSTALL_DIR=/srv

# mysql
if [ -f $INSTALL_DIR/mysql/bin/mysql.server ]; then
	RUNNING=`ps ax | grep "/srv/mysql/bin/mysqld" | grep -v grep | cut -c1-5 | paste -s -`
	if [ ! "$RUNNING" ]; then
		pkill mysql;
		logger -p local0.err -t host4ge "MySQL not running"
		logger -p local0.notice -t host4ge "start MySQL"
		$INSTALL_DIR/mysql/bin/mysql.server start
	fi
fi

# httpd
if [ -f $INSTALL_DIR/httpd/bin/apachectl ]; then
	RUNNING=`ps ax | grep "/srv/httpd/bin/httpd" | grep -v grep | cut -c1-5 | paste -s -`
	if [ ! "$RUNNING" ]; then
		pkill httpd;
		logger -p local0.err -t host4ge "Apache HTTPD not running"
		logger -p local0.notice -t host4ge "start Apache HTTPD"
		$INSTALL_DIR/httpd/bin/apachectl -k start
	fi
fi

# proftpd
if [ -f $INSTALL_DIR/proftpd/bin/proftpd ]; then
	RUNNING=`ps ax | grep "proftpd:" | grep -v grep | cut -c1-5 | paste -s -`
	if [ ! "$RUNNING" ]; then
		pkill proftpd;
		logger -p local0.err -t host4ge "ProFTPD not running"
		logger -p local0.notice -t host4ge "start ProFTPD"
		nohup $INSTALL_DIR/proftpd/bin/log-proftpd.pl > /dev/null 2>&1 &
		$INSTALL_DIR/proftpd/bin/proftpd
	fi
fi

# postfix
if [ -f $INSTALL_DIR/postfix/bin/postfix ]; then
	RUNNING=`ps ax | grep "/srv/postfix/bin/master" | grep -v grep | cut -c1-5 | paste -s -`
	if [ ! "$RUNNING" ]; then
		pkill master;
		logger -p local0.err -t host4ge "Postfix not running"
		logger -p local0.notice -t host4ge "start Postfix"
		$INSTALL_DIR/postfix/bin/postfix start
	fi
fi

# dovecot
if [ -f $INSTALL_DIR/dovecot/bin/dovecot ]; then
	RUNNING=`ps ax | grep "/srv/dovecot/bin/dovecot" | grep -v grep | cut -c1-5 | paste -s -`
	if [ ! "$RUNNING" ]; then
		pkill dovecot;
		logger -p local0.err -t host4ge "Dovecot not running"
		logger -p local0.notice -t host4ge "start Dovecot"
		$INSTALL_DIR/dovecot/bin/dovecot
	fi
fi
