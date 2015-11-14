#!/bin/bash

data_dir=$pkgs_dir/nexus/data

#
# install
#

rm -rf $cache_dir/sonatype-work
sudo rm -rf $install_dir/*
mv * $install_dir
rm $install_dir/bin/*.bat

[ ! -x $install_dir/bin/nexus ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin/nexus

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    user_exists "nexus" && user_delete "nexus"
    user_create "nexus" "nexus" --home $data_dir --shell /bin/bash
    mkdir -p $data_dir
    sudo chown -R nexus:nexus $install_dir
    sudo chown -R nexus:nexus $data_dir

    sudo file_replace_str \
        "nexus-work=\\$\{bundleBasedir\}/../sonatype-work/nexus" \
        "nexus-work=$data_dir" \
        $install_dir/conf/nexus.properties

fi

exit 0
