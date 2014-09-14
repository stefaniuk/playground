#!/bin/bash

##
## variables
##

OPENJDK_VERSION="${OPENJDK_VERSION_NUMBER}u${OPENJDK_VERSION_UPDATE}-${OPENJDK_VERSION_BUILD}"
OPENJDK_ARCHIVE_DIR="jdk1.${OPENJDK_VERSION_NUMBER}.0_0${OPENJDK_VERSION_UPDATE}"

##
## download
##

URL="http://www.java.net/download/jdk${OPENJDK_VERSION_NUMBER}u${OPENJDK_VERSION_UPDATE}/archive/${OPENJDK_VERSION_BUILD}/binaries/jdk-${OPENJDK_VERSION_NUMBER}u${OPENJDK_VERSION_UPDATE}-ea-bin-${OPENJDK_VERSION_BUILD}-linux-x64-${OPENJDK_VERSION_DATE}.tar.gz"
FILE=jdk-${OPENJDK_VERSION_NUMBER}u${OPENJDK_VERSION_UPDATE}-ea-bin-${OPENJDK_VERSION_BUILD}-linux-x64-${OPENJDK_VERSION_DATE}.tar.gz
RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 50000000)
if [ "$RESULT" == "error" ]; then
	echo "Error: Unable to download $FILE file!"
	exit 1
fi

##
## install
##

echo "Installing OpenJDK:"
[ -d $INSTALL_DIR/openjdk ] && rm -rf $INSTALL_DIR/openjdk
tar -zxf $FILE
mv $OPENJDK_ARCHIVE_DIR $INSTALL_DIR/openjdk
rm -rf $INSTALL_DIR/openjdk/{man,src.zip}

# check
if [ ! -x $INSTALL_DIR/openjdk/bin/javac ]; then
	echo "Error: OpenJDK has NOT been installed successfully!"
	exit 1
else
    echo "OpenJDK installed successfully!"
fi

##
## configure
##

# set files permission
chown -R root:root $INSTALL_DIR/openjdk

##
## post install
##

[ -f $FILE ] && rm $FILE

# log event
logger -p local0.notice -t host4ge "openjdk $OPENJDK_VERSION installed successfully"

# save package version
package_add_version "openjdk" "$OPENJDK_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/openjdk/bin
hashes_add_dir $INSTALL_DIR/openjdk/lib
hashes_add_dir $INSTALL_DIR/openjdk/jre/bin
hashes_add_dir $INSTALL_DIR/openjdk/jre/lib

exit 0
