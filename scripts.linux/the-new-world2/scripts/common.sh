#!/bin/bash
#
# File: common.sh
#
# Description: Common functions.
#
# Usage:
#
#	source ./common.sh

# parameters:
#	$1 str_to_remove
#	$2 file_name
function remove_from_file {

	TMP_FILE=/tmp/remove_from_file.$$
	TMP_STR='1h;1!H;${;g;s/'
	sed -n "$TMP_STR$1//g;p;}" $2 > $TMP_FILE && mv $TMP_FILE $2
}

# parameters:
#	$1 str_to_replace
#	$2 new_str
#	$3 file_name
function replace_in_file {

	TMP_FILE=/tmp/replace_in_file.$$
	sed "s/$1/$2/g" $3 > $TMP_FILE && mv $TMP_FILE $3
}

# parameters:
#	$1 string
#	$2 prefix
#	$3 suffix
function substring {

	NOPREF="${1#${1%${2}*}${2}}";
	echo "${NOPREF%${3}*}";
}

# parameters:
#	$1 directory
function strip_debug_symbols {

	ls -la $1/*
	du -ch $1/* | grep total
	strip --strip-debug $1/*
	du -ch $1/* | grep total
	ls -la $1/*
}

# parameters:
#	$1 file
function strip_debug_symbols_file {

	ls -la $1
	strip --strip-debug $1
	ls -la $1
}

# parameters:
#	$1 directory
function fix_libraries {

	ln -sfv $1/*.so* /lib/
	ln -sfv $1/*.so* /usr/lib/
	ln -sfv $1/*.a /usr/lib/
}

# parameters:
#	$1 certificate_name
function generate_certificate {

	$INSTALL_DIR/openssl/bin/openssl req \
		-new -x509 -nodes -sha1 -newkey rsa:2048 -days 1095 -subj "/O=unknown/OU=unknown/CN=$1" \
		-keyout $INSTALL_DIR/openssl/certs/$1.key \
		-out $INSTALL_DIR/openssl/certs/$1.crt
	cat $INSTALL_DIR/openssl/certs/$1.crt $INSTALL_DIR/openssl/certs/$1.key > $INSTALL_DIR/openssl/certs/$1.pem
	chmod 400 $INSTALL_DIR/openssl/certs/$1.{crt,key,pem}
}

# parameters:
#	$1 length
function get_random_string {

	STR=</dev/urandom tr -dc A-Za-z0-9 | (head -c $ > /dev/null 2>&1 || head -c $1)
	echo $STR
}

# parameters:
#	$1 instance_name
#	$2 url
function run_apache_performance_test {

	pkill httpd
	sleep 1
	$INSTALL_DIR/$1/bin/apachectl -k start
	sleep 3
	echo -e "\n\n *** Apache Benchmark ***\n"
	$INSTALL_DIR/$1/bin/ab -n 10000 -c 10 -k -r $2
	echo -e "\n\n"
	sleep 5
	$INSTALL_DIR/$1/bin/apachectl -k stop
}
