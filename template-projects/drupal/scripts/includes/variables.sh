#!/bin/bash

project_dir=$(readlink -f $(dirname $(readlink -f $0))/..)
project_user=$USER

drush_system_user=$project_user
drush_install_path=$(readlink -f $project_dir/source)
drush_dir=$drush_install_path/drush

drupal_system_user=$project_user
drupal_install_path=$(readlink -f $project_dir/source)
drupal_dir=$drush_install_path/drupal
drupal_modules=""
drupal_domain_install_path=$(readlink -f $project_dir/source/domains)
drupal_domain="example.com"
drupal_domain_dir=$drupal_domain_install_path/$drupal_domain
drupal_domain_system_user=$project_user
drupal_admin_name="admin"
drupal_admin_pass="admin"
drupal_db_name="example_com"
drupal_db_user="example_com"
drupal_db_pass="password"

is_development="yes"
