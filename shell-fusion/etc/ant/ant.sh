#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir
rm $install_dir/bin/*.bat
rm $install_dir/bin/*.cmd

[ ! -x $install_dir/bin/ant ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin/ant

fi

exit 0
