#!/bin/bash
#
# File: conf/includes.sh
#
# Description: Common constants and functions to include in shell scripts.
#
# Usage:
#
#   source conf/includes.sh

#
# include
#

# ssh
[ -f /root/.ssh/environment ] && \
    source /root/.ssh/environment

#
# options
#

shopt -s extglob

#
# variables
#

# installation directories
export INSTALL_DIR=/srv
export INSTALL_DIR_ESC=`echo "$INSTALL_DIR" | sed 's/\//\\\\\//g'`
export HOST4GE_DIR=$INSTALL_DIR/host4ge
export HOST4GE_DIR_ESC=`echo "$HOST4GE_DIR" | sed 's/\//\\\\\//g'`

# project directories
export BIN_DIR=$HOST4GE_DIR/bin
export CONF_DIR=$HOST4GE_DIR/conf
export LOG_DIR=$HOST4GE_DIR/log
# backup
export BACKUP_DIR=$HOST4GE_DIR/var/backup
export BACKUP_ACCOUNTS_DIR=$HOST4GE_DIR/var/backup/accounts
export BACKUP_DATABASES_DIR=$HOST4GE_DIR/var/backup/databases
export BACKUP_LOGS_DIR=$HOST4GE_DIR/var/backup/logs
# cache
export CACHE_DIR=$HOST4GE_DIR/var/cache
export DOWNLOADS_DIR=$HOST4GE_DIR/var/cache/downloads
export KERNELS_DIR=$HOST4GE_DIR/var/cache/kernels
export PACKAGES_DIR=$HOST4GE_DIR/var/cache/packages
export UPDATES_DIR=$HOST4GE_DIR/var/cache/updates
# hosting
export HOSTING_DIR=$HOST4GE_DIR/var/hosting
export HOSTING_ACCOUNTS_DIR=$HOST4GE_DIR/var/hosting/accounts
export HOSTING_APPLICATIONS_DIR=$HOST4GE_DIR/var/hosting/applications
# others
export CERTIFICATES_DIR=$HOST4GE_DIR/var/certificates
export MAIL_DIR=$HOST4GE_DIR/var/mail
export TMP_DIR=$HOST4GE_DIR/var/tmp
export WWW_DIR=$HOST4GE_DIR/var/www

# configuration files
export HOST4GE_CONF_FILE=$HOST4GE_DIR/conf/host4ge.conf
export CRONTAB_FILE=$HOST4GE_DIR/conf/.crontab
export DATABASE_USERS_FILE=$HOST4GE_DIR/conf/.database-users
export HASH_DIRECTORIES_FILE=$HOST4GE_DIR/conf/.hash-directories
export HASH_FILES_FILE=$HOST4GE_DIR/conf/.hash-files
export PACKAGES_FILE=$HOST4GE_DIR/conf/.packages
export PROFILE_FILE=$HOST4GE_DIR/conf/.profile
export REPOSITORIES_FILE=$HOST4GE_DIR/conf/.repositories

# perl library directory
export PERL5LIB=$HOST4GE_DIR/lib

# commands
export CMD_OPENSSL=/usr/bin/openssl
export CMD_MYSQL=$INSTALL_DIR/mysql/bin/mysql
export CMD_MYSQLDUMP=$INSTALL_DIR/mysql/bin/mysqldump
export CMD_APACHECTL=$INSTALL_DIR/httpd/bin/apachectl

# jobs
export JOB_LOG_EVENT_TIME=30 # 30 seconds
export JOB_LOCK_DIR=$TMP_DIR
export JOB_LOCK_ALL_FILE=$JOB_LOCK_DIR/host4ge-all-jobs.lock
export JOB_BACKUP_LOGS_REMOVE_DAYS=1095 # 3 years
export JOB_BACKUP_DATABASES_REMOVE_DAYS=92 # 3 months
export JOB_BACKUP_SITES_REMOVE_DAYS=21 # 3 weeks

# logs
export LOG_FILES="auth.log sys.log cron.log daemon.log kern.log user.log host4ge.log host4ge.err mysql.log mysql.err httpd.log httpd.err ftp.log mail.log mail.err"
export LOG_BACKUP_TMP_DIR=/tmp/log-backup
export LOG_BACKUP_FILE=$BACKUP_LOGS_DIR/log-backup.tar.gz

# text color
#txtred='\e[0;31m'       # red
#txtgrn='\e[0;32m'       # green
#txtylw='\e[0;33m'       # yellow
#txtblu='\e[0;34m'       # blue
#txtpur='\e[0;35m'       # purple
#txtcyn='\e[0;36m'       # cyan
#txtwht='\e[0;37m'       # white
#txtund=$(tput sgr 0 1)  # underline
#txtbld=$(tput bold)     # bold
#txtrst='\e[0m'          # reset

# system variables
export SSH_ENV=/root/.ssh/environment
export PERL5LIB=$HOST4GE_DIR/lib
export JAVA_HOME=$INSTALL_DIR/openjdk
export CATALINA_HOME=$INSTALL_DIR/tomcat

#
# functions
#

# parameters:
#   $1 text
function msg_info {
    echo -e "${txtcyn}${txtbld}$1${txtrst}"
}

# parameters:
#   $1 text
function msg_warn {
    echo -e "${txtylw}$1${txtrst}"
}

# parameters:
#   $1 text
function msg_error {
    echo -e "${txtred}$1${txtrst}"
}

# parameters:
#   --url <url>                         url address
#   --cache-dir-name <path>             cache directory (downloads|kernels|packages|updates)
#   --file <name>                       name of file
#   --donwload-directory <directory>    where file should be placed
#   --force                             force to download from given url
#   --check-file-size <size>            check file size on download
#   --do-not-cache                      do not cache file locally
function file_download {

    local URL=
    local CACHE_DIR_NAME="downloads"
    local FILE=
    local CURRENT_DOWNLOADS_DIR=./
    local FORCE="N"
    local FILE_SIZE=0
    local DO_NOT_CACHE="N"

    while [ "$1" != "" ]; do
        case $1 in
            --url)                  shift && URL=$1
                                    ;;
            --cache-dir-name)       shift && CACHE_DIR_NAME=$1
                                    ;;
            --file)                 shift && FILE=$1
                                    ;;
            --donwload-directory)   shift && CURRENT_DOWNLOADS_DIR=$1
                                    ;;
            --force)                FORCE="Y"
                                    ;;
            --check-file-size)      shift && FILE_SIZE=$1
                                    ;;
            --do-not-cache)         DO_NOT_CACHE="Y"
                                    ;;
        esac
        shift
    done

    # package may have already been downloaded
    if [ ! -s $CURRENT_DOWNLOADS_DIR/$FILE ] && [ -s $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [ $FORCE == "N" ]; then
        cp -f $CACHE_DIR/$CACHE_DIR_NAME/$FILE $CURRENT_DOWNLOADS_DIR
    else

        # are we at local network? try to download from the storage
        if [ ! -s $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [[ "$IP_ADDRESS" == 192.168.* ]] && [ $FORCE == "N" ]; then
            wget --tries=1 --connect-timeout=10 --user="$LOCAL_DOWNLOAD_USER" --password="$LOCAL_DOWNLOAD_PASS" $LOCAL_DOWNLOAD_URL/$CACHE_DIR_NAME/$FILE -O $FILE
            [ -s $FILE ] && mv -f $FILE $CACHE_DIR/$CACHE_DIR_NAME
            # check file size
            [ $FILE_SIZE != 0 ] && [ -f $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [ $FILE_SIZE -gt `ls -l $CACHE_DIR/$CACHE_DIR_NAME/$FILE | awk '{ print $5 }'` ] && rm $CACHE_DIR/$CACHE_DIR_NAME/$FILE
        fi
        # try to download it from the given URL address
        if ([ -n "$URL" ] && ([ ! -s $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] || [ $FORCE == "Y" ])); then
            wget --tries=1 --connect-timeout=10 $URL -O $FILE
            [ -s $FILE ] && mv -f $FILE $CACHE_DIR/$CACHE_DIR_NAME
            # check file size
            [ $FILE_SIZE != 0 ] && [ -f $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [ $FILE_SIZE -gt `ls -l $CACHE_DIR/$CACHE_DIR_NAME/$FILE | awk '{ print $5 }'` ] && rm $CACHE_DIR/$CACHE_DIR_NAME/$FILE
        fi
        # try to download it from custom location
        if [ ! -s $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [ $FORCE == "N" ]; then
            wget --tries=1 --connect-timeout=10 $ONLINE_DOWNLOAD_URL/$CACHE_DIR_NAME/$FILE -O $FILE
            [ -s $FILE ] && mv -f $FILE $CACHE_DIR/$CACHE_DIR_NAME
            # check file size
            [ $FILE_SIZE != 0 ] && [ -f $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [ $FILE_SIZE -gt `ls -l $CACHE_DIR/$CACHE_DIR_NAME/$FILE | awk '{ print $5 }'` ] && rm $CACHE_DIR/$CACHE_DIR_NAME/$FILE
        fi

        # permissions
        [ -s $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && chmod 400 $CACHE_DIR/$CACHE_DIR_NAME/$FILE

        # current download directory
        if [ -s $CACHE_DIR/$CACHE_DIR_NAME/$FILE ] && [ ! -s $CURRENT_DOWNLOADS_DIR/$FILE ]; then
            cp -f $CACHE_DIR/$CACHE_DIR_NAME/$FILE $CURRENT_DOWNLOADS_DIR
        fi

    fi

    # do not cache
    if [ "$DO_NOT_CACHE" == "Y" ] && [ -f $CACHE_DIR/$CACHE_DIR_NAME/$FILE ]; then
        rm $CACHE_DIR/$CACHE_DIR_NAME/$FILE
    fi

    # return value
    if [ -s $CURRENT_DOWNLOADS_DIR/$FILE ]; then
        echo "success"
    else
        echo "error"
    fi
}

# parameters:
#   $1 string to remove
#   $2 file name
function remove_from_file {

    local FILE=$TMP_DIR/remove_from_file.$$
    local STR='1h;1!H;${;g;s/'
    sed -n "$STR$1//g;p;}" $2 > $FILE && mv $FILE $2
}

# parameters:
#   $1 string to search for
#   $2 new string
#   $3 file name
function replace_in_file {

    local FILE=$TMP_DIR/replace_in_file.$$
    sed "s/$1/$2/g" $3 > $FILE && mv $FILE $3
}

# parameters:
#   $1 string to search for (regular expression, multiline)
#   $2 file name
function file_contains {

    local COUNT=$(cat $2 | grep -P "$1" | wc -l)
    if [ $COUNT -gt 0 ]; then
        echo "yes"
    else
        echo "no"
    fi
}

# parameters:
#   $1 string
#   $2 dir
function file_find_in {

    local STR=$1
    local DIR=$2

    if [ "$DIR" == "" ]; then
        find . -iname "*" | xargs grep -iR "$STR" | sort | uniq | grep -iR "$STR"
    else
        find $DIR -iname "*" | xargs grep -iR "$STR" | sort | uniq | grep -iR "$STR"
    fi
}

# parameters:
#   $1 string to search for
#   $2 new string
#   $3 dir
function file_replace_in {

    local STR1=$1
    local STR2=$2
    local DIR=$3

    if [ "$DIR" == "" ]; then
        find . -type f -name "*" -exec sed -i 's/$STR1/$STR2/' {} \;
    else
        find $DIR -type f -name "*" -exec sed -i 's/$STR1/$STR2/' {} \;
    fi
}

# parameters:
#   $1 string
#   $2 character to be used as a replacement
#   $3 max length
#   --allowed-characters <characters>
function sanitize {

    local STR=$1
    local CHAR=$2
    local LEN=255
    local ALLOW=

    # get max length
    if [ "$3" != "" ] && [ "$3" != "--allowed-characters" ]; then
        LEN=$3
    fi
    # get allowed characters
    while [ "$1" != "" ]; do
        case $1 in
            --allowed-characters)   shift && ALLOW=$1
                                    ;;
        esac
        shift
    done

    local SANITIZED=${STR//+([^A-Za-z0-9$ALLOW])/$CHAR}
    if [ -n "$LEN" ]; then
        SANITIZED=`echo $SANITIZED | cut -c1-$LEN`
    fi
    echo $SANITIZED | tr '[:upper:]' '[:lower:]'
}

# parameters:
#   $1 string
#   $2 prefix as string
#   $3 suffix as string
function substring {

    local STR="${1#${1%${2}*}${2}}";
    echo "${STR%${3}*}";
}

# parameters:
#   $1 directory
function strip_debug_symbols {

    ls -la $1/*
    du -ch $1/* | grep total
    strip --strip-debug $1/*
    du -ch $1/* | grep total
    ls -la $1/*
}

# parameters:
#   $1 file
function strip_debug_symbols_file {

    ls -la $1
    strip --strip-debug $1
    ls -la $1
}

# parameters:
#   $1 directory
function fix_libraries {

    # /lib
    ln -sfv $1/*.so* /lib/
    if [ -d /lib/x86_64-linux-gnu ]; then
        ln -sfv $1/*.so* /lib/x86_64-linux-gnu/
    fi

    # /usr/lib
    ln -sfv $1/*.so* /usr/lib/
    ln -sfv $1/*.a /usr/lib/
    if [ -d /usr/lib/x86_64-linux-gnu ]; then
        ln -sfv $1/*.so* /usr/lib/x86_64-linux-gnu/
        ln -sfv $1/*.a /usr/lib/x86_64-linux-gnu/
    fi
}

# parameters:
#   $1 certificate name
function generate_certificate {

    $CMD_OPENSSL req \
        -new -x509 -nodes -sha1 -newkey rsa:4096 -days 3650 -subj "/O=unknown/OU=unknown/CN=$1" \
        -keyout $CERTIFICATES_DIR/$1.key \
        -out $CERTIFICATES_DIR/$1.crt
    cat $CERTIFICATES_DIR/$1.crt $CERTIFICATES_DIR/$1.key > $CERTIFICATES_DIR/$1.pem
    chmod 400 $CERTIFICATES_DIR/$1.{crt,key,pem}
}

# parameters:
#   $1 length
function get_random_string {

    STR=</dev/urandom tr -dc A-Za-z0-9 | (head -c $ > /dev/null 2>&1 || head -c $1)
    echo $STR
}

# parameters:
#   $1 user
#   $2 uid
#   $3 group
#   $4 gid
#   --shell <shell>
function user_create {

    local TMP_USER=$1
    local TMP_UID=$2
    local TMP_GROUP=$3
    local TMP_GID=$4

    # get shell
    local TMP_SHELL=/usr/sbin/nologin
    while [ "$1" != "" ]; do
        case $1 in
            --shell)    shift && TMP_SHELL=$1
                        ;;
        esac
        shift
    done

    groupadd -g $TMP_GID $TMP_GROUP
    useradd -u $TMP_UID -d /dev/null -s $TMP_SHELL -g $TMP_GROUP $TMP_USER
}

# parameters:
#   $1 user
function user_exists {

    if [ `grep "^$1:" /etc/passwd | wc -l` == "1" ]; then
        echo "yes"
    else
        echo "no"
    fi
}

# parameters:
#   $1 group
function group_exists {

    if [ `grep "^$1:" /etc/group | wc -l` == "1" ]; then
        echo "yes"
    else
        echo "no"
    fi
}

# parameters:
#   $1 role
function server_add_role {

    # TODO
    echo TODO
}

# parameters:
#   $1 role
function server_remove_role {

    # TODO
    echo TODO
}

# parameters:
#   $1 role
function server_has_role {

    if [[ "$SERVER_ROLE" == *$1* ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

# parameters:
#   $1 mode
function server_set_mode {

    # TODO: save change in profile and crontab

    export SERVER_MODE=$1
}

function server_get_mode {

    echo $SERVER_MODE
}

# parameters:
#   $1 key
#   $1 value
function host4ge_conf_set_option {

    local KEY=$1
    local VALUE=$2

    local LINE=$(cat $HOST4GE_CONF_FILE | grep "^[ \t]*$KEY[ \t]*=")
    [ -n "$LINE" ] && replace_in_file "$LINE" "$KEY = $VALUE" $HOST4GE_CONF_FILE
    chmod 600 $HOST4GE_CONF_FILE
}

# parameters:
#   $1 key
function host4ge_conf_get_option {

    local KEY=$1

    local LINE=$(cat $HOST4GE_CONF_FILE | grep "^[ \t]*$KEY[ \t]*=")
    # TODO
}

# parameters:
#   $1 user
#   $2 password
function mysql_add_user_password {

    local FILE=$DATABASE_USERS_FILE
    local PASS=`mysql_get_user_password $1`

    if [ -z "$PASS" ]; then
        [ ! -f $FILE ] && touch $FILE
        echo "$1=$2" >> $FILE
        cat $FILE | grep -v '# ' | sort | uniq > $FILE.tmp
        mv $FILE.tmp $FILE
    else
        replace_in_file $PASS $2 $FILE
    fi
    chown root:root $FILE
    chmod 600 $FILE
}

# parameters:
#   $1 user
function mysql_get_user_password {

    local LINE=`cat $DATABASE_USERS_FILE | grep "$1="`
    local LEN=`expr length $1`
    local POS=`expr $LEN + 1`
    local PASS=${LINE:$POS}

    echo $PASS
}

# parameters:
#   $1 database
#   $2 dir
function mysql_backup_database_to_files {

    local DB_PASS=$(mysql_get_user_password root)

    local LIST=$(echo "use $1; show tables;" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1  ) { print } }')
    for ITEM in $LIST; do
        local COLLATION=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = '$1' and t.table_name = '$ITEM';" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1  ) { print } }')
        $CMD_MYSQLDUMP --user="root" --password="$DB_PASS" --default-character-set="$COLLATION" --extended-insert=FALSE --skip-comments "$1" "$ITEM" > $2/$ITEM.sql
        chmod 400 $2/$ITEM.sql
    done
}

# parameters:
#   $1 dir
#   $2 database
function mysql_restore_database_from_files {

    local DB_PASS=$(mysql_get_user_password root)

    local LIST=$(ls $1/*.sql)
    for ITEM in $LIST; do
        $CMD_MYSQL --user="root" --password="$DB_PASS" "$2" < $ITEM
    done
}

# parameters:
#   $1 database
#   $2 file
function mysql_backup_database_to_archive {

    local DB_PASS=$(mysql_get_user_password root)

    # TODO: include views
    local LIST=$(echo "use $1; show tables;" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1  ) { print } }')
    for ITEM in $LIST; do
        local COLLATION=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = '$1' and t.table_name = '$ITEM';" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1  ) { print } }')
        $CMD_MYSQLDUMP --user="root" --password="$DB_PASS" --default-character-set="$COLLATION" --extended-insert=FALSE --skip-comments "$1" "$ITEM" > $ITEM.sql
    done
    local COUNT=`ls *.sql | wc -l`
    if [ $COUNT -gt 0 ]; then
        [ -f $2 ] && rm $2
        tar -zcf $2 *.sql
        chmod 400 $2
        rm *.sql
    fi
}

# parameters:
#   $1 file
#   $2 database
function mysql_restore_database_from_archive {

    local DB_PASS=$(mysql_get_user_password root)

    tar -zxf $1
    local LIST=$(ls *.sql)
    for ITEM in $LIST; do
        $CMD_MYSQL --user="root" --password="$DB_PASS" "$2" < $ITEM
    done
    rm *.sql
}

# parameters:
#   $1 file
#   $2 database
#   $3 table prefix
function mysql_restore_database_from_file_prefix {

    local DB_PASS=$(mysql_get_user_password root)

    tar -zxf $1
    local LIST=$(ls *.sql)
    for ITEM in $LIST; do
        local BASENAME=$( basename $ITEM .sql )
        replace_in_file "\`$BASENAME\`" "\`$3$BASENAME\`" $ITEM
        $CMD_MYSQL --user="root" --password="$DB_PASS" "$2" < $ITEM
    done
    rm *.sql
}

# parameters:
#   $1 source database
#   $2 destination database
function mysql_copy_tables {

    [ "$1" == "$2" ] && exit 1

    local DB_PASS=$(mysql_get_user_password root)

    # TODO: include views
    local LIST=$(echo "use $1; show tables;" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1  ) { print } }')
    for ITEM in $LIST; do
        local COLLATION=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = '$1' and t.table_name = '$ITEM';" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1  ) { print } }')
        $CMD_MYSQLDUMP --user="root" --password="$DB_PASS" --default-character-set="$COLLATION" --extended-insert=FALSE --skip-comments "$1" "$ITEM" | $CMD_MYSQL --user="root" --password="$DB_PASS" "$2"
    done
}

# parameters:
#   $1 database
function mysql_create_database {

    local DB_PASS=$(mysql_get_user_password root)

    cat <<EOF | $CMD_MYSQL --user="root" --password="$DB_PASS"
create database $1;
EOF
}

# parameters:
#   $1 database
function mysql_drop_database {

    local DB_PASS=$(mysql_get_user_password root)

    cat <<EOF | $CMD_MYSQL --user="root" --password="$DB_PASS"
drop database if exists $1;
EOF
}

# parameters:
#   $1 databases
#   $2 user
#   $3 password
function mysql_create_user {

    local DB_PASS=$(mysql_get_user_password root)

    for DB in $1; do
        cat <<EOF | $CMD_MYSQL --user="root" --password="$DB_PASS"
grant all on $DB.* to '$2'@'localhost' identified by '$3';
EOF
    done
}

# parameters:
#   $1 user
function mysql_drop_user {

    local DB_PASS=$(mysql_get_user_password root)

    cat <<EOF | $CMD_MYSQL --user="root" --password="$DB_PASS"
drop user '$1'@'localhost';
EOF
}

function mysql_list_databases {

    local DB_PASS=$(mysql_get_user_password root)

    local LIST=$(echo "show databases;" | $CMD_MYSQL --user=root --password=$DB_PASS | awk '{ if ( NR > 1 ) { print } }')
    for ITEM in $LIST; do
        echo $ITEM
    done
}

# parameters:
#   $1 database
function mysql_database_exists {

    local COUNT=`mysql_list_databases | grep "^$1$" | wc -l`
    if [ "$COUNT" == "0" ]; then
        echo "no"
    else
        echo "yes"
    fi
}

function httpd_restart {

    job_lock_all

    local SEC=$(expr 60 - `date +"%S"`)
    [ $SEC -ge 55 ] && sleep 5

    logger -p local0.notice -t host4ge "httpd restart initiated"
    $CMD_APACHECTL -k stop
    sleep 30
    $CMD_APACHECTL -k start
    sleep 5

    job_unlock_all
}

# parameters:
#   $1 user
function ftp_account_exists {

    local DB_PASS=`mysql_get_user_password ftp`

    local USER=$(echo "select * from ftp.users where name = '$1';" | $CMD_MYSQL --user=ftp --password=$DB_PASS | awk '{ if ( NR > 1  ) { print $2 } }')
    if [ "$USER" == "$1" ]; then
        echo "yes"
    else
        echo "no"
    fi
}

# parameters:
#   $1 name
function job_lock_set {

    touch $JOB_LOCK_DIR/host4ge-$1.lock
}

# parameters:
#   $1 name
function job_lock_unset {

    rm $JOB_LOCK_DIR/host4ge-$1.lock > /dev/null 2>&1
}

# parameters:
#   $1 name
function job_lock_exists {

    if [ -f $JOB_LOCK_DIR/host4ge-$1.lock ] || [ -f $JOB_LOCK_ALL_FILE ]; then
        echo "yes"
    else
        echo "no"
    fi
}

function job_lock_all {

    touch $JOB_LOCK_ALL_FILE
    logger -p local0.notice -t host4ge "all jobs are locked"
}

function job_unlock_all {

    rm $JOB_LOCK_DIR/host4ge-*.lock > /dev/null 2>&1
    rm $JOB_LOCK_ALL_FILE > /dev/null 2>&1
    logger -p local0.notice -t host4ge "all jobs are unlocked"
}

# parameters:
#   $1 exclude (optional)
function job_lock_list {

    if [ -f $JOB_LOCK_ALL_FILE ]; then
        echo "all jobs are locked"
    else
        local LOCKS=`find $JOB_LOCK_DIR -iname host4ge-*.lock | sort`
        for LOCK in $LOCKS; do
            if [ -z "$1" ]; then
                echo $( basename $LOCK .lock ) | cut -c9-32
            else
                if [ "$( basename $LOCK .lock )" != "host4ge-$1" ]; then
                    echo $( basename $LOCK .lock ) | cut -c9-32
                fi
            fi
        done
    fi
}

function log_files_backup {

    local DIR=$LOG_BACKUP_TMP_DIR
    [ -d $DIR ] && rm -rf $DIR
    mkdir $DIR && chmod 700 $DIR

    for LOG in $LOG_FILES; do
        cp -p /var/log/$LOG* $DIR
    done
    local CURRENT_DIR=$PWD && cd $DIR
    tar -zcf $LOG_BACKUP_FILE *
    chmod 400 $LOG_BACKUP_FILE
    cd $CURRENT_DIR && rm -rf $DIR
}

function log_files_restore {

    [ ! -f $LOG_BACKUP_FILE ] && return
    read -n1 -p "are you sure you want to restore all log files (y/n)? "
    echo
    [[ ! $REPLY = [yY] ]] && return

    local DIR=$LOG_BACKUP_TMP_DIR
    [ -d $DIR ] && rm -rf $DIR
    mkdir $DIR && chmod 700 $DIR

    tar -zxf $LOG_BACKUP_FILE -C $DIR
    local CURRENT_DIR=$PWD && cd $DIR
    for LOG in $LOG_FILES; do
        local FILES=`ls $LOG*`
        for FILE in $FILES; do
            if [ $LOG == $FILE ] && [ -f /var/log/$FILE ]; then
                cat $FILE /var/log/$FILE > $FILE.merge
                chown syslog:syslog $FILE.merge
                chmod 600 $FILE.merge
                mv -f $FILE.merge /var/log/$FILE
                logger -p local0.notice -t host4ge "merged log file $FILE"
            else
                mv $FILE /var/log
            fi
        done
    done
    cd $CURRENT_DIR && rm -rf $DIR
}

# parameters:
#   $1 dir
function hashes_add_dir {

    local FILE=$HASH_DIRECTORIES_FILE

    [ ! -f $FILE ] && touch $FILE
    echo $1 >> $FILE

    cat $FILE | grep -v '# ' | sort | uniq > $FILE.tmp
    mv $FILE.tmp $FILE

    chown root:root $FILE
    chmod 600 $FILE
}

# parameters:
#   $1 dir
#   $2 pattern
function hashes_get_files_recursively {

    find $1 -type f -name "$2" | sort | xargs sha1sum
}

function hashes_create_list {

    local FILE1=$HASH_DIRECTORIES_FILE
    local FILE2=$HASH_FILES_FILE

    [ -f $FILE2 ] && rm $FILE2
    while read DIR; do
        [ -d "$DIR" ] && hashes_get_files_recursively "$DIR" "*" >> $FILE2
    done < $FILE1
    [ ! -f $FILE2 ] && touch $FILE2

    chown root:root $FILE2
    chmod 600 $FILE2
}

function hashes_count_bad {

    local FILE=$HASH_FILES_FILE

    sha1sum -c $FILE | grep -v ': OK$' | wc -l
}

function hashes_list_bad {

    local FILE=$HASH_FILES_FILE

    sha1sum -c $FILE | grep -v ': OK$'
}

# parameters:
#   $1 dir
function repositories_add_dir {

    local FILE=$REPOSITORIES_FILE

    [ ! -f $FILE ] && touch $FILE
    echo $1 >> $FILE

    cat $FILE | grep -v '# ' | sort | uniq > $FILE.tmp
    mv $FILE.tmp $FILE

    chown root:root $FILE
    chmod 600 $FILE
}

# parameters:
#   $1 name
#   $2 donwload directory
#   --check-file-size <size>
function package_download {

    local FILE=$(sanitize $1 '-' --allowed-characters '\.').pkg
    local CURRENT_DOWNLOADS_DIR=./
    local FILE_SIZE=0

    # get minimum file size
    while [ "$1" != "" ]; do
        case $1 in
            --check-file-size)  shift && FILE_SIZE=$1
                                ;;
        esac
        shift
    done

    # package may have already been downloaded
    if [ ! -s $PACKAGES_DIR/$FILE ]; then

        # are we at local network? try to download from the storage
        if [ ! -s $PACKAGES_DIR/$FILE ] && [[ "$IP_ADDRESS" == 192.168.* ]]; then
            wget --tries=1 --connect-timeout=10 --user="$LOCAL_DOWNLOAD_USER" --password="$LOCAL_DOWNLOAD_PASS" $LOCAL_DOWNLOAD_URL/packages/$FILE -O $FILE
            [ -s $FILE ] && mv -f $FILE $PACKAGES_DIR
            # check file size
            [ $FILE_SIZE != 0 ] && [ -f $PACKAGES_DIR/$FILE ] && [ $FILE_SIZE -gt `ls -l $PACKAGES_DIR/$FILE | awk '{ print $5 }'` ] && rm $PACKAGES_DIR/$FILE
        fi
        # try to download it from custom location
        if [ ! -s $PACKAGES_DIR/$FILE ]; then
            wget $ONLINE_DOWNLOAD_URL/packages/$FILE -O $FILE
            [ -s $FILE ] && mv -f $FILE $PACKAGES_DIR
            # check file size
            [ $FILE_SIZE != 0 ] && [ -f $PACKAGES_DIR/$FILE ] && [ $FILE_SIZE -gt `ls -l $PACKAGES_DIR/$FILE | awk '{ print $5 }'` ] && rm $PACKAGES_DIR/$FILE
        fi

        # set permissions
        [ -s $PACKAGES_DIR/$FILE ] && chmod 400 $PACKAGES_DIR/$FILE

        # copy to the destination directory
        if [ -s $PACKAGES_DIR/$FILE ] && [ ! -s $CURRENT_DOWNLOADS_DIR/$FILE ]; then
            cp -f $PACKAGES_DIR/$FILE $CURRENT_DOWNLOADS_DIR
        fi

    fi

    # return value
    if [ -s $PACKAGES_DIR/$FILE ]; then
        echo "success"
    else
        echo "error"
    fi
}

# parameters:
#   $1 dir
#   $2 name
function package_create {

    local DIR=$1
    local ARCHIVE=$(sanitize $2 '-' --allowed-characters '\.').pkg
    local CURRENT_DIR=`pwd`

    cd $DIR/..
    tar -zcf $ARCHIVE $(basename $DIR)
    mv -v $ARCHIVE $PACKAGES_DIR
    chmod 400 $PACKAGES_DIR/$ARCHIVE

    cd $CURRENT_DIR
}

# parameters:
#   $1 dir
#   $2 name
#   $3 files
function package_create_files {

    local DIR=$1
    local ARCHIVE=$(sanitize $2 '-' --allowed-characters '\.').pkg
    local FILES=$3
    local CURRENT_DIR=`pwd`

    cd $DIR
    tar -zcf $ARCHIVE $FILES
    mv -v $ARCHIVE $PACKAGES_DIR
    chmod 400 $PACKAGES_DIR/$ARCHIVE

    cd $CURRENT_DIR
}

# parameters:
#   $1 name
function package_restore {

    local NAME=$(sanitize $1 '-' --allowed-characters '\.')
    local ARCHIVE=$NAME.pkg
    local DESTINATION_DIR=$INSTALL_DIR
    local CURRENT_DIR=`pwd`

    cd $PACKAGES_DIR
    if [ -f $ARCHIVE ]; then
        [ -d $NAME ] && rm -rf $NAME
        mkdir $NAME
        cp $ARCHIVE $NAME
        cd $NAME
        tar -zxf $ARCHIVE
        rm $ARCHIVE
        DIR_NAME=$(ls -1)
        [ -d $DESTINATION_DIR/$DIR_NAME ] && rm -rf $DESTINATION_DIR/$DIR_NAME
        mv -v * $DESTINATION_DIR
        cd ..
        rm -rf $NAME
    fi

    cd $CURRENT_DIR
}

# parameters:
#   $1 name
#   $2 dir
function package_restore_files {

    local NAME=$(sanitize $1 '-' --allowed-characters '\.')
    local ARCHIVE=$NAME.pkg
    local DESTINATION_DIR=$2
    local CURRENT_DIR=`pwd`

    cd $PACKAGES_DIR
    if [ -f $ARCHIVE ] && [ -d $DESTINATION_DIR ]; then
        cp $ARCHIVE $DESTINATION_DIR
        cd $DESTINATION_DIR
        tar -zxvf $ARCHIVE
        rm $ARCHIVE
    fi

    cd $CURRENT_DIR
}

# parameters:
#   $1 package
#   $2 version
function package_add_version {

    local FILE=$PACKAGES_FILE
    local PKG=$(sanitize $1 '-')
    local VERSION=$2

    if [ -f $FILE ]; then
        cat $FILE | grep -v "$PKG=" > $FILE.tmp
        mv $FILE.tmp $FILE
    else
        touch $FILE
    fi
    echo "$PKG=$VERSION" >> $FILE

    cat $FILE | grep -v '# ' | sort | uniq > $FILE.tmp
    mv $FILE.tmp $FILE

    chown root:root $FILE
    chmod 600 $FILE
}

# parameters:
#   $1 package
function package_get_version {

    local PKG=$(sanitize $1 '-')

    local LINE=`cat $PACKAGES_FILE | grep "$PKG="`
    local LEN=`expr length $PKG`
    local POS=`expr $LEN + 1`
    local VER=${LINE:$POS}

    echo $VER
}

# parameters:
#   $1 package
function package_is_installed {

    local PKG=$(sanitize $1 '-')

    if [ -n "$(cat $PACKAGES_FILE | grep ^$PKG=.*)" ]; then
        echo "yes"
    else
        echo "no"
    fi
}

# parameters:
#   $1 version
#   $2 version
function package_cmp_ver () {

    if [[ $1 == $2 ]]; then
        echo 0
        return
    fi

    local IFS=.
    local i ver1=($1) ver2=($2)

    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            echo 1
            return
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            echo -1
            return
        fi
    done

    echo 0
}
