#!/bin/bash

##
## variables
##

APC_HTTPD_NAME=
APC_HTTPD_PORT=
APC_PHP_NAME=
APC_PHP_INSTALL_DIR=

##
## functions
##

# parameters:
#    $1 instance_name
#    $2 url
function run_apache_performance_test {

    pkill httpd
    sleep 1
    $INSTALL_DIR/$1/bin/apachectl -k start
    sleep 3
    echo -e "\n\n *** Apache Benchmark ***\n"
    $INSTALL_DIR/$1/bin/ab -n 10000 -c 10 -k -r $2
    echo -e "\n\n"
    sleep 5
    $INSTALL_DIR/$1/bin/apachectl -k stop
}

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --apc)  shift && APC_HTTPD_NAME=$1
                shift && APC_HTTPD_PORT=$1
                shift && APC_PHP_NAME=$1
                ;;
    esac
    shift
done

APC_PHP_INSTALL_DIR=$INSTALL_DIR/$APC_PHP_NAME
APC_PHP_EXT_DIR=$APC_PHP_INSTALL_DIR/lib/php/extensions/$(ls $APC_PHP_INSTALL_DIR/lib/php/extensions/)

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$APC_HTTPD_NAME/bin/httpd ]; then
    echo "Error: APC requires Apache HTTPD Server!"
    exit 1
fi
if [ ! -f $APC_PHP_INSTALL_DIR/bin/php ]; then
    echo "Error: APC requires PHP!"
    exit 1
fi

##
## download
##

PKG_NAME="APC-$APC_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://pecl.php.net/get/APC-$APC_VERSION.tgz"
    FILE=APC-$APC_VERSION.tgz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 100000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile APC":
    tar -zxf APC-$APC_VERSION.tgz
    cd APC-$APC_VERSION
    $APC_PHP_INSTALL_DIR/bin/phpize
    ./configure \
        --with-php-config=$APC_PHP_INSTALL_DIR/bin/php-config \
        --enable-apc \
    && make && make install && echo "APC installed successfully in $APC_PHP_INSTALL_DIR!"
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols_file $APC_PHP_EXT_DIR/apc.so
    echo "Create package:"
    package_create_files $APC_PHP_EXT_DIR $PKG_NAME apc.so
else
    echo "Install APC in $APC_PHP_INSTALL_DIR from package:"
    package_restore_files $PKG_NAME $APC_PHP_EXT_DIR
fi

# check
if [ ! -f $APC_PHP_EXT_DIR/apc.so ]; then
    echo "Error: APC has NOT been installed successfully in $APC_PHP_INSTALL_DIR"
    exit 1
fi

##
## configure
##

# php.ini
if [ -f $APC_PHP_INSTALL_DIR/conf/php.ini ]; then
    replace_in_file "; extensions end" "extension = apc.so\n; extensions end" $APC_PHP_INSTALL_DIR/conf/php.ini
    echo -e "\napc.enabled = Off" >> $APC_PHP_INSTALL_DIR/conf/php.ini
fi

##
## post install
##

rm -v package.xml
[ -f APC-$APC_VERSION.tgz ] && rm APC-$APC_VERSION.tgz
[ -d APC-$APC_VERSION ] && rm -rf APC-$APC_VERSION

# log event
logger -p local0.notice -t host4ge "apc $APC_VERSION installed successfully"

# save package version
package_add_version "apc" "$APC_VERSION"

# test
if [ "$CHROOT" == "N" ]; then
    echo -e "\n\n *** APC settings ***\n"
    $APC_PHP_INSTALL_DIR/bin/php -i | grep apc
    if [ "$SERVER_HYPERVISOR" != "openvz" ]; then
        echo -e "\n\n"
        echo -e "<?php phpinfo(); ?>" > $INSTALL_DIR/$APC_HTTPD_NAME/htdocs/info.php
        run_apache_performance_test $APC_HTTPD_NAME "http://$(hostname).$DOMAIN:$APC_HTTPD_PORT/info.php"
        echo -e "<?php //phpinfo(); ?>" > $INSTALL_DIR/$APC_HTTPD_NAME/htdocs/info.php
    fi
fi

exit 0
