shell-fusion
============

My shell scripts.

Installation
------------

Project can be installed in the default location in `/usr/local/shell-fusion`

    curl -L https://raw.githubusercontent.com/stefaniuk/shell-fusion/master/installer.sh -o - | \
        /bin/bash

or in the user directory

    curl -L https://raw.githubusercontent.com/stefaniuk/shell-fusion/master/installer.sh -o - | \
        SHELL_FUSION_HOME=~/.shell-fusion /bin/bash

Usage
-----

Source `$SHELL_FUSION_HOME/shell-fusion.sh` file. From now, all scripts listed in the `bin` directory should be available from the shell command-line.

For example, try the `random` command:

    $ random --help

    DESCRIPTION: Return random string (A-Za-z0-9) with the given length.

    PARAMETERS:
        $1 length

    $ random 32
    Hmvqtyy4J3Wx5p07iOScsxRceGLVN56k

Also, `spkg` script should be available from the shell command-line.

    $ spkg install <package> 1.2.3 -b -c -g -s

Project structure
-----------------

Installation directory

    /usr/local/shell-fusion/
        .cache/
            ${name}-1.2.3-src.tar.gz
            ${name}-1.2.3-build-${dist}-${arch}.tar.gz
        bin/
            <commands>
            spkg
        etc/
            ${name}/
                ${name}.json
                ${name}.sh
        opt/
            ${name}/
                current/ -> 1.2.3/
                1.2.3/
                    [ ... ]
        test/
            <tests>
        installer.sh
        shell-fusion.sh

TODO list
---------

 * Provide option to specify installation directory
 * Develop `spkg-server`
 * Install
    - Docker, Vagrant, Packer
    - FitNesse
    - Scala
 * Modify download list to include mirror URL property
 * Modify download list to include depends on property, i.e. `${name} (>=${version})`
 * Provide custom URL to download files, i.e. `${url}/${file}.tar.gz`
 * Create control file for each package that has been installed
 * Make all relevant commands working with pipes, e.g. `cmd "data"` -> `echo "data" | cmd`

See
---

 * [Homebrew](http://brew.sh/)
 * [NixOS](http://nixos.org/)
 * [Linux From Scratch](http://www.linuxfromscratch.org/)
 * [Ubuntu](http://packages.ubuntu.com/)
