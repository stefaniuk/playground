#!/bin/bash
#
# see:
# https://help.ubuntu.com/community/OpenVZ
# http://www.howtoforge.com/installing-and-using-openvz-on-ubuntu-10.04
# http://wiki.openvz.org/Download/template/precreated
#

#apt-get install --reinstall grub-pc

# parameters: str_to_replace new_str file_name
function replace_in_file {

	TMP_FILE=/tmp/replace_in_file.$$
	sed "s/$1/$2/g" $3 > $TMP_FILE && mv $TMP_FILE $3
}

dpkg-reconfigure dash
/etc/init.d/apparmor stop
update-rc.d -f apparmor remove
apt-get remove apparmor apparmor-utils

uname -r
apt-get update && apt-get -y install \
	build-essential libncurses5-dev libssl-dev libxml2-dev autoconf automake libexpat1-dev libtool \
	git-core
aptitude install kernel-package libncurses5-dev fakeroot wget bzip2 module-assistant debhelper
aptitude build-dep linux-image-2.6.32-28

cd /usr/src
#wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.tar.bz2
m-a prepare
#wget http://download.openvz.org/kernel/branches/2.6.32/2.6.32-belyayev.1/patches/patch-belyayev.1-combined.gz
#wget http://download.openvz.org/kernel/branches/2.6.32/2.6.32-belyayev.1/configs/kernel-2.6.32-x86_64.config.ovz

kernel-packageconfig
echo "CONCURRENCY_LEVEL := 2" >> /etc/kernel-pkg.conf

rm -rf linux-2.6.32-openvz
tar -xpf linux-2.6.32.tar.bz2
mv linux-2.6.32 linux-2.6.32-openvz
rm -f linux
ln -s linux-2.6.32-openvz linux
cd linux
gunzip -dc ../patch-belyayev.1-combined.gz | patch -p1
cp -rf ../kernel-2.6.32-x86_64.config.ovz .config
make oldconfig
fakeroot make-kpkg --initrd --append-to-version=-ovz32 --revision=1.0 kernel_image kernel_headers

cd ..
ls -l *.deb
dpkg -i linux-image-2.6.32.14-ovz32_1.0_amd64.deb linux-headers-2.6.32.14-ovz32_1.0_amd64.deb
mkinitramfs -k 2.6.32.14-ovz32 -o /boot/initrd.img-2.6.32.14-ovz32
update-grub

cd
git clone git://git.openvz.org/pub/vzctl vzctl
cd vzctl
./autogen.sh
./configure --enable-bashcomp --enable-logrotate
make
make install
make install-debian

cd
git clone git://git.openvz.org/pub/vzquota vzquota
cd vzquota
make
make install

cd
git clone git://git.openvz.org/pub/vzpkg vzpkg
cd vzpkg
make install

#apt-get install --no-install-recommends vzctl vzquota vzdump

update-rc.d vz defaults
ln -s /var/lib/vz /vz

cat > /etc/sysctl.conf << "EOF"
net.ipv4.conf.all.rp_filter=1
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.conf.default.forwarding=1
net.ipv4.conf.default.proxy_arp = 0
net.ipv4.ip_forward=1
kernel.sysrq = 1
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.eth0.proxy_arp=1
EOF
#nano /etc/sysctl.conf
sysctl -p

replace_in_file 'NEIGHBOUR_DEVS=detect' 'NEIGHBOUR_DEVS=all' /etc/vz/vz.conf
#nano /etc/vz/vz.conf

reboot

cd /vz/template/cache
wget http://download.openvz.org/template/precreated/contrib/ubuntu-10.04-minimal_10.04_amd64.tar.gz
vzctl create 101 --ostemplate ubuntu-10.04-minimal_10.04_amd64 --config basic
