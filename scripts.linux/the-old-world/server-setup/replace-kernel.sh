#!/bin/bash
#
# usage:
#
#	./replace-kernel.sh
#	./replace-kernel.sh 2>&1 | tee replace-kernel.out
#	bash -x ./replace-kernel.sh 2>&1 | tee replace-kernel.out
#
# see:
#
#	http://library.linode.com/linode-platform/custom-instances/pv-grub-howto
#

###
### variables
###

#KERNEL_VERSION="2.6.32-30-virtual"
KERNEL_VERSION="virtual"

###
### script
###

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install linux-image-$KERNEL_VERSION

TMP=`ls /boot/vmlinuz-2.6.*`
KERNEL_VERSION=`echo ${TMP:14}`
echo "New kernel version is $KERNEL_VERSION"

[ ! -d /boot/grub ] && mkdir /boot/grub
(	echo -e "timeout 5\n" && \
	echo -e "title		Ubuntu 10.04 LTS, kernel $KERNEL_VERSION" && \
	echo -e "root		(hd0)" && \
	echo -e "kernel		/boot/vmlinuz-$KERNEL_VERSION root=/dev/xvda console=hvc0 ro quiet" && \
	echo -e "initrd		/boot/initrd.img-$KERNEL_VERSION" \
) > /boot/grub/menu.lst

echo "WARNING: Do not forget to set kernel pv-grub-x86_*"
read -p "Press any key to reboot..."

reboot
