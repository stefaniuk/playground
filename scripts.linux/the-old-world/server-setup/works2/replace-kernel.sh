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

KERNEL_VERSION="virtual"

###
### process arguments
###

while [ "$1" != "" ]; do
	case $1 in
		-v|--version)	KERNEL_VERSION=$1
						;;
	esac
	shift
done

###
### script
###

echo "Script $(readlink -f $0) started on $(date)"

apt-get update && \
apt-get -y upgrade --show-upgraded && \
apt-get -y install linux-image-$KERNEL_VERSION

TMP=`ls /boot/vmlinuz-2.6.*`
KERNEL_VERSION=`echo ${TMP:14}`

[ ! -d /boot/grub ] && mkdir /boot/grub
(	echo -e "timeout 5\n" && \
	echo -e "title		Ubuntu 10.04 LTS, kernel $KERNEL_VERSION" && \
	echo -e "root		(hd0)" && \
	echo -e "kernel		/boot/vmlinuz-$KERNEL_VERSION root=/dev/xvda console=hvc0 ro quiet" && \
	echo -e "initrd		/boot/initrd.img-$KERNEL_VERSION" \
) > /boot/grub/menu.lst

echo "New kernel version is $KERNEL_VERSION"
echo "WARNING: Do not forget to amend kernel to pv-grub-x86_*"

echo "Script $(readlink -f $0) ended on $(date)"
