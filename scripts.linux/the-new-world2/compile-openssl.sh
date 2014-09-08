#!/bin/bash

##
## variables
##

OPENSSL_VERSION="1.0.0d"

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: OpenSSL requires zlib!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f openssl.tar.gz ]; then
	wget http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -O openssl.tar.gz
fi
if [ ! -f openssl.tar.gz ]; then
	echo "Error: Unable to download openssl.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing OpenSSL:"
[ -d $INSTALL_DIR/openssl ] && rm -rf $INSTALL_DIR/openssl
tar -zxf openssl.tar.gz
cd openssl-$OPENSSL_VERSION
./config \
	--prefix=$INSTALL_DIR/openssl \
	--openssldir=$INSTALL_DIR/openssl \
	--with-zlib-lib=$INSTALL_DIR/zlib/lib \
	--with-zlib-include=$INSTALL_DIR/zlib/include \
	shared zlib-dynamic enable-camellia \
&& make depend && make && make install && echo "OpenSSL installed successfully!"
rm -rf $INSTALL_DIR/openssl/man
cd ..

# check
if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: OpenSSL has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/openssl/bin
strip_debug_symbols $INSTALL_DIR/openssl/lib

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/openssl/lib

echo "Shared library dependencies for $INSTALL_DIR/openssl/bin/openssl:"
ldd $INSTALL_DIR/openssl/bin/openssl

echo "Copy includes:"
rm -rf /usr/include/openssl
cp -rfv $INSTALL_DIR/openssl/include/openssl /usr/include/

# set files permission
chown -R root:root $INSTALL_DIR/openssl
chmod 500 $INSTALL_DIR/openssl/certs

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f openssl.tar.gz ] && rm openssl.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d openssl-$OPENSSL_VERSION ] && rm -rf openssl-$OPENSSL_VERSION
