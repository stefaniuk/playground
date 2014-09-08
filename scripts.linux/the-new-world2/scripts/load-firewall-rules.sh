#!/bin/bash
#
# File: load-firewall-rules.sh
#
# Description: This script defines firewall rules.
#
# Usage:
#
#	./load-firewall-rules.sh

# log event
logger -p local0.notice -t host4ge "load firewall rules"

# flush all rules
iptables -F
iptables -X

# allow outgoing traffic and disallow any passthroughs
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# allow traffic already established to continue
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT

# allow traffic on loopback
iptables -A INPUT -i lo -j ACCEPT

# allow ping
iptables -A INPUT -p icmp --icmp echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp echo-reply -j ACCEPT

# allow DNS
#iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# allow SSH
iptables -A INPUT -p tcp --dport 2200 -m state --state NEW,ESTABLISHED -j ACCEPT

# allow HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# allow FTP
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -j ACCEPT

# allow SMTP/POP3/IMAP
#iptables -A INPUT -p tcp --dport 25 -j ACCEPT
#iptables -A INPUT -p tcp --dport 110 -j ACCEPT
#iptables -A INPUT -p tcp --dport 143 -j ACCEPT
#iptables -A INPUT -p tcp --dport 993 -j ACCEPT
#iptables -A INPUT -p tcp --dport 995 -j ACCEPT

# log dropped packets
iptables -A INPUT -m limit --limit 10/minute -j LOG --log-prefix "iptables denied: " --log-level 7

# make sure nothing else comes to this box
iptables -A INPUT -j DROP

# show detailed view of created rules
iptables -L -v
