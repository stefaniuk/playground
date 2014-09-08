#!/bin/bash
#
# File: database-commit.sh
#
# Description: Commit database.

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

function checkout_table {
    git checkout database/$1.sql
}

##
## main
##

cd $PROJECT_DIR

# TODO: improve this script to handle drupal updates properly

checkout_table cache
checkout_table cache_block
checkout_table cache_bootstrap
checkout_table cache_field
checkout_table cache_filter
checkout_table cache_form
checkout_table cache_image
checkout_table cache_menu
checkout_table cache_page
checkout_table cache_path
checkout_table cache_rules
checkout_table cache_token
checkout_table cache_update
checkout_table cache_views
checkout_table cache_views_data
if [ "$IS_DEV" == "yes" ]; then
    checkout_table flood
    checkout_table languages
    checkout_table locales_source
    checkout_table queue
    checkout_table sessions
    checkout_table watchdog
    checkout_table xmlsitemap
    checkout_table xmlsitemap_sitemap
fi

MSG="$1"
[ "$MSG" == "" ] && MSG="database changes"
git add database/
git commit -m "$MSG"
git push

cd $CURRENT_DIR

exit 0
