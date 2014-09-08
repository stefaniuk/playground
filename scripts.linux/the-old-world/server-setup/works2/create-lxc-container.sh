#!/bin/bash
#
# usage:
#
#	./create-lxc-container.sh
#	./create-lxc-container.sh 2>&1 | tee create-lxc-container.out
#	bash -x ./create-lxc-container.sh 2>&1 | tee create-lxc-container.out
#
# see:
#
#	http://blog.bodhizazen.net/linux/lxc-linux-containers/
#	http://blog.bodhizazen.net/linux/lxc-configure-ubuntu-lucid-containers/
#	http://lxc.teegra.net/
#	http://ubuntuforums.org/showthread.php?t=1497732
#	https://help.ubuntu.com/community/LXC
#	http://xiaopeng.me/2011/01/setup-lxc-container-on-ubuntu-10-04-inside-virtualbox/
#	http://lxc.sourceforge.net/man/
#	http://www.mail-archive.com/lxc-users@lists.sourceforge.net/msg01447.html
#	http://blog.foaa.de/2010/05/lxc-on-debian-squeeze/
#
#	http://www.mail-archive.com/lxc-users@lists.sourceforge.net/msg01582.html
#	http://www.nsnam.org/wiki/index.php/HOWTO_Use_Linux_Containers_to_set_up_virtual_networks
#

###
### variables
###

CURRENT_DIR=`pwd`
WORKING_DIR=/usr/local
INSTALL_DIR=/usr/local
LXC_CONTAINERS_DIR=$INSTALL_DIR/lxc-containers
# TODO: read arguments
LXC_CONTAINER_IP=192.168.1.1
LXC_CONTAINER_NAME=vm1
MIRROR=http://gb.archive.ubuntu.com/ubuntu/

###
### script
###

echo "Script $(readlink -f $0) started on $(date)"

cd $WORKING_DIR

debootstrap --variant=minbase --arch amd64 lucid $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME $MIRROR

# fix devices
LXC_DEV_DIR=$LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/dev
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

cat <<EOF > $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/etc/apt/sources.list
deb $MIRROR lucid main universe multiverse
deb $MIRROR lucid-security main universe multiverse
EOF

chroot $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME /bin/bash

# TODO: repeat variables

apt-get update
apt-get -y install --force-yes -y gpgv

apt-get -y install language-pack-en
locale-gen en_US.UTF-8
/usr/sbin/update-locale LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" LC_CTYPE="C"
apt-get install -y adduser apt-utils console-setup iproute iptables nano netbase openssh-blacklist openssh-blacklist-extra openssh-server php5 iputils-ping rsyslog sudo ufw
passwd
echo "$LXC_CONTAINER_NAME" > /etc/hostname
echo "127.0.0.1 localhost $LXC_CONTAINER_NAME" > /etc/hosts
echo "$LXC_CONTAINER_IP $LXC_CONTAINER_NAME" >> /etc/hosts
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

cat <<EOF > $LXC_CONTAINERS_DIR/config.$LXC_CONTAINER_NAME
lxc.utsname = $LXC_CONTAINER_NAME
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
#lxc.network.ipv4 = $LXC_CONTAINER_IP/24
lxc.rootfs = $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME
lxc.mount = $LXC_CONTAINERS_DIR/fstab.$LXC_CONTAINER_NAME
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

cat <<EOF > $LXC_CONTAINERS_DIR/config.$LXC_CONTAINER_NAME
lxc.utsname = $LXC_CONTAINER_NAME
lxc.tty = 4
lxc.network.type = vlan
lxc.network.vlan.id = 1234
lxc.network.flags = up
lxc.network.link = eth0
lxc.network.hwaddr = 4a:49:43:49:79:bd
lxc.network.ipv4 = $LXC_CONTAINER_IP/24
lxc.network.ipv6 = 2003:db8:1:0:214:1234:fe0b:3596
lxc.rootfs = $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME
lxc.mount = $LXC_CONTAINERS_DIR/fstab.$LXC_CONTAINER_NAME
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

cat <<EOF > $LXC_CONTAINERS_DIR/fstab.$LXC_CONTAINER_NAME
none $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/dev/pts devpts defaults 0 0
none $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/proc proc defaults 0 0
none $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/sys sysfs defaults 0 0
none $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/var/lock tmpfs defaults 0 0
none $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/var/run tmpfs defaults 0 0
/etc/resolv.conf $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/etc/resolv.conf none bind 0 0
EOF

rm -f $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/etc/init/rc-sysinit
cat > $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/etc/init/rc-sysinit << "EOF"
#!/bin/bash
rm -f $(find /var/run -name '*pid')
rm -f /var/lock/apache/*
route add default gw 109.74.198.1
exit 0
EOF
chmod a+x $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/etc/init/rc-sysinit

cd $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/etc/init
rm -f console* control* hwclock* module* mount* network-interface* plymouth* procps* tty{4,5,6}.conf udev* upstart*

mkdir -p $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/lib/modules/2.6.32-30-server/kernel
cp /lib/modules/2.6.32-30-server/modules.dep $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/lib/modules/2.6.32-30-server/
cp -R /lib/modules/2.6.32-30-server/kernel/net $LXC_CONTAINERS_DIR/$LXC_CONTAINER_NAME/lib/modules/2.6.32-30-server/kernel/

### 1.
# lxc-ubuntu create -n vm0 2>&1 | tee lxc-ubuntu.vm0.out
# http://gb.archive.ubuntu.com/ubuntu
# lxc-start --name vm0 --rcfile /usr/local/lxc-containers/vm0.conf --logpriority=DEBUG --logfile=/usr/local/vm0.out --daemon &
# lxc-info --name vm0
# no network in the container, disconected SSH session for ~30sec, vm has been stoped

### 2.
#lxc-destroy -n vm1
#lxc-create -f /usr/local/lxc-containers/config.vm1 -n vm1
#lxc-ls
#lxc-start --name vm1 --rcfile /usr/local/lxc-containers/config.vm1 --logpriority=DEBUG --logfile=/usr/local/vm1.out /bin/bash
#lxc-info -n vm1

cd $CURRENT_DIR

echo "Script $(readlink -f $0) ended on $(date)"
