#!/bin/bash

##
## variables
##

PHP_MYSQL_NAME=
PHP_HTTPD_NAME=
PHP_HTTPD_PORT=
PHP_HTTPD_USER=
PHP_HTTPD_GROUP=
PHP_INSTALL_DIR=$INSTALL_DIR/php
PHP_INSTALL_DIR_ESC=`echo "$PHP_INSTALL_DIR" | sed 's/\//\\\\\//g'`
PHP_TIMEZONE="Europe/London"
if [ "$LOCATION" == "PL" ]; then
    PHP_TIMEZONE="Europe/Warsaw"
fi
PHP_TIMEZONE_ESC=`echo "$PHP_TIMEZONE" | sed 's/\//\\\\\//g'`
PHP_CONFIGURE_OPTIONS=
[ -f $INSTALL_DIR/libiconv/bin/iconv ] && PHP_CONFIGURE_OPTIONS="--with-iconv=shared,$INSTALL_DIR/libiconv"
[[ $PHP_VERSION == 5.3.* ]] && PHP_CONFIGURE_OPTIONS="$PHP_CONFIGURE_OPTIONS --without-sqlite"

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
        --php)  shift && PHP_MYSQL_NAME=$1
                shift && PHP_HTTPD_NAME=$1
                shift && PHP_HTTPD_PORT=$1
                shift && PHP_HTTPD_USER=$1
                shift && PHP_HTTPD_GROUP=$1
                ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$PHP_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: PHP requires MySQL!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/$PHP_HTTPD_NAME/bin/httpd ]; then
    echo "Error: PHP requires Apache HTTPD Server!"
    exit 1
fi

##
## download
##

PKG_NAME="php-$PHP_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://de.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror"
    FILE=php-$PHP_VERSION.tar.gz
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
    echo "Compile PHP":
    [ -d $PHP_INSTALL_DIR ] && rm -rf $PHP_INSTALL_DIR
    tar -zxf php-$PHP_VERSION.tar.gz
    cd php-$PHP_VERSION
    # http://tech.barwick.de/linux/crypto-set-id-callback-error-compiling-php-with-curl.html
    ./configure \
        --prefix=$PHP_INSTALL_DIR \
        --sysconfdir=$PHP_INSTALL_DIR/conf \
        --with-config-file-path=$PHP_INSTALL_DIR/conf \
        --with-apxs2=$INSTALL_DIR/$PHP_HTTPD_NAME/bin/apxs \
        --disable-cgi \
        --enable-bcmath=shared \
        --enable-calendar=shared \
        --enable-cli=shared \
        --enable-ctype=shared \
        --enable-exif=shared \
        --enable-ftp=shared \
        --enable-libxml=shared \
        --enable-mbstring=shared \
        --enable-soap=shared \
        --enable-sockets=shared \
        --enable-zip=shared \
        --with-bz2=shared \
        --with-gd=shared \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-jpeg-dir=shared \
        --with-png-dir=shared \
        --with-gettext=shared \
        --with-mcrypt=shared \
        --with-mhash=shared \
        --with-pear=shared \
        --with-pcre-regex \
        --enable-pdo=shared \
        --with-sqlite3=shared \
        --with-pdo-sqlite=shared,/usr \
        --with-mysql=shared,$INSTALL_DIR/$PHP_MYSQL_NAME \
        --with-mysql-sock=$INSTALL_DIR/$PHP_MYSQL_NAME/log/mysql.sock \
        --with-mysqli=shared,$INSTALL_DIR/$PHP_MYSQL_NAME/bin/mysql_config \
        --with-pdo-mysql=shared,$INSTALL_DIR/$PHP_MYSQL_NAME \
        --with-zlib-dir=shared,/usr \
        --with-openssl=shared,/usr \
        --with-curl \
        $PHP_CONFIGURE_OPTIONS \
    && replace_in_file ' -lxml2 -lxml2 -lxml2 -lcrypt' ' -lxml2 -lxml2 -lxml2 -lcrypto' ./Makefile \
    && make && make install && echo "PHP installed successfully!" \
    && rm -rfv $PHP_INSTALL_DIR/man \
    && mkdir $PHP_INSTALL_DIR/log \
    && cp -p php.ini-production $PHP_INSTALL_DIR/conf/php.ini \
    && cp -p php.ini-production $PHP_INSTALL_DIR/conf \
    && cp -p php.ini-development $PHP_INSTALL_DIR/conf
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $PHP_INSTALL_DIR/bin
    strip_debug_symbols $PHP_INSTALL_DIR/lib/php/extensions/$(ls $PHP_INSTALL_DIR/lib/php/extensions/)
    strip_debug_symbols_file $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so
    echo "Create package:"
    cp -v $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so $INSTALL_DIR/php
    package_create $INSTALL_DIR/php $PKG_NAME
    rm -v $INSTALL_DIR/php/libphp5.so
else
    echo "Install PHP from package:"
    package_restore $PKG_NAME
    mv -v $INSTALL_DIR/php/libphp5.so $INSTALL_DIR/$PHP_HTTPD_NAME/modules
fi

# TODO: http://www.hardened-php.net/suhosin/index.html

# check
if [ ! -f $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so ]; then
    echo "Error: PHP has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so:"
ldd $INSTALL_DIR/$PHP_HTTPD_NAME/modules/libphp5.so

# TODO: check disable_functions, open_basedir, doc_root, user_dir
PHP_DISABLE_FUNCTIONS="apache_get_modules,apache_get_version,apache_getenv,apache_setenv,disk_free_space,diskfreespace,dl,exec,passthru,popen,proc_open,set_time_limit,shell_exec,system"
replace_in_file 'disable_functions =' "disable_functions = $PHP_DISABLE_FUNCTIONS" $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'expose_php = On' 'expose_php = Off' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'max_execution_time = 30' 'max_execution_time = 1200' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'max_input_time = 60' 'max_input_time = 20' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file 'memory_limit = 128M' 'memory_limit = 256M' $PHP_INSTALL_DIR/conf/php.ini
replace_in_file ';date.timezone =' "date.timezone = \"$PHP_TIMEZONE_ESC\"" $PHP_INSTALL_DIR/conf/php.ini
#replace_in_file ';error_log = php_errors.log' "error_log = \/var\/log\/php.log" $PHP_INSTALL_DIR/conf/php.ini
replace_in_file ';sendmail_path =' "sendmail_path = \"$INSTALL_DIR_ESC\/postfix\/bin\/sendmail -t -i\"" $PHP_INSTALL_DIR/conf/php.ini
echo -e "\n; extensions begin" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = bcmath.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = bz2.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = calendar.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = ctype.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = exif.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = ftp.so" >> $PHP_INSTALL_DIR/conf/php.ini
# iconv.so has to be loaded before gd.so
[ -f $INSTALL_DIR/libiconv/bin/iconv ] && echo -e "extension = iconv.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = gd.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = gettext.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = mbstring.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = mcrypt.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = openssl.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = sqlite3.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = mysql.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = mysqli.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = pdo.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = pdo_sqlite.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = pdo_mysql.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = soap.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = sockets.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "extension = zip.so" >> $PHP_INSTALL_DIR/conf/php.ini
echo -e "; extensions end" >> $PHP_INSTALL_DIR/conf/php.ini

# httpd.conf
rm $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf.bak
replace_in_file 'DirectoryIndex index.html' 'DirectoryIndex index.html index.php' $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf
if [ "$PKG_RESULT" == "success" ]; then
    replace_in_file '# end of modules' 'LoadModule php5_module modules\/libphp5.so\n# end of modules' $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf
else
    replace_in_file 'LoadModule php5_module[ \t]*modules\/libphp5.so' 'LoadModule php5_module modules\/libphp5.so' $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf
fi
echo -e "\n<FilesMatch \.php$>\n\tSetHandler application/x-httpd-php\n</FilesMatch>" >> $INSTALL_DIR/$PHP_HTTPD_NAME/conf/httpd.conf

# set files permission
chown -R root:root $PHP_INSTALL_DIR
chmod 755 $PHP_INSTALL_DIR/bin
chmod 500 $PHP_INSTALL_DIR/bin/*
chmod 555 $PHP_INSTALL_DIR/bin/php

##
## post install
##

[ -f php-$PHP_VERSION.tar.gz ] && rm php-$PHP_VERSION.tar.gz
[ -d php-$PHP_VERSION ] && rm -rf php-$PHP_VERSION

# log event
logger -p local0.notice -t host4ge "php $PHP_VERSION installed successfully"

# save package version
package_add_version "php" "$PHP_VERSION"

# add directories to create hashes
hashes_add_dir $PHP_INSTALL_DIR/bin
hashes_add_dir $PHP_INSTALL_DIR/lib/php/extensions

# test
if [ "$CHROOT" == "N" ]; then
    echo -e "\n\n *** PHP settings ***\n"
    $PHP_INSTALL_DIR/bin/php -i
    if [ "$SERVER_HYPERVISOR" != "openvz" ]; then
        echo -e "\n\n"
        echo -e "<?php phpinfo(); ?>" > $INSTALL_DIR/$PHP_HTTPD_NAME/htdocs/info.php
        run_apache_performance_test $PHP_HTTPD_NAME "http://$(hostname).$DOMAIN:$PHP_HTTPD_PORT/info.php"
        echo -e "<?php //phpinfo(); ?>" > $INSTALL_DIR/$PHP_HTTPD_NAME/htdocs/info.php
    fi
fi

exit 0
