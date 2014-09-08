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
#	https://help.ubuntu.com/community/LXC
#	http://lxc.sourceforge.net/man/
#	http://lxc.teegra.net/
#

###
### variables
###

CURRENT_DIR=`pwd`
WORKING_DIR=/usr/local
INSTALL_DIR=/usr/local
LXC_CONTAINERS_DIR=$INSTALL_DIR/lxc-containers
LXC_TOOLS_DIR=$INSTALL_DIR/lxc-tools
LXC_VERSION=0.7.4.1

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

echo "Script $(readlink -f $0) started on $(date)"

cd $WORKING_DIR

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install build-essential libcap-dev libcap2-bin \
	debootstrap screen git-core

if [ ! -f lxc.tar.gz ]; then
	wget http://lxc.sourceforge.net/download/lxc/lxc-$LXC_VERSION.tar.gz -O lxc.tar.gz
fi
[ -d $INSTALL_DIR/lxc ] && rm -rf $INSTALL_DIR/lxc
tar -zxf lxc.tar.gz
cd lxc-$LXC_VERSION
./configure \
	--prefix=$INSTALL_DIR/lxc \
&& make && make install && echo LXC installed successfully!
mkdir -p $INSTALL_DIR/lxc/var/lib/lxc
cd ..
rm -rf lxc-$LXC_VERSION

[ -d /cgroup ] && umount /cgroup && rm -rf /cgroup
mkdir -p /cgroup
remove_from_file "\nnone \/cgroup cgroup defaults 0 0" /etc/fstab
echo "none /cgroup cgroup defaults 0 0" >> /etc/fstab
mount /cgroup

$INSTALL_DIR/lxc/bin/lxc-checkconfig

[ ! -d $LXC_CONTAINERS_DIR ] && mkdir $LXC_CONTAINERS_DIR
[ ! -d $LXC_TOOLS_DIR ] && git clone git://github.com/stefaniuk/lxc-tools.git $LXC_TOOLS_DIR

NEW_PATH=$INSTALL_DIR/lxc/bin:$LXC_TOOLS_DIR
remove_from_file "\n# BEGIN: path.*END: path\n" ~/.profile
echo -e "# BEGIN: path" >> ~/.profile
echo -e "export PATH=\"$NEW_PATH:/usr/sbin:/usr/bin:/sbin:/bin\"" >> ~/.profile
echo -e "# END: path\n" >> ~/.profile

cd $CURRENT_DIR

echo "Script $(readlink -f $0) ended on $(date)"
