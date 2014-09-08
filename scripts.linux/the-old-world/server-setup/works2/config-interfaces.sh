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
#	http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge
#	http://www.linuxfoundation.org/collaborate/workgroups/networking/vlan
#	http://www.tolaris.com/2010/02/20/vlans-bridges-and-virtual-machines/
#
#	http://www.faqs.org/docs/Linux-mini/IP-Alias.html
#	http://mailman.ds9a.nl/pipermail/lartc/2006q1/018537.html
#	http://www.linuxsa.org.au/pipermail/linuxsa/2006-July/084589.html
#

###
### variables
###

# TODO: read arguments
IP_PUBLIC=109.74.198.188
NETMASK_PUBLIC=255.255.255.0
IP_PRIVATE=192.168.165.66
NETMASK_PRIVATE=255.255.128.0
GATEWAY=109.74.198.1

###
### script
###

echo "Script $(readlink -f $0) started on $(date)"

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install tcpdump vlan bridge-utils

cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

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

echo "Script $(readlink -f $0) ended on $(date)"
