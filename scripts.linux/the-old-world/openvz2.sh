#!/bin/bash
#

# set custom kernel first

function replace_in_file {

	TMP_FILE=/tmp/replace_in_file.$$
	sed "s/$1/$2/g" $3 > $TMP_FILE && mv $TMP_FILE $3
}

dpkg-reconfigure dash

apt-get install kernel-package libncurses5-dev fakeroot wget bzip2 module-assistant debhelper build-essential

VERSION="2.6.32-28"

# ???
apt-get build-dep --no-install-recommends linux-image-$VERSION-virtual
#apt-get build-dep --no-install-recommends linux-image-virtual
m-a prepare
kernel-packageconfig

Cores=$(Nr () { echo $#; }; Nr $(grep "processor" /proc/cpuinfo | cut -f2 -d":"))
echo "CONCURRENCY_LEVEL := $(($Cores + 1))" | tee -a /etc/kernel-pkg.conf

cd /usr/src
#wget http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux_2.6.32.orig.tar.gz
wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.tar.gz
wget http://download.openvz.org/kernel/branches/2.6.32/current/patches/patch-feoktistov.1-combined.gz
wget http://download.openvz.org/kernel/branches/2.6.32/current/configs/kernel-2.6.32-x86_64.config.ovz

rm -rf linux-2.6.32
#tar -xpf linux_2.6.32.orig.tar.gz
tar -zxf linux-2.6.32.tar.gz
rm -rf "linux-2.6.32-openvz"
mv linux-2.6.32 "linux-2.6.32-openvz"
rm linux
ln -s "linux-2.6.32-openvz" linux

cd /usr/src/linux
gunzip -dc /usr/src/patch-feoktistov.1-combined.gz | patch -p1 --batch
cp -rf "/usr/src/kernel-2.6.32-x86_64.config.ovz" .config
make oldconfig

replace_in_file "all: lguest" "all:" /usr/src/linux/Documentation/lguest/Makefile

# *** START FROM HERE:

make 2>&1 | tee openvz.make.out
#make modules 2>&1 | tee openvz.make-modules.out
make modules_install 2>&1 | tee openvz.make-modules-install.out
make install 2>&1 | tee openvz.make-install.out
mkinitramfs -k 2.6.32.28 -o /boot/initrd.img-2.6.32.28
(	echo -e "module          /boot/vmlinuz-2.6.32.28 root=/dev/xvda console=hvc0 ro quiet" && \
	echo -e "module          /boot/initrd.img-2.6.32.28" \
) >> /boot/grub/menu.lst

# *** END

#make-kpkg --initrd --append-to-version="-openvz" --revision=1 kernel_image kernel_headers

cd /usr/src
ls -l *.deb
dpkg -i linux-image-2.6.32.28-openvz_1_amd64.deb
dpkg -i linux-headers-2.6.32.28-openvz_1_amd64.deb
mkinitramfs -k 2.6.32.28-openvz -o /boot/initrd.img-2.6.32.28-openvz
apt-get install --reinstall grub-pc
update-grub

(	echo -e "timeout 5\n" && \
	echo -e "title           Ubuntu 10.04 LTS, kernel $VERSION-openvz" && \
	echo -e "root            (hd0)" && \
	echo -e "kernel          /boot/vmlinuz-$VERSION-openvz root=/dev/xvda console=hvc0 ro quiet" && \
	echo -e "initrd          /boot/initrd.img-$VERSION-openvz" \
) > /boot/grub/menu.lst

cat > /etc/sysctl.conf << "EOF"
net.ipv4.conf.default.forwarding=1
net.ipv4.conf.default.proxy_arp = 1
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter = 1
kernel.sysrq = 1
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.all.send_redirects = 0
EOF
sysctl -p

apt-get install --no-install-recommends vzctl vzquota vzdump

ln -s /var/lib/vz /vz

#reboot

#uname -a

