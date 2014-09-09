#!/bin/bash
#
# File: git-database-commit.sh
#
# Description: Commits database.

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
git_checkout_table cache
git_checkout_table cache_block
git_checkout_table cache_bootstrap
git_checkout_table cache_field
git_checkout_table cache_filter
git_checkout_table cache_form
git_checkout_table cache_image
git_checkout_table cache_menu
git_checkout_table cache_page
git_checkout_table cache_path
git_checkout_table cache_rules
git_checkout_table cache_token
git_checkout_table cache_update
git_checkout_table cache_views
git_checkout_table cache_views_data
if [ "$is_development" == "yes" ]; then
    git_checkout_table flood
    git_checkout_table languages
    git_checkout_table locales_source
    git_checkout_table queue
    git_checkout_table sessions
    git_checkout_table watchdog
    git_checkout_table xmlsitemap
    git_checkout_table xmlsitemap_sitemap
fi
msg="$1"
[ "$msg" == "" ] && msg="database changes"
git add database/
git commit -m "$msg"
git push

exit 0
