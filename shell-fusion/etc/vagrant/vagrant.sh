#!/bin/bash

if [ $DIST == "macosx" ]; then

    file=$(\ls -1 *.pkg)
    sudo installer -pkg "$file" -target /

elif [ $DIST == "ubuntu" ]; then

    sudo dpkg -i $cache_dir/$PKG_FILE

fi

which vagrant > /dev/null 2>&1 || exit 2

exit 0
