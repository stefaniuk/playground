#!/bin/bash

##
## variables
##

MOD_SECURITY_HTTPD_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --mod-security) shift && MOD_SECURITY_HTTPD_NAME=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/bin/httpd ]; then
    echo "Error: mod_security requires Apache HTTPD Server!"
    exit 1
fi

##
## download
##

PKG_NAME="mod_security-$MOD_SECURITY_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://www.modsecurity.org/download/modsecurity-apache_$MOD_SECURITY_VERSION.tar.gz"
    FILE=modsecurity-apache_$MOD_SECURITY_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile mod_security:"
    tar -zxf modsecurity-apache_$MOD_SECURITY_VERSION.tar.gz
    cd modsecurity-apache_$MOD_SECURITY_VERSION
    ./configure \
        --prefix=$TMP_DIR/modsecurity \
        --with-apxs=$INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/bin/apxs \
        --with-apr=$INSTALL_DIR/apr \
        --with-apu=$INSTALL_DIR/apr \
    && make && make install && echo "mod_security installed successfully!" \
    && rm -rf $TMP_DIR/modsecurity
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols_file $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules/mod_security2.so
    echo "Create package:"
    package_create_files $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules $PKG_NAME mod_security2.so
else
    echo "Install mod_security from package:"
    package_restore_files $PKG_NAME $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules
fi

# check
if [ ! -f $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules/mod_security2.so ]; then
    echo "Error: mod_security has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules/mod_security2.so:"
ldd $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules/mod_security2.so

# httpd.conf
replace_in_file '# end of modules' 'LoadModule security2_module modules\/mod_security2.so\n# end of modules' $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/conf/httpd.conf

# TODO:
#   http://www.modsecurity.org/documentation/modsecurity-apache/1.9.3/html-multipage/03-configuration.html
#   http://www.howtoforge.com/apache_mod_security

# set files permission
chown -R root:root $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules/mod_security.so
chmod 755 $INSTALL_DIR/$MOD_SECURITY_HTTPD_NAME/modules/mod_security.so

##
## post install
##

[ -f modsecurity-apache_$MOD_SECURITY_VERSION.tar.gz ] && rm modsecurity-apache_$MOD_SECURITY_VERSION.tar.gz
[ -d modsecurity-apache_$MOD_SECURITY_VERSION ] && rm -rf modsecurity-apache_$MOD_SECURITY_VERSION

# log event
logger -p local0.notice -t host4ge "mod-security $MOD_SECURITY_VERSION installed successfully"

# save package version
package_add_version "mod-security" "$MOD_SECURITY_VERSION"

exit 0
