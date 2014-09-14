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

# conf/.profile
cat <<EOF > $HOST4GE_DIR/conf/.profile
export ADMIN_NAME="$ADMIN_NAME"
export ADMIN_MAIL="$ADMIN_MAIL"

export LOCAL_DOWNLOAD_USER=$LOCAL_DOWNLOAD_USER
export LOCAL_DOWNLOAD_PASS=$LOCAL_DOWNLOAD_PASS
export LOCAL_DOWNLOAD_URL=$LOCAL_DOWNLOAD_URL
export ONLINE_DOWNLOAD_URL=$ONLINE_DOWNLOAD_URL

export IP_ADDRESS=$IP_ADDRESS
export IP_ADDRESS1=$IP_ADDRESS1
export IP_ADDRESS2=$IP_ADDRESS2
export IP_ADDRESS3=$IP_ADDRESS3
export IP_ADDRESS4=$IP_ADDRESS4
export NETMASK=$NETMASK
export NETWORK=$NETWORK
export BROADCAST=$BROADCAST
export GATEWAY=$GATEWAY
export DNS_NAMESERVER1=$DNS_NAMESERVER1
export DNS_NAMESERVER2=$DNS_NAMESERVER2
export DNS_NAMESERVER3=$DNS_NAMESERVER3
export DNS_NAMESERVER4=$DNS_NAMESERVER4
export DNS_NAMESERVERS="$DNS_NAMESERVERS"
export DNS_SEARCH=$DNS_SEARCH

export DOMAIN=$DOMAIN
export LOCATION="$LOCATION"
export COMMON_NAME="$COMMON_NAME"

export SERVER_PROVIDER="$SERVER_PROVIDER"
export SERVER_HYPERVISOR="$SERVER_HYPERVISOR"
export SERVER_HIERARCHY="$SERVER_HIERARCHY"
export SERVER_ROLE="$SERVER_ROLE"
export SERVER_MODE="online"

export VPN_SERVER_IP=$VPN_SERVER_IP
export VPN_SERVER_PORT=$VPN_SERVER_PORT
export VPN_SERVER_FQDN=$VPN_SERVER_FQDN
export VPN_NETWORK=$VPN_NETWORK
export VPN_NETMASK=$VPN_NETMASK
export VPN_IP_POOL=$VPN_IP_POOL

export CODENAME=$CODENAME

export INSTALL_DIR=/srv
export HOST4GE_DIR=$INSTALL_DIR/host4ge

export PATH=$NEW_PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

export TERM=xterm
export SHELL=/bin/bash
export EDITOR=vim
export MAILTO="$ADMIN_MAIL"

source $HOST4GE_DIR/conf/includes.sh
source $HOST4GE_DIR/conf/aliases.sh
EOF

# ~/.profile
[ ! -f ~/.profile.old ] && cp ~/.profile ~/.profile.old
cat <<EOF > ~/.profile
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n

source $HOST4GE_DIR/conf/.profile
EOF

# do not bash save history
ln -sf /dev/null ~/.bash_history

exit 0
