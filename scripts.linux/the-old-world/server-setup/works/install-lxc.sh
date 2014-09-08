#!/bin/bash
#
# usage:
#
#	./install-lxc.sh
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
apt-get -y install build-essential \
	lxc debootstrap screen git-core

#LXC_VERSION=0.7.4.1
#wget http://lxc.sourceforge.net/download/lxc/lxc-$LXC_VERSION.tar.gz -O lxc.tar.gz
#tar -zxf lxc.tar.gz
#cd lxc-$LXC_VERSION
#./configure --prefix=/usr/local/lxc \
#&& make make install echo LXC installed successfully!

[ -d /cgroup ] && umount /cgroup && rm -r /cgroup
mkdir -p /cgroup
remove_from_file "\nnone \/cgroup cgroup defaults 0 0" /etc/fstab
echo "none /cgroup cgroup defaults 0 0" >> /etc/fstab
mount /cgroup

lxc-checkconfig

[ ! -d /usr/local/containers ] && mkdir /usr/local/containers
[ ! -d /usr/local/lxc-tools ] && git clone git://github.com/stefaniuk/lxc-tools.git /usr/local/lxc-tools

### 1.
# lxc-ubuntu create -n vm0
# http://gb.archive.ubuntu.com/ubuntu
# lxc-start --name vm0 --rcfile /usr/local/containers/vm0.conf --logpriority=DEBUG --logfile=/usr/local/vm0.out --daemon &
# lxc-info --name vm0
# no network in the container, disconected SSH session for ~30sec, vm has been stoped
