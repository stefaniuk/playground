#!/bin/bash
#
# https://help.ubuntu.com/community/IptablesHowTo
# http://www.cyberciti.biz/tips/linux-iptables-12-how-to-block-or-open-dnsbind-service-port-53.html
#
# TODO: save iptables rules
#

echo Script started on $(date)

###
### initialize
###

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

# allow incoming SSH
iptables -A INPUT -p tcp --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# allow web traffic
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# allow DNS
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# allow ping
iptables -A INPUT -p icmp --icmp echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp echo-reply -j ACCEPT

# log dropped packets
iptables -A INPUT -m limit --limit 10/minute -j LOG --log-prefix "iptables denied: " --log-level 7

# make sure nothing else comes or goes out of this box
iptables -A INPUT -j DROP

# show detailed view of created rules
iptables -L -v

echo Script ended on $(date)
