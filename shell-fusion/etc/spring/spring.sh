#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir
rm $install_dir/bin/*.bat

[ ! -x $install_dir/bin/spring ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin
    [ -f /etc/bash_completion ] && bcpath=/etc/bash_completion.d || bcpath=/usr/local/etc/bash_completion.d
    if [ -d $bcpath ]; then
        print_h3 "Link bash completion:"
        ln -sfv $install_dir/shell-completion/bash/spring $bcpath/spring
    fi

fi

exit 0
