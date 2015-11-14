#!/bin/bash

# do not install git for Mac OS X
[ $DIST == "macosx" ] && exit 0

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    print_h3 'Run `configure`'
    ./configure \
        --prefix=$install_dir \
        --with-gitconfig=$install_dir/conf/gitconfig \
    && rm -rf $install_dir \
    && print_h3 'Run `make all`' && V=1 make all && (cd contrib/subtree && V=1 make all) \
    && print_h3 'Run `make install`' && V=1 make install && (cd contrib/subtree && V=1 make install) \
    && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin
    dev_strip_symbols $install_dir/libexec/git-core

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/git ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin

fi

exit 0
