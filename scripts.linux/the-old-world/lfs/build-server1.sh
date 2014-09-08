#!/bin/bash
#
# build-server.sh
#
# This script builds a customized Linux server.
#
# Based on project: Linux From Scratch
# Home page: http://www.linuxfromscratch.org
#

# hard drive
fdisk /dev/sda << EOF
d
1
d
n
p
1

+1024M
n
p
2


t
1
82
a
2
p
w
EOF

# swap partition
mkswap /dev/sda1
swapon -v /dev/sda1

# filesystem
mke2fs -jv /dev/sda2
export LFS=/mnt/lfs
mkdir -pv $LFS
mount -v -t ext3 /dev/sda2 $LFS

# floppy drive
#mkdir /mnt/floppy
#mkfs -t ext2 /dev/fd0
#mount /dev/fd0 -t ext2 /mnt/floppy

# CD-ROM
#mkdir /mnt/cdrom
#mount /dev/hdc -t iso9660 -r /mnt/cdrom

# windows share
#mkdir /mnt/share
#smbmount //041047-xp/public /mnt/share -o username=dast7%CodeDev00,workgroup=npfit.nhs.uk

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
mkdir -v $LFS/tools
ln -sv $LFS/tools /

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

su - lfs

exit 0
