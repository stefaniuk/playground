#!/bin/bash
#
# File: patches-apply.sh
#
# Description: Applies patches.

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
#patch -p1 -i ./patches/name.patch

exit 0
