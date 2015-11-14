#!/bin/bash

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    print_h3 'Run `configure`'
    ./configure \
        --prefix=$install_dir \
        --datadir=$install_dir/share2 \
        --enable-charset \
    && print_h3 'Run `make`' && make && rm -rf $install_dir \
    && print_h3 'Run `make install`' && make install && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin
    dev_strip_symbols $install_dir/libexec

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/mc ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin
    sudo dev_link_binaries $install_dir/bin/mc mcdiff
    sudo dev_link_binaries $install_dir/bin/mc mcedit
    sudo dev_link_binaries $install_dir/bin/mc mcview
    sudo dev_link_binaries $install_dir/bin --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/mc mcdiff --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/mc mcedit --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/mc mcview --dir /usr/local/bin

fi

exit 0
