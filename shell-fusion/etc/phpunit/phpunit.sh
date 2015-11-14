#!/bin/bash

#
# install
#

mkdir -p $pkgs_dir/phpunit/current
cp -fv $cache_dir/phpunit.phar $pkgs_dir/phpunit/current/phpunit.phar
chmod +x $pkgs_dir/phpunit/current/phpunit.phar
ln -sfv $pkgs_dir/phpunit/current/phpunit.phar $pkgs_dir/phpunit/current/phpunit

[ ! -x $pkgs_dir/phpunit/current/phpunit ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $pkgs_dir/phpunit/current/phpunit.phar phpunit

fi

exit 0
