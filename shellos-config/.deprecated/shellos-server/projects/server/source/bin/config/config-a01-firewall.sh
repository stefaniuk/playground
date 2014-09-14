#!/bin/bash

if [ "$SERVER_MODE" == "installation" ]; then

    iptables -F
    iptables -X
    iptables -P INPUT REJECT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD DROP
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A INPUT -p icmp --icmp echo-request -j ACCEPT
    iptables -A INPUT -p icmp --icmp echo-reply -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A INPUT -p tcp --dport 2200 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A INPUT -m limit --limit 6/minute -j LOG --log-prefix "iptables denied: " --log-level 7
    iptables -A INPUT -j REJECT
    iptables -L -v

fi

exit 0
