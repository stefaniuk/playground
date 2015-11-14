#!/bin/bash

if [ $DIST == "ubuntu" ]; then

    sudo add-apt-repository --yes ppa:ubuntu-mozilla-daily/firefox-aurora
    sudo apt-get --yes update
    sudo apt-get --yes --force-yes --ignore-missing --no-install-recommends --only-upgrade install \
        firefox

fi

which firefox > /dev/null 2>&1 || exit 2

exit 0
