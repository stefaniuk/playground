#!/bin/bash

# SEE: http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux

version=$(echo $PKG_VERSION | \grep -oE '^[0-9]+')

#
# install
#

if [ $DIST == "macosx" ]; then
    file=$(\ls -1 *.pkg)
    sudo installer -pkg "$file" -target /
    rm -rf $install_dir
    ln -sfv "$(find /Library/Java/JavaVirtualMachines -name jdk1.$version.*.jdk | sort -r | head -1)/Contents/Home" $install_dir
elif [ $OS == "linux" ]; then
    rm -rf $install_dir/*
    mv * $install_dir
fi
ln -sfv $install_dir $pkgs_dir/$PKG_NAME/$version

[ ! -x $install_dir/bin/javac ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin

fi

exit 0
