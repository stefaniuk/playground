#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir
rm $install_dir/bin/*.bat

[ ! -x $install_dir/bin/groovyc ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin

fi

exit 0
