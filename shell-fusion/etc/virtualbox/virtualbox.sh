#!/bin/bash

if [ $DIST == "macosx" ]; then

    file=$(\ls -1 *.pkg)
    sudo installer -pkg "$file" -target /

elif [ $DIST == "ubuntu" ]; then

    sudo apt-get --yes --force-yes --ignore-missing --no-install-recommends install \
        linux-headers-$(uname -r) \
        build-essential \
        dkms
    sudo dpkg -i $cache_dir/$PKG_FILE
    sudo apt-get --yes --force-yes --ignore-missing --no-install-recommends -f install

fi

which VirtualBox > /dev/null 2>&1 || exit 2

exit 0
