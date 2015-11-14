#!/bin/bash

data_dir=$pkgs_dir/scm-server/data

#
# install
#

sudo rm -rf $install_dir/*
sudo mv * $install_dir
rm $install_dir/bin/*.bat

[ ! -x $install_dir/bin/scm-server ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    #sudo dev_link_binaries $install_dir/bin/scm-server

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    user_exists "scm-server" && user_delete "scm-server"
    user_create "scm-server" "scm-server" --home $data_dir --shell /bin/bash
    mkdir -p $data_dir
    sudo chown -R scm-server:scm-server $install_dir
    sudo chown -R scm-server:scm-server $data_dir

    sudo file_replace_str \
        "ARCH=\`uname -m\`" \
        "ARCH=\`uname -m\`\nJAVA_HOME=$JAVA_HOME" \
        $install_dir/bin/scm-server \
        --multiline

fi

exit 0
