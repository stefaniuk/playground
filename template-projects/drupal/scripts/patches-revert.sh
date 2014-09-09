#!/bin/bash
#
# File: patches-revert.sh
#
# Description: Reverts patches.

##
## includes
##

source $(dirname $(readlink -f $0))/includes/variables.sh
source $(dirname $(readlink -f $0))/includes/constants.sh
source $(dirname $(readlink -f $0))/includes/functions.sh

##
## main
##

cd $project_dir
#patch -p1 -R < ./patches/name.patch

exit 0
