#!/bin/bash

##
## variables
##

PHPMYADMIN_VERSION="3.4.3.1"
PHPMYADMIN_MYSQL_NAME=
PHPMYADMIN_HTTPD_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--phpmyadmin)	shift
						PHPMYADMIN_MYSQL_NAME=$1
						shift
						PHPMYADMIN_HTTPD_NAME=$1
						;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysqld ]; then
	echo "Error: phpMyAdmin requires MySQL!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/bin/httpd ]; then
	echo "Error: phpMyAdmin requires Apache HTTPD Server!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/modules/libphp5.so ]; then
	echo "Error: phpMyAdmin requires PHP!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f phpmyadmin.tar.gz ]; then
	COUNT=0
	while [ 1 ]; do
		# repeat only 10 times
		if [ $COUNT -gt 9 ]; then
			break
		fi
		# try to download
		wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.gz -O phpmyadmin.tar.gz
		# check size
		SIZE=$(stat -c %s phpmyadmin.tar.gz)
		if [ $SIZE -gt 5000000 ]; then
			break;
		else
			rm phpmyadmin.tar.gz;
		fi
		# increment counter
		COUNT=`expr $COUNT + 1`
	done
fi
if [ ! -f phpmyadmin.tar.gz ]; then
	echo "Error: Unable to download phpmyadmin.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing phpMyAdmin:"
[ -d $INSTALL_DIR/applications/phpmyadmin ] && rm -rf $INSTALL_DIR/applications/phpmyadmin
[ ! -d $INSTALL_DIR/applications ] && mkdir -p $INSTALL_DIR/applications
tar -zxf phpmyadmin.tar.gz -C $INSTALL_DIR/applications
mv $INSTALL_DIR/applications/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages $INSTALL_DIR/applications/phpmyadmin
rm -rfv $INSTALL_DIR/applications/phpmyadmin/setup

# check
if [ ! -f $INSTALL_DIR/applications/phpmyadmin/index.php ]; then
	echo "Error: phpMyAdmin has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

PHPMYADMIN_BLOWFISH_SECRET=`get_random_string 32`

# database user
PHPMYADMIN_CONTROL_USER_NAME="ctrl_phpmyadmin"
PHPMYADMIN_CONTROL_USER_PASSWORD=`get_random_string 32`
echo "$PHPMYADMIN_CONTROL_USER_NAME=$PHPMYADMIN_CONTROL_USER_PASSWORD" >> $INSTALL_DIR/mysql/.details/.users

# config.inc.php
cat <<EOF > $INSTALL_DIR/applications/phpmyadmin/config.inc.php
<?php
\$cfg['blowfish_secret'] = '$PHPMYADMIN_BLOWFISH_SECRET';
\$i = 0;
\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
\$cfg['Servers'][\$i]['host'] = '127.0.0.1';
\$cfg['Servers'][\$i]['connect_type'] = 'tcp';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['extension'] = 'mysql';
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;
\$cfg['Servers'][\$i]['AllowRoot'] = false;
\$cfg['Servers'][\$i]['controluser'] = '$PHPMYADMIN_CONTROL_USER_NAME';
\$cfg['Servers'][\$i]['controlpass'] = '$PHPMYADMIN_CONTROL_USER_PASSWORD';
\$cfg['Servers'][\$i]['pmadb'] = 'phpmyadmin';
\$cfg['Servers'][\$i]['relation'] = 'pma_relation';
\$cfg['Servers'][\$i]['table_info'] = 'pma_table_info';
\$cfg['Servers'][\$i]['table_coords'] = 'pma_table_coords';
\$cfg['Servers'][\$i]['pdf_pages'] = 'pma_pdf_pages';
\$cfg['Servers'][\$i]['column_info'] = 'pma_column_info';
\$cfg['Servers'][\$i]['bookmarktable'] = 'pma_bookmark';
\$cfg['Servers'][\$i]['history'] = 'pma_history';
\$cfg['Servers'][\$i]['designer_coords'] = 'pma_designer_coords';
\$cfg['Servers'][\$i]['tracking'] = 'pma_tracking';
\$cfg['Servers'][\$i]['userconfig'] = 'pma_userconfig';
?>
EOF

# config database
$INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysql.server start
sleep 5
$INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysql -u root < $INSTALL_DIR/applications/phpmyadmin/scripts/create_tables.sql
cat <<EOF | $INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysql -u root
GRANT USAGE ON mysql.* TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost' IDENTIFIED BY '$PHPMYADMIN_CONTROL_USER_PASSWORD';
GRANT SELECT (
	Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv,
	Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv,
	File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,
	Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv,
	Execute_priv, Repl_slave_priv, Repl_client_priv
) ON mysql.user TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost';
GRANT SELECT ON mysql.db TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost';
GRANT SELECT ON mysql.host TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost';
GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv) ON mysql.tables_priv TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost';
GRANT USAGE ON phpmyadmin.* TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost';
GRANT SELECT ON phpmyadmin.* TO '$PHPMYADMIN_CONTROL_USER_NAME'@'localhost';
EOF
sleep 1
$INSTALL_DIR/$PHPMYADMIN_MYSQL_NAME/bin/mysqladmin -u root shutdown
sleep 3

# config webserver
remove_from_file "\n# BEGIN: phpmyadmin configuration.*END: phpmyadmin configuration" $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/conf/httpd.conf
(	echo -e "# BEGIN: phpmyadmin configuration" && \
	echo -e "<Directory $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/htdocs/phpmyadmin/>" && \
	echo -e "\tphp_admin_value apc.enabled 0" && \
	echo -e "</Directory>" && \
	echo -e "# END: phpmyadmin configuration" \
) >> $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/conf/httpd.conf
[ -d $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/htdocs/phpmyadmin ] && rm -rf $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/htdocs/phpmyadmin
ln -s $INSTALL_DIR/applications/phpmyadmin $INSTALL_DIR/$PHPMYADMIN_HTTPD_NAME/htdocs/phpmyadmin

# set files permission
chown $PHPMYADMIN_HTTPD_NAME:$PHPMYADMIN_HTTPD_NAME $INSTALL_DIR/applications/phpmyadmin/config.inc.php
chmod 400 $INSTALL_DIR/applications/phpmyadmin/config.inc.php

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f phpmyadmin.tar.gz ] && rm phpmyadmin.tar.gz
