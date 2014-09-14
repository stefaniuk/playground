#!/bin/bash

# /etc/hostname
echo "$(hostname)" > /etc/hostname

# /etc/hosts
[ ! -f /etc/hosts.old ] && cp /etc/hosts /etc/hosts.old
cat <<EOF > /etc/hosts
127.0.0.1 localhost.localdomain localhost
$IP_ADDRESS $(hostname).$DOMAIN $(hostname)

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

exit 0
