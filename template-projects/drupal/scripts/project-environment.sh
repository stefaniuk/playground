#!/bin/bash
#
# File: project-environment.sh
#
# Description: Changes environment of the project.

##
## includes
##

source $(dirname $(readlink -f $0))/includes/variables.sh
source $(dirname $(readlink -f $0))/includes/constants.sh
source $(dirname $(readlink -f $0))/includes/functions.sh

##
## main
##

cd $drupal_dir
if [ "$is_development" == "yes" ]; then
    # devel
    drupal_download_module devel
    drupal_enable_module devel $drupal_domain
    # environment_indicator
    drupal_download_module environment_indicator
    drupal_enable_module environment_indicator $drupal_domain
else
    # devel
    drupal_disable_module devel $drupal_domain
    # environment_indicator
    drupal_disable_module environment_indicator $drupal_domain
fi

exit 0
