#!/bin/bash

DRUSH_VERSION="7.x-5.7"
DRUPAL_VERSION="7.16"

TMP_DIR=/tmp
CACHE_DIR=/tmp
HTTPD_USER="httpd"
HTTPD_CONF_DIR=/srv/httpd/conf/domains
DATABASE_USERS_FILE=$project_dir/config/.database-users
CERTIFICATES_DIR=$project_dir/config
CMD_OPENSSL=openssl
CMD_MYSQL=/srv/mysql/bin/mysql
CMD_MYSQLDUMP=/srv/mysql/bin/mysqldump

DEVELOPER_NAME="Daniel Stefaniuk"
DEVELOPER_EMAIL="daniel.stefaniuk@gmail.com"
