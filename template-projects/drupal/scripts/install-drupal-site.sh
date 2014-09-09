#!/bin/bash
#
# File: install-drupal-site.sh
#
# Description: Installs Drupal site.
#
# Usage:
#
#   install-drupal-site.sh \
#       --drupal-dir <drupal_dir> \
#       --drush-dir <drush_dir> \
#       --domain-path <domain_dir> \
#       --domain <domain> \
#       --user <system_user> \
#       --admin-name <drupal_admin_name> \
#       --admin-pass <drupal_admin_pass> \
#       --db-name <db_name> \
#       --db-user <db_user> \
#       --db-pass <db_pass>

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
        --drupal-dir)   shift && drupal_dir=$1
                        ;;
        --drush-dir)    shift && drush_dir=$1
                        ;;
        --domain-path)  shift && drupal_domain_install_path=$1
                        ;;
        --domain)       shift && drupal_domain=$1
                        ;;
        --user)         shift && drupal_domain_system_user=$1
                        ;;
        --admin-name)   shift && drupal_admin_name=$1
                        ;;
        --admin-pass)   shift && drupal_admin_pass=$1
                        ;;
        --db-name)      shift && drupal_db_name=$1
                        ;;
        --db-user)      shift && drupal_db_user=$1
                        ;;
        --db-pass)      shift && drupal_db_pass=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $drupal_dir/index.php ]; then
    echo "Error: Drupal site requires Drupal!"
    exit 1
fi
if [ ! -x $drush_dir/drush ]; then
    echo "Error: Drupal site requires Drush!"
    exit 1
fi
if [ ! -d $drupal_domain_install_path ]; then
    echo "Error: Drupal site requires '$drupal_domain_install_path' directory to exist!"
    exit 1
fi
if [ ! -f $db_users_file ]; then
    echo "Error: Drupal site requires '$db_users_file' file to exist!"
    exit 1
fi

##
## install
##

# create drupal multi-site drupal_domain
cd $drupal_dir
rm -rf ./sites/$drupal_domain
$drush_dir/drush site-install -y \
    --db-url=mysql://root:$(mysql_get_user_password root)@localhost/$drupal_db_name \
    --account-name=$drupal_admin_name \
    --account-pass=$drupal_admin_pass \
    --account-mail=admin@$drupal_domain \
    --locale=pl \
    --clean-url=1 \
    --site-name=$drupal_domain \
    --site-mail=admin@$drupal_domain \
    --sites-subdir=$drupal_domain
mkdir $drupal_dir/sites/$drupal_domain/{modules,themes}

# create database user
cat <<EOF | mysql --user="root" --password=$(mysql_get_user_password root)
GRANT ALL ON $drupal_db_name.* TO '$drupal_db_user'@'localhost' IDENTIFIED BY '$drupal_db_pass';
EOF
replace_in_file "'root'" "'$drupal_db_user'" $drupal_dir/sites/$drupal_domain/settings.php
replace_in_file "$(mysql_get_user_password root)" "$drupal_db_pass" $drupal_dir/sites/$drupal_domain/settings.php

# create drupal_domain
cd $drupal_domain_install_path
[ ! -d $drupal_domain ] && mkdir $drupal_domain
cd $drupal_domain
rm -rf *
mkdir -p sites/$drupal_domain
cp $drupal_dir/.htaccess .
cp $drupal_dir/robots.txt .
ln -s $drupal_dir/misc misc
ln -s $drupal_dir/modules modules
ln -s $drupal_dir/themes themes
ln -s $drupal_dir/sites/all sites/all
ln -s $drupal_dir/sites/$drupal_domain/files sites/$drupal_domain/files
ln -s $drupal_dir/sites/$drupal_domain/modules sites/$drupal_domain/modules
ln -s $drupal_dir/sites/$drupal_domain/themes sites/$drupal_domain/themes

cat <<EOF > ./index.php
<?php
    chdir('$drupal_dir/');
    \$file_name = substr(strrchr(__FILE__, '/'), 1);
    include('./' . \$file_name);
?>
EOF
cp ./index.php ./authorize.php
cp ./index.php ./cron.php
cp ./index.php ./update.php
cp ./index.php ./xmlrpc.php

# set files permission
chown -R $drupal_domain_system_user:$drupal_domain_system_user $drupal_dir/sites/$drupal_domain
chown -R $HTTPD_USER:$HTTPD_USER $drupal_dir/sites/$drupal_domain/files
chown -R $drupal_domain_system_user:$drupal_domain_system_user $drupal_domain_dir

# configure modules
cd $drupal_dir
$drush_dir/drush --uri=http://$drupal_domain -y pm-disable overlay
$drush_dir/drush --uri=http://$drupal_domain -y pm-uninstall overlay
$drush_dir/drush --uri=http://$drupal_domain -y pm-enable garland
$drush_dir/drush --uri=http://$drupal_domain -y vset theme_default garland
$drush_dir/drush --uri=http://$drupal_domain -y vset admin_theme seven
echo '1' | $drush_dir/drush --uri=http://$drupal_domain cache-clear

exit 0
