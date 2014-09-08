#!/bin/bash
#
# File: project-setup.sh
#
# Description: Setup project.
#
# Usage:
#
#   cd /srv/host4ge/var/hosting/accounts/zeroday/home/zeroday/project
#   ./scripts/project-setup.sh 2>&1 | tee $LOG_DIR/www.zeroday.pl-project-setup.log

##
## includes
##

source $(dirname $(readlink -f $0))/includes.sh

##
## variables
##

CURRENT_DIR=$(pwd)
SCRIPT_DIR=$(dirname $(readlink -f $0))

##
## functions
##

function download_module {
    echo '1' | $SOURCE_DIR/drush/drush dl $1
}

function enable_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 -y pm-enable $1
}

function disable_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 -y pm-disable $1
}

function uninstall_module {
    $SOURCE_DIR/drush/drush --uri=http://$2 -y pm-uninstall $1
}

##
## main
##

# remove vhosts
echo "remove vhosts"
[ -f $INSTALL_DIR/httpd/conf/accounts/$USER.conf ] && rm $INSTALL_DIR/httpd/conf/accounts/$USER.conf
apachectl -k restart

# ==========================
# clean project
echo "clean project"
$SCRIPT_DIR/project-clean.sh
# ==========================

# ============================
# prepare project
echo "prepare project"
$SCRIPT_DIR/project-prepare.sh
# ============================

# install drupal instance
echo "install drupal instance"
[ $(mysql_database_exists $DATABASE_NAME) == "yes" ] && mysql_drop_database $DATABASE_NAME
cd $SOURCE_DIR/drupal
install-drupal-site.sh \
    --drupal-path $SOURCE_DIR \
    --drush-path $SOURCE_DIR \
    --domain-path $PUBLIC_DIR \
    --domain $DOMAIN_NAME \
    --user $USER \
    --admin-name $ADMIN_NAME \
    --admin-pass $ADMIN_PASS \
    --db-name $DATABASE_NAME \
    --db-user $DATABASE_USER \
    --db-pass $DATABASE_PASS
cp -f $SOURCE_DIR/drupal/sites/$DOMAIN_NAME/settings.php $SOURCE_DIR/drupal/sites/default/settings.php

# install drupal modules
#echo "install drupal modules"
#cd $SOURCE_DIR/drupal
#MODULES=""
#for MODULE in $MODULES; do
#    download_module $MODULE
#done
#echo "------------------------------------------------------------"
#echo "$DOMAIN_NAME: A list of non-core, enabled modules (before install)"
#$SOURCE_DIR/drush/drush --uri=http://$DOMAIN_NAME pm-list --no-core --status="enabled"
#echo "------------------------------------------------------------"
# enable modules
#for MODULE in $MODULES; do
#    enable_module $MODULE $DOMAIN_NAME
#done
# remove overlay module
disable_module overlay $DOMAIN_NAME
uninstall_module overlay $DOMAIN_NAME
# set theme
enable_module fusion_starter $DOMAIN_NAME
$SOURCE_DIR/drush/drush --uri=http://$DOMAIN_NAME -y vset theme_default fusion_starter
disable_module bartik $DOMAIN_NAME
disable_module garland $DOMAIN_NAME
disable_module seven $DOMAIN_NAME
disable_module stark $DOMAIN_NAME

# =============================
# restore database
echo "restore database"
$SCRIPT_DIR/database-restore.sh
# =============================

# restore settings
cd $PROJECT_DIR
git checkout source/drupal/sites/default/settings.php
git checkout source/drupal/sites/zeroday.pl/settings.php

echo "------------------------------------------------------------"
echo "$DOMAIN_NAME: A list of non-core, enabled modules (after install)"
$SOURCE_DIR/drush/drush --uri=http://$DOMAIN_NAME pm-list --no-core --status="enabled"
echo "------------------------------------------------------------"

# create ftp accout
echo "create ftp accout"
ftp_account_create.pl -u $FTP_USER -p $FTP_PASS -i $(id -u $USER) -d $FTP_DIR

# create vhosts
echo "create vhosts"
STR=$(cat <<END_HEREDOC
\tServerAlias www.$DOMAIN_NAME
\tDocumentRoot $DOCUMENT_ROOT
\t<Directory $DOCUMENT_ROOT>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder allow,deny
\t\tAllow from all
\t</Directory>
END_HEREDOC
)
httpd_vhost_remove.pl -s "httpd" -t "account" -n $USER -i $VHOST_IP_ADDRESS -d $DOMAIN_NAME -p 80
httpd_vhost_create.pl -s "httpd" -t "account" -n $USER -i $VHOST_IP_ADDRESS -d $DOMAIN_NAME -p 80 -c "$STR"
STR=$(cat <<END_HEREDOC
\tDocumentRoot $DOCUMENT_ROOT
\t<Directory $DOCUMENT_ROOT>
\t\tOptions Indexes FollowSymLinks
\t\tAllowOverride All
\t\tOrder allow,deny
\t\tAllow from all
\t</Directory>
\tSSLEngine on
\tSSLCertificateFile $CERTIFICATES_DIR/$DOMAIN_NAME.pem
\tSSLCertificateKeyFile $CERTIFICATES_DIR/$DOMAIN_NAME.key
END_HEREDOC
)
httpd_vhost_remove.pl -s "httpd" -t "account" -n $USER -i $VHOST_IP_ADDRESS -d $DOMAIN_NAME -p 443
httpd_vhost_create.pl -s "httpd" -t "account" -n $USER -i $VHOST_IP_ADDRESS -d $DOMAIN_NAME -p 443 -c "$STR"

# generate certificate
echo "generate certificate"
cd $PROJECT_DIR/config
if [ -f $DOMAIN_NAME.crt ] && [ -f $DOMAIN_NAME.key ] && [ -f $DOMAIN_NAME.pem ]; then
    cp -fv $DOMAIN_NAME.* $CERTIFICATES_DIR
    chown root:root $CERTIFICATES_DIR/$DOMAIN_NAME.*
    chmod 400 $CERTIFICATES_DIR/$DOMAIN_NAME.*
else
    generate_certificate $DOMAIN_NAME
fi

# restart httpd
echo "restart httpd"
apachectl -k restart

# ==========================
# set files permissions
echo "set files permissions"
$SCRIPT_DIR/project-files.sh
# ==========================

(
    echo "------------------------------------------------------"
    echo "Domain name:          $DOMAIN_NAME"
    echo "Drupal admin name:    $ADMIN_NAME"
    echo "Drupal admin pass:    $ADMIN_PASS"
    echo "Database name:        $DATABASE_NAME"
    echo "Database user:        $DATABASE_USER"
    echo "Database pass:        $DATABASE_PASS"
    echo "FTP user:             $FTP_USER"
    echo "FTP pass:             $FTP_PASS"
    echo "FTP directory:        $FTP_DIR"
    echo "------------------------------------------------------"
)

cd $CURRENT_DIR

exit 0
