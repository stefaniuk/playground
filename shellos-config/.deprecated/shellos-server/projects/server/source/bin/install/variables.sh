#!/bin/bash
#
# File: bin/install/variables.sh
#
# Description: This script sets global variables for installation purpose
#              depending on hostname.
#
# Usage:
#
#   source bin/install/variables.sh

##
## ### GLOBAL VARIABLES ################################################################################################
##

ADMIN_NAME="Daniel Stefaniuk"
ADMIN_MAIL="daniel.stefaniuk@gmail.com"

LOCAL_DOWNLOAD_USER="host4ge"
LOCAL_DOWNLOAD_PASS="3TxYFX"
LOCAL_DOWNLOAD_URL="ftp://192.168.1.31/host4ge"
ONLINE_DOWNLOAD_URL="http://dl.dropbox.com/u/7395263/host4ge"

IP_ADDRESS=
IP_ADDRESS1=
IP_ADDRESS2="none"
IP_ADDRESS3="none"
IP_ADDRESS4="none"
NETMASK="255.255.255.0"
NETWORK="192.168.1.0"
BROADCAST="192.168.1.255"
GATEWAY="192.168.1.1"
DNS_NAMESERVER1="$GATEWAY"
DNS_NAMESERVER2="none"
DNS_NAMESERVER3="none"
DNS_NAMESERVER4="none"
DNS_NAMESERVERS="$DNS_NAMESERVER1"
DNS_SEARCH="none"

DOMAIN="host4ge.com"
LOCATION=
COMMON_NAME="Host4ge"

SERVER_PROVIDER=
SERVER_HYPERVISOR=
SERVER_HIERARCHY=
SERVER_ROLE=
if [ -z "$SERVER_MODE" ]; then
    SERVER_MODE="installation"
else
    SERVER_MODE="update"
fi

VPN_SERVER_IP="none"
VPN_SERVER_FQDN="none"
VPN_SERVER_PORT="8443"
VPN_SERVER_PROTOCOL="tcp"
VPN_NETWORK="172.24.16.0"
VPN_NETMASK="255.255.255.0"
VPN_IP_POOL="172.24.16"

CODENAME=$(lsb_release -a | grep Codename | awk '{ print $2 }')

# get IP address assigned to eth0
__IP=$(ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

##
## ### BUILD SERVERS ###################################################################################################
##

# local (build)
[ "`hostname`" == "build" ] && \
    IP_ADDRESS="192.168.1.70" && \
    IP_ADDRESS1="192.168.1.70" && \
    LOCATION="GB" && \
    SERVER_PROVIDER="home" && \
    SERVER_HYPERVISOR="vmware" && \
    SERVER_HIERARCHY="master" && \
    SERVER_ROLE="build" && \
    hostname "build"

##
## ### TEST SERVERS ####################################################################################################
##

# local (host4ge-test1)
#[ "`hostname`" == "host4ge-test1" ] && \
#    IP_ADDRESS="192.168.1.71" && \
#    IP_ADDRESS1="192.168.1.71" && \
#    IP_ADDRESS2="192.168.1.72" && \
#    LOCATION="GB" && \
#    SERVER_PROVIDER="home" && \
#    SERVER_HYPERVISOR="vmware" && \
#    SERVER_HIERARCHY="master" && \
#    SERVER_ROLE="test admin" && \
#    VPN_SERVER_IP="192.168.1.71" && \
#    VPN_SERVER_FQDN="host4ge-test1" && \
#    hostname "host4ge-test1"

# local (host4ge-test2)
#[ "`hostname`" == "host4ge-test2" ] && \
#    IP_ADDRESS="192.168.1.73" && \
#    IP_ADDRESS1="192.168.1.73" && \
#    IP_ADDRESS2="192.168.1.74" && \
#    LOCATION="GB" && \
#    SERVER_PROVIDER="home" && \
#    SERVER_HYPERVISOR="vmware" && \
#    SERVER_HIERARCHY="slave" && \
#    SERVER_ROLE="test host" && \
#    VPN_SERVER_IP="192.168.1.71" && \
#    VPN_SERVER_FQDN="host4ge-test1" && \
#    hostname "host4ge-test2"

# local (host4ge-test3)
#[ "`hostname`" == "host4ge-test3" ] && \
#    IP_ADDRESS="192.168.1.75" && \
#    IP_ADDRESS1="192.168.1.75" && \
#    IP_ADDRESS2="192.168.1.76" && \
#    LOCATION="GB" && \
#    SERVER_PROVIDER="home" && \
#    SERVER_HYPERVISOR="vmware" && \
#    SERVER_HIERARCHY="slave" && \
#    SERVER_ROLE="test host" && \
#    VPN_SERVER_IP="192.168.1.71" && \
#    VPN_SERVER_FQDN="host4ge-test1" && \
#    hostname "host4ge-test3"

##
## ### DEVELOPMENT SERVERS #############################################################################################
##

# home (development of mhaker.pl web site)
[ "`hostname`" == "mhaker" ] && \
    IP_ADDRESS="192.168.1.201" && \
    IP_ADDRESS1="192.168.1.201" && \
    LOCATION="GB" && \
    SERVER_PROVIDER="home" && \
    SERVER_HYPERVISOR="vmware" && \
    SERVER_HIERARCHY="slave" && \
    SERVER_ROLE="development mhaker" && \
    hostname "mhaker"

# home (development of zeroday.pl web site)
[ "`hostname`" == "zeroday" ] && \
    IP_ADDRESS="192.168.1.202" && \
    IP_ADDRESS1="192.168.1.202" && \
    LOCATION="GB" && \
    SERVER_PROVIDER="home" && \
    SERVER_HYPERVISOR="vmware" && \
    SERVER_HIERARCHY="slave" && \
    SERVER_ROLE="development zeroday" && \
    hostname "zeroday"

##
## ### LIVE SERVERS ####################################################################################################
##

# linode.com (draco)
if [ "`hostname`" == "li195-117" ] || [ "$__IP" == "178.79.139.117" ] || [ "`hostname`" == "draco" ]; then

    hostname "draco"

    IP_ADDRESS="178.79.139.117"
    IP_ADDRESS1="178.79.139.117"
    IP_ADDRESS2="178.79.157.69"
    NETMASK="255.255.255.0"
    NETWORK="178.79.139.0"
    BROADCAST="178.79.139.255"
    GATEWAY="178.79.139.1"
    DNS_NAMESERVER1="109.74.192.20"
    DNS_NAMESERVER2="109.74.193.20"
    DNS_NAMESERVER3="109.74.194.20"
    DNS_NAMESERVERS="$DNS_NAMESERVER1 $DNS_NAMESERVER2 $DNS_NAMESERVER3"
    DNS_SEARCH="members.linode.com"

    LOCATION="GB"

    SERVER_PROVIDER="linode"
    SERVER_HYPERVISOR="xen"
    SERVER_HIERARCHY="slave"
    SERVER_ROLE="live host"

    VPN_SERVER_IP=$IP_ADDRESS
    VPN_SERVER_FQDN="$(hostname).$DOMAIN"

fi

# linode.com (mercury)
#[ "`hostname`" == "li140-158" ] || [ "`hostname`" == "mercury" ] && \
#    IP_ADDRESS="109.74.193.158" && \
#    IP_ADDRESS1="109.74.193.158" && \
#    LOCATION="GB" && \
#    SERVER_PROVIDER="linode" && \
#    SERVER_HYPERVISOR="xen" && \
#    SERVER_HIERARCHY="slave" && \
#    SERVER_ROLE="live" && \
#    hostname "mercury"

# kylos.pl (earth)
#[ "`hostname`" == "earth" ] && \
#    IP_ADDRESS="195.162.24.216" && \
#    IP_ADDRESS1="195.162.24.216" && \
#    IP_ADDRESS2="195.162.24.217" && \
#    LOCATION="PL" && \
#    SERVER_PROVIDER="kylos" && \
#    SERVER_HYPERVISOR="dedicated" && \
#    SERVER_HIERARCHY="slave" && \
#    SERVER_ROLE="live" && \
#    hostname "earth"

##
## ### FINAL CONFIGURATION #############################################################################################
##

if [[ "$IP_ADDRESS" != 192.168.* ]]; then
    LOCAL_DOWNLOAD_USER="none"
    LOCAL_DOWNLOAD_PASS="none"
    LOCAL_DOWNLOAD_URL="none"
fi
