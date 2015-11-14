#!/bin/bash

# TODO:
#   log to /var/log/mysql.*
#   create resources/my.cnf

data_dir=$pkgs_dir/mysql/data

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    print_h3 'Run `cmake`'
    file_replace_str "USERNAME_CHAR_LENGTH 16" "USERNAME_CHAR_LENGTH 32" ./include/mysql_com.h
    file_replace_str "MYSQL_USERNAME_LENGTH 48" "MYSQL_USERNAME_LENGTH 96" ./include/mysql/plugin_auth_common.h
    file_replace_str "char authenticated_as\[48 \+\1];" "char authenticated_as\[96 \+ 1\];" ./include/mysql/plugin_auth.h.pp
    cmake . \
        -DCMAKE_INSTALL_PREFIX=$install_dir \
        -DINSTALL_LAYOUT=STANDALONE \
        -DMYSQL_DATADIR=$data_dir \
        -DSYSCONFDIR=$install_dir/conf \
        -DMYSQL_UNIX_ADDR=$install_dir/log/mysql.sock \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_SSL=system \
        -DWITH_ZLIB=system \
        -DWITH_EXTRA_CHARSETS=all \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DENABLE_DOWNLOADS=ON \
    && print_h3 'Run `make`' && make && sudo rm -rf $install_dir \
    && print_h3 'Run `make install`' && make install \
    && mkdir $install_dir/{conf,log} \
    && cp $install_dir/support-files/mysql.server $install_dir/bin \
    && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin
    dev_strip_symbols $install_dir/lib
    dev_strip_symbols $install_dir/lib/plugin

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/mysqld ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    user_exists "mysql" && user_delete "mysql"
    user_create "mysql" "mysql"
    mkdir -p $data_dir
    sudo chown -R mysql:mysql $data_dir
    rm -rf $install_dir/data

    # my.cnf
    cat << EOF > $install_dir/conf/my.cnf
[client]
port        = 3306
socket      = $install_dir/log/mysql.sock

[mysqld]
server-id   = 1
port        = 3306
socket      = $install_dir/log/mysql.sock
pid-file    = $install_dir/log/mysql.pid

character_set_server = utf8
collation_server = utf8_general_ci

max_allowed_packet = 4M
key_buffer_size = 256K
net_buffer_length = 2K
read_buffer_size = 128K
read_rnd_buffer_size = 256K
sort_buffer_size = 64K
table_open_cache = 8

thread_cache_size = 8
thread_stack = 256K

query_cache_type = ON
query_cache_size = 16M

skip-character-set-client-handshake
skip-external-locking

innodb_buffer_pool_size = 64M
innodb_data_file_path = ibdata1:10M:autoextend
innodb_data_home_dir = $data_dir
innodb_log_group_home_dir = $data_dir
innodb_flush_log_at_trx_commit = 1

explicit_defaults_for_timestamp = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

slow-query-log = ON
slow_query_log_file = $install_dir/log/mysql-slow-query.log
long_query_time = 10
log-slow-admin-statements

[mysqld_safe]
syslog

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M

[mysqlhotcopy]
interactive-timeout
EOF

    sudo chown -R mysql:mysql $install_dir
    (cd $install_dir; sudo $install_dir/scripts/mysql_install_db --verbose --user=mysql --basedir=$install_dir --datadir=$data_dir)
    sudo rm $install_dir/my*.cnf
    sudo chown -R $USER:$(id -g -n $USER) $install_dir
    sudo chown -R mysql:mysql $install_dir/log

    sudo $install_dir/bin/mysql.server start
    sleep 1
    $install_dir/bin/mysqladmin --user=root password root
    sleep 1
    sudo $install_dir/bin/mysql.server stop

fi

exit 0
