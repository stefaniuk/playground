#!/bin/bash
#
# File: site-commit.sh
#
# Description: Commit site.

##
## includes
##

source $(dirname $(readlink -f $0))/includes.sh

##
## variables
##

CURRENT_DIR=$(pwd)

##
## main
##

cd $PROJECT_DIR

MSG="$1"
[ "$MSG" == "" ] && MSG="site changes"
git add config/ documentation/ patches/ scripts/ source/ utils/ .gitignore build.* README.md
git commit -m "$MSG"
git push

cd $CURRENT_DIR

exit 0
