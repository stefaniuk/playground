#!/bin/bash
#
# File: run.sh
#
# Description: This script configures the server and builds all the services from source.
#
# Usage:
#
#	./run.sh && source ~/.profile
#	./run.sh --debug && source ~/.profile

PREFIX=
[ "$1" = "--debug" ] && PREFIX="bash -x "

# TODO: set valid hostname for Linode account

[ "`hostname`" = "vps1" ] && IP_ADDRESS="95.154.203.14"
[ "`hostname`" = "vps2" ] && IP_ADDRESS="95.154.203.15"
[ "`hostname`" = "test" ] && IP_ADDRESS="95.154.203.27"
[ "`hostname`" = "shared" ] && IP_ADDRESS="109.74.193.158"

$PREFIX./build-vps.sh \
	--initialize \
	--zlib \
	--openssl \
	--apr \
	--mysql "mysql" "3306" "mysql" "mysql" \
	--httpd "httpd" "80" "443" "httpd" "httpd" \
	--geoip "httpd" \
	--libiconv \
	--php "mysql" "httpd" "80" \
	--php-fpm "5.3" "mysql" \
	--php-fpm "5.4" "mysql" \
	--imagemagick \
	--phpmyadmin "mysql" "httpd" \
	--proftpd "mysql" \
	--postfix "mysql" \
	--dovecot "mysql" \
	--download \
	--remove-src-dirs \
	--finalize $IP_ADDRESS 2>&1 | tee build-vps.log
