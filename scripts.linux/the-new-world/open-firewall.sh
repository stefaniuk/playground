#!/bin/bash
#
# usage:
#
#	./open-firewall.sh

echo Script started on $(date)

###
### initialize
###

# flush all rules
iptables -F
iptables -X

# allow any traffic
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# show detailed view of created rules
iptables -L -v

echo Script ended on $(date)
