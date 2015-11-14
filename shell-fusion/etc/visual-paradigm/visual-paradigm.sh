#!/bin/bash

rm -rf $install_dir/.install4j
rm -rf $install_dir/*
mv .install4j $install_dir
mv * $install_dir

[ ! -x $install_dir/Visual_Paradigm ] && exit 2

if [ $opt_scope == "global" ]; then
    print_h3 "Link application:"
    if [ $DIST == "ubuntu" ]; then
        sudo cp -fv $conf_dir/$PKG_NAME/visual-paradigm.desktop /usr/share/applications
        sudo file_replace_str "path" "$install_dir" /usr/share/applications/visual-paradigm.desktop
    fi
fi

exit 0
