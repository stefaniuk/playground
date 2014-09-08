#!/bin/bash
#
# usage:
#
#	./install-lxc.sh 2>&1 | tee install-lxc.out
#	bash -x ./install-lxc.sh 2>&1 | tee install-lxc.out
#
# see:
#
#	http://ubuntuforums.org/showthread.php?t=1497732
#	https://help.ubuntu.com/community/LXC
#	http://blog.bodhizazen.net/linux/lxc-linux-containers/
#	http://blog.bodhizazen.net/linux/lxc-configure-ubuntu-lucid-containers/
#	http://xiaopeng.me/2011/01/setup-lxc-container-on-ubuntu-10-04-inside-virtualbox/
#	http://lxc.sourceforge.net/man/
#	http://www.mail-archive.com/lxc-users@lists.sourceforge.net/msg01447.html
#
#	http://blog.foaa.de/2010/05/lxc-on-debian-squeeze/
#

###
### functions
###

# parameters: str_to_remove file_name
function remove_from_file {

	TMP_FILE=/tmp/remove_from_file.$$
	TMP_STR='1h;1!H;${;g;s/'
	sed -n "$TMP_STR$1//g;p;}" $2 > $TMP_FILE && mv $TMP_FILE $2
}

###
### script
###

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install vlan bridge-utils lxc debootstrap screen git-core

[ -d /cgroup ] && umount /cgroup && rm -r /cgroup
mkdir -p /cgroup
remove_from_file "\nnone \/cgroup cgroup defaults 0 0" /etc/fstab
echo "none /cgroup cgroup defaults 0 0" >> /etc/fstab
mount /cgroup

cat > /etc/network/interfaces << "EOF"
auto lo
iface lo inet loopback

auto br0
iface br0 inet dhcp
	bridge_ports eth0
	bridge_fd 0
EOF
/etc/init.d/networking restart

ifconfig
lxc-checkconfig

[ ! -d /usr/local/containers ] && mkdir /usr/local/containers
[ ! -d /usr/local/lxc-tools ] && git clone git://github.com/stefaniuk/lxc-tools.git /usr/local/lxc-tools

#lxc-start --name lemon -l DEBUG -o $(tty)
