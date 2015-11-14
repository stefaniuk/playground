#!/bin/bash

#
# install
#

mkdir -p $pkgs_dir/composer/current
cp -fv $cache_dir/composer.phar $pkgs_dir/composer/current/composer.phar
chmod +x $pkgs_dir/composer/current/composer.phar
(cd $pkgs_dir/composer/current; ./composer.phar self-update)
ln -sfv $pkgs_dir/composer/current/composer.phar $pkgs_dir/composer/current/composer

[ ! -x $pkgs_dir/composer/current/composer ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $pkgs_dir/composer/current/composer.phar composer

fi

exit 0
