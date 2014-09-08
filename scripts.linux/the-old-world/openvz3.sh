#!/bin/bash

wget http://download.openvz.org/kernel/branches/2.6.32/2.6.32-feoktistov.1/kernel-2.6.32-feoktistov.1.x86_64.rpm
rpm -ihv kernel-2.6.32-feoktistov.1.x86_64.rpm

mkdir /boot/grub
(	echo -e "#boot=/dev/xvda" && \
	echo -e "default=0" && \
	echo -e "timeout=5" && \
	echo -e "splashimage=(hd0,0)/boot/grub/splash.xpm.gz" && \
	echo -e "title OpenVZ" && \
	echo -e "\troot (hd0,0)" && \
	echo -e "\tkernel /boot/vmlinuz-2.6.32-feoktistov.1 ro root=LABEL=/" && \
	echo -e "\tinitrd /boot/initrd-2.6.32-feoktistov.1.img" \
) > /boot/grub/grub.conf

wget http://download.openvz.org/utils/vzctl/current/vzctl-3.0.26.2-1.x86_64.rpm
wget http://download.openvz.org/utils/vzctl/current/vzctl-lib-3.0.26.2-1.x86_64.rpm
wget http://download.openvz.org/utils/vzquota/current/vzquota-3.0.12-1.x86_64.rpm

rpm -Uhv --nodeps vzctl-3.0.26.2-1.x86_64.rpm vzctl-lib-3.0.26.2-1.x86_64.rpm vzquota-3.0.12-1.x86_64.rpm

wget http://download.openvz.org/template/precreated/centos-5-x86_64.tar.gz
mv centos-5-x86_64.tar.gz /vz/template/cache

(	echo -e "timeout 5\n" && \
	echo -e "title           Fedora 14, kernel 2.6.35.11-83.fc14.x86_64" && \
	echo -e "root            (hd0)" && \
	echo -e "kernel          /boot/vmlinuz-2.6.35.11-83.fc14.x86_64 root=/dev/xvda ro quiet" && \
	echo -e "initrd          /boot/initramfs-2.6.35.11-83.fc14.x86_64.img" \
) > /boot/grub/menu.lst
