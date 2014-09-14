#!/bin/bash

#
# https://wiki.ubuntu.com/KernelTeam/Specs/PreciseKernelConfigReviewPreciseRally
#
# kernel:
#
# https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
# http://newbiedoc.sourceforge.net/system/kernel-pkg.html
# http://library.linode.com/linode-platform/custom-instances/pv-grub-custom-compiled-kernel
# http://crunchbanglinux.org/forums/topic/18060/how-to-compile-the-kernel-from-source/
#

##
## variables
##

KRNL_APPEND_TO_VERSION="-host4ge"
KRNL_REVISION="1.0.0dev"
KRNL_IMAGE_PKG="linux-image-${KERNEL_VERSION}${KRNL_APPEND_TO_VERSION}_${KRNL_REVISION}_amd64.deb"
KRNL_HEADERS_PKG="linux-headers-${KERNEL_VERSION}${KRNL_APPEND_TO_VERSION}_${KRNL_REVISION}_amd64.deb"

##
## install
##

# download packages
if [ "$KERNEL_FORCE_COMPILATION" == "N" ]; then
    RESULT1=$(file_download --cache-dir-name kernels --file ${SERVER_PROVIDER}-${KRNL_IMAGE_PKG} --do-not-cache)
    RESULT2=$(file_download --cache-dir-name kernels --file ${SERVER_PROVIDER}-${KRNL_HEADERS_PKG} --do-not-cache)
fi

if [ "$RESULT1" != "success" ] || [ "$RESULT2" != "success" ]; then

    # download source
    URL="http://www.kernel.org/pub/linux/kernel/v3.0/linux-$KERNEL_VERSION.tar.bz2"
    FILE=linux-$KERNEL_VERSION.tar.bz2
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 50000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi

    # unpack
    echo "Compile Linux kernel:"
    tar jxf linux-$KERNEL_VERSION.tar.bz2
    cd linux-$KERNEL_VERSION

    # configure
    if [ -f /proc/config.gz ]; then
        zcat /proc/config.gz > .config
    elif [ -f /boot/config-`uname -r` ]; then
        cp /boot/config-`uname -r` .config
    fi
    # CONFIG_DEVPTS_MULTIPLE_INSTANCES
    sed "s/# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set/CONFIG_DEVPTS_MULTIPLE_INSTANCES=y/g" .config > .config.tmp && mv .config.tmp .config
    sed "s/CONFIG_DEVPTS_MULTIPLE_INSTANCES=m/CONFIG_DEVPTS_MULTIPLE_INSTANCES=y/g" .config > .config.tmp && mv .config.tmp .config
    # CONFIG_VLAN_8021Q
    sed "s/# CONFIG_VLAN_8021Q is not set/CONFIG_VLAN_8021Q=y/g" .config > .config.tmp && mv .config.tmp .config
    sed "s/CONFIG_VLAN_8021Q=m/CONFIG_VLAN_8021Q=y/g" .config > .config.tmp && mv .config.tmp .config
    # CONFIG_VETH
    sed "s/# CONFIG_VETH is not set/CONFIG_VETH=y/g" .config > .config.tmp && mv .config.tmp .config
    sed "s/CONFIG_VETH=m/CONFIG_VETH=y/g" .config > .config.tmp && mv .config.tmp .config
    # CONFIG_MACVLAN
    sed "s/# CONFIG_MACVLAN is not set/CONFIG_MACVLAN=y/g" .config > .config.tmp && mv .config.tmp .config
    sed "s/CONFIG_MACVLAN=m/CONFIG_MACVLAN=y/g" .config > .config.tmp && mv .config.tmp .config
    # CONFIG_DUMMY
    sed "s/# CONFIG_DUMMY is not set/CONFIG_DUMMY=y/g" .config > .config.tmp && mv .config.tmp .config
    sed "s/CONFIG_DUMMY=m/CONFIG_DUMMY=y/g" .config > .config.tmp && mv .config.tmp .config

    # compile
    yes '' | make oldconfig
    sed -rie 's/echo "\+"/#echo "\+"/' scripts/setlocalversion
    make-kpkg clean
    CONCURRENCY_LEVEL=`getconf _NPROCESSORS_ONLN` fakeroot make-kpkg --append-to-version=${KRNL_APPEND_TO_VERSION} --revision=${KRNL_REVISION} --initrd kernel_image kernel_headers
    cd ..

    # clean up
    [ -f linux-$KERNEL_VERSION.tar.bz2 ] && rm linux-$KERNEL_VERSION.tar.bz2
    [ -d linux-$KERNEL_VERSION ] && rm -rf linux-$KERNEL_VERSION

else

    # rename files
    mv ${SERVER_PROVIDER}-${KRNL_IMAGE_PKG} ${KRNL_IMAGE_PKG}
    mv ${SERVER_PROVIDER}-${KRNL_HEADERS_PKG} ${KRNL_HEADERS_PKG}

fi

# install kernel
if [ -f $KRNL_IMAGE_PKG ] && [ -f $KRNL_HEADERS_PKG ]; then
    dpkg -i $KRNL_IMAGE_PKG
    dpkg -i $KRNL_HEADERS_PKG
    mv *${KERNEL_VERSION}${KRNL_APPEND_TO_VERSION}_${KRNL_REVISION}_amd64.deb $KERNELS_DIR
    cd /lib/modules
    update-initramfs -ck ${KERNEL_VERSION}${KRNL_APPEND_TO_VERSION}
fi

# check
if [ ! -f /boot/vmlinuz-${KERNEL_VERSION}${KRNL_APPEND_TO_VERSION} ]; then
    echo "Error: Linux kernel has NOT been installed successfully!"
    exit 1
fi

# update grub
if [ "$SERVER_PROVIDER" == "linode" ]; then
    [ ! -d /boot/grub ] && mkdir /boot/grub
    cat <<EOF > /boot/grub/menu.lst
default     0
timeout     30

title       Host4ge Server (kernel $KERNEL_VERSION)
root        (hd0)
kernel      /boot/vmlinuz-${KERNEL_VERSION}${KRNL_APPEND_TO_VERSION} root=/dev/xvda ro quiet rootflags=nobarrier
EOF
else
    update-grub
fi

# Apparmor 2.4 Compatibility Patch
# http://ubuntuforums.org/showthread.php?t=1676117
# http://kernel.org/pub/linux/security/apparmor/

##
## post install
##

# log event
logger -p local0.notice -t host4ge "kernel $KERNEL_VERSION installed successfully"

# save package version
package_add_version "kernel" "$KERNEL_VERSION"

# add directories to create hashes
hashes_add_dir /boot
hashes_add_dir /lib/modules

exit 0
