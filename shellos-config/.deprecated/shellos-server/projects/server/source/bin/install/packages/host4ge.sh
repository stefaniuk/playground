#!/bin/bash

##
## variables
##

HOST4GE_MYSQL_NAME=
HOST4GE_DB_NAME="host4ge"
HOST4GE_DB_USER="host4ge"
HOST4GE_DB_PASS=`get_random_string 32`

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --host4ge)  shift && HOST4GE_MYSQL_NAME=$1
                    ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$HOST4GE_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: Host4ge requires MySQL!"
    exit 1
fi

##
## install database
##

# create user and group
user_create "host4ge" 500 "host4ge" 500

# get mysql root password
MYSQL_ROOT_PASSWORD=`mysql_get_user_password root`
# config database
$INSTALL_DIR/$HOST4GE_MYSQL_NAME/bin/mysql.server start
sleep 5
# create database
$INSTALL_DIR/$HOST4GE_MYSQL_NAME/bin/mysql --user="root" --password="$MYSQL_ROOT_PASSWORD" < $HOST4GE_DIR/bin/install/packages/host4ge/host4ge.sql
# create database user
cat <<EOF | $INSTALL_DIR/$HOST4GE_MYSQL_NAME/bin/mysql --user=root --password=$MYSQL_ROOT_PASSWORD
GRANT ALL PRIVILEGES ON $HOST4GE_DB_NAME.* TO $HOST4GE_DB_USER@localhost IDENTIFIED BY '$HOST4GE_DB_PASS';
EOF
# create admin mailbox
$HOST4GE_DIR/bin/mail_account_create.pl -m "admin@$(hostname).$DOMAIN" -p "`get_random_string 32`"
sleep 1
$INSTALL_DIR/$HOST4GE_MYSQL_NAME/bin/mysqladmin --user="root" --password="$MYSQL_ROOT_PASSWORD" shutdown
sleep 3
# clear password variable
MYSQL_ROOT_PASSWORD=

##
## configure database
##

mysql_add_user_password "$HOST4GE_DB_USER" "$HOST4GE_DB_PASS"
host4ge_conf_set_option "db_name" "$HOST4GE_DB_NAME"
host4ge_conf_set_option "db_user" "$HOST4GE_DB_USER"
host4ge_conf_set_option "db_pass" "$HOST4GE_DB_PASS"

# add directories to create hashes
hashes_add_dir $HOST4GE_DIR/bin
hashes_add_dir $HOST4GE_DIR/lib
hashes_add_dir $HOST4GE_DIR/var/download

exit 0
