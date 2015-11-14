#!/bin/bash

if [ $DIST == "ubuntu" ]; then

    sudo dpkg -i $cache_dir/$PKG_FILE
    rm -rf $install_dir

fi

[ ! -x /usr/bin/atom ] && exit 2

exit 0
