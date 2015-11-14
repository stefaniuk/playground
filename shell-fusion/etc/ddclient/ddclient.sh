#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir
rm $install_dir/*.exe
mkdir -p $install_dir/{bin,conf,etc,var/cache}
mv $install_dir/{ddclient,*.sh} $install_dir/bin
mv $install_dir/*.conf $install_dir/conf
mv $install_dir/sample-etc_* $install_dir/etc

[ ! -x $install_dir/bin/ddclient ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin/ddclient

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    cat << EOF >> $install_dir/conf/ddclient.conf
daemon=300
syslog=yes
pid=$install_dir/var/ddclient.pid
ssl=yes

##
## DNS-O-Matic account-configuration
##
use=web, web=myip.dnsomatic.com
server=updates.dnsomatic.com,      \\
protocol=dyndns2,                  \\
login=dnsomatic_username,          \\
password=dnsomatic_password        \\
all.dnsomatic.com
EOF

    file_replace_str "/etc/ddclient" "$install_dir/conf" $install_dir/bin/ddclient
    file_replace_str "/var/cache/ddclient" "$install_dir/var/cache" $install_dir/bin/ddclient

fi

exit 0
