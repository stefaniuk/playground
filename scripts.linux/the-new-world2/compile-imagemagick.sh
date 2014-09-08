#!/bin/bash

##
## variables
##

IMAGEMAGICK_VERSION="6.7.1-0"
IMAGICK_VERSION="3.1.0b1"

##
## functions
##

function install_imagick {

	# variables
	IMAGICK_PHP_INSTALL_DIR=$1

	# check dependencies
	if [ ! -f $IMAGICK_PHP_INSTALL_DIR/bin/php ]; then
		echo "Error installing imagick extension in $IMAGICK_PHP_INSTALL_DIR"
		return
	fi

	# install
	echo "Installing imagick in $IMAGICK_PHP_INSTALL_DIR"
	rm -rf imagick-$IMAGICK_VERSION
	tar -zxf imagick.tgz
	cd imagick-$IMAGICK_VERSION
	$IMAGICK_PHP_INSTALL_DIR/bin/phpize
	./configure \
		--with-php-config=$IMAGICK_PHP_INSTALL_DIR/bin/php-config \
		--with-imagick=$INSTALL_DIR/imagemagick \
	&& make && make install && echo "imagick installed successfully in $IMAGICK_PHP_INSTALL_DIR!"
	cd ..

	IMAGICK_PHP_EXTENSIONS_DIR_NAME=`ls $IMAGICK_PHP_INSTALL_DIR/lib/php/extensions/`

	# check
	if [ ! -f $IMAGICK_PHP_INSTALL_DIR/lib/php/extensions/$IMAGICK_PHP_EXTENSIONS_DIR_NAME/imagick.so ]; then
		echo "Error: imagick has NOT been installed successfully in $IMAGICK_PHP_INSTALL_DIR"
		return
	fi

	# configure
	echo "Strip symbols:"
	strip_debug_symbols_file $IMAGICK_PHP_INSTALL_DIR/lib/php/extensions/$IMAGICK_PHP_EXTENSIONS_DIR_NAME/imagick.so

	if [ -f $IMAGICK_PHP_INSTALL_DIR/conf/php.ini ]; then
		echo -e "extension=imagick.so" >> $IMAGICK_PHP_INSTALL_DIR/conf/php.ini
	fi

}

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f imagemagick.tar.gz ]; then
	wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$IMAGEMAGICK_VERSION.tar.gz -O imagemagick.tar.gz
fi
if [ ! -f imagemagick.tar.gz ]; then
	echo "Error: Unable to download imagemagick.tar.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f imagick.tgz ]; then
	wget http://pecl.php.net/get/imagick-$IMAGICK_VERSION.tgz -O imagick.tgz
fi
if [ ! -f imagick.tgz ]; then
	echo "Error: Unable to download imagick.tgz file!"
	exit 1
fi

##
## install
##

echo "Installing ImageMagick:"
[ -d $INSTALL_DIR/imagemagick ] && rm -rf $INSTALL_DIR/imagemagick
tar -zxf imagemagick.tar.gz
cd ImageMagick-$IMAGEMAGICK_VERSION
./configure \
	--prefix=$INSTALL_DIR/imagemagick \
&& make && make install && echo "ImageMagick installed successfully!"
rm -rf $INSTALL_DIR/imagemagick/share/{doc,man}
cd ..

# check
if [ ! -f $INSTALL_DIR/imagemagick/lib/libMagickCore.a ]; then
	echo "Error: ImageMagick has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/imagemagick/bin
strip_debug_symbols $INSTALL_DIR/imagemagick/lib

echo "Fix libraries:"
fix_libraries $INSTALL_DIR/imagemagick/lib

echo "Copy includes:"
cp -rfv $INSTALL_DIR/imagemagick/include/ImageMagick /usr/include

##
## install imagick
##

for IMAGICK_PHP_DIR_NAME in $INSTALL_DIR/php-*; do
	if [ -d $IMAGICK_PHP_DIR_NAME ]; then
		install_imagick $IMAGICK_PHP_DIR_NAME
	fi
done

##
## clean up
##

rm -v package.xml
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f imagemagick.tar.gz ] && rm imagemagick.tar.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f imagick.tgz ] && rm imagick.tgz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d ImageMagick-$IMAGEMAGICK_VERSION ] && rm -rf ImageMagick-$IMAGEMAGICK_VERSION
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d imagick-$IMAGICK_VERSION ] && rm -rf imagick-$IMAGICK_VERSION
