#!/bin/bash

##
## variables
##

MYSQL_NAME=
MYSQL_PORT=
MYSQL_USER=
MYSQL_GROUP=

DEFAULT_CHARSET="utf8"
DEFAULT_COLLATION="utf8_general_ci"
#if [ "$LOCATION" == "GB" ]; then
#    DEFAULT_CHARSET="utf8"
#    DEFAULT_COLLATION="utf8_general_ci"
#fi
#if [ "$LOCATION" == "PL" ]; then
#    DEFAULT_CHARSET="latin1"
#    DEFAULT_COLLATION="latin1_swedish_ci"
#fi
MYSQL_CONFIGURE_OPTIONS="-DDEFAULT_CHARSET=$DEFAULT_CHARSET -DDEFAULT_COLLATION=$DEFAULT_COLLATION"

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --mysql)    shift && MYSQL_NAME=$1
                    shift && MYSQL_PORT=$1
                    shift && MYSQL_USER=$1
                    shift && MYSQL_GROUP=$1
                    ;;
    esac
    shift
done

##
## download
##

PKG_NAME="mysql-$MYSQL_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-$MYSQL_VERSION.tar.gz/from/http://mysql.mirrors.ovh.net/ftp.mysql.com/"
    FILE=mysql-$MYSQL_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 20000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

pkill mysql

# create user and group
user_create "$MYSQL_USER" 510 "$MYSQL_GROUP" 510

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile MySQL":
    [ -d $INSTALL_DIR/$MYSQL_NAME ] && rm -rf $INSTALL_DIR/$MYSQL_NAME
    tar -zxf mysql-$MYSQL_VERSION.tar.gz
    cd mysql-$MYSQL_VERSION
    replace_in_file "USERNAME_CHAR_LENGTH 16" "USERNAME_CHAR_LENGTH 32" ./include/mysql_com.h
    replace_in_file "MYSQL_USERNAME_LENGTH 48" "MYSQL_USERNAME_LENGTH 96" ./include/mysql/plugin_auth_common.h
    replace_in_file "char authenticated_as\[48 +1\];" "char authenticated_as\[96 + 1\];" ./include/mysql/plugin_auth.h.pp
    cmake . \
        -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$MYSQL_NAME \
        -DMYSQL_DATADIR=$INSTALL_DIR/$MYSQL_NAME/data \
        -DSYSCONFDIR=$INSTALL_DIR/$MYSQL_NAME/conf \
        -DMYSQL_UNIX_ADDR=$INSTALL_DIR/$MYSQL_NAME/log/mysql.sock \
        -DMYSQL_TCP_PORT=$MYSQL_PORT \
        -DWITH_EXTRA_CHARSETS=all \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_ZLIB=system \
        -DWITH_SSL=system \
        $MYSQL_CONFIGURE_OPTIONS \
    && make && make install && echo "MySQL installed successfully!" \
    && rm -rf $INSTALL_DIR/$MYSQL_NAME/{data/test,docs,man,mysql-test,sql-bench} \
    && rm -f $INSTALL_DIR/$MYSQL_NAME/{COPYING,INSTALL-BINARY,README} \
    && mkdir $INSTALL_DIR/$MYSQL_NAME/{conf,log}
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/$MYSQL_NAME/bin
    strip_debug_symbols $INSTALL_DIR/$MYSQL_NAME/lib
    strip_debug_symbols $INSTALL_DIR/$MYSQL_NAME/lib/plugin
    echo "Create package:"
    package_create $INSTALL_DIR/$MYSQL_NAME $PKG_NAME
else
    echo "Install MySQL from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/$MYSQL_NAME/bin/mysqld ]; then
    echo "Error: MySQL has NOT been installed successfully!"
    exit 1
fi

# TODO: http://www.webhostingtalk.pl/topic/31466-optymalizacja-mysql/

##
## configure
##

# create link to mysql_config
ln -s $INSTALL_DIR/$MYSQL_NAME/bin/mysql_config /bin/

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

# make sure all logs end up in syslog
replace_in_file "logger -t '\\\$syslog_tag_mysqld' -p daemon.error" "$HOST4GE_DIR_ESC\/bin\/additional-scripts\/support\/log-mysql.pl info" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "syslog_tag_mysqld=mysqld" "syslog_tag_mysqld=mysql" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "syslog_tag_mysqld_safe=mysqld_safe" "syslog_tag_mysqld_safe=mysql" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "daemon.notice" "local3.info" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
replace_in_file "daemon.error" "local3.err" $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe
chmod +x $INSTALL_DIR/$MYSQL_NAME/bin/mysqld_safe

MEMORY=$(echo `free -m` | awk '{ print $8 }')
INNODB_BUFFER_POOL_SIZE=32
[ $MEMORY -gt 512 ] && INNODB_BUFFER_POOL_SIZE=64
[ $MEMORY -gt 1024 ] && INNODB_BUFFER_POOL_SIZE=128
[ $MEMORY -gt 1536 ] && INNODB_BUFFER_POOL_SIZE=192
[ $MEMORY -gt 2048 ] && INNODB_BUFFER_POOL_SIZE=256

# my.cnf
cp $INSTALL_DIR/$MYSQL_NAME/support-files/my-small.cnf $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "thread_stack = 128K" "thread_stack = 256K" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "#innodb_" "innodb_" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_buffer_pool_size = 16M" "innodb_buffer_pool_size = ${INNODB_BUFFER_POOL_SIZE}M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_additional_mem_pool_size = 2M" "innodb_additional_mem_pool_size = 2M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_log_file_size = 5M" "innodb_log_file_size = 5M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
replace_in_file "innodb_log_buffer_size = 8M" "innodb_log_buffer_size = 8M" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
# FIXME: http://dev.mysql.com/doc/refman/5.5/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit
# if set to 1 mysql restore from SQL file takes ages on erth.host4ge.com
replace_in_file "innodb_flush_log_at_trx_commit = 1" "innodb_flush_log_at_trx_commit = 0" $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf
(   echo -e "\n[mysqld]" && \
    echo -e "character_set_server=$DEFAULT_CHARSET" && \
    echo -e "collation_server=$DEFAULT_COLLATION" && \
    echo -e "skip-character-set-client-handshake" && \
    echo -e "#default-storage-engine = MyISAM" && \
    echo -e "pid-file=$INSTALL_DIR/$MYSQL_NAME/log/mysql.pid" && \
    echo -e "#slow_query_log=1" && \
    echo -e "#slow_query_log_file=$INSTALL_DIR/$MYSQL_NAME/log/mysql-slow.log" && \
    echo -e "#long_query_time=3" && \
    echo -e "#log-slow-admin-statements" && \
    echo -e "\n[mysqld_safe]" && \
    echo -e "syslog" \
) >> $INSTALL_DIR/$MYSQL_NAME/conf/my.cnf

if [ "$CHROOT" == "N" ]; then

    # install
    chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/$MYSQL_NAME
    CURRNET_DIR=`pwd`
    cd $INSTALL_DIR/$MYSQL_NAME && scripts/mysql_install_db --user=$MYSQL_USER
    cd $CURRNET_DIR

    # mysql.server
    cp $INSTALL_DIR/$MYSQL_NAME/support-files/mysql.server $INSTALL_DIR/$MYSQL_NAME/bin
    chmod +x $INSTALL_DIR/$MYSQL_NAME/bin/mysql.server

    # set password
    MYSQL_ROOT_PASSWORD=`get_random_string 32`
    mysql_add_user_password "root" "$MYSQL_ROOT_PASSWORD"
    # prepare database server
    rm -rf $INSTALL_DIR/$MYSQL_NAME/data/test
    $INSTALL_DIR/$MYSQL_NAME/bin/mysql.server start
    sleep 5
    echo "use mysql; delete from db;" | $INSTALL_DIR/$MYSQL_NAME/bin/mysql --user=root
    sleep 1
    echo "show global variables;" | $INSTALL_DIR/$MYSQL_NAME/bin/mysql --user=root
    sleep 1
    $INSTALL_DIR/$MYSQL_NAME/bin/mysqladmin --user=root password $MYSQL_ROOT_PASSWORD
    sleep 1
    $INSTALL_DIR/$MYSQL_NAME/bin/mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown
    sleep 3
    # clear password variable
    MYSQL_ROOT_PASSWORD=

fi

# set files permission
chown -R root:root $INSTALL_DIR/$MYSQL_NAME
chown -R $MYSQL_USER:$MYSQL_GROUP $INSTALL_DIR/$MYSQL_NAME/{data,log}
chmod 755 $INSTALL_DIR/$MYSQL_NAME/bin
chmod 500 $INSTALL_DIR/$MYSQL_NAME/bin/*
chmod 555 $INSTALL_DIR/$MYSQL_NAME/bin/{mysql,mysqldump}
chmod 700 $INSTALL_DIR/$MYSQL_NAME/data/{,mysql}
chmod 755 $INSTALL_DIR/$MYSQL_NAME/log

##
## post install
##

[ -f mysql-$MYSQL_VERSION.tar.gz ] && rm mysql-$MYSQL_VERSION.tar.gz
[ -d mysql-$MYSQL_VERSION ] && rm -rf mysql-$MYSQL_VERSION

# log event
logger -p local0.notice -t host4ge "mysql $MYSQL_VERSION installed successfully"

# save package version
package_add_version "mysql" "$MYSQL_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/$MYSQL_NAME/bin
hashes_add_dir $INSTALL_DIR/$MYSQL_NAME/lib

exit 0
