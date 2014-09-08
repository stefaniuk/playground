#!/bin/bash

##
## variables
##

APR_VERSION="1.4.5"
APR_UTIL_VERSION="1.3.12"
APR_ICONV_VERSION="1.2.1"

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f apr.tar.gz ]; then
	wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//apr/apr-$APR_VERSION.tar.gz -O apr.tar.gz
fi
if [ ! -f apr.tar.gz ]; then
	echo "Error: Unable to download apr.tar.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f apr-util.tar.gz ]; then
	wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//apr/apr-util-$APR_UTIL_VERSION.tar.gz -O apr-util.tar.gz
fi
if [ ! -f apr-util.tar.gz ]; then
	echo "Error: Unable to download apr-util.tar.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f apr-iconv.tar.gz ]; then
	wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//apr/apr-iconv-$APR_ICONV_VERSION.tar.gz -O apr-iconv.tar.gz
fi
if [ ! -f apr-iconv.tar.gz ]; then
	echo "Error: Unable to download apr-iconv.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing APR:"
[ -d $INSTALL_DIR/apr ] && rm -rf $INSTALL_DIR/apr
tar -zxf apr.tar.gz
cd apr-$APR_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr \
&& make && make install && echo "APR installed successfully!"
cd ..

# check
if [ ! -f $INSTALL_DIR/apr/bin/apr-1-config ]; then
	echo "Error: APR has NOT been installed successfully!"
	exit 1
fi

echo "Installing APR Util:"
tar -zxf apr-util.tar.gz
cd apr-util-$APR_UTIL_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr \
	--with-apr=$INSTALL_DIR/apr \
&& make && make install && echo "APR Util installed successfully!"
cd ..

# check
if [ ! -f $INSTALL_DIR/apr/bin/apu-1-config ]; then
	echo "Error: APR Util has NOT been installed successfully!"
	exit 1
fi

echo "Installing APR Iconv:"
tar -zxf apr-iconv.tar.gz
cd apr-iconv-$APR_ICONV_VERSION
./configure \
	--prefix=$INSTALL_DIR/apr \
	--with-apr=$INSTALL_DIR/apr \
&& make && make install && echo "APR Iconv installed successfully!"
cd ..

# check
if [ ! -f $INSTALL_DIR/apr/bin/apriconv ]; then
	echo "Error: APR Iconv has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apr-1-config:"
ldd $INSTALL_DIR/apr/bin/apr-1-config
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apu-1-config:"
ldd $INSTALL_DIR/apr/bin/apu-1-config
echo "Shared library dependencies for $INSTALL_DIR/apr/bin/apriconv:"
ldd $INSTALL_DIR/apr/bin/apriconv

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/apr/bin
strip_debug_symbols $INSTALL_DIR/apr/lib
strip_debug_symbols $INSTALL_DIR/apr/lib/iconv

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/apr/lib

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f apr.tar.gz ] && rm apr.tar.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f apr-util.tar.gz ] && rm apr-util.tar.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f apr-iconv.tar.gz ] && rm apr-iconv.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d apr-$APR_VERSION ] && rm -rf apr-$APR_VERSION
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d apr-util-$APR_UTIL_VERSION ] && rm -rf apr-util-$APR_UTIL_VERSION
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d apr-iconv-$APR_ICONV_VERSION ] && rm -rf apr-iconv-$APR_ICONV_VERSION
