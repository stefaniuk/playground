#!/bin/bash

##
## variables
##

LIBICONV_VERSION="1.13.1"

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f libiconv.tar.gz ]; then
	wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz -O libiconv.tar.gz
fi
if [ ! -f libiconv.tar.gz ]; then
	echo "Error: Unable to download libiconv.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing libiconv":
[ -d $INSTALL_DIR/libiconv ] && rm -rf $INSTALL_DIR/libiconv
tar -zxf libiconv.tar.gz
cd libiconv-$LIBICONV_VERSION
./configure \
	--prefix=$INSTALL_DIR/libiconv \
&& make && make install && echo "libiconv installed successfully!"

# check
if [ ! -f $INSTALL_DIR/libiconv/bin/iconv ]; then
	echo "Error: libiconv has NOT been installed successfully!"
	exit 1
fi

# directories' structure
rm -rf $INSTALL_DIR/libiconv/share/{doc,man}
cd ..

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/libiconv/bin
strip_debug_symbols $INSTALL_DIR/libiconv/lib

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/libiconv/lib

echo "Shared library dependencies for $INSTALL_DIR/libiconv/bin/iconv:"
ldd $INSTALL_DIR/libiconv/bin/iconv

echo "Copy includes:"
cp -v $INSTALL_DIR/libiconv/include/*.h /usr/include/

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f libiconv.tar.gz ] && rm libiconv.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d libiconv-$LIBICONV_VERSION ] && rm -rf libiconv-$LIBICONV_VERSION
