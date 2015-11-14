#!/bin/bash

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    print_h3 'Run `configure`'
    ./configure \
        --prefix=$install_dir \
        --mandir=$install_dir/man \
        --with-features="huge" \
        --enable-cscope \
        --enable-multibyte \
        --enable-gui="no" \
        --without-x \
        --with-compiledby="custom" \
    && print_h3 'Run `make`' && make && rm -rf $install_dir \
    && print_h3 'Run `make install`' && make install && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/vim ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin
    sudo dev_link_binaries $install_dir/bin/vim ex
    sudo dev_link_binaries $install_dir/bin/vim rview
    sudo dev_link_binaries $install_dir/bin/vim rvim
    sudo dev_link_binaries $install_dir/bin/vim vi
    sudo dev_link_binaries $install_dir/bin/vim view
    sudo dev_link_binaries $install_dir/bin/vim vimdiff
    sudo dev_link_binaries $install_dir/bin --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/vim ex --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/vim rview --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/vim rvim --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/vim vi --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/vim view --dir /usr/local/bin
    sudo dev_link_binaries $install_dir/bin/vim vimdiff --dir /usr/local/bin

fi

exit 0
