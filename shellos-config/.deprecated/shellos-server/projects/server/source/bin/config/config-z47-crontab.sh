#!/bin/bash

# set new PATH
NEW_PATH=$HOST4GE_DIR/bin
[ -d $INSTALL_DIR/openssl/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/openssl/bin
[ -d $INSTALL_DIR/openssh/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/openssh/bin
[ -d $INSTALL_DIR/openvpn/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/openvpn/bin
[ -d $INSTALL_DIR/curl/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/curl/bin
[ -d $INSTALL_DIR/geoip/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/geoip/bin
[ -d $INSTALL_DIR/mysql/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/mysql/bin
[ -d $INSTALL_DIR/nginx/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/nginx/bin
[ -d $INSTALL_DIR/httpd/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/httpd/bin
[ -d $INSTALL_DIR/php/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/php/bin
[ -d $INSTALL_DIR/php-fpm/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/php-fpm/bin
[ -d $INSTALL_DIR/proftpd/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/proftpd/bin
[ -d $INSTALL_DIR/postfix/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/postfix/bin
[ -d $INSTALL_DIR/dovecot/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/dovecot/bin
[ -d $INSTALL_DIR/git/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/git/bin
[ -d $INSTALL_DIR/openjdk/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/openjdk/bin
[ -d $INSTALL_DIR/tomcat/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/tomcat/bin
#[ -d $INSTALL_DIR/lxc/bin ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/lxc/bin
#[ -d $INSTALL_DIR/lxc/lib/lxc/templates ] && NEW_PATH=$NEW_PATH:$INSTALL_DIR/lxc/lib/lxc/templates
NEW_PATH=$NEW_PATH:$HOST4GE_DIR/bin/task:$HOST4GE_DIR/bin/additional-scripts/hosting:$HOST4GE_DIR/bin/additional-scripts/custom

# conf/.crontab
cat <<EOF > $HOST4GE_DIR/conf/.crontab
ADMIN_NAME="$ADMIN_NAME"
ADMIN_MAIL="$ADMIN_MAIL"

LOCAL_DOWNLOAD_USER=$LOCAL_DOWNLOAD_USER
LOCAL_DOWNLOAD_PASS=$LOCAL_DOWNLOAD_PASS
LOCAL_DOWNLOAD_URL=$LOCAL_DOWNLOAD_URL
ONLINE_DOWNLOAD_URL=$ONLINE_DOWNLOAD_URL

IP_ADDRESS=$IP_ADDRESS
IP_ADDRESS1=$IP_ADDRESS1
IP_ADDRESS2=$IP_ADDRESS2
IP_ADDRESS3=$IP_ADDRESS3
IP_ADDRESS4=$IP_ADDRESS4
NETMASK=$NETMASK
NETWORK=$NETWORK
BROADCAST=$BROADCAST
GATEWAY=$GATEWAY
DNS_NAMESERVER1=$DNS_NAMESERVER1
DNS_NAMESERVER2=$DNS_NAMESERVER2
DNS_NAMESERVER3=$DNS_NAMESERVER3
DNS_NAMESERVER4=$DNS_NAMESERVER4
DNS_NAMESERVERS="$DNS_NAMESERVERS"
DNS_SEARCH=$DNS_SEARCH

DOMAIN=$DOMAIN
LOCATION="$LOCATION"
COMMON_NAME="$COMMON_NAME"

SERVER_PROVIDER="$SERVER_PROVIDER"
SERVER_HYPERVISOR="$SERVER_HYPERVISOR"
SERVER_HIERARCHY="$SERVER_HIERARCHY"
SERVER_ROLE="$SERVER_ROLE"
SERVER_MODE="online"

VPN_SERVER_IP=$VPN_SERVER_IP
VPN_SERVER_PORT=$VPN_SERVER_PORT
VPN_SERVER_FQDN=$VPN_SERVER_FQDN
VPN_NETWORK=$VPN_NETWORK
VPN_NETMASK=$VPN_NETMASK
VPN_IP_POOL=$VPN_IP_POOL

CODENAME=$CODENAME

INSTALL_DIR=/srv
HOST4GE_DIR=$INSTALL_DIR/host4ge

PATH=$NEW_PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

TERM=xterm
SHELL=/bin/bash
EDITOR=vim
MAILTO="$ADMIN_MAIL"

@reboot [ -x $HOST4GE_DIR/bin/task/system-services.sh ] && $HOST4GE_DIR/bin/task/system-services.sh --on-reboot
#29,59 */1 * * * [ -x $HOST4GE_DIR/bin/task/backup-logs.sh ] && $HOST4GE_DIR/bin/task/backup-logs.sh
#17 3 * * * [ -x $HOST4GE_DIR/bin/task/backup-databases.sh ] && $HOST4GE_DIR/bin/task/backup-databases.sh
#23 3 * * * [ -x $HOST4GE_DIR/bin/task/backup-sites.sh ] && $HOST4GE_DIR/bin/task/backup-sites.sh
29 3 * * * [ -x $HOST4GE_DIR/bin/task/system-update.sh ] && $HOST4GE_DIR/bin/task/system-update.sh
#37 3 * * * [ -x $HOST4GE_DIR/bin/task/update-geoip-database.sh ] && $HOST4GE_DIR/bin/task/update-geoip-database.sh
1 */3 * * * [ -x $HOST4GE_DIR/bin/task/system-status.sh ] && $HOST4GE_DIR/bin/task/system-status.sh
#*/5 * * * * [ -x $HOST4GE_DIR/bin/task/system-monitor-analysis.sh ] && $HOST4GE_DIR/bin/task/system-monitor-analysis.sh --time-interval 5
#*/1 * * * * [ -x $HOST4GE_DIR/bin/task/system-monitor.sh ] && $HOST4GE_DIR/bin/task/system-monitor.sh
*/1 * * * * [ -x $HOST4GE_DIR/bin/task/system-services.sh ] && $HOST4GE_DIR/bin/task/system-services.sh --log-errors
EOF

# /etc/rc.local
[ ! -f /etc/rc.local.old ] && cp /etc/rc.local /etc/rc.local.old
if [ "$SERVER_MODE" == "installation" ]; then

    cat <<EOF > /etc/rc.local
#!/bin/sh -e
sleep 30
INSTALL_DIR=$INSTALL_DIR HOST4GE_DIR=$HOST4GE_DIR JOB_LOG_EVENT_TIME=30 \
    $HOST4GE_DIR/bin/task/system-services.sh --initial-reboot
crontab $HOST4GE_DIR/conf/.crontab
(   echo "#!/bin/sh" && \
    echo "exit 0" \
) > /etc/rc.local
chmod u+x /etc/rc.local
exit 0
EOF
    chmod u+x /etc/rc.local

else

    crontab $HOST4GE_DIR/conf/.crontab

fi

exit 0
