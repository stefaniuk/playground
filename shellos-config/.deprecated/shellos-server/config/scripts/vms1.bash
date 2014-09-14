#!/bin/bash

name="vms1"
cd /srv; [ -f host4ge-$name.tar.gz ] && (
    rm -rf {host4ge,source}
    tar zxf host4ge-$name.tar.gz
    mv source host4ge
    cd host4ge/sbin
    chmod u+x ./install
    ./install \
        --lzo \
        --zlib \
        --openssl \
        --git \
        --geoip \
        --openssh \
        --openvpn \
        --mysql \
        --postfix \
        --qemu-kvm \
        --libvirt \
        --perl \
        --host4ge --notify 2>&1 | tee /srv/host4ge/log/install.log
)

exit 0
