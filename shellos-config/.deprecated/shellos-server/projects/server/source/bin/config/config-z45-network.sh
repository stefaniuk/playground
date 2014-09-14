#!/bin/bash

[ ! -f /etc/network/interfaces.old ] && cp /etc/network/interfaces /etc/network/interfaces.old

# /etc/network/interfaces (loopback network interface)
cat <<EOF > /etc/network/interfaces
# loopback network interface
auto lo
iface lo inet loopback
  address 127.0.0.1
  netmask 255.0.0.0
EOF

# /etc/network/interfaces (primary network interface)
cat <<EOF >> /etc/network/interfaces

# primary network interface
auto eth0
iface eth0 inet static
  address $IP_ADDRESS1
  netmask $NETMASK
  network $NETWORK
  broadcast $BROADCAST
  gateway $GATEWAY
EOF
[ "$DNS_NAMESERVERS" != "none" ] && cat <<EOF >> /etc/network/interfaces
  dns-nameservers $DNS_NAMESERVERS
EOF
[ "$DNS_SEARCH" != "none" ] && cat <<EOF >> /etc/network/interfaces
  dns-search $DNS_SEARCH
EOF

# /etc/network/interfaces (secondary network interface)
[ "$IP_ADDRESS2" != "none" ] && cat <<EOF >> /etc/network/interfaces

# secondary network interface
auto eth0:0
iface eth0:0 inet static
  address $IP_ADDRESS2
  netmask $NETMASK
  network $NETWORK
  broadcast $BROADCAST
EOF

# /etc/network/interfaces (bridge), SEE: http://linuxnet.ch/groups/linuxnet/wiki/a0502/Setup_Linux_VLAN__vconfig.html
#cat <<EOF >> /etc/network/interfaces

#auto br0
#iface br0 inet static
#  address $IP_ADDRESS1
#  netmask $NETMASK
#  network $NETWORK
#  broadcast $BROADCAST
#  gateway $GATEWAY
#  bridge_ports eth0
#  bridge_fd 9
#  bridge_hello 2
#  bridge_maxage 12
#  bridge_stp off

#auto br1
#iface br1 inet static
#  pre-up modprobe dummy
#  address 172.19.0.1
#  netmask 255.255.255.0
#  network 172.19.0.0
#  broadcast 172.19.0.255
#  bridge_fd 0
#  bridge_ports dummy0
#  pre-up /sbin/iptables -t nat -A POSTROUTING -o br0 -j MASQUERADE
#  post-up echo "1" > /proc/sys/net/ipv4/ip_forward
#  post-down /sbin/iptables -t nat -D POSTROUTING -o br0 -j MASQUERADE
#EOF

##
## #####################################################################################################################
##

#if [[ "$IP_ADDRESS" == 192.168.* ]]; then
#    # /etc/resolv.conf
#    cat <<EOF > /etc/resolv.conf
#nameserver 192.168.1.1
#EOF
#fi

if [[ "$IP_ADDRESS" == 192.168.* ]] && [[ "$SERVER_ROLE" == *test* ]]; then
    # /etc/hosts
    cat <<EOF >> /etc/hosts

192.168.1.71    host4ge-test1 host4ge-test1.host4ge.com
192.168.1.73    host4ge-test2 host4ge-test2.host4ge.com
192.168.1.75    host4ge-test3 host4ge-test3.host4ge.com
EOF
fi

exit 0
