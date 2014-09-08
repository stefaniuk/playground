#!/bin/bash

##
## variables
##

MYSQL_VERSION="5.5.14"
MYSQL_NAME=
MYSQL_PORT=
MYSQL_USER=
MYSQL_GROUP=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--mysql)	shift
					MYSQL_NAME=$1
					shift
					MYSQL_PORT=$1
					shift
					MYSQL_USER=$1
					shift
					MYSQL_GROUP=$1
					;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: MySQL requires zlib!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: MySQL requires OpenSSL!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f mysql.tar.gz ]; then
	wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-$MYSQL_VERSION.tar.gz/from/http://mysql.mirrors.ovh.net/ftp.mysql.com/ -O mysql.tar.gz
fi
if [ ! -f mysql.tar.gz ]; then
	echo "Error: Unable to download mysql.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing MySQL":
pkill mysql
[ -d $INSTALL_DIR/$MYSQL_NAME ] && rm -rf $INSTALL_DIR/$MYSQL_NAME
tar -zxf mysql.tar.gz
cd mysql-$MYSQL_VERSION
cmake . \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$MYSQL_NAME \
	-DMYSQL_DATADIR=$INSTALL_DIR/$MYSQL_NAME/data \
	-DSYSCONFDIR=$INSTALL_DIR/$MYSQL_NAME/conf \
	-DMYSQL_UNIX_ADDR=$INSTALL_DIR/$MYSQL_NAME/log/mysql.sock \
	-DMYSQL_TCP_PORT=$MYSQL_PORT \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci \
	-DWITH_EXTRA_CHARSETS=all \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_SSL=system \
	-DWITH_ZLIB=system \
&& make && make install && echo "MySQL installed successfully!"
cd ..

# check
if [ ! -f $INSTALL_DIR/$MYSQL_NAME/bin/mysqld ]; then
	echo "Error: MySQL has NOT been installed successfully!"
	exit 1
fi

# directories' structure
rm -rf $INSTALL_DIR/$MYSQL_NAME/{docs,man,mysql-test,sql-bench}
rm -f $INSTALL_DIR/$MYSQL_NAME/{COPYING,INSTALL-BINARY,README}
mkdir $INSTALL_DIR/$MYSQL_NAME/{.details,conf,log}
echo -n > $INSTALL_DIR/$MYSQL_NAME/.details/.users
wget http://mysqltuner.com/mysqltuner.pl && cp -v mysqltuner.pl $INSTALL_DIR/$MYSQL_NAME/bin/

# TODO: http://www.webhostingtalk.pl/topic/31466-optymalizacja-mysql/

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/$MYSQL_NAME/bin
strip_debug_symbols $INSTALL_DIR/$MYSQL_NAME/lib
strip_debug_symbols $INSTALL_DIR/$MYSQL_NAME/lib/plugin

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/$MYSQL_NAME/lib

echo "Shared library dependencies for $INSTALL_DIR/$MYSQL_NAME/bin/mysqld:"
ldd $INSTALL_DIR/$MYSQL_NAME/bin/mysqld
echo "Shared library dependencies for $INSTALL_DIR/$MYSQL_NAME/bin/mysql:"
ldd $INSTALL_DIR/$MYSQL_NAME/bin/mysql

echo "Copy includes:"
rm -rf /usr/include/mysql
cp -rv $INSTALL_DIR/$MYSQL_NAME/include /usr/include/mysql
rm -rfv /usr/include/mysql/mysql

# create links to the log files
ln -sfv /var/log/mysql.log $INSTALL_DIR/$MYSQL_NAME/log/mysql.log
ln -sfv /var/log/mysql.err $INSTALL_DIR/$MYSQL_NAME/log/mysql.err

# copy script that will pipe logs to the syslog
cp -v $INSTALL_DIR/conf/log-mysql.pl $INSTALL_DIR/$MYSQL_NAME/bin

# make sure all logs end up in syslog
replace_in_file "logger -t '\\\$syslog_tag_mysqld' -p daemon.error" "$INSTALL_DIR_ESC\/$MYSQL_NAME\/bin\/log-mysql.pl info" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "syslog_tag_mysqld=mysqld" "syslog_tag_mysqld=mysql" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "syslog_tag_mysqld_safe=mysqld_safe" "syslog_tag_mysqld_safe=mysql" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "daemon.notice" "local3.info" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "daemon.error" "local3.err" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
chmod +x $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe

# my.cnf
cp $INSTALL_DIR/$MYSQL_NAME/support-files/my-small.cnf $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "#innodb_" "innodb_" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_buffer_pool_size = 16M" "innodb_buffer_pool_size = 4M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_additional_mem_pool_size = 2M" "innodb_additional_mem_pool_size = 1M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_log_file_size = 5M" "innodb_log_file_size = 1M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_log_buffer_size = 8M" "innodb_log_buffer_size = 2M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
(	echo -e "\n[mysqld]" && \
	echo -e "default-storage-engine = MyISAM" && \
	echo -e "pid-file=$INSTALL_DIR/$MYSQL_NAME/log/mysql.pid" && \
	echo -e "#slow_query_log=1" && \
	echo -e "#slow_query_log_file=$INSTALL_DIR/$MYSQL_NAME/log/mysql-slow.log" && \
	echo -e "#long_query_time=3" && \
	echo -e "#log-slow-admin-statements" && \
	echo -e "\n[mysqld_safe]" && \
	echo -e "syslog" \
) >> $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf

# create user and group
groupadd -g 510 $MYSQL_GROUP
useradd -u 510 -d /dev/null -s /usr/sbin/nologin -g $MYSQL_GROUP $MYSQL_USER

# install
chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/$MYSQL_NAME
cd $INSTALL_DIR/$MYSQL_NAME && scripts/mysql_install_db --user=$MYSQL_USER && cd $WORKING_DIR

# mysql.server
cp $INSTALL_DIR/$MYSQL_NAME/support-files/mysql.server $INSTALL_DIR/$MYSQL_NAME/bin
chmod +x $INSTALL_DIR/$MYSQL_NAME/bin/mysql.server

# test and prepare database server
rm -rf $INSTALL_DIR/$MYSQL_NAME/bin/mysql/data/test
$INSTALL_DIR/$MYSQL_NAME/bin/mysql.server start
sleep 5 # the script may fail without this
echo "use mysql; delete from db;" | $INSTALL_DIR/$MYSQL_NAME/bin/mysql -u root
sleep 1 # the script may fail without this
$INSTALL_DIR/$MYSQL_NAME/bin/mysqladmin -u root shutdown
sleep 3 # the script may fail without this

# set files permission
chown -R root:root $INSTALL_DIR/$MYSQL_NAME
chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/$MYSQL_NAME/{data,log}
chmod 500 $INSTALL_DIR/$MYSQL_NAME/.details
chmod 600 $INSTALL_DIR/$MYSQL_NAME/.details/.users
chmod 500 $INSTALL_DIR/$MYSQL_NAME/bin
chmod 500 $INSTALL_DIR/$MYSQL_NAME/bin/*
chmod 700 $INSTALL_DIR/$MYSQL_NAME/{data,log}

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f mysql.tar.gz ] && rm mysql.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d mysql-$MYSQL_VERSION ] && rm -rf mysql-$MYSQL_VERSION
