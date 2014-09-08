#!/bin/bash

##
## variables
##

FINALIZE_IP_ADDRESS=
SCRIPTS_DIR=$INSTALL_DIR/scripts
INSTALLATION_FILES_DIR=$INSTALL_DIR/installation-files
ADMIN_EMAIL_ADDRESS="daniel.stefaniuk@gmail.com"

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--finalize)	shift
					FINALIZE_IP_ADDRESS=$1
					;;
	esac
	shift
done

# root's profile
NEW_PATH=$SCRIPTS_DIR
[ -d $INSTALL_DIR/openssl/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/openssl/bin
[ -d $INSTALL_DIR/mysql/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/mysql/bin
[ -d $INSTALL_DIR/httpd/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/httpd/bin
[ -d $INSTALL_DIR/geoip/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/geoip/bin
[ -d $INSTALL_DIR/php/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/php/bin
[ -d $INSTALL_DIR/proftpd/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/proftpd/bin
[ -d $INSTALL_DIR/postfix/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/postfix/bin
[ -d $INSTALL_DIR/dovecot/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/dovecot/bin
[ -d $INSTALL_DIR/openjdk/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/openjdk/bin
[ -d $INSTALL_DIR/ant/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/ant/bin
[ -d $INSTALL_DIR/tomcat/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/tomcat/bin
NEW_PATH=$NEW_PATH:$INSTALLATION_FILES_DIR
remove_from_file "\n# BEGIN: server settings.*END: server settings\n" ~/.profile
echo -e "# BEGIN: server settings" >> ~/.profile
echo -e "export INSTALL_DIR=$INSTALL_DIR" >> ~/.profile
echo -e "export PATH=$NEW_PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> ~/.profile
echo -e "export PERL5LIB=$SCRIPTS_DIR" >> ~/.profile
echo -e "export EDITOR=vim" >> ~/.profile
echo -e "source $INSTALL_DIR/scripts/common.sh" >> ~/.profile
echo -e "# END: server settings\n" >> ~/.profile

# generate server certificate
generate_certificate $FINALIZE_IP_ADDRESS

# set mysql password
if [ -d $INSTALL_DIR/mysql ]; then
	MYSQL_PASSWORD=`get_random_string 32`
	echo -e "root=$MYSQL_PASSWORD" >> $INSTALL_DIR/mysql/.details/.users
	$INSTALL_DIR/mysql/bin/mysql.server start
	sleep 5
	$INSTALL_DIR/mysql/bin/mysqladmin -u root password "$MYSQL_PASSWORD"
	sleep 1
	pkill mysqld
fi

# clean up
rm -rfv /tmp/*
rm -rfv /var/www

# welcome screen
cat <<EOF > /etc/motd.tail
    __               __  __ __
   / /_  ____  _____/ /_/ // / ____ ____   _________  ____ ___
  / __ \\/ __ \\/ ___/ __/ // /_/ __ \`/ _ \\ / ___/ __ \\/ __ \`__ \\
 / / / / /_/ (__  ) /_/__  __/ /_/ /  __// /__/ /_/ / / / / / /
/_/ /_/\\____/____/\\__/  /_/  \\__, /\\___(_)___/\\____/_/ /_/ /_/
                            /____/

EOF

# crontab
(	echo -e "PATH=$NEW_PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" && \
	echo -e "SHELL=/bin/bash" && \
	echo -e "TERM=xterm" && \
	echo -e "MAILTO=$ADMIN_EMAIL_ADDRESS\n" && \
	echo -e "@reboot $INSTALL_DIR/scripts/startup-services.sh" && \
	echo -e "30 3 * * * $INSTALL_DIR/scripts/update-system.sh" && \
	echo -e "1 */3 * * * $INSTALL_DIR/scripts/report-status.sh" && \
	echo -e "*/3 * * * * $INSTALL_DIR/scripts/check-services.sh" \
) | crontab

# log event
logger -p local0.notice -t host4ge "system build complete"

# startup services
[ -f $INSTALL_DIR/scripts/startup-services.sh ] && $INSTALL_DIR/scripts/startup-services.sh && sleep 5

# get some info about the host
host $FINALIZE_IP_ADDRESS
nslookup $FINALIZE_IP_ADDRESS

# show list of connections
netstat -tuapn
# show list of processes
ps aux --sort cmd
# show memory usage
free -m

if [ -d $INSTALL_DIR/postfix ]; then
	echo "`hostname -f` ($FINALIZE_IP_ADDRESS) has been build at `date +\"%T %Z (%d %b %G)\"`." | $INSTALL_DIR/postfix/bin/mailx -s "`hostname -f` - build" $ADMIN_EMAIL_ADDRESS
fi

# organise installation files and set permission
rm -rf $INSTALL_DIR/conf
mkdir $INSTALLATION_FILES_DIR && mv $INSTALL_DIR/*.{sh,pl,log} $INSTALLATION_FILES_DIR > /dev/null 2>&1
[ ! "$REMOVE_SOURCE_FILES" = "Y" ] && mv $INSTALL_DIR/*.{tar.gz,tgz,tar.bz2,patch,dat.gz} $INSTALLATION_FILES_DIR > /dev/null 2>&1
chmod 500 {$SCRIPTS_DIR,$INSTALLATION_FILES_DIR}
chmod 400 -R {$SCRIPTS_DIR,$INSTALLATION_FILES_DIR}/*
chmod u+x {$SCRIPTS_DIR,$INSTALLATION_FILES_DIR}/*.{sh,pl} > /dev/null 2>&1
chmod 400 $INSTALL_DIR/README

echo "Disk usage: " `du -hcs / | grep total`
