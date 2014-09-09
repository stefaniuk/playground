#!/bin/bash

# Replaces string by new string in the given file.
#
# parameters:
#   $1 string to search for
#   $2 new string
#   $3 file name
function replace_in_file() {

    local file=$TMP_DIR/replace_in_file.$$
    sed "s/$1/$2/g" $3 > $file && mv $file $3
}

# Downloads file from the given URL address.
#
# parameters:
#   --url <url>                         url address of the file to download
#   --force                             force to download from the given url
#                                       address not using a cached file or
#                                       an alternative location
#   --file <name>                       name of an output file
#   --cache-dir-name <name>             cache directory name; file name in that
#                                       directory must match the file name given
#                                       as the parameter
#   --donwload-directory <directory>    destination directory, where the file
#                                       should be placed after download
#   --check-file-size <size>            check file size after download
#   --do-not-cache                      do not cache file locally
function file_download() {

    # variables
    local url=
    local force="N"
    local file=
    local cache_dir_name=$CACHE_DOWNLOADS_DIR
    local current_download_dir=./
    local file_size=0
    local do_not_cache="N"
    local current_dir=$(pwd)

    # arguments
    while [ "$1" != "" ]; do
        case $1 in
            --url)                  shift; url=$1
                                    ;;
            --force)                force="Y"
                                    ;;
            --file)                 shift; file=$1
                                    ;;
            --cache-dir-name)       shift; cache_dir_name=$1
                                    ;;
            --donwload-directory)   shift; current_download_dir=$1
                                    ;;
            --check-file-size)      shift; file_size=$1
                                    ;;
            --do-not-cache)         do_not_cache="Y"
                                    ;;
        esac
        shift
    done

    # file may have already been downloaded
    if [ $force == "N" ] && [ -s $CACHE_DIR/$cache_dir_name/$file ] && \
            [ ! -s $current_download_dir/$file ]; then

        cp -f $CACHE_DIR/$cache_dir_name/$file $current_download_dir

    else

        # local network available, so try to download from a local storage
        if [ ! -s $CACHE_DIR/$cache_dir_name/$file ] && [[ "$IP_ADDRESS" == 192.168.* ]] && [ $force == "N" ]; then
            # try to download
            wget \
                --tries=1 \
                --connect-timeout=10 \
                --user="$LOCAL_DOWNLOAD_USER" \
                --password="$LOCAL_DOWNLOAD_PASS" \
                $LOCAL_DOWNLOAD_URL/$cache_dir_name/$file -O $file
            # cache file
            [ -s $file ] && mv -f $file $CACHE_DIR/$cache_dir_name
            # check file size
            if [ $file_size != 0 ] && [ -f $CACHE_DIR/$cache_dir_name/$file ]; then
                local size=$(ls -l $CACHE_DIR/$cache_dir_name/$file | awk '{ print $5 }')
                if [ $file_size -gt $size ]; then
                    rm -f $CACHE_DIR/$cache_dir_name/$file
                fi
            fi
        fi

        # try to download from the given url address
        if ([ -n "$url" ] && ([ ! -s $CACHE_DIR/$cache_dir_name/$file ] || [ $force == "Y" ])); then
            # try to download
            wget \
                --tries=1 \
                --connect-timeout=10 \
                $url -O $file
            # cache file
            [ -s $file ] && mv -f $file $CACHE_DIR/$cache_dir_name
            # check file size
            if [ $file_size != 0 ] && [ -f $CACHE_DIR/$cache_dir_name/$file ]; then
                local size=$(ls -l $CACHE_DIR/$cache_dir_name/$file | awk '{ print $5 }')
                if [ $file_size -gt $size ]; then
                    rm -f $CACHE_DIR/$cache_dir_name/$file
                fi
            fi
        fi

        # try to download from a custom location
        if [ ! -s $CACHE_DIR/$cache_dir_name/$file ] && [ $force == "N" ]; then
            # try to download
            wget \
                --tries=1 \
                --connect-timeout=10 \
                $ONLINE_DOWNLOAD_URL/$cache_dir_name/$file -O $file
            # cache file
            [ -s $file ] && mv -f $file $CACHE_DIR/$cache_dir_name
            # check file size
            if [ $file_size != 0 ] && [ -f $CACHE_DIR/$cache_dir_name/$file ]; then
                local size=$(ls -l $CACHE_DIR/$cache_dir_name/$file | awk '{ print $5 }')
                if [ $file_size -gt $size ]; then
                    rm -f $CACHE_DIR/$cache_dir_name/$file
                fi
            fi
        fi

        # set read only permission
        if [ -s $CACHE_DIR/$cache_dir_name/$file ]; then
            chmod 600 $CACHE_DIR/$cache_dir_name/$file
        fi

        # copy file to the current download directory
        if [ -s $CACHE_DIR/$cache_dir_name/$file ] && \
                [ ! -s $current_download_dir/$file ]; then
            cp -f $CACHE_DIR/$cache_dir_name/$file $current_download_dir
        fi

    fi

    # do not cache
    if [ "$do_not_cache" == "Y" ] && \
            [ -f $CACHE_DIR/$cache_dir_name/$file ]; then
        rm -f $CACHE_DIR/$cache_dir_name/$file
    fi

    # return value
    if [ -s $current_download_dir/$file ]; then
        echo "success"
    else
        rm -f $current_download_dir/$file > /dev/null 2>&1
        echo "error"
    fi

    cd $current_dir
}

# Puts message in the system log.
#
# parameters:
#   $1 message
function log_info() {

    logger -p local0.notice -t host4ge "$1"
}

# Puts error message in the system log.
#
# parameters:
#   $1 message
function log_error() {

    logger -p local0.err -t host4ge "$1"
}

# Generates X.509 certificate.
#
# parameters:
#   $1 certificate name
#   $2 size of the certificate (default is 4096)
#   $3 for how many days the certificate remains valid (default is 3650)
function generate_certificate() {

    # size
    local size=4096
    [ -n "$2" ] && size=$2

    # days
    local days=3650
    [ -n "$3" ] && days=$3

    $CMD_OPENSSL req \
        -new -x509 -nodes -sha1 -newkey rsa:$size -days $days -subj "/O=unknown/OU=unknown/CN=$1" \
        -keyout $CERTIFICATES_DIR/$1.key \
        -out $CERTIFICATES_DIR/$1.crt
    cat $CERTIFICATES_DIR/$1.crt $CERTIFICATES_DIR/$1.key > $CERTIFICATES_DIR/$1.pem
    chmod 400 $CERTIFICATES_DIR/$1.{crt,key,pem}
}

# Returns user password stored in a flat file.
#
# parameters:
#   $1 user name
function mysql_get_user_password() {

    local line=`cat $DATABASE_USERS_FILE | grep "$1="`
    local len=`expr length $1`
    local pos=`expr $len + 1`
    local pass=${line:$pos}

    echo $pass
}

# Backups database to flat SQL files.
#
# parameters:
#   $1 database name
#   $2 output directory
function mysql_backup_database_to_files() {

    local db_name=$1
    local db_pass=$(mysql_get_user_password root)

    local list=$(echo "use $db_name; show tables;" | $CMD_MYSQL --user=root --password=$db_pass | awk '{ if ( NR > 1  ) { print } }')
    for item in $list; do
        local collation=$(echo "select ccsa.character_set_name from information_schema.tables t, information_schema.collation_character_set_applicability ccsa where ccsa.collation_name = t.table_collation and t.table_schema = '$db_name' and t.table_name = '$item';" | $CMD_MYSQL --user=root --password=$db_pass | awk '{ if ( NR > 1  ) { print } }')
        $CMD_MYSQLDUMP --user="root" --password="$db_pass" --default-character-set="$collation" --extended-insert=FALSE --skip-comments "$db_name" "$item" > $2/$item.sql
        chmod 400 $2/$item.sql
    done

    log_info "database '$db_name' backed up to files"
}

# Restores database from flat SQL files.
#
# parameters:
#   $1 input directory
#   $2 database name
function mysql_restore_database_from_files() {

    local db_name=$2
    local db_pass=$(mysql_get_user_password root)

    local list=$(ls $1/*.sql)
    for item in $list; do
        $CMD_MYSQL --user="root" --password="$db_pass" "$db_name" < $item
    done

    log_info "database '$db_name' restored from files"
}

# Downloads Drupal module.
#
# parameters:
#   $1 module
#   $2 domain
function drupal_download_module {

    cd $drupal_dir
    $drush_dir/drush -y pm-download $1
    chown -R $project_user:$project_user $drupal_dir/sites/all/modules/$2
}

# Enables Drupal module.
#
# parameters:
#   $1 module
#   $2 domain
function drupal_enable_module {

    cd $drupal_dir
    $drush_dir/drush --uri=http://$2 -y pm-enable $1
}

# Disables Drupal module.
#
# parameters:
#   $1 module
#   $2 domain
function drupal_disable_module {

    cd $drupal_dir
    $drush_dir/drush --uri=http://$2 -y pm-disable $1
}

# Uninstalls Drupal module.
#
# parameters:
#   $1 module
#   $2 domain
function drupal_uninstall_module {

    cd $drupal_dir
    $drush_dir/drush --uri=http://$2 -y pm-uninstall $1
}

# Checkouts table from repository.
#
# parameters:
#   $1 table
function git_checkout_table {

    cd $project_dir
    echo "do not commit $1 table"
    git checkout database/$1.sql
}
