#!/bin/bash
#
# File: install-drush.sh
#
# Description: Installs Drush.
#
# Usage:
#
#   install-drush.sh --user <system_user> --path <install_path>

##
## includes
##

source $(dirname $(readlink -f $0))/includes/variables.sh
source $(dirname $(readlink -f $0))/includes/constants.sh
source $(dirname $(readlink -f $0))/includes/functions.sh

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --user) shift && drush_system_user=$1
                ;;
        --path) shift && drush_install_path=$1
                ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -d $drush_install_path ]; then
    echo "Error: Drush requires '$drush_install_path' directory to exist!"
    exit 1
fi

##
## download
##

url="http://ftp.drupal.org/files/projects/drush-$DRUSH_VERSION.tar.gz"
file=drush-$DRUSH_VERSION.tar.gz
result=$(file_download --url $url --file $file --check-file-size 300000)
if [ "$result" = "error" ]; then
    echo "Error: Unable to download $file file!"
    exit 1
fi

##
## install
##

mv $file $drush_install_path
cd $drush_install_path
rm -rf $drush_dir/*
tar -zxf $file
cp $drush_dir/examples/example.drush.ini $drush_dir/drush.ini
replace_in_file ";disable_functions =" "disable_functions =" $drush_dir/drush.ini
chown -R $drush_system_user:$drush_system_user $drush_dir
rm $file

exit 0
