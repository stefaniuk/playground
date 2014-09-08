#!/bin/bash
#
# File: replace-kernel.sh
#
# Description: This script upgrades the Linux kernel.
#
# Usage:
#
#	./replace-kernel.sh 2>&1 | tee replace-kernel.log
#
# see: http://forum.linode.com/viewtopic.php?p=40195#40195

LINUX_IMAGE=`apt-cache search linux-image-2.6 | grep "^linux-image-2.6.*-virtual" | sort | awk '{print $1}' | tail -1`
apt-get -y install $LINUX_IMAGE

TMP=`ls /boot/vmlinuz-2.6.*`
KERNEL_VERSION=`echo ${TMP:14}`
echo "The new kernel version is $KERNEL_VERSION"

[ ! -d /boot/grub ] && mkdir /boot/grub
(	echo -e "timeout 5\n" && \
	echo -e "title Ubuntu 10.04 LTS, kernel $KERNEL_VERSION" && \
	echo -e "root (hd0)" && \
	echo -e "kernel /boot/vmlinuz-$KERNEL_VERSION root=/dev/xvda console=hvc0 ro quiet" && \
	echo -e "initrd /boot/initrd.img-$KERNEL_VERSION" \
) > /boot/grub/menu.lst

echo "WARNING: Do not forget to set kernel settings in the administration panel if applicable"
read -p "Press any key to reboot..."

#reboot
