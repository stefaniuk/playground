#!/bin/bash
#
# File: project-setup.sh
#
# Description: Sets up project.
#
# Usage:
#
#   ./scripts/project-setup.sh 2>&1 | tee ~/project-setup.sh.log

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

# set files permissions
echo "set files permissions"
chmod 700 $project_dir/scripts/*.sh

# install drush
echo "install drush"
$project_dir/scripts/install-drush.sh

# install drupal
echo "install drupal"
$project_dir/scripts/install-drupal.sh

# install drupal site
echo "install drupal site"
$project_dir/scripts/install-drupal-site.sh
cp -f $drupal_dir/sites/$drupal_domain/settings.php $drupal_dir/sites/default/settings.php

# install environment drupal modules
echo "install environment drupal modules"
$project_dir/scripts/project-environment.sh

# install additional drupal modules
echo "install additional drupal modules"
for module in $drupal_modules; do
    drupal_download_module $module
done
# enable modules
for module in $drupal_modules; do
    drupal_enable_module $module $drupal_domain
done
# set theme
#enable_module fusion_starter $DOMAIN_NAME
#$SOURCE_DIR/drush/drush --uri=http://$DOMAIN_NAME -y vset theme_default fusion_starter
#disable_module bartik $DOMAIN_NAME
#disable_module garland $DOMAIN_NAME
#disable_module seven $DOMAIN_NAME
#disable_module stark $DOMAIN_NAME

# show installed modules
echo "show installed modules"
echo "------------------------------------------------------------"
echo "$drupal_domain: A list of non-core, enabled modules"
cd $drupal_dir
$drush_dir/drush --uri=http://$drupal_domain pm-list --no-core --status="enabled"
echo "------------------------------------------------------------"

# backup database
echo "backup database"
$project_dir/scripts/database-backup.sh

# create virtual hosts
echo "create virtual hosts"
cat << EOF > $HTTPD_CONF_DIR/$drupal_domain.conf
<VirtualHost *:80>
    ServerName $drupal_domain:80
    ServerAlias www.$drupal_domain
    DocumentRoot $drupal_domain_dir
    <Directory $drupal_domain_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    ServerName $drupal_domain:443
    DocumentRoot $drupal_domain_dir
    <Directory $drupal_domain_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
    SSLEngine on
    SSLCertificateFile $project_dir/config/$drupal_domain.pem
    SSLCertificateKeyFile $project_dir/config/$drupal_domain.key
</VirtualHost>
EOF

# generate certificate
echo "generate certificate"
generate_certificate $drupal_domain

# set files permissions
echo "set files permissions"
chown -R $project_user:$project_user $project_dir
chmod 700 $project_dir/{.git*,build*,config,database,documentation,patches,scripts,utils}
chown -R $HTTPD_USER:$HTTPD_USER $drupal_dir/sites/default/files
chown -R $HTTPD_USER:$HTTPD_USER $drupal_dir/sites/$drupal_domain/files
cd $drupal_dir
find -iname '.htaccess' | xargs chown -R $project_user:$project_user
chown root:root $DATABASE_USERS_FILE
chmod 600 $DATABASE_USERS_FILE
chown root:root $project_dir/scripts/includes/variables.sh
chmod 600 $project_dir/scripts/includes/variables.sh

# set up git repository
echo "set up git repository"
cd $project_dir
[ -d .git ] && rm -rf .git
git init
git config user.name "$DEVELOPER_NAME"
git config user.email "$DEVELOPER_EMAIL"
git config core.autocrlf false
git config core.filemode true
git add .
git commit -m "initial commit"

exit 0
