#!/bin/bash

##
## variables
##

ZLIB_VERSION="1.2.5"

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f zlib.tar.gz ]; then
	wget http://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz -O zlib.tar.gz
fi
if [ ! -f zlib.tar.gz ]; then
	echo "Error: Unable to download zlib.tar.gz file!"
	exit 1
fi

##
## install
##

if [ ! -d $INSTALL_DIR/zlib ]; then

echo "Installing zlib:"
tar -zxf zlib.tar.gz
cd zlib-$ZLIB_VERSION
replace_in_file "ifdef _LARGEFILE64_SOURCE" "ifndef _LARGEFILE64_SOURCE" zlib.h
./configure \
	--prefix=$INSTALL_DIR/zlib \
&& make && make install && echo "zlib installed successfully!"
rm -rf $INSTALL_DIR/zlib/share
cd ..

# check
if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: zlib has NOT been installed successfully!"
	exit 1
fi

else
echo "zlib has already been installed successfully!"
fi

##
## configure
##

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/zlib/lib

echo "Shared library dependencies for $INSTALL_DIR/zlib/lib/libz.so:"
ldd $INSTALL_DIR/zlib/lib/libz.so

echo "Copy includes:"
rm /usr/include/{zconf.h,zlib.h}
cp -v $INSTALL_DIR/zlib/include/*.h /usr/include/

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f zlib.tar.gz ] && rm zlib.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d zlib-$ZLIB_VERSION ] && rm -rf zlib-$ZLIB_VERSION
