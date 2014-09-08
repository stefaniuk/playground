#!/bin/bash
# Create global variables
# Define Bridge Interface
br="br0"
# Define list of TAP interfaces to be bridged,
# for example tap="tap0 tap1 tap2".
tap="tap0"
# Define physical ethernet interface to be bridged
# with TAP interface(s) above.
eth="eth0"
eth_ip="109.74.198.188"
eth_netmask="255.255.255.0"
eth_broadcast="109.74.198.255"
gw="109.74.198.1"
start_bridge () {
#################################
# Set up Ethernet bridge on Linux
# Requires: bridge-utils
#################################
for t in $tap; do
openvpn --mktun --dev $t
done
for t in $tap; do
ifconfig $t 0.0.0.0 promisc up
done
ifconfig $eth 0.0.0.0 promisc up
brctl addbr $br
brctl addif $br $eth
for t in $tap; do
brctl addif $br $t
done
ifconfig $br $eth_ip netmask $eth_netmask broadcast $eth_broadcast up
route add default gw $gw $br
}
stop_bridge () {
####################################
# Tear Down Ethernet bridge on Linux
####################################
ifconfig $br down
brctl delbr $br
for t in $tap; do
openvpn --rmtun --dev $t
done
ifconfig $eth $eth_ip netmask $eth_netmask broadcast $eth_broadcast up
route add default gw $gw $eth
}
case "$1" in
start)
echo -n "Starting Bridge"
start_bridge
;;
stop)
echo -n "Stopping Bridge"
stop_bridge
;;
restart)
stop_bridge
sleep 2
start_bridge
;;
*)
echo "Usage: $0 {start|stop|restart}" >&2
exit 1
;;
esac