#!/bin/bash
#
# File: project-setup.sh
#
# Description: Setup project.
#
# Usage:
#
#   project-setup.sh 2>&1 | tee $LOG_DIR/zeroday.pl-project-setup.log

##
## includes
##

source $(dirname $(readlink -f $0))/includes.sh

##
## variables
##

CURRENT_DIR=$(pwd)
SCRIPT_DIR=$(dirname $(readlink -f $0))

##
## main
##

ACTION="$1"
MODULE="$2"

function download_module {
    $SOURCE_DIR/drush/drush pm-download $1
    chown -R $USER:$USER $SOURCE_DIR/drupal/sites/all/modules/$2
}

function enable_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 pm-enable $1
}

function disable_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 pm-disable $1
}

function uninstall_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 pm-uninstall $1
}

cd $SOURCE_DIR/drupal

if [ "$ACTION" == "download" ] || [ "$ACTION" == "dl" ]; then
    download_module "$MODULE"
fi
if [ "$ACTION" == "enable" ] || [ "$ACTION" == "en" ]; then
    enable_module "$MODULE" "$DOMAIN_NAME"
fi
if [ "$ACTION" == "disable" ] || [ "$ACTION" == "di" ]; then
    disable_module "$MODULE" "$DOMAIN_NAME"
fi
if [ "$ACTION" == "uninstall" ] || [ "$ACTION" == "un" ]; then
    uninstall_module "$MODULE" "$DOMAIN_NAME"
fi

# update drupal core and modules
if [ "$ACTION" == "update" ] || [ "$ACTION" == "up" ]; then

    # TODO: improve this script to handle drupal updates properly

    # mode 1 (test) or mode 2 (live)

    # take site offline

    # commit site (mode 2 only)

    # backup database and commit (mode 2 only)

    # check if status is clean

    $SOURCE_DIR/drush/drush --uri=http://$DOMAIN_NAME pm-update

    rm -rf ~/drush-backups

    # commit site (mode 2 only)

    # commit database (mode 2 only)

    # take site online

fi

# ==========================
# set files permissions
echo "set files permissions"
$SCRIPT_DIR/project-files.sh
# ==========================

cd $CURRENT_DIR

exit 0
