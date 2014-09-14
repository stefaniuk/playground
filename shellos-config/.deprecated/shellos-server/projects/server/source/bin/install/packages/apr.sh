#!/bin/bash

##
## download
##

PKG_NAME="apr-$APR_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://mirror.ox.ac.uk/sites/rsync.apache.org//apr/apr-$APR_VERSION.tar.gz"
    FILE=apr-$APR_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
    URL="http://mirror.ox.ac.uk/sites/rsync.apache.org//apr/apr-util-$APR_UTIL_VERSION.tar.gz"
    FILE=apr-util-$APR_UTIL_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
    URL="http://mirror.ox.ac.uk/sites/rsync.apache.org//apr/apr-iconv-$APR_ICONV_VERSION.tar.gz"
    FILE=apr-iconv-$APR_ICONV_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 1000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile APR:"
    [ -d $INSTALL_DIR/apr ] && rm -rf $INSTALL_DIR/apr
    tar -zxf apr-$APR_VERSION.tar.gz
    cd apr-$APR_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/apr \
    && make && make install && echo "APR installed successfully!"
    cd ..
    echo "Compile APR Util:"
    tar -zxf apr-util-$APR_UTIL_VERSION.tar.gz
    cd apr-util-$APR_UTIL_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/apr \
        --with-apr=$INSTALL_DIR/apr \
    && make && make install && echo "APR Util installed successfully!"
    cd ..
    echo "Compile APR Iconv:"
    tar -zxf apr-iconv-$APR_ICONV_VERSION.tar.gz
    cd apr-iconv-$APR_ICONV_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/apr \
        --with-apr=$INSTALL_DIR/apr \
    && make && make install && echo "APR Iconv installed successfully!"
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/apr/bin
    strip_debug_symbols $INSTALL_DIR/apr/lib
    strip_debug_symbols $INSTALL_DIR/apr/lib/iconv
    echo "Create package:"
    package_create $INSTALL_DIR/apr $PKG_NAME
else
    echo "Install APR from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/apr/bin/apr-1-config ] || [ ! -f $INSTALL_DIR/apr/bin/apu-1-config ] || [ ! -f $INSTALL_DIR/apr/bin/apriconv ]; then
	echo "Error: APR has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/apr/lib

echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apr-1-config:"
ldd $INSTALL_DIR/apr/bin/apr-1-config
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apu-1-config:"
ldd $INSTALL_DIR/apr/bin/apu-1-config
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apriconv:"
ldd $INSTALL_DIR/apr/bin/apriconv

echo "Copy pkgconfig:"
cp -vf $INSTALL_DIR/apr/lib/pkgconfig/* /usr/lib/pkgconfig

##
## post install
##

[ -f apr-$APR_VERSION.tar.gz ] && rm apr-$APR_VERSION.tar.gz
[ -f apr-util-$APR_UTIL_VERSION.tar.gz ] && rm apr-util-$APR_UTIL_VERSION.tar.gz
[ -f apr-iconv-$APR_ICONV_VERSION.tar.gz ] && rm apr-iconv-$APR_ICONV_VERSION.tar.gz
[ -d apr-$APR_VERSION ] && rm -rf apr-$APR_VERSION
[ -d apr-util-$APR_UTIL_VERSION ] && rm -rf apr-util-$APR_UTIL_VERSION
[ -d apr-iconv-$APR_ICONV_VERSION ] && rm -rf apr-iconv-$APR_ICONV_VERSION

# log event
logger -p local0.notice -t host4ge "apr $APR_VERSION installed successfully"

# save package version
package_add_version "apr" "$APR_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/apr/bin
hashes_add_dir $INSTALL_DIR/apr/lib

exit 0
