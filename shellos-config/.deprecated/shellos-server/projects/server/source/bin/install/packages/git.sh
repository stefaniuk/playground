#!/bin/bash

##
## download
##

PKG_NAME="git-$GIT_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://git-core.googlecode.com/files/git-$GIT_VERSION.tar.gz"
    FILE=git-$GIT_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 3000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##


if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile Git:"
    [ -d $INSTALL_DIR/git ] && rm -rf $INSTALL_DIR/git
    tar -zxf git-$GIT_VERSION.tar.gz
    cd git-$GIT_VERSION
    # gettext library needs to be linked dynamically
    # see:
    #   http://mono.1490590.n4.nabble.com/Can-t-compile-git-for-a-long-time-td3336232.html
    #   http://mail-index.netbsd.org/pkgsrc-users/2008/01/09/msg000092.html
    #   http://scottschulz.us/2008/06/07/ubuntu-hardy-the-10-minute-git-install/
    replace_in_file 'EXTLIBS += \$(ICONV_LINK) -liconv' 'EXTLIBS += \$(ICONV_LINK) -liconv -lcharset' ./Makefile
    ./configure \
        --prefix=$INSTALL_DIR/git \
        --with-gitconfig=$INSTALL_DIR/git/conf/gitconfig \
    && make all && make install && echo "Git installed successfully!" && \
    mkdir $INSTALL_DIR/git/conf && touch $INSTALL_DIR/git/conf/gitconfig
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/git/bin
    strip_debug_symbols $INSTALL_DIR/git/libexec
    echo "Create package:"
    package_create $INSTALL_DIR/git $PKG_NAME
else
    echo "Install Git from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/git/bin/git ]; then
	echo "Error: Git has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/git/bin/git:"
ldd $INSTALL_DIR/git/bin/git

$INSTALL_DIR/git/bin/git config --global color.branch auto
$INSTALL_DIR/git/bin/git config --global color.diff auto
$INSTALL_DIR/git/bin/git config --global color.interactive auto
$INSTALL_DIR/git/bin/git config --global color.status auto
$INSTALL_DIR/git/bin/git config --global user.name "$ADMIN_NAME"
$INSTALL_DIR/git/bin/git config --global user.email "$ADMIN_MAIL"

##
## post install
##

[ -f git-$GIT_VERSION.tar.gz ] && rm git-$GIT_VERSION.tar.gz
[ -d git-$GIT_VERSION ] && rm -rf git-$GIT_VERSION

# log event
logger -p local0.notice -t host4ge "git $GIT_VERSION installed successfully"

# save package version
package_add_version "git" "$GIT_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/git/bin
hashes_add_dir $INSTALL_DIR/git/libexec

exit 0
