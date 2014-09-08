#!/bin/bash
#
# File: project-development.sh
#
# Description: Development project.

##
## includes
##

source $(dirname $(readlink -f $0))/includes.sh

##
## variables
##

CURRENT_DIR=$(pwd)

##
## functions
##

function download_module {
    echo '1' | $SOURCE_DIR/drush/drush dl $1
}

function enable_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 -y pm-enable $1
}

##
## main
##

cd $SOURCE_DIR/drupal

# install developemnt modules
if [ "$IS_DEV" == "yes" ]; then
    # devel
    download_module devel
    enable_module devel
    # environment_indicator
    download_module environment_indicator
    enable_module environment_indicator
fi

cd $CURRENT_DIR

exit 0
