#!/bin/bash

# TODO:
#   log to /var/log/php.*
#   create resources/php.ini
#   create resources/php-fpm.conf

[ -x $pkgs_dir/httpd/current/bin/apxs ] && httpd_installed="y" || httpd_installed="n"
[ -x $pkgs_dir/mysql/current/bin/mysqld ] && mysql_installed="y" || mysql_installed="n"

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    conf=
    [[ $PKG_VERSION == 5.3.* ]] && conf=" \
        --with-pcre-dir=$pkgs_dir/pcre/current \
        --without-sqlite"
    [[ $PKG_VERSION == 5.4.* ]] && conf=" \
        --with-pcre-regex=$pkgs_dir/pcre/current \
        --enable-fpm=shared"
    [[ $PKG_VERSION == 5.5.* ]] && conf=" \
        --enable-opcache=shared \
        --with-pcre-regex=$pkgs_dir/pcre/current \
        --enable-fpm=shared"
    [[ $PKG_VERSION == 5.6.* ]] && conf=" \
        --enable-opcache=shared \
        --with-pcre-regex=$pkgs_dir/pcre/current \
        --enable-fpm=shared"

    [ $httpd_installed == "y" ] && conf="$conf \
        --with-apxs2=$pkgs_dir/httpd/current/bin/apxs"
    [ $mysql_installed == "y" ] && conf="$conf \
        --with-mysql-sock=$pkgs_dir/mysql/current/log/mysql.sock \
        --with-mysql=shared \
        --with-mysqli=shared \
        --with-pdo-mysql=shared"
    [ $DIST == "macosx" ] && conf="$conf --enable-pdo" || conf="$conf --enable-pdo=shared"

    print_h3 'Run `configure`'
    ./configure \
        --prefix=$install_dir \
        --sbindir=$install_dir/bin \
        --sysconfdir=$install_dir/conf \
        --localstatedir=$install_dir/log \
        --with-config-file-path=$install_dir/conf \
        --disable-cgi \
        --enable-bcmath=shared \
        --enable-calendar=shared \
        --enable-cli=shared \
        --enable-ctype=shared \
        --enable-exif=shared \
        --enable-ftp=shared \
        --enable-intl=shared \
        --enable-libxml=shared \
        --enable-mbregex=shared \
        --enable-mbstring=shared \
        --enable-shmop=shared \
        --enable-soap=shared \
        --enable-sockets=shared \
        --enable-sysvmsg=shared \
        --enable-sysvsem=shared \
        --enable-sysvshm=shared \
        --enable-wddx=shared \
        --enable-zip=shared \
        --with-bz2=shared \
        --with-curl=shared \
        --with-gd=shared \
        --with-gettext=shared \
        --with-jpeg-dir=shared \
        --with-mcrypt=shared \
        --with-mhash=shared \
        --with-openssl=shared \
        --with-pdo-sqlite=shared \
        --with-pear=shared \
        --with-png-dir=shared \
        --with-sqlite3=shared \
        --with-xmlrpc=shared \
        --with-zlib-dir=shared \
        $conf \
    && [ $OS == "linux" ] && file_replace_str " -lxml2 -lxml2 -lxml2 -lcrypt" " -lxml2 -lxml2 -lxml2 -lcrypto" ./Makefile || true \
    && print_h3 'Run `make`' && make && rm -rf $install_dir \
    && print_h3 'Run `make install`' && make install && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin
    dev_strip_symbols $install_dir/lib/php/extensions/$(\ls $install_dir/lib/php/extensions)
    if [ $httpd_installed == "y" ]; then
        libphp5_so=$pkgs_dir/httpd/current/modules/libphp5.so
        dev_strip_symbols $libphp5_so
        print_h3 "Copy module:"
        cp -fv $libphp5_so $install_dir/lib
    fi

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/php ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    # php.ini
    php_ini=$install_dir/conf/php.ini
    cp -p php.ini-production $php_ini
    cp -p php.ini-production $install_dir/conf
    cp -p php.ini-development $install_dir/conf

    # extensions
    ext_dir=$install_dir/lib/php/extensions/$(\ls $install_dir/lib/php/extensions)
    function conigure_ext {
        [ -f ext_dir/$1.so ] && echo "extension = $1.so" >> $php_ini
    }
    echo -e "\n; extensions begin" >> $php_ini
    conigure_ext "bcmath"
    conigure_ext "bz2"
    conigure_ext "calendar"
    conigure_ext "ctype"
    conigure_ext "curl"
    conigure_ext "ftp"
    conigure_ext "gd"
    conigure_ext "gettext"
    conigure_ext "intl"
    conigure_ext "ldap"
    conigure_ext "mbstring"
    conigure_ext "exif" # exif.so must be loaded after mbstring
    conigure_ext "mcrypt"
    conigure_ext "mysql"
    conigure_ext "mysqli"
    conigure_ext "opcache"
    conigure_ext "openssl"
    conigure_ext "pdo"
    conigure_ext "pdo_mysql"
    conigure_ext "pdo_sqlite"
    conigure_ext "shmop"
    conigure_ext "soap"
    conigure_ext "sockets"
    conigure_ext "sqlite3"
    conigure_ext "sysvmsg"
    conigure_ext "sysvsem"
    conigure_ext "sysvshm"
    conigure_ext "wddx"
    conigure_ext "xmlrpc"
    conigure_ext "zip"
    echo "; extensions end" >> $php_ini

    # httpd configuration
    if [ $httpd_installed == "y" ]; then
        httpd_conf=$pkgs_dir/httpd/current/conf/httpd.conf
        rm -f $httpd_conf.bak
        file_replace_str \
            "DirectoryIndex\(.*\)index.[a-z]*" \
            "DirectoryIndex index.html index.php" \
            $httpd_conf
        if [ $(cat $httpd_conf | grep 'SetHandler application/x-httpd-php' | wc -l) -eq 0 ]; then
            (   echo "<FilesMatch \.php$>"
                echo "    SetHandler application/x-httpd-php"
                echo "</FilesMatch>"
            ) >> $httpd_conf
        fi
        index_php=$pkgs_dir/httpd/current/htdocs/index.php
        [ ! -f $index_php ] && echo "<?php phpinfo(); ?>" > $index_php
    fi

fi

exit 0
