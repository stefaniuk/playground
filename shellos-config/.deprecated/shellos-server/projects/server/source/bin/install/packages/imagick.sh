#!/bin/bash

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/imagemagick/lib/libMagickCore.a ]; then
	echo "Error: imagick requires ImageMagick!"
	exit 1
fi

##
## functions
##

function install_imagick {

    IMAGICK_PHP_INSTALL_DIR=$1
    IMAGICK_PHP_EXT_DIR=$IMAGICK_PHP_INSTALL_DIR/lib/php/extensions/$(ls $IMAGICK_PHP_INSTALL_DIR/lib/php/extensions/)

    # download
    PKG_NAME="imagick-$IMAGICK_VERSION"
    [ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
    if [ "$PKG_RESULT" != "success" ]; then
        URL="http://pecl.php.net/get/imagick-$IMAGICK_VERSION.tgz"
        FILE=imagick-$IMAGICK_VERSION.tgz
        RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 50000)
        if [ "$RESULT" == "error" ]; then
            echo "Error: Unable to download $FILE file!"
            exit 1
        fi
    fi

    # install
    if [ "$PKG_RESULT" != "success" ]; then
        echo "Compile imagick"
        rm -rf imagick-$IMAGICK_VERSION
        tar -zxf imagick-$IMAGICK_VERSION.tgz
        cd imagick-$IMAGICK_VERSION
        export PKG_CONFIG_PATH=$INSTALL_DIR/imagemagick/lib/pkgconfig
        $IMAGICK_PHP_INSTALL_DIR/bin/phpize
        ./configure \
            --with-php-config=$IMAGICK_PHP_INSTALL_DIR/bin/php-config \
            --with-imagick=$INSTALL_DIR/imagemagick \
        && make && make install && echo "imagick installed successfully in $IMAGICK_PHP_INSTALL_DIR!"
        cd ..
        echo "Strip symbols:"
        strip_debug_symbols_file $IMAGICK_PHP_EXT_DIR/imagick.so
        echo "Create package:"
        package_create_files $IMAGICK_PHP_EXT_DIR $PKG_NAME imagick.so
    else
        echo "Install imagick in $IMAGICK_PHP_INSTALL_DIR from package:"
        package_restore_files $PKG_NAME $IMAGICK_PHP_EXT_DIR
    fi

    # check
    if [ ! -f $IMAGICK_PHP_EXT_DIR/imagick.so ]; then
        echo "Error: imagick has NOT been installed successfully in $IMAGICK_PHP_INSTALL_DIR"
        exit 1
    fi

    # configure
    if [ -f $IMAGICK_PHP_INSTALL_DIR/conf/php.ini ]; then
        replace_in_file "extension = imagick.so\n" "" $IMAGICK_PHP_INSTALL_DIR/conf/php.ini
        replace_in_file "; extensions end" "extension = imagick.so\n; extensions end" $IMAGICK_PHP_INSTALL_DIR/conf/php.ini
    fi

}

##
## main
##

for IMAGICK_PHP_DIR_NAME in $INSTALL_DIR/php*; do
    if [ -d $IMAGICK_PHP_DIR_NAME ]; then
        install_imagick $IMAGICK_PHP_DIR_NAME
    fi
done

##
## post install
##

rm -v package.xml
[ -f imagick-$IMAGICK_VERSION.tgz ] && rm imagick-$IMAGICK_VERSION.tgz
[ -d imagick-$IMAGICK_VERSION ] && rm -rf imagick-$IMAGICK_VERSION

# log event
logger -p local0.notice -t host4ge "imagick $IMAGICK_VERSION installed successfully"

# save package version
package_add_version "imagick" "$IMAGICK_VERSION"

exit 0
