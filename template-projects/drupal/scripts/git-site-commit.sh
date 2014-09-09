#!/bin/bash
#
# File: git-site-commit.sh
#
# Description: Commits site.

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
msg="$1"
[ "$msg" == "" ] && msg="site changes"
git add config/ documentation/ patches/ scripts/ source/ utils/ .gitignore build.* README.md
git commit -m "$msg"
git push

exit 0
