#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir

[ ! -x $install_dir/bin/node ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin/node
    sudo dev_link_binaries $install_dir/bin/npm

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    $install_dir/bin/npm update -g npm

fi

exit 0
