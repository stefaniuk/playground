#!/bin/bash

# TODO:
#   log to /var/log/httpd.*
#   create resources/httpd.conf

#
# build
#

if [ $opt_force_build == "y" ] || [ $opt_from_archive == "n" ]; then

    print_h3 'Run `configure`'
    file_replace_str '\$\{localstatedir\}/logs' '\$\{localstatedir\}/log' ./config.layout
    ./configure \
        --prefix=$install_dir \
        --with-mpm="event" \
        --enable-mpms-shared="all" \
        --enable-mods-shared="all" \
        --enable-so \
        --enable-suexec \
        --with-suexec-bin=$install_dir/bin/suexec \
        --with-suexec-uidmin=1000 \
        --with-suexec-gidmin=1000 \
        --with-suexec-caller="httpd" \
        --with-suexec-docroot=/var/www \
        --with-suexec-userdir="public" \
        --with-suexec-safepath="/usr/local/bin:/usr/bin:/bin" \
        --with-suexec-logfile=$install_dir/log/httpd-suexec.log \
        --with-apr=$pkgs_dir/apr/current \
        --with-apr-util=$pkgs_dir/apr-util/current \
        --with-pcre=$pkgs_dir/pcre/current \
        --with-ssl \
        --with-z \
    && print_h3 'Run `make`' && make && sudo rm -rf $install_dir \
    && print_h3 'Run `make install`' && make install \
    && print_h3 "Build complete"
    [ $? -ne 0 ] && exit 1

    print_h3 "Strip symbols:"
    dev_strip_symbols $install_dir/bin
    dev_strip_symbols $install_dir/modules

    archive
else
    unarchive
fi

[ ! -x $install_dir/bin/httpd ] && exit 2

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

    user_exists "httpd" && user_delete "httpd"
    user_create "httpd" "httpd"

    file_replace_str "#ServerName www.example.com:80" "ServerName 127.0.0.1" $install_dir/conf/httpd.conf
    file_replace_str "User daemon" "User httpd" $install_dir/conf/httpd.conf
    file_replace_str "Group daemon" "Group httpd" $install_dir/conf/httpd.conf

    chmod 4550 $install_dir/bin/suexec
    sudo chown -R httpd:httpd $install_dir/log

fi

exit 0
