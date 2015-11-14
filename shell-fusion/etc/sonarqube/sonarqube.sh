#!/bin/bash

#
# install
#

rm -rf $install_dir/*
mv * $install_dir

[ ! -f $install_dir/lib/sonar-application-$PKG_VERSION.jar ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    [ $DIST == "macosx" ] && sudo dev_link_binaries $install_dir/bin/macosx-universal-64/sonar.sh sonarqube
    [ $OS == "linux" ] && sudo dev_link_binaries $install_dir/bin/linux-x86-64/sonar.sh sonarqube

fi

exit 0
