#!/bin/bash

##
## download
##

PKG_NAME="lzo-$LZO_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://www.oberhumer.com/opensource/lzo/download/lzo-$LZO_VERSION.tar.gz"
    FILE=lzo-$LZO_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile lzo:"
    [ -d $INSTALL_DIR/lzo ] && rm -rf $INSTALL_DIR/lzo
    tar -zxf lzo-$LZO_VERSION.tar.gz
    cd lzo-$LZO_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/lzo \
        --enable-shared \
    && make && make install && echo "lzo installed successfully!" \
    && rm -rf $INSTALL_DIR/lzo/share
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/lzo/lib
    echo "Create package:"
    package_create $INSTALL_DIR/lzo $PKG_NAME
else
    echo "Install lzo from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/lzo/lib/liblzo2.a ]; then
	echo "Error: lzo has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/lzo/lib

echo "Copy includes:"
mkdir /usr/include/lzo
cp -rfv $INSTALL_DIR/lzo/include/lzo/*.h /usr/include/lzo

# set files permission
chown -R root:root $INSTALL_DIR/lzo

##
## post install
##

[ -f lzo-$LZO_VERSION.tar.gz ] && rm lzo-$LZO_VERSION.tar.gz
[ -d lzo-$LZO_VERSION ] && rm -rf lzo-$LZO_VERSION

# log event
logger -p local0.notice -t host4ge "lzo $LZO_VERSION installed successfully"

# save package version
package_add_version "lzo" "$LZO_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/lzo/lib

exit 0
