#!/bin/bash
#
# usage:
#
#	./config-network.sh
#	./config-network.sh 2>&1 | tee config-network.out
#	bash -x ./config-network.sh 2>&1 | tee config-network.out
#
# see:
#
#	http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge
#	http://www.monkeedev.co.uk/blog/2009/03/06/setting-up-openvpn-in-debianubuntu/
#

###
### variables
###

eth_ip="109.74.198.188"
eth_netmask="255.255.255.0"
eth_broadcast="109.74.198.255"
gateway="109.74.198.1"

br="br0"
eth="eth0"
tap="eth0:0"

###
### script
###

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install bridge-utils

start_bridge () {
	ifconfig $tap 0.0.0.0 promisc up
	ifconfig $eth 0.0.0.0 promisc up
	brctl addbr $br
	brctl addif $br $eth
	brctl addif $br $tap
	ifconfig $br $eth_ip netmask $eth_netmask broadcast $eth_broadcast up
	route add default gw $gateway $br
}

start_bridge

ifconfig
