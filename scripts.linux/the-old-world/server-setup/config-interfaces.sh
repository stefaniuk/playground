#!/bin/bash
#
# usage:
#
#	./config-interfaces.sh
#	./config-interfaces.sh 2>&1 | tee config-interfaces.out
#	bash -x ./config-interfaces.sh 2>&1 | tee config-interfaces.out
#
# see:
#
#	http://library.linode.com/networking/configuring-static-ip-interfaces/
#	http://www.linuxfoundation.org/collaborate/workgroups/networking/vlan
#	http://www.tolaris.com/2010/02/20/vlans-bridges-and-virtual-machines/
#

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install vlan bridge-utils

#cat > /etc/resolv.conf << "EOF"
#domain members.linode.com
#search members.linode.com
#nameserver 109.74.192.20
#nameserver 109.74.193.20
#nameserver 109.74.194.20
#options rotate
#EOF

cat > /etc/network/interfaces << "EOF"
auto lo
iface lo inet loopback

# this line ensures that the interface will be brought up during boot
#auto eth0 eth0:0

# eth0 - this is the main IP address
#iface eth0 inet static
#address 109.74.198.188
#netmask 255.255.255.0
#gateway 109.74.198.1

# eth0:0 - this is a private IP
#iface eth0:0 inet static
#address 192.168.165.66
#netmask 255.255.128.0

auto br0
iface br0 inet dhcp
bridge_ports eth0
bridge_stp off
bridge_maxwait 5
post-up /usr/sbin/brctl setfd br0 0
EOF

/etc/init.d/networking restart

ifconfig
route -n
