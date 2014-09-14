#!/bin/bash

##
## variables
##

GEOIP_SO_PHP_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --geoip-so) shift && GEOIP_SO_PHP_NAME=$1
                    ;;
    esac
    shift
done

GEOIP_SO_PHP_DIR=$INSTALL_DIR/$GEOIP_SO_PHP_NAME
GEOIP_PHP_EXT_DIR=$GEOIP_SO_PHP_DIR/lib/php/extensions/$(ls $GEOIP_SO_PHP_DIR/lib/php/extensions/)

##
## check dependencies
##

if [ ! -f $GEOIP_SO_PHP_DIR/bin/php ]; then
    echo "Error: GeoIP PHP extension requires PHP!"
    exit 1
fi

##
## download
##

PKG_NAME="geoip-so-$GEOIP_SO_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://pecl.php.net/get/geoip-$GEOIP_SO_VERSION.tgz"
    FILE=geoip-$GEOIP_SO_VERSION.tgz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 10000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile GeoIP PHP extension:"
    tar -xzf geoip-$GEOIP_SO_VERSION.tgz
    cd geoip-$GEOIP_SO_VERSION
    $GEOIP_SO_PHP_DIR/bin/phpize
    ./configure \
        --prefix=$INSTALL_DIR/geoip \
        --with-php-config=$GEOIP_SO_PHP_DIR/bin/php-config \
    && make && make install && echo "GeoIP PHP extension installed successfully in $GEOIP_SO_PHP_DIR!"
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols_file $GEOIP_PHP_EXT_DIR/geoip.so
    echo "Create package:"
    package_create_files $GEOIP_PHP_EXT_DIR $PKG_NAME geoip.so
else
    echo "Install GeoIP PHP extension in $GEOIP_SO_PHP_DIR from package:"
    package_restore_files $PKG_NAME $GEOIP_PHP_EXT_DIR
fi

# check
if [ ! -f $GEOIP_PHP_EXT_DIR/geoip.so ]; then
    echo "Error: GeoIP PHP extension has NOT been installed successfully in $GEOIP_SO_PHP_DIR"
    exit 1
fi

##
## configure
##

# php.ini
if [ -f $GEOIP_SO_PHP_DIR/conf/php.ini ]; then
    replace_in_file "extension = geoip.so\n" "" $GEOIP_SO_PHP_DIR/conf/php.ini
    replace_in_file "; extensions end" "extension = geoip.so\n; extensions end" $GEOIP_SO_PHP_DIR/conf/php.ini
    echo -e "\n[geoip]\ngeoip.custom_directory = $INSTALL_DIR/geoip/share/GeoIP/" >> $GEOIP_SO_PHP_DIR/conf/php.ini
fi

##
## post install
##

[ -f geoip-$GEOIP_SO_VERSION.tgz ] && rm geoip-$GEOIP_SO_VERSION.tgz
[ -d geoip-$GEOIP_SO_VERSION ] && rm -rf geoip-$GEOIP_SO_VERSION

# log event
logger -p local0.notice -t host4ge "geoip-so $GEOIP_SO_VERSION installed successfully"

# save package version
package_add_version "geoip-so" "$GEOIP_SO_VERSION"

exit 0
