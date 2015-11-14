#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir

[ ! -x $install_dir/tools/android ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/tools/android
    sudo dev_link_binaries $install_dir/platform-tools/adb

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    script=./android-sdk-update.$$
    cat << EOF >> $script
#!/usr/bin/expect
set timeout -1;
spawn $install_dir/tools/android update sdk --all --no-ui;
expect {
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
EOF
    chmod +x $script
    $script
    rm -f $script

fi

exit 0
