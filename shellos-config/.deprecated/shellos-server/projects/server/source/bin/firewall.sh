#!/bin/bash
#
# File: bin/firewall.sh
#
# Description: This script defines firewall rules.
#
# Usage:
#
#   bin/firewall.sh

# TODO: http://www.debian-administration.org/articles/187
# SEE: http://www.cyberciti.biz/tips/linux-iptables-examples.html

##
## include
##

source $HOST4GE_DIR/conf/includes.sh

##
## variables
##

IPTv4=/sbin/iptables
IPTv6=/sbin/ip6tables
PUBIF="eth0"

##
## === IPv6 ====================================================================
##

# flush all rules
$IPTv6 -F
$IPTv6 -X

# drop all by default
$IPTv6 -P INPUT DROP
$IPTv6 -P OUTPUT ACCEPT
$IPTv6 -P FORWARD DROP

##
## === IPv4 ====================================================================
##

# flush all rules
$IPTv4 -F
$IPTv4 -X

# drop all by default
$IPTv4 -P INPUT DROP
$IPTv4 -P OUTPUT ACCEPT
$IPTv4 -P FORWARD DROP

# allow traffic on loopback and drop all traffic to 127.0.0.0/8 that does not use lo
$IPTv4 -A INPUT -i lo -j ACCEPT
$IPTv4 -A INPUT -i lo -d 127.0.0.0/8 -j REJECT

##
## =============================================================================
##

# allow ping
$IPTv4 -A INPUT -i $PUBIF -p icmp --icmp echo-request -j ACCEPT
$IPTv4 -A INPUT -i $PUBIF -p icmp --icmp echo-reply -j ACCEPT

# allow traffic already established to continue
$IPTv4 -A INPUT -i $PUBIF -m state --state ESTABLISHED,RELATED -j ACCEPT

# allow SSH
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 2200 -m state --state NEW,ESTABLISHED -j ACCEPT

# allow OpenVPN
#$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 8443 -m state --state NEW,ESTABLISHED -j ACCEPT

# allow SMTP
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 25 -j ACCEPT

# allow HTTP/HTTPS
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 80 -j ACCEPT
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 443 -j ACCEPT

# allow FTP
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 20 -j ACCEPT
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 21 -j ACCEPT
$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 1900:1999 -j ACCEPT

# allow POP3/IMAP
#$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 110 -j ACCEPT
#$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 143 -j ACCEPT
#$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 993 -j ACCEPT
#$IPTv4 -A INPUT -i $PUBIF -p tcp --dport 995 -j ACCEPT

# allow SAMBA
#if [[ "$IP_ADDRESS" == 192.168.* ]]; then
#    # at home
#    $IPTv4 -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 137 -j ACCEPT
#    $IPTv4 -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 138 -j ACCEPT
#    $IPTv4 -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 139 -j ACCEPT
#    $IPTv4 -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 445 -j ACCEPT
#else
#    # live (VPN only)
#    $IPTv4 -A INPUT -s $VPN_NETWORK/$VPN_NETMASK -m state --state NEW -p tcp --dport 137 -j ACCEPT
#    $IPTv4 -A INPUT -s $VPN_NETWORK/$VPN_NETMASK -m state --state NEW -p tcp --dport 138 -j ACCEPT
#    $IPTv4 -A INPUT -s $VPN_NETWORK/$VPN_NETMASK -m state --state NEW -p tcp --dport 139 -j ACCEPT
#    $IPTv4 -A INPUT -s $VPN_NETWORK/$VPN_NETMASK -m state --state NEW -p tcp --dport 445 -j ACCEPT
#fi

# drop private network address on public interface
#$IPTv4 -A INPUT -i $PUBIF -s 10.0.0.0/8 -j LOG --log-prefix "ip spoof: " # A
#$IPTv4 -A INPUT -i $PUBIF -s 10.0.0.0/8 -j DROP
#$IPTv4 -A INPUT -i $PUBIF -s 172.16.0.0/12 -j LOG --log-prefix "ip spoof: " # B
#$IPTv4 -A INPUT -i $PUBIF -s 172.16.0.0/12 -j DROP
#$IPTv4 -A INPUT -i $PUBIF -s 192.168.0.0/16 -j LOG --log-prefix "ip spoof: " # C
#$IPTv4 -A INPUT -i $PUBIF -s 192.168.0.0/16 -j DROP
#$IPTv4 -A INPUT -i $PUBIF -s 224.0.0.0/4 -j LOG --log-prefix "ip spoof: " # multicast D
#$IPTv4 -A INPUT -i $PUBIF -s 224.0.0.0/4 -j DROP
#$IPTv4 -A INPUT -i $PUBIF -s 240.0.0.0/5 -j LOG --log-prefix "ip spoof: " # E
#$IPTv4 -A INPUT -i $PUBIF -s 240.0.0.0/5 -j DROP
#$IPTv4 -A INPUT -i $PUBIF -s 127.0.0.0/8 -j LOG --log-prefix "ip spoof: " # loopback
#$IPTv4 -A INPUT -i $PUBIF -s 127.0.0.0/8 -j DROP

##
## =============================================================================
##

# log dropped packets
$IPTv4 -A INPUT -m limit --limit 6/minute -j LOG --log-prefix "iptables denied: " --log-level 7

# make sure nothing else comes to this box
$IPTv4 -A INPUT -j DROP

# show detailed view of created rules
$IPTv4 -L -v

# log event
logger -p local0.notice -t host4ge "firewall rules loaded"

exit 0
