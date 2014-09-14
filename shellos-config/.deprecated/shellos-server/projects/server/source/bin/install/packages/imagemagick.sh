#!/bin/bash

##
## download
##

PKG_NAME="ImageMagick-$IMAGEMAGICK_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$IMAGEMAGICK_VERSION.tar.gz"
    FILE=ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 10000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile ImageMagick:"
    [ -d $INSTALL_DIR/imagemagick ] && rm -rf $INSTALL_DIR/imagemagick
    tar -zxf ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
    cd ImageMagick-$IMAGEMAGICK_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/imagemagick \
    && make && make install && echo "ImageMagick installed successfully!"
    rm -rf $INSTALL_DIR/imagemagick/share/{doc,man}
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/imagemagick/bin
    strip_debug_symbols $INSTALL_DIR/imagemagick/lib
    echo "Create package:"
    package_create $INSTALL_DIR/imagemagick $PKG_NAME
else
    echo "Install ImageMagick from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/imagemagick/lib/libMagickCore.a ]; then
    echo "Error: ImageMagick has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/imagemagick/lib

echo "Copy includes:"
cp -rfv $INSTALL_DIR/imagemagick/include/ImageMagick/* /usr/include

echo "Copy pkgconfig:"
cp -vf $INSTALL_DIR/imagemagick/lib/pkgconfig/* /usr/lib/pkgconfig

##
## post install
##

[ -f ImageMagick-$IMAGEMAGICK_VERSION.tar.gz ] && rm ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
[ -d ImageMagick-$IMAGEMAGICK_VERSION ] && rm -rf ImageMagick-$IMAGEMAGICK_VERSION

# log event
logger -p local0.notice -t host4ge "imagemagick $IMAGEMAGICK_VERSION installed successfully"

# save package version
package_add_version "imagemagick" "$IMAGEMAGICK_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/imagemagick/bin
hashes_add_dir $INSTALL_DIR/imagemagick/lib

exit 0
