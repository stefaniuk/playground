#!/bin/bash

##
## download
##

PKG_NAME="GeoIP-$GEOIP_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://geolite.maxmind.com/download/geoip/api/c/GeoIP-$GEOIP_VERSION.tar.gz"
    FILE=GeoIP-$GEOIP_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

URL="http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
FILE=GeoLiteCity.dat.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 5000000)
if [ "$RESULT" == "error" ]; then
    echo "Error: Unable to download $FILE file!"
    exit 1
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile GeoIP:"
    [ -d $INSTALL_DIR/geoip ] && rm -rf $INSTALL_DIR/geoip
    tar -zxf GeoIP-$GEOIP_VERSION.tar.gz
    cd GeoIP-$GEOIP_VERSION
    libtoolize -f && ./configure \
        --prefix=$INSTALL_DIR/geoip \
    && make && make install \
    && echo "GeoIP installed successfully!" \
    && rm -rf $INSTALL_DIR/geoip/share/man
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/geoip/bin
    strip_debug_symbols $INSTALL_DIR/geoip/lib
    echo "Create package:"
    package_create $INSTALL_DIR/geoip $PKG_NAME
else
    echo "Install GeoIP from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/geoip/bin/geoiplookup ]; then
    echo "Error: GeoIP has NOT been installed successfully!"
    exit 1
fi

echo "Install GeoIP database:"
cp -v GeoLiteCity.dat.gz $INSTALL_DIR/geoip/share/GeoIP/GeoLiteCity.dat.gz
gunzip -d $INSTALL_DIR/geoip/share/GeoIP/GeoLiteCity.dat.gz
mv $INSTALL_DIR/geoip/share/GeoIP/GeoLiteCity.dat $INSTALL_DIR/geoip/share/GeoIP/GeoIPCity.dat

# check
if [ ! -f $INSTALL_DIR/geoip/share/GeoIP/GeoIPCity.dat ]; then
    echo "Error: GeoIP database has NOT been installed successfully!"
    exit 1
else
    echo "GeoIP database installed successfully!"
fi

##
## configure
##

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/geoip/lib

echo "Shared library dependencies for $INSTALL_DIR/geoip/bin/geoiplookup:"
ldd $INSTALL_DIR/geoip/bin/geoiplookup

echo "Copy includes:"
rm /usr/include/GeoIP*.h > /dev/null 2>&1
cp -v $INSTALL_DIR/geoip/include/*.h /usr/include/

# set files permission
chown -R root:root $INSTALL_DIR/geoip
chmod 755 $INSTALL_DIR/geoip/bin
chmod 555 $INSTALL_DIR/geoip/bin/*
chmod 644 $INSTALL_DIR/geoip/share/GeoIP/*.dat

##
## post install
##

[ -f GeoIP-$GEOIP_VERSION.tar.gz ] && rm GeoIP-$GEOIP_VERSION.tar.gz
[ -f GeoLiteCity.dat.gz ] && rm GeoLiteCity.dat.gz
[ -d GeoIP-$GEOIP_VERSION ] && rm -rf GeoIP-$GEOIP_VERSION

# log event
logger -p local0.notice -t host4ge "geoip $GEOIP_VERSION installed successfully"

# save package version
package_add_version "geoip" "$GEOIP_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/geoip/bin
hashes_add_dir $INSTALL_DIR/geoip/lib

exit 0
