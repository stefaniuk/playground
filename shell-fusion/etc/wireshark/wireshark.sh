#!/bin/bash

#
# install
#

if [ $DIST == "macosx" ]; then

    brew update
    if ! which wireshark > /dev/null 2>&1; then
        brew install -v \
            wireshark --with-qt
    else
        brew upgrade -v \
            wireshark --with-qt
    fi

elif [ $DIST == "ubuntu" ]; then

    sudo apt-get --yes update
    if ! which wireshark > /dev/null 2>&1; then
        sudo apt-get --yes --force-yes --ignore-missing --no-install-recommends install \
            wireshark
    else
        sudo apt-get --yes --force-yes --ignore-missing --no-install-recommends --only-upgrade install \
            wireshark
    fi
    sudo groupadd wireshark
    sudo usermod -aG wireshark $USER
    sudo chgrp wireshark /usr/bin/dumpcap
    sudo chmod 750 /usr/bin/dumpcap
    sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
    sudo getcap /usr/bin/dumpcap

fi

which wireshark > /dev/null 2>&1 || exit 2

exit 0
