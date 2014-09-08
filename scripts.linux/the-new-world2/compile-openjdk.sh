#!/bin/bash

##
## variables
##

NAME_VERSION=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/NAME/bin/NAME ]; then
	echo "Error: NAME requires NAME!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f NAME.tar.gz ]; then
	wget URL -O NAME.tar.gz
fi
if [ ! -f NAME.tar.gz ]; then
	echo "Error: Unable to download NAME.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing NAME":

# check
if [ ! -f $INSTALL_DIR/NAME/bin/NAME ]; then
	echo "Error: NAME has NOT been installed successfully!"
	exit 1
fi

##
## configure
##


##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f NAME.tar.gz ] && rm NAME.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d NAME-$NAME_VERSION ] && rm -rf NAME-$NAME_VERSION
