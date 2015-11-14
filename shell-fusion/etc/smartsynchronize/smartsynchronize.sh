#!/bin/bash

rm -rf $install_dir/*
mv * $install_dir

[ ! -x $install_dir/bin/smartsynchronize.sh ] && exit 2

if [ $opt_scope == "global" ]; then
    print_h3 "Link application:"
    if [ $DIST == "ubuntu" ]; then
        sudo cp -fv $conf_dir/$PKG_NAME/smartsynchronize.desktop /usr/share/applications
        sudo file_replace_str "path" "$install_dir" /usr/share/applications/smartsynchronize.desktop
    fi
fi

exit 0
