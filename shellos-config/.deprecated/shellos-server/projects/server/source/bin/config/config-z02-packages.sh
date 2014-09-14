#!/bin/bash

# exclude packages from updates (to remove exclusion use 'echo package install | dpkg --set-selections')
(   echo linux-image-$KERNEL_VERSION-host4ge hold
    echo bind9 hold
    echo mysql-common hold
    echo postfix hold
) | dpkg --set-selections

# apt-get update and install
export DEBIAN_FRONTEND="noninteractive"
apt-get --yes update
apt-get -y --force-yes upgrade
apt-get -y --ignore-missing --no-install-recommends install \
    mutt
apt-get autoremove
apt-get autoclean

# virtualisation packages
# ubuntu-vm-builder

# cache archives
cd /var/cache/apt/archives
tar -zcf $UPDATES_DIR/$CODENAME.tar.gz *.deb
chmod 400 $UPDATES_DIR/$CODENAME.tar.gz
rm -v *.deb

exit 0
