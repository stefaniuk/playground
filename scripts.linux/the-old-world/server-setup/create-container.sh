#!/bin/bash
#
# usage:
#
#	./create-container.sh
#	./create-container.sh 2>&1 | tee create-container.out
#	bash -x ./create-container.sh 2>&1 | tee create-container.out
#
# see:
#
#	http://blog.bodhizazen.net/linux/lxc-linux-containers/
#	http://blog.bodhizazen.net/linux/lxc-configure-ubuntu-lucid-containers/
#	http://lxc.teegra.net/
#

debootstrap --variant=minbase --arch amd64 lucid rootfs.ubuntu

# fix devices
LXC_DEV_DIR=/usr/local/containers/rootfs.ubuntu/dev
rm -rf $LXC_DEV_DIR
mkdir $LXC_DEV_DIR
mknod -m 666 $LXC_DEV_DIR/null c 1 3
mknod -m 666 $LXC_DEV_DIR/zero c 1 5
mknod -m 666 $LXC_DEV_DIR/random c 1 8
mknod -m 666 $LXC_DEV_DIR/urandom c 1 9
mkdir -m 755 $LXC_DEV_DIR/pts
mkdir -m 1777 $LXC_DEV_DIR/shm
mknod -m 666 $LXC_DEV_DIR/tty c 5 0
mknod -m 666 $LXC_DEV_DIR/tty0 c 4 0
mknod -m 666 $LXC_DEV_DIR/tty1 c 4 1
mknod -m 666 $LXC_DEV_DIR/tty2 c 4 2
mknod -m 666 $LXC_DEV_DIR/tty3 c 4 3
mknod -m 666 $LXC_DEV_DIR/tty4 c 4 4
mknod -m 600 $LXC_DEV_DIR/console c 5 1
mknod -m 666 $LXC_DEV_DIR/full c 1 7
mknod -m 600 $LXC_DEV_DIR/initctl p
mknod -m 666 $LXC_DEV_DIR/ptmx c 5 2

cat > /usr/local/containers/rootfs.ubuntu/etc/apt/sources.list << "EOF"
deb http://gb.archive.ubuntu.com/ubuntu/ lucid main universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ lucid-security main universe multiverse
EOF

chroot /usr/local/containers/rootfs.ubuntu /bin/bash

apt-get -y install --force-yes -y gpgv
apt-get update

# set locales
apt-get -y install language-pack-en
locale-gen en_US.UTF-8
/usr/sbin/update-locale LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" LC_CTYPE="C"
# Add to the installed applications
apt-get install -y adduser apt-utils console-setup iproute iptables nano netbase openssh-blacklist openssh-blacklist-extra openssh-server php5 iputils-ping rsyslog sudo ufw
#Set a root passwd
passwd
# As an alternate to setting a root password, you may of course add a new user and configure sudo.
# Configure the hostname of the container and /etc/hosts
# Change "host_name" to your desired host name
# Change "192.168.0.60" to the ip address you wish to assign to the container
echo "host1" > /etc/hostname
echo "127.0.0.1 localhost host1" > /etc/hosts
echo "192.168.165.70 host1" >> /etc/hosts
# Fix mtab
rm /etc/mtab
ln -s /proc/mounts /etc/mtab
cat >> /etc/environment << "EOF"
LANG="en_US.UTF-8"
LANGUAGE="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
LC_CTYPE="C"
EOF

exit chroot

cat > /usr/local/containers/config.ubuntu << "EOF"
lxc.utsname = ubuntu
lxc.tty = 4
lxc.network.type = vlan
lxc.network.vlan.id = 1234
lxc.network.flags = up
lxc.network.link = eth0
lxc.network.hwaddr = 4a:49:43:49:79:bd
lxc.network.ipv4 = 1.2.3.4/24
lxc.network.ipv6 = 2003:db8:1:0:214:1234:fe0b:3596
#lxc.network.type = veth
#lxc.network.flags = up
#lxc.network.link = br0
#lxc.network.name = eth0
#lxc.network.mtu = 1500
#lxc.network.ipv4 = 192.168.165.70/255
lxc.rootfs = /usr/local/containers/rootfs.ubuntu
lxc.mount = /usr/local/containers/fstab.ubuntu
lxc.cgroup.devices.deny = a
# /dev/null and zero
lxc.cgroup.devices.allow = c 1:3 rwm
lxc.cgroup.devices.allow = c 1:5 rwm
# consoles
lxc.cgroup.devices.allow = c 5:1 rwm
lxc.cgroup.devices.allow = c 5:0 rwm
lxc.cgroup.devices.allow = c 4:0 rwm
lxc.cgroup.devices.allow = c 4:1 rwm
# /dev/{,u}random
lxc.cgroup.devices.allow = c 1:9 rwm
lxc.cgroup.devices.allow = c 1:8 rwm
# /dev/pts/* - pts namespaces are "coming soon"
lxc.cgroup.devices.allow = c 136:* rwm
lxc.cgroup.devices.allow = c 5:2 rwm
# rtc
lxc.cgroup.devices.allow = c 254:0 rwm
EOF

cat > /usr/local/containers/fstab.ubuntu << "EOF"
none /usr/local/containers/rootfs.ubuntu/dev/pts devpts defaults 0 0
none /usr/local/containers/rootfs.ubuntu/proc proc defaults 0 0
none /usr/local/containers/rootfs.ubuntu/sys sysfs defaults 0 0
none /usr/local/containers/rootfs.ubuntu/var/lock tmpfs defaults 0 0
none /usr/local/containers/rootfs.ubuntu/var/run tmpfs defaults 0 0
/etc/resolv.conf /usr/local/containers/rootfs.ubuntu/etc/resolv.conf none bind 0 0
EOF

rm -f /usr/local/containers/rootfs.ubuntu/etc/init/rc-sysinit
cat > /usr/local/containers/rootfs.ubuntu/etc/init/rc-sysinit << "EOF"
#!/bin/bash
rm -f $(find /var/run -name '*pid')
rm -f /var/lock/apache/*
route add default gw 109.74.198.1
exit 0
EOF
chmod a+x /usr/local/containers/rootfs.ubuntu/etc/init/rc-sysinit

cd /usr/local/containers/rootfs.ubuntu/etc/init
rm -f console* control* hwclock* module* mount* network-interface* plymouth* procps* tty{4,5,6}.conf udev* upstart*

mkdir -p /usr/local/containers/rootfs.ubuntu/lib/modules/2.6.32-30-server/kernel
cp /lib/modules/2.6.32-30-server/modules.dep /usr/local/containers/rootfs.ubuntu/lib/modules/2.6.32-30-server/
cp -R /lib/modules/2.6.32-30-server/kernel/net /usr/local/containers/rootfs.ubuntu/lib/modules/2.6.32-30-server/kernel/

#lxc-destroy -n ubuntu
#lxc-create -f /usr/local/containers/config.ubuntu -n ubuntu
#lxc-ls
#lxc-start --name ubuntu --rcfile /usr/local/containers/config.ubuntu --logpriority=DEBUG --logfile=/usr/local/ubuntu.out /bin/bash
#lxc-info -n ubuntu
