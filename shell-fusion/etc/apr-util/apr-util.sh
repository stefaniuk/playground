#!/bin/bash

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    print_h3 'Run `configure`'
    ./configure \
        --prefix=$install_dir \
        --with-apr=$pkgs_dir/apr/current \
        --with-openssl \
    && print_h3 'Run `make`' && make && rm -rf $install_dir \
    && print_h3 'Run `make install`' && make install && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin
    dev_strip_symbols $install_dir/lib

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/apu-1-config ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Copy pkg-config files:"
    sudo cp -rfv $install_dir/lib/pkgconfig/* /usr/lib/pkgconfig
    print_h3 "Copy includes:"
    sudo mkdir -p /usr/include/apr-1
    sudo cp -rfv $install_dir/include/apr-1/* /usr/include/apr-1
    print_h3 "Link libraries:"
    sudo dev_link_libraries $install_dir/lib
    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin

fi

exit 0
