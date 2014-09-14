#!/bin/bash

##
## download
##

PKG_NAME="lxc-$LXC_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://lxc.sourceforge.net/download/lxc/lxc-$LXC_VERSION.tar.gz"
    FILE=lxc-$LXC_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 200000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile LXC:"
    [ -d $INSTALL_DIR/lxc ] && rm -rf $INSTALL_DIR/lxc
    tar -zxf lxc-$LXC_VERSION.tar.gz
    cd lxc-$LXC_VERSION
    ./autogen.sh && ./configure \
        --prefix=$INSTALL_DIR/lxc \
        --localstatedir=$INSTALL_DIR/lxc \
    && make && make install && echo "LXC installed successfully!"
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/lxc/bin
    strip_debug_symbols $INSTALL_DIR/lxc/lib
    echo "Create package:"
    package_create $INSTALL_DIR/lxc $PKG_NAME
else
    echo "Install LXC from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/lxc/bin/lxc-start ]; then
	echo "Error: LXC has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

#echo "Fix libraries:"
#fix_libraries $INSTALL_DIR/lxc/lib

echo "Shared library dependencies for $INSTALL_DIR/lxc/bin/lxc-start:"
ldd $INSTALL_DIR/lxc/bin/lxc-start

#echo "Copy includes:"
#cp -rfv $INSTALL_DIR/lxc/include/lxc /usr/include/

#echo "Copy pkgconfig:"
#cp -vf $INSTALL_DIR/lxc/share/pkgconfig/* /usr/lib/pkgconfig

##
## post install
##

[ -f lxc-$LXC_VERSION.tar.gz ] && rm lxc-$LXC_VERSION.tar.gz
[ -d lxc-$LXC_VERSION ] && rm -rf lxc-$LXC_VERSION

# log event
logger -p local0.notice -t host4ge "lxc $LXC_VERSION installed successfully"

# save package version
package_add_version "lxc" "$LXC_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/lxc/bin
hashes_add_dir $INSTALL_DIR/lxc/lib
hashes_add_dir $INSTALL_DIR/lxc/lib/lxc/templates

exit 0
