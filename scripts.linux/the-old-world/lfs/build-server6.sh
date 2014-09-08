logout
chroot $LFS /tools/bin/env -i \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /tools/bin/bash --login

/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
  -exec /tools/bin/strip --strip-debug '{}' ';'
/tools/bin/find /{,usr/}{bin,sbin} -type f \
  -exec /tools/bin/strip --strip-all '{}' ';'

exit

chroot "$LFS" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

rm -rf /tools

tar -jxf lfs-bootscripts-20081031.tar.bz2
cd lfs-bootscripts-20081031
make install
cd ..
rm -rf lfs-bootscripts-20081031

cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=0

# End /etc/sysconfig/clock
EOF

cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

#LOGLEVEL=""
#KEYMAP=""
#KEYMAP_CORRECTIONS=""
#FONT=""
#UNICODE=""
#LEGACY_CHARSET=""

# End /etc/sysconfig/console
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF


#LC_ALL=en_GB.iso88591 locale language
#LC_ALL=en_GB.iso88591 locale charmap
#LC_ALL=en_GB.iso88591 locale int_curr_symbol
#LC_ALL=en_GB.iso88591 locale int_prefix

cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=en_GB.iso88591

# End /etc/profile
EOF


echo "HOSTNAME=lfs" > /etc/sysconfig/network


cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
#<192.168.1.1> <HOSTNAME.example.org> [alias1] [alias2 ...]

# End /etc/hosts (network card version)
EOF



for NIC in /sys/class/net/* ; do
    INTERFACE=${NIC##*/} udevadm test --action=add --subsystem=net $NIC
done

#cat /etc/udev/rules.d/70-persistent-net.rules

cd /etc/sysconfig/network-devices
mkdir -v ifconfig.eth0
cat > ifconfig.eth0/ipv4 << "EOF"
ONBOOT=yes
SERVICE=ipv4-static
IP=192.168.1.1
#GATEWAY=192.168.1.2
PREFIX=24
BROADCAST=192.168.1.255
EOF



cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

#domain <Your Domain Name>
#nameserver <IP address of your primary nameserver>
#nameserver <IP address of your secondary nameserver>

# End /etc/resolv.conf
EOF




cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options         dump  fsck
#                                                        order

/dev/sda2      /            ext3   defaults        1     1
/dev/sda1      swap         swap   pri=1           0     0
proc           /proc        proc   defaults        0     0
sysfs          /sys         sysfs  defaults        0     0
devpts         /dev/pts     devpts gid=4,mode=620  0     0
tmpfs          /dev/shm     tmpfs  defaults        0     0
# End /etc/fstab
EOF


cd /sources
tar -jxf linux-2.6.27.4.tar.bz2
cd linux-2.6.27.4
make mrproper
# ??? make LANG=en_GB.iso88591 LC_ALL= menuconfig
make oldconfig
make
make modules_install
cp -v arch/x86/boot/bzImage /boot/lfskernel-2.6.27.4
cp -v System.map /boot/System.map-2.6.27.4
cp -v .config /boot/config-2.6.27.4
#install -d /usr/share/doc/linux-2.6.27.4
#cp -r Documentation/* /usr/share/doc/linux-2.6.27.4
cd ..
rm -rf linux-2.6.27.4


grub
root (hd0,1)
setup (hd0)
quit



cat > /boot/grub/menu.lst << "EOF"
# Begin /boot/grub/menu.lst

# By default boot the first menu entry.
default 0

# Allow 30 seconds before booting the default.
timeout 30

# Use prettier colors.
color green/black light-green/black

# The first entry is for LFS.
title LFS 6.4
root (hd0,1)
kernel /boot/lfskernel-2.6.27.4 root=/dev/sda2
EOF

mkdir -v /etc/grub
ln -sv /boot/grub/menu.lst /etc/grub

echo 6.4 > /etc/lfs-release



logout

umount -v $LFS/dev/pts
umount -v $LFS/dev/shm
umount -v $LFS/dev
umount -v $LFS/proc
umount -v $LFS/sys

umount -v $LFS

shutdown -r now