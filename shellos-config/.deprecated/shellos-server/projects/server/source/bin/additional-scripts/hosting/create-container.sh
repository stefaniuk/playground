#!/bin/bash

# USAGE: create-container.sh 192.168.0.16 255.255.255.0 192.168.0.1 24 br1

NAME="ubuntu"
LOCATION=/srv/lxc/lib/lxc/$NAME
ARCH="amd64"
IP=$1
SUBNET=$2
GW=$3
NET=$4
TYPE=$5

#lxc-start -n $NAME -f $LOCATION/config -l DEBUG -o ~/lxc-$NAME.log -d
#rm ~/debug.out
#lxc-start -n $NAME -f $LOCATION/config -l DEBUG -o ~/debug.out
#screen lxc-console -n $NAME
#lxc-stop -n $NAME
#lxc-info -n $NAME

exit 0

#debootstrap
rm -rf $LOCATION
mkdir -p $LOCATION/rootfs
debootstrap --arch $ARCH precise $LOCATION/rootfs http://archive.ubuntu.com/ubuntu || exit 0
#rm -rf $LOCATION/fstab; rm -rf $LOCATION/config; rm -rf $LOCATION/rootfs; cp -a $LOCATION/rootfs.backup $LOCATION/rootfs

#container main config file
COUNT=`lxc-ls |uniq |wc -l`
cat <<EOF > $LOCATION/config
lxc.utsname = $NAME
lxc.network.type = veth
lxc.network.flags = up
lxc.network.mtu = 1500
# br0 = bridge, br1 = nat
lxc.network.link = $TYPE
# As appropiate (line only needed if you wish to dhcp later. To be unique)
lxc.network.hwaddr =  00:FF:08:5E:00:$COUNT
# (Use 0.0.0.0 if you wish to dhcp later)
lxc.network.ipv4 = $IP/$NET
# could likely be whatever you want
lxc.network.name = eth0
lxc.mount = $LOCATION/fstab
lxc.rootfs = $LOCATION/rootfs
lxc.tty = 2
#lxc.cgroup.devices.deny = a
# /dev/null and zero
#lxc.cgroup.devices.allow = c 1:3 rwm
#lxc.cgroup.devices.allow = c 1:5 rwm
# consoles
#lxc.cgroup.devices.allow = c 5:1 rwm
#lxc.cgroup.devices.allow = c 5:0 rwm
#lxc.cgroup.devices.allow = c 4:0 rwm
#lxc.cgroup.devices.allow = c 4:1 rwm
# /dev/{,u}random
#lxc.cgroup.devices.allow = c 1:9 rwm
#lxc.cgroup.devices.allow = c 1:8 rwm
# /dev/pts/* - pts namespaces are "coming soon"
#lxc.cgroup.devices.allow = c 136:* rwm
#lxc.cgroup.devices.allow = c 5:2 rwm
# rtc
#lxc.cgroup.devices.allow = c 254:0 rwm
#fuse
#lxc.cgroup.devices.allow = c 10:229 rwm
#udev update
#lxc.cgroup.devices.allow = c 108:0 rwm
#lxc.cgroup.devices.allow = b 7:0 rwm
#lxc.cgroup.devices.allow = c 10:200 rwm
EOF

#container fstab
cat <<EOF > $LOCATION/fstab
none $LOCATION/rootfs/dev/pts devpts defaults 0 0
none $LOCATION/rootfs/proc    proc   defaults 0 0
none $LOCATION/rootfs/sys     sysfs  defaults 0 0
none $LOCATION/rootfs/dev/shm tmpfs  defaults 0 0
EOF

#cleanup container
pushd $LOCATION/rootfs/etc/init
rm -f mountall* control-alt-delete.conf hwclock* network-interface.conf procps.conf upstart-udev-bridge.conf
cat <<EOF > lxc.conf
# provide workaround to make upstart work with lxc

start on startup

task

script
 >/etc/mtab
        initctl emit virtual-filesystems
        initctl emit local-filesystems
        initctl emit remote-filesystems
        initctl emit filesystem
end script
EOF
cat <<EOF > networking.conf
#lxc-provider
# networking - configure virtual network devices
#
# This task causes virtual network devices that do not have an associated
# kernel object to be started on boot.
# Modified by lxc-provider
description     "configure virtual network devices"

start on local-filesystems

task

script
        mkdir -p /var/run/network || true
        ifdown -a
        ifup -a
end script
EOF
popd
cat <<EOF > $LOCATION/rootfs/etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address $IP
netmask $SUBNET
gateway $GW
mtu 1500
EOF
echo "$NAME" > $LOCATION/rootfs/etc/hostname
echo -e "127.0.0.1 localhost\n192.168.100.2 $NAME\n" > $LOCATION/rootfs/etc/hosts
echo "Set a new root password for the container:"
chroot $LOCATION/rootfs passwd root

# create the container
lxc-create -f $LOCATION/config -n $NAME

#fix container
cat <<EOF > $LOCATION/rootfs/etc/apt/sources.list
## main & restricted repositories
deb http://gb.archive.ubuntu.com/ubuntu/ precise main restricted
deb-src http://gb.archive.ubuntu.com/ubuntu/ precise main restricted

deb http://security.ubuntu.com/ubuntu precise-updates main restricted
deb-src http://security.ubuntu.com/ubuntu precise-updates main restricted

deb http://security.ubuntu.com/ubuntu precise-security main restricted
deb-src http://security.ubuntu.com/ubuntu precise-security main restricted

## universe repositories - uncomment to enable
deb http://gb.archive.ubuntu.com/ubuntu/ precise universe
deb-src http://gb.archive.ubuntu.com/ubuntu/ precise universe

deb http://gb.archive.ubuntu.com/ubuntu/ precise-updates universe
deb-src http://gb.archive.ubuntu.com/ubuntu/ precise-updates universe

deb http://security.ubuntu.com/ubuntu precise-security universe
deb-src http://security.ubuntu.com/ubuntu precise-security universe

## partner repositories
deb http://archive.canonical.com/ubuntu precise partner
deb-src http://archive.canonical.com/ubuntu precise partner

deb http://archive.canonical.com/ubuntu precise-updates partner
deb-src http://archive.canonical.com/ubuntu precise-updates partner

deb http://archive.canonical.com/ubuntu precise-security partner
deb-src http://archive.canonical.com/ubuntu precise-security partner
EOF

#create update backage for use rto run in lxc container:
cat <<FEOF > $LOCATION/rootfs/root/update.sh
apt-get update
apt-get --force-yes -y install lxc gpgv
apt-get update
apt-get --force-yes -y install language-pack-en
locale-gen en_US.UTF-8
update-locale LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" LC_CTYPE="C"
apt-get --force-yes -y install aptitude ppp dialog
apt-get --force-yes -y install openssh-server iproute iptables dnsutils syslog-ng sudo logrotate
aptitude -y upgrade
pushd /etc/init
rm -f mountall* control-alt-delete.conf hwclock* network-interface.conf procps.conf upstart-udev-bridge.conf
cat <<EOF > networking.conf
#lxc-provider
# networking - configure virtual network devices
#
# This task causes virtual network devices that do not have an associated
# kernel object to be started on boot.
# Modified by lxc-provider
description     "configure virtual network devices"

start on local-filesystems

task

script
        mkdir -p /var/run/network || true
        ifdown -a
        ifup -a
end script
EOF
cat <<EOF > /etc/network/if-up.d/upstart
#!/bin/sh

set -e

initctl emit -n net-device-up \\\\
        "IFACE=\\\$IFACE" \\\\
        "LOGICAL=\\\$LOGICAL" \\\\
        "ADDRFAM=\\\$ADDRFAM" \\\\
        "METHOD=\\\$METHOD"
EOF
popd
FEOF
chmod 755 $LOCATION/rootfs/root/update.sh
echo -e "\n\n\nWe are done, you may start your container now."
echo "IMPORTANT: to update & upgrade your system run this NOW:"
echo "1. start container: lxc-start -d -n $NAME"
echo "2. connect to container: lxc-console -n $NAME"
echo "3. login when prompted for username and password by container"
echo "4. inside container, run the update script: /root/update.sh"
echo "5. optional: remove the script when done: rm -f /root/update.sh"
echo "6. when done, exit container, stop, start again and connect to console to see if all still works."
echo -e "\n\nSome tips:"
echo "lxc-create -f $LOCATION/config -n $NAME will create the container"
echo "lxc-destroy -n $NAME will kill it"
echo "lxc-start -d -n $NAME starts a container"
echo "lxc-stop -n $NAME will in fact stop it brutally. use lxc-halt to be nice"
echo "lxc-console -n $NAME will give you console access to the container"
echo "Ctrl+a q will let you get out of the console"
echo "Have fun!"

exit 0
